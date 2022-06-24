import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/student_calendar.dart';
import 'package:success_academy/calendar/teacher_calendar.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    }
    if (account.authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.profile == null) {
      return const ProfileBrowse();
    }
    return const BaseCalendar();
  }
}

class BaseCalendar extends StatefulWidget {
  const BaseCalendar({Key? key}) : super(key: key);

  @override
  State<BaseCalendar> createState() => _BaseCalendarState();
}

class _BaseCalendarState extends State<BaseCalendar> {
  late final ValueNotifier<List<EventModel>> _selectedEvents;
  final DateTime _firstDay =
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 365)));
  final DateTime _lastDay =
      DateUtils.dateOnly(DateTime.now().add(const Duration(days: 365)));
  SubscriptionPlan? _subscriptionType;
  Map<DateTime, List<EventModel>> _allFreeLessons = {};
  Map<DateTime, List<EventModel>> _allPreschoolLessons = {};
  Map<DateTime, List<EventModel>> _allPrivateLessons = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final CalendarBuilders _calendarBuilders = CalendarBuilders(
    markerBuilder: ((context, day, events) {
      if (events.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber[600],
          ),
          height: 20,
          width: 20,
          alignment: Alignment.center,
          child: Text(
            '${events.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }
      return null;
    }),
  );

  @override
  void initState() {
    // TODO: Calendar refresh
    super.initState();
    tz.initializeTimeZones();
    _setAllEvents(accountContext: context.read<AccountModel>());
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    if (_subscriptionType == null ||
        _subscriptionType == SubscriptionPlan.monthly) {
      return [];
    }

    List<EventModel> events = [];
    if (_subscriptionType == SubscriptionPlan.minimumPreschool) {
      events.addAll(_allPreschoolLessons[day] ?? []);
    }
    events.addAll(_allFreeLessons[day] ?? []);
    events.addAll(_allPrivateLessons[day] ?? []);
    return events;
  }

  void _onTodayButtonTap() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = _focusedDay;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  void _onFormatChanged(format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  Future<void> _setSubscriptionType(
      {required AccountModel accountContext}) async {
    final subscriptionType =
        await profile_service.getSubscriptionTypeForProfile(
            profileId: accountContext.profile!.profileId,
            userId: accountContext.firebaseUser!.uid);
    setState(() {
      _subscriptionType = subscriptionType;
    });
  }

  Future<void> _setAllEvents({required AccountModel accountContext}) async {
    await _setSubscriptionType(accountContext: accountContext);

    if (_subscriptionType == null ||
        _subscriptionType == SubscriptionPlan.monthly) {
      return;
    }
    if (_subscriptionType == SubscriptionPlan.minimumPreschool) {
      await _setAllPreschoolLessons(accountContext: accountContext);
    }
    await _setAllFreeLessons(accountContext: accountContext);
    await _setAllPrivateLessons(accountContext: accountContext);
  }

  Future<void> _setAllFreeLessons({required AccountModel accountContext}) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .getAllEventsFromFreeLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => setState(() {
              _allFreeLessons =
                  buildEventMap(CalendarType.free, eventList, timeZone);
            }))
        .catchError((e) => null
            // TODO: Show error state.
            );
  }

  Future<void> _setAllPreschoolLessons({required AccountModel accountContext}) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .getAllEventsFromPreschoolLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => setState(() {
              _allPreschoolLessons =
                  buildEventMap(CalendarType.preschool, eventList, timeZone);
            }))
        .catchError((e) => null
            // TODO: Show error state.
            );
  }

  Future<void> _setAllPrivateLessons({required AccountModel accountContext}) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .getAllEventsFromPrivateLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => setState(() {
              _allPrivateLessons =
                  buildEventMap(CalendarType.private, eventList, timeZone);
            }))
        .catchError((e) => null
            // TODO: Show error state.
            );
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.teacherProfile != null) {
      return TeacherCalendar(
        selectedDay: _selectedDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        calendarBuilders: _calendarBuilders,
        onTodayButtonTap: _onTodayButtonTap,
        onDaySelected: _onDaySelected,
        onFormatChanged: _onFormatChanged,
        onPageChanged: _onPageChanged,
      );
    }
    return StudentCalendar(
      selectedDay: _selectedDay,
      selectedEvents: _selectedEvents,
      firstDay: _firstDay,
      lastDay: _lastDay,
      subscriptionType: _subscriptionType,
      allFreeLessons: _allFreeLessons,
      allPreschoolLessons: _allPreschoolLessons,
      allPrivateLessons: _allPrivateLessons,
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      onTodayButtonTap: _onTodayButtonTap,
      onDaySelected: _onDaySelected,
      onFormatChanged: _onFormatChanged,
      onPageChanged: _onPageChanged,
      getEventsForDay: _getEventsForDay,
      calendarBuilders: _calendarBuilders,
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader(
      {Key? key,
      required this.header,
      required this.timeZone,
      required this.onTodayButtonTap})
      : super(key: key);

  final String header;
  final String timeZone;
  final VoidCallback onTodayButtonTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            S.of(context).calendarHeader(header),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            S.of(context).timeZone(timeZone.replaceAll('_', ' ')),
            style: Theme.of(context).textTheme.headline6,
          ),
          IconButton(
            onPressed: onTodayButtonTap,
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }
}

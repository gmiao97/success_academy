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
    if (account.userType == UserType.studentNoProfile) {
      return const ProfileBrowse();
    }
    return BaseCalendar(userType: account.userType);
  }
}

class BaseCalendar extends StatefulWidget {
  const BaseCalendar({Key? key, required this.userType}) : super(key: key);

  final UserType userType;

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
  Map<DateTime, List<EventModel>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late final List<CalendarType> _availableEventFilters;
  List<CalendarType> _eventFilters = [];

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
    initCalendar(accountContext: context.read<AccountModel>());
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> initCalendar({required AccountModel accountContext}) async {
    await _setEventFilters(accountContext);
    await _setAllEvents(accountContext);
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
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

  Future<void> _setSubscriptionType(accountContext) async {
    final subscriptionType =
        await profile_service.getSubscriptionTypeForProfile(
            profileId: accountContext.studentProfile!.profileId,
            userId: accountContext.firebaseUser!.uid);
    setState(() {
      _subscriptionType = subscriptionType;
    });
  }

  Future<void> _setEventFilters(accountContext) async {
    final filters = [];
    if (widget.userType == UserType.teacher) {
      filters.addAll([
        CalendarType.myPreschool,
        CalendarType.myPrivate,
      ]);
    }
    if (widget.userType == UserType.student) {
      await _setSubscriptionType(accountContext);

      if (_subscriptionType != null &&
          _subscriptionType != SubscriptionPlan.monthly) {
        if (_subscriptionType == SubscriptionPlan.minimumPreschool) {
          filters.addAll([CalendarType.preschool, CalendarType.myPreschool]);
        }
        filters.addAll(
            [CalendarType.free, CalendarType.private, CalendarType.myPrivate]);
      }
    }

    setState(() {
      _availableEventFilters = List.from(filters);
      _eventFilters = List.from(filters);
    });
  }

  Future<void> _setAllEvents(AccountModel accountContext) async {
    final sanitizedFilters = List.from(_eventFilters);
    sanitizedFilters.contains(CalendarType.preschool) &&
        sanitizedFilters.remove(CalendarType.myPreschool);
    sanitizedFilters.contains(CalendarType.private) &&
        sanitizedFilters.remove(CalendarType.myPrivate);

    List<EventModel> events = [];
    for (final filter in sanitizedFilters) {
      switch (filter) {
        case CalendarType.free:
          events.addAll(await _getFreeLessons(accountContext));
          break;
        case CalendarType.myPreschool:
          break;
        case CalendarType.myPrivate:
          break;
        case CalendarType.preschool:
          events.addAll(await _getPreschoolLessons(accountContext));
          break;
        case CalendarType.private:
          events.addAll(await _getPrivateLessons(accountContext));
          break;
      }
    }
    setState(() {
      _events = buildEventMap(events);
    });
  }

  Future<List<EventModel>> _getFreeLessons(AccountModel accountContext) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromFreeLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map((event) =>
                EventModel.fromJson(event, timeZone, CalendarType.free))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  Future<List<EventModel>> _getPreschoolLessons(AccountModel accountContext) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromPreschoolLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map((event) =>
                EventModel.fromJson(event, timeZone, CalendarType.preschool))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  Future<List<EventModel>> _getPrivateLessons(accountContext) {
    final timeZoneName = accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromPrivateLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map((event) =>
                EventModel.fromJson(event, timeZone, CalendarType.private))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userType == UserType.teacher) {
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

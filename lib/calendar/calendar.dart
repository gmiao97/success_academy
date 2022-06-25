import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/student_calendar.dart';
import 'package:success_academy/calendar/teacher_calendar.dart';
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
  bool _isCalendarInitialized = false;
  AccountModel? _accountContext;
  Map<DateTime, List<EventModel>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late final List<EventType> _availableEventFilters;
  List<EventType> _eventFilters = [];

  final CalendarBuilders _calendarBuilders = CalendarBuilders(
    markerBuilder: ((context, day, events) {
      if (events.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber[600],
          ),
          height: 15,
          width: 15,
          alignment: Alignment.center,
          child: Text(
            '${events.length}',
            style: Theme.of(context).textTheme.bodySmall,
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
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> initCalendar({required AccountModel accountContext}) async {
    _selectedEvents = ValueNotifier([]);
    setState(() {
      _accountContext = context.read<AccountModel>();
    });
    await _setEventFilters();
    await _setAllEvents();
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onTodayButtonTap() {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    setState(() {
      _focusedDay = today;
      _selectedDay = today;
      _selectedEvents.value = _getEventsForDay(today);
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

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _onEventFilterConfirm(List<EventType> filters) {
    setState(() {
      _eventFilters = filters;
    });
    _setAllEvents();
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

  Future<void> _setEventFilters() async {
    final filters = [];
    if (widget.userType == UserType.teacher) {
      filters.addAll([
        EventType.myPreschool,
        EventType.myPrivate,
      ]);
    }
    if (widget.userType == UserType.student) {
      await _setSubscriptionType(_accountContext);

      if (_subscriptionType != null &&
          _subscriptionType != SubscriptionPlan.monthly) {
        if (_subscriptionType == SubscriptionPlan.minimumPreschool) {
          filters.addAll([EventType.preschool, EventType.myPreschool]);
        }
        filters
            .addAll([EventType.free, EventType.private, EventType.myPrivate]);
      }
    }

    setState(() {
      _availableEventFilters = List.from(filters);
      _eventFilters = List.from(filters);
    });
  }

  Future<void> _setAllEvents() async {
    final sanitizedFilters = List.from(_eventFilters);
    sanitizedFilters.contains(EventType.preschool) &&
        sanitizedFilters.remove(EventType.myPreschool);
    sanitizedFilters.contains(EventType.private) &&
        sanitizedFilters.remove(EventType.myPrivate);

    List<EventModel> events = [];
    for (final filter in sanitizedFilters) {
      switch (filter) {
        case EventType.free:
          events.addAll(await _getFreeLessons());
          break;
        case EventType.myPreschool:
          break;
        case EventType.myPrivate:
          break;
        case EventType.preschool:
          events.addAll(await _getPreschoolLessons());
          break;
        case EventType.private:
          events.addAll(await _getPrivateLessons());
          break;
      }
    }
    setState(() {
      _events = buildEventMap(events);
      _isCalendarInitialized = true;
    });
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  Future<List<EventModel>> _getFreeLessons() {
    final timeZoneName = _accountContext!.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromFreeLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map(
                (event) => EventModel.fromJson(event, timeZone, EventType.free))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  Future<List<EventModel>> _getPreschoolLessons() {
    final timeZoneName = _accountContext!.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromPreschoolLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map((event) =>
                EventModel.fromJson(event, timeZone, EventType.preschool))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  Future<List<EventModel>> _getPrivateLessons() {
    final timeZoneName = _accountContext!.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    return event_service
        .listEventsFromPrivateLessonCalendar(
          timeZone: timeZoneName,
          timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
          timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
        )
        .then((eventList) => eventList
            .map((event) =>
                EventModel.fromJson(event, timeZone, EventType.private))
            .toList())
        .catchError((e) {}
            // TODO: Show error state.
            );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCalendarInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    }
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
      calendarBuilders: _calendarBuilders,
      availableEventFilters: _availableEventFilters,
      eventFilters: _eventFilters,
      onTodayButtonTap: _onTodayButtonTap,
      onDaySelected: _onDaySelected,
      onFormatChanged: _onFormatChanged,
      onPageChanged: _onPageChanged,
      getEventsForDay: _getEventsForDay,
      onEventFilterConfirm: _onEventFilterConfirm,
    );
  }
}

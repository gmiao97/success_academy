import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/admin_calendar.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/student_calendar.dart';
import 'package:success_academy/calendar/teacher_calendar.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
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
    return const BaseCalendar();
  }
}

class BaseCalendar extends StatefulWidget {
  const BaseCalendar({Key? key}) : super(key: key);

  @override
  State<BaseCalendar> createState() => _BaseCalendarState();
}

class _BaseCalendarState extends State<BaseCalendar> {
  final DateTime _firstDay =
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 365)));
  final DateTime _lastDay =
      DateUtils.dateOnly(DateTime.now().add(const Duration(days: 365)));
  late DateTime _focusedDay;
  late DateTime _currentDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  late AccountModel _accountContext;
  List<EventModel> _allEvents = [];
  Map<DateTime, List<EventModel>> _events = {};
  late final ValueNotifier<List<EventModel>> _selectedEvents;
  bool _isCalendarInitialized = false;
  late final List<EventType> _availableEventFilters;
  List<EventType> _eventFilters = [];
  EventDisplay _eventDisplay = EventDisplay.all;

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
    initCalendar();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> initCalendar() async {
    _selectedEvents = ValueNotifier([]);
    _accountContext = context.read<AccountModel>();

    _currentDay =
        tz.TZDateTime.now(tz.getLocation(_accountContext.myUser!.timeZone));
    _focusedDay = _currentDay;

    await _setEventFilters();
    await _setAllEvents();
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    if (_events[day] == null) {
      return [];
    }
    _events[day]!.sort((a, b) => a.startTime.millisecondsSinceEpoch
        .compareTo(b.startTime.millisecondsSinceEpoch));
    return _events[day]!;
  }

  void _onTodayButtonTap() {
    final now =
        tz.TZDateTime.now(tz.getLocation(_accountContext.myUser!.timeZone));
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
      _events = buildEventMap(_filterAllEvents(
          showMyEventsOnly: _eventDisplay == EventDisplay.mine));
      _selectedEvents.value =
          _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    });
  }

  void _onEventDisplayChanged(EventDisplay? display) {
    setState(() {
      _eventDisplay = display!;
      _events = buildEventMap(_filterAllEvents(
          showMyEventsOnly: _eventDisplay == EventDisplay.mine));
      _selectedEvents.value =
          _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    });
  }

  Future<void> _setEventFilters() async {
    final filters = [];
    if (_accountContext.userType == UserType.student) {
      final subscriptionPlan = _accountContext.subscriptionPlan;
      if (subscriptionPlan != null &&
          subscriptionPlan != SubscriptionPlan.monthly) {
        if (subscriptionPlan == SubscriptionPlan.minimumPreschool) {
          filters.add(EventType.preschool);
        }
        filters.addAll([EventType.free, EventType.private]);
      }
    } else {
      filters.addAll([
        EventType.free,
        EventType.preschool,
        EventType.private,
      ]);
    }

    setState(() {
      _availableEventFilters = List.from(filters);
      _eventFilters = List.from(filters);
    });
  }

  Future<void> _setAllEvents() async {
    _allEvents = await _listEvents();
    setState(() {
      _events = buildEventMap(_filterAllEvents(
          showMyEventsOnly: _eventDisplay == EventDisplay.mine));
      _isCalendarInitialized = true;
    });
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  List<EventModel> _filterAllEvents({showMyEventsOnly = false}) {
    return _allEvents.where((event) {
      if (!_eventFilters.contains(event.eventType)) {
        return false;
      }
      if (showMyEventsOnly) {
        if (_accountContext.userType == UserType.teacher) {
          return event.teacherId == _accountContext.teacherProfile!.profileId;
        }
        if (_accountContext.userType == UserType.student) {
          return event.studentIdList
              .contains(_accountContext.studentProfile!.profileId);
        }
      }
      return true;
    }).toList();
  }

  Future<List<EventModel>> _listEvents() async {
    final timeZoneName = _accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    List<EventModel> recurringEvents = (await event_service.listEvents(
            timeZone: timeZoneName,
            timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
            timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
            singleEvents: false))
        .where((event) => event['status'] != 'cancelled')
        .map((event) => EventModel.fromJson(event, timeZone))
        .where((event) => event.recurrence.isNotEmpty)
        .toList();

    Map<String, List<String>> recurringEventsMap = {
      for (EventModel e in recurringEvents) e.eventId!: e.recurrence
    };

    List<EventModel> singleEvents = (await event_service.listEvents(
            timeZone: timeZoneName,
            timeMin: tz.TZDateTime.from(_firstDay, timeZone).toIso8601String(),
            timeMax: tz.TZDateTime.from(_lastDay, timeZone).toIso8601String(),
            singleEvents: true))
        .map((event) => EventModel.fromJson(event, timeZone))
        .toList();

    for (EventModel event in singleEvents) {
      if (event.recurrenceId != null) {
        event.recurrence = recurringEventsMap[event.recurrenceId]!;
      }
    }

    return singleEvents;
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
    if (_accountContext.userType == UserType.admin) {
      return AdminCalendar(
        selectedDay: _selectedDay,
        selectedEvents: _selectedEvents,
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        currentDay: _currentDay,
        calendarFormat: _calendarFormat,
        calendarBuilders: _calendarBuilders,
        availableEventFilters: _availableEventFilters,
        eventFilters: _eventFilters,
        eventDisplay: _eventDisplay,
        onTodayButtonTap: _onTodayButtonTap,
        onDaySelected: _onDaySelected,
        onFormatChanged: _onFormatChanged,
        onPageChanged: _onPageChanged,
        getEventsForDay: _getEventsForDay,
        onEventFilterConfirm: _onEventFilterConfirm,
        onEventDisplayChanged: _onEventDisplayChanged,
        onRefresh: _setAllEvents,
      );
    }
    if (_accountContext.userType == UserType.teacher) {
      return TeacherCalendar(
        selectedDay: _selectedDay,
        selectedEvents: _selectedEvents,
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        currentDay: _currentDay,
        calendarFormat: _calendarFormat,
        calendarBuilders: _calendarBuilders,
        availableEventFilters: _availableEventFilters,
        eventFilters: _eventFilters,
        eventDisplay: _eventDisplay,
        onTodayButtonTap: _onTodayButtonTap,
        onDaySelected: _onDaySelected,
        onFormatChanged: _onFormatChanged,
        onPageChanged: _onPageChanged,
        getEventsForDay: _getEventsForDay,
        onEventFilterConfirm: _onEventFilterConfirm,
        onEventDisplayChanged: _onEventDisplayChanged,
        onRefresh: _setAllEvents,
      );
    }
    return StudentCalendar(
      selectedDay: _selectedDay,
      selectedEvents: _selectedEvents,
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      currentDay: _currentDay,
      calendarFormat: _calendarFormat,
      calendarBuilders: _calendarBuilders,
      availableEventFilters: _availableEventFilters,
      eventFilters: _eventFilters,
      eventDisplay: _eventDisplay,
      subscriptionType: _accountContext.subscriptionPlan,
      onTodayButtonTap: _onTodayButtonTap,
      onDaySelected: _onDaySelected,
      onFormatChanged: _onFormatChanged,
      onPageChanged: _onPageChanged,
      getEventsForDay: _getEventsForDay,
      onEventFilterConfirm: _onEventFilterConfirm,
      onEventDisplayChanged: _onEventDisplayChanged,
      onRefresh: _setAllEvents,
    );
  }
}

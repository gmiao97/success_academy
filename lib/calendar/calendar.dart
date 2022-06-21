import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/utils.dart' as utils;
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
    if (account.teacherProfile != null) {
      return const TeacherCalendar();
    }
    if (account.profile == null) {
      return const ProfileBrowse();
    }
    return const StudentCalendar();
  }
}

class StudentCalendar extends StatefulWidget {
  const StudentCalendar({Key? key}) : super(key: key);

  @override
  State<StudentCalendar> createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
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

    return utils.buildStudentProfileScaffold(
      context: context,
      body: Column(
        children: [
          _CalendarHeader(
            header: account.profile!.firstName,
            timeZone: account.myUser!.timeZone,
            onTodayButtonTap: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = _focusedDay;
              });
            },
          ),
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            locale: account.locale,
            daysOfWeekHeight: 25,
            availableCalendarFormats: {
              CalendarFormat.month:
                  account.locale == 'en' ? 'Display Monthly' : '月間表示',
              CalendarFormat.twoWeeks:
                  account.locale == 'en' ? 'Display Biweekly' : '二週間表示',
              CalendarFormat.week:
                  account.locale == 'en' ? 'Display Weekly' : '一週間表示',
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => _getEventsForDay(day),
            calendarBuilders: CalendarBuilders(
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
              }),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _selectedDay != null ? dateFormatter.format(_selectedDay!) : '',
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: ValueListenableBuilder<List<EventModel>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color(value[index].color),
                      ),
                      child: ListTile(
                        onTap: () {},
                        title: Text(value[index].summary),
                        subtitle: Text(
                          '${DateFormat.jm().format(value[index].start)} - ${DateFormat.jm().format(value[index].end)}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherCalendar extends StatefulWidget {
  const TeacherCalendar({Key? key}) : super(key: key);

  @override
  State<TeacherCalendar> createState() => _TeacherCalendarState();
}

class _TeacherCalendarState extends State<TeacherCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return utils.buildTeacherProfileScaffold(
      context: context,
      body: Column(
        children: [
          _CalendarHeader(
            header: account.teacherProfile!.firstName,
            timeZone: account.myUser!.timeZone,
            onTodayButtonTap: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = _focusedDay;
              });
            },
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 500)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            locale: account.locale,
            daysOfWeekHeight: 25,
            availableCalendarFormats: {
              CalendarFormat.month:
                  account.locale == 'en' ? 'Display Monthly' : '月間表示',
              CalendarFormat.twoWeeks:
                  account.locale == 'en' ? 'Display Biweekly' : '二週間表示',
              CalendarFormat.week:
                  account.locale == 'en' ? 'Display Weekly' : '一週間表示',
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => [],
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader(
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

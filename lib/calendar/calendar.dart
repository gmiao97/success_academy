import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/utils.dart' as utils;
import 'package:table_calendar/table_calendar.dart';

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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  List<EventModel> _getAllFreeLessonsForDay(DateTime day) {
    return [
      EventModel(
        title: 'Event 1',
        start: DateTime.parse('2022-06-16 20:18:04Z'),
        end: DateTime.parse('2022-06-16 22:18:04Z'),
      )
    ];
    // if (day.weekday == DateTime.monday) {
    //   return [
    //     EventModel(
    //       title: 'Cyclic event',
    //       start: DateTime.now(),
    //       end: DateTime.now(),
    //     )
    //   ];
    // }
    // return [];
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
            eventLoader: (day) {
              return _getAllFreeLessonsForDay(day);
            },
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
            style: Theme.of(context).textTheme.headlineMedium,
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

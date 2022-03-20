import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/utils.dart' as utils;
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

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
      return utils.buildTeacherProfileScaffold(
        context: context,
        body: _TableCalendar(
          header: account.teacherProfile!.firstName,
          timeZone: account.myUser!.timeZone,
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          calendarFormat: _calendarFormat,
          locale: account.locale,
          onTodayButtonTap: () {
            setState(() {
              _focusedDay = DateTime.now();
              _selectedDay = _focusedDay;
            });
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
        ),
      );
    }
    if (account.profile == null) {
      return const ProfileBrowse();
    }
    return utils.buildStudentProfileScaffold(
      context: context,
      body: _TableCalendar(
        header: account.profile!.firstName,
        timeZone: account.myUser!.timeZone,
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
        calendarFormat: _calendarFormat,
        locale: account.locale,
        onTodayButtonTap: () {
          setState(() {
            _focusedDay = DateTime.now();
            _selectedDay = _focusedDay;
          });
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
      ),
    );
  }
}

typedef _DaySelectedCallback = Function(DateTime, DateTime);
typedef _FormatChangedCallback = Function(CalendarFormat);
typedef _PageChangedCallback = Function(DateTime);

class _TableCalendar extends StatelessWidget {
  const _TableCalendar(
      {Key? key,
      required this.header,
      required this.timeZone,
      required this.focusedDay,
      required this.selectedDay,
      required this.calendarFormat,
      required this.locale,
      required this.onTodayButtonTap,
      required this.onDaySelected,
      required this.onFormatChanged,
      required this.onPageChanged})
      : super(key: key);

  final String header;
  final String timeZone;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final String locale;
  final VoidCallback onTodayButtonTap;
  final _DaySelectedCallback onDaySelected;
  final _FormatChangedCallback onFormatChanged;
  final _PageChangedCallback onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CalendarHeader(
          header: header,
          timeZone: timeZone,
          onTodayButtonTap: onTodayButtonTap,
        ),
        TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.now().add(const Duration(days: 500)),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          locale: locale,
          daysOfWeekHeight: 25,
          availableCalendarFormats: {
            CalendarFormat.month: locale == 'en' ? 'Display Monthly' : '月間表示',
            CalendarFormat.twoWeeks:
                locale == 'en' ? 'Display Biweekly' : '二週間表示',
            CalendarFormat.week: locale == 'en' ? 'Display Weekly' : '一週間表示',
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          onPageChanged: onPageChanged,
        ),
      ],
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

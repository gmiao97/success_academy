import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar.dart';
import 'package:success_academy/utils.dart' as utils;
import 'package:table_calendar/table_calendar.dart';

class TeacherCalendar extends StatelessWidget {
  const TeacherCalendar({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.calendarBuilders,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  }) : super(key: key);

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final CalendarBuilders calendarBuilders;
  final VoidCallback onTodayButtonTap;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return utils.buildTeacherProfileScaffold(
      context: context,
      body: Column(
        children: [
          CalendarHeader(
            header: account.teacherProfile!.firstName,
            timeZone: account.myUser!.timeZone,
            onTodayButtonTap: onTodayButtonTap,
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 500)),
            focusedDay: focusedDay,
            calendarFormat: calendarFormat,
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
              return isSameDay(selectedDay, day);
            },
            onDaySelected: onDaySelected,
            onFormatChanged: onFormatChanged,
            onPageChanged: onPageChanged,
            eventLoader: (day) => [],
            calendarBuilders: calendarBuilders,
          ),
        ],
      ),
    );
  }
}

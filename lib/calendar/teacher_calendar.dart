import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_header.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/utils.dart' as utils;
import 'package:table_calendar/table_calendar.dart';

class TeacherCalendar extends StatelessWidget {
  const TeacherCalendar({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.selectedEvents,
    required this.firstDay,
    required this.lastDay,
    required this.calendarFormat,
    required this.calendarBuilders,
    required this.availableEventFilters,
    required this.eventFilters,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.getEventsForDay,
    required this.onEventFilterConfirm,
  }) : super(key: key);

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final ValueNotifier<List<EventModel>> selectedEvents;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat calendarFormat;
  final CalendarBuilders calendarBuilders;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final VoidCallback onTodayButtonTap;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;
  final List<EventModel> Function(DateTime) getEventsForDay;
  final void Function(List<EventType>) onEventFilterConfirm;

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
            availableEventFilters: availableEventFilters,
            eventFilters: eventFilters,
            onEventFilterConfirm: onEventFilterConfirm,
          ),
          TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
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
            eventLoader: getEventsForDay,
            calendarBuilders: calendarBuilders,
          ),
        ],
      ),
    );
  }
}

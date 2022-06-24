import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/utils.dart' as utils;
import 'package:table_calendar/table_calendar.dart';

class StudentCalendar extends StatelessWidget {
  const StudentCalendar({
    Key? key,
    required this.selectedDay,
    required this.selectedEvents,
    required this.firstDay,
    required this.lastDay,
    required this.subscriptionType,
    required this.allFreeLessons,
    required this.allPreschoolLessons,
    required this.allPrivateLessons,
    required this.focusedDay,
    required this.calendarFormat,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.getEventsForDay,
    required this.calendarBuilders,
  }) : super(key: key);

  final DateTime? selectedDay;
  final ValueNotifier<List<EventModel>> selectedEvents;
  final DateTime firstDay;
  final DateTime lastDay;
  final SubscriptionPlan? subscriptionType;
  final Map<DateTime, List<EventModel>> allFreeLessons;
  final Map<DateTime, List<EventModel>> allPreschoolLessons;
  final Map<DateTime, List<EventModel>> allPrivateLessons;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final VoidCallback onTodayButtonTap;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;
  final List<EventModel> Function(DateTime) getEventsForDay;
  final CalendarBuilders calendarBuilders;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return utils.buildStudentProfileScaffold(
      context: context,
      body: Column(
        children: [
          CalendarHeader(
            header: account.studentProfile!.firstName,
            timeZone: account.myUser!.timeZone,
            onTodayButtonTap: onTodayButtonTap,
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
          const SizedBox(height: 10),
          Text(
            selectedDay != null ? dateFormatter.format(selectedDay!) : '',
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: ValueListenableBuilder<List<EventModel>>(
              valueListenable: selectedEvents,
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

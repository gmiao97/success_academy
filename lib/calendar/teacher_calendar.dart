import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_header.dart';
import 'package:success_academy/calendar/event_dialog.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
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
                  account.locale == 'en' ? 'Display Monthly' : '????????????',
              CalendarFormat.twoWeeks:
                  account.locale == 'en' ? 'Display Biweekly' : '???????????????',
              CalendarFormat.week:
                  account.locale == 'en' ? 'Display Weekly' : '???????????????',
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
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => TeacherCreateEventDialog(
                firstDay: firstDay,
                lastDay: lastDay,
                selectedDay: selectedDay,
                eventTypes: const [EventType.private],
              ),
            ),
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            label: Text(S.of(context).createEvent),
          ),
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
                        border: Border.all(
                          color: Color(value[index].bordercolor),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color(value[index].fillColor),
                      ),
                      child: ListTile(
                        onTap: () {},
                        title: Text(value[index].summary),
                        subtitle: Text(
                          '${timeFormatter.format(value[index].startTime)} - ${timeFormatter.format(value[index].endTime)}',
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_header.dart';
import 'package:success_academy/calendar/create_event_dialog.dart';
import 'package:success_academy/calendar/edit_event_dialog.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/view_event_dialog.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherCalendar extends StatelessWidget {
  const TeacherCalendar({
    Key? key,
    required this.focusedDay,
    required this.currentDay,
    required this.selectedDay,
    required this.selectedEvents,
    required this.firstDay,
    required this.lastDay,
    required this.calendarFormat,
    required this.calendarBuilders,
    required this.availableEventFilters,
    required this.eventFilters,
    required this.eventDisplay,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.getEventsForDay,
    required this.onEventFilterConfirm,
    required this.onEventDisplayChanged,
    required this.onRefresh,
  }) : super(key: key);

  final DateTime focusedDay;
  final DateTime currentDay;
  final DateTime? selectedDay;
  final ValueNotifier<List<EventModel>> selectedEvents;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat calendarFormat;
  final CalendarBuilders calendarBuilders;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final EventDisplay eventDisplay;
  final VoidCallback onTodayButtonTap;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final void Function(DateTime) onPageChanged;
  final List<EventModel> Function(DateTime) getEventsForDay;
  final void Function(List<EventType>) onEventFilterConfirm;
  final void Function(EventDisplay?) onEventDisplayChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Column(
      children: [
        CalendarHeader(
          header: account.teacherProfile!.firstName,
          timeZone: account.myUser!.timeZone,
          onTodayButtonTap: onTodayButtonTap,
          availableEventFilters: availableEventFilters,
          eventFilters: eventFilters,
          onEventFilterConfirm: onEventFilterConfirm,
          shouldShowEventDisplay: true,
          eventDisplay: eventDisplay,
          onEventDisplayChanged: onEventDisplayChanged,
        ),
        TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          currentDay: currentDay,
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
        ElevatedButton.icon(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateEventDialog(
              teacherId: account.teacherProfile!.profileId,
              firstDay: firstDay,
              lastDay: lastDay,
              selectedDay: selectedDay,
              eventTypes: const [EventType.private],
              onRefresh: onRefresh,
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
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(value[index].fillColor),
                    ),
                    child: ListTile(
                      onTap: () => value[index].teacherId ==
                              account.teacherProfile!.profileId
                          ? showDialog(
                              context: context,
                              builder: (context) => EditEventDialog(
                                event: value[index],
                                firstDay: firstDay,
                                lastDay: lastDay,
                                eventTypes: const [
                                  EventType.private,
                                  EventType.free,
                                  EventType.preschool
                                ],
                                onRefresh: onRefresh,
                              ),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) => ViewEventDialog(
                                event: value[index],
                              ),
                            ),
                      title: Text(value[index].summary),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${timeFormatter.format(value[index].startTime)} - '
                            '${timeFormatter.format(value[index].endTime)}',
                          ),
                          value[index].teacherId ==
                                  account.teacherProfile!.profileId
                              ? Text(
                                  S.of(context).signedUp,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

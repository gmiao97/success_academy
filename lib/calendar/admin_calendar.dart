import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_header.dart';
import 'package:success_academy/calendar/create_event_dialog.dart';
import 'package:success_academy/calendar/edit_event_dialog.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

@Deprecated('migration to CalendarV2')
class AdminCalendar extends StatelessWidget {
  const AdminCalendar({
    super.key,
    required this.focusedDay,
    required this.currentDay,
    required this.selectedDay,
    required this.selectedEvents,
    required this.firstDay,
    required this.lastDay,
    required this.calendarBuilders,
    required this.availableEventFilters,
    required this.eventFilters,
    required this.eventDisplay,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.getEventsForDay,
    required this.onEventFilterConfirm,
    required this.onEventDisplayChanged,
    required this.onRefresh,
  });

  final DateTime focusedDay;
  final DateTime currentDay;
  final DateTime? selectedDay;
  final ValueNotifier<List<EventModel>> selectedEvents;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarBuilders calendarBuilders;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final EventDisplay eventDisplay;
  final VoidCallback onTodayButtonTap;
  final void Function(DateTime, DateTime) onDaySelected;
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
          header: "ADMIN",
          timeZone: account.myUser!.timeZone,
          onTodayButtonTap: onTodayButtonTap,
          availableEventFilters: availableEventFilters,
          eventFilters: eventFilters,
          onEventFilterConfirm: onEventFilterConfirm,
          shouldShowEventDisplay: false,
        ),
        TableCalendar(
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
          ),
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          currentDay: currentDay,
          calendarFormat: CalendarFormat.week,
          locale: account.locale,
          daysOfWeekHeight: 25,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
          eventLoader: getEventsForDay,
          calendarBuilders: calendarBuilders,
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateEventDialog(
              firstDay: firstDay,
              lastDay: lastDay,
              selectedDay: selectedDay ?? DateTime.now(),
              onRefresh: onRefresh,
            ),
          ),
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
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
                      onTap: () => showDialog(
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
                      ),
                      title: Text(value[index].summary),
                      subtitle: Text(
                        '${timeFormatter.format(value[index].startTime)} - '
                        '${timeFormatter.format(value[index].endTime)}',
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_header.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/signup_event_dialog.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentCalendar extends StatefulWidget {
  const StudentCalendar({
    super.key,
    required this.selectedDay,
    required this.selectedEvents,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.currentDay,
    required this.calendarFormat,
    required this.calendarBuilders,
    required this.availableEventFilters,
    required this.eventFilters,
    required this.eventDisplay,
    required this.subscriptionType,
    required this.onTodayButtonTap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.getEventsForDay,
    required this.onEventFilterConfirm,
    required this.onEventDisplayChanged,
    required this.onRefresh,
  });

  final DateTime? selectedDay;
  final ValueNotifier<List<EventModel>> selectedEvents;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime currentDay;
  final CalendarFormat calendarFormat;
  final CalendarBuilders calendarBuilders;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final EventDisplay eventDisplay;
  final SubscriptionPlan? subscriptionType;
  final VoidCallback onTodayButtonTap;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final void Function(DateTime) onPageChanged;
  final List<EventModel> Function(DateTime) getEventsForDay;
  final void Function(List<EventType>) onEventFilterConfirm;
  final void Function(EventDisplay?) onEventDisplayChanged;
  final VoidCallback onRefresh;

  @override
  State<StudentCalendar> createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
  late bool _showHeader;

  @override
  void initState() {
    super.initState();
    _showHeader = widget.subscriptionType == null ||
        widget.subscriptionType == SubscriptionPlan.monthly;
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Column(
      children: [
        _showHeader
            ? MaterialBanner(
                content: Text(S.of(context).noPlan),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showHeader = false;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              )
            : const SizedBox.shrink(),
        CalendarHeader(
          header: account.studentProfile!.firstName,
          timeZone: account.myUser!.timeZone,
          onTodayButtonTap: widget.onTodayButtonTap,
          availableEventFilters: widget.availableEventFilters,
          eventFilters: widget.eventFilters,
          onEventFilterConfirm: widget.onEventFilterConfirm,
          shouldShowEventDisplay: true,
          eventDisplay: widget.eventDisplay,
          onEventDisplayChanged: widget.onEventDisplayChanged,
        ),
        TableCalendar(
          firstDay: widget.firstDay,
          lastDay: widget.lastDay,
          focusedDay: widget.focusedDay,
          currentDay: widget.currentDay,
          calendarFormat: widget.calendarFormat,
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
            return isSameDay(widget.selectedDay, day);
          },
          onDaySelected: widget.onDaySelected,
          onFormatChanged: widget.onFormatChanged,
          onPageChanged: widget.onPageChanged,
          eventLoader: widget.getEventsForDay,
          calendarBuilders: widget.calendarBuilders,
        ),
        const SizedBox(height: 10),
        Text(
          widget.selectedDay != null
              ? dateFormatter.format(widget.selectedDay!)
              : '',
          style: Theme.of(context).textTheme.headline6,
        ),
        Expanded(
          child: ValueListenableBuilder<List<EventModel>>(
            valueListenable: widget.selectedEvents,
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
                        builder: (context) => SignupEventDialog(
                          event: value[index],
                          onRefresh: widget.onRefresh,
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
                          value[index]
                                  .studentIdList
                                  .contains(account.studentProfile!.profileId)
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

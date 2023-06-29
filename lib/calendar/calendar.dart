import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/calendar/create_event_dialog.dart';
import 'package:success_academy/calendar/delete_event_dialog.dart';
import 'package:success_academy/calendar/edit_event_dialog.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/quit_event_dialog.dart';
import 'package:success_academy/calendar/signup_event_dialog.dart';
import 'package:success_academy/calendar/view_event_dialog.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final List<EventType> _availableEventTypes;
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  final Map<DateTime, List<EventModel>> _events = HashMap(
    equals: (a, b) => isSameDay(a, b),
    hashCode: (e) => DateUtils.dateOnly(e).hashCode,
  );
  late DateTime _currentDay;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<EventType> _selectedEventTypes;
  List<EventModel> _selectedEvents = [];
  EventDisplay _eventDisplay = EventDisplay.all;
  bool _showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final account = context.read<AccountModel>();
    _currentDay = _focusedDay = _selectedDay =
        tz.TZDateTime.now(tz.getLocation(account.myUser!.timeZone));
    _firstDay = _currentDay.subtract(const Duration(days: 365));
    _lastDay = _currentDay.add(const Duration(days: 365));
    _availableEventTypes = _selectedEventTypes =
        getEventTypesCanView(account.userType, account.subscriptionPlan);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final account = context.watch<AccountModel>();
    _currentDay = tz.TZDateTime.now(tz.getLocation(account.myUser!.timeZone));
    _setEvents();
  }

  void _setEvents() async {
    setState(() {
      _showLoadingIndicator = true;
    });
    final account = context.read<AccountModel>();
    final location = tz.getLocation(account.myUser!.timeZone);

    final singleEvents = (await event_service.listEvents(
            location: location,
            timeMin: _currentDay
                .subtract(const Duration(days: 30))
                .toIso8601String(),
            timeMax:
                _currentDay.add(const Duration(days: 90)).toIso8601String(),
            singleEvents: true))
        .where((event) {
      if (!_selectedEventTypes.contains(event.eventType)) {
        return false;
      }
      if (_eventDisplay == EventDisplay.mine) {
        if (account.userType == UserType.teacher) {
          return isTeacherInEvent(account.teacherProfile!.profileId, event);
        }
        if (account.userType == UserType.student) {
          return isStudentInEvent(account.studentProfile!.profileId, event);
        }
      }
      return true;
    }).toList();

    setState(() {
      _events.clear();
      _events.addAll(buildEventMap(singleEvents));
      _selectedEvents = _getEventsForDay(_selectedDay);
      _showLoadingIndicator = false;
    });
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _deleteEventsLocally(
      {required String eventId, bool isRecurrence = false, DateTime? from}) {
    if (isRecurrence) {
      setState(() {
        for (final eventList in _events.values) {
          eventList.removeWhere((e) {
            if (from != null) {
              return e.startTime.isAfter(from) && e.recurrenceId == eventId;
            }
            return e.recurrenceId == eventId;
          });
        }
      });
    } else {
      setState(() {
        for (final eventList in _events.values) {
          eventList.removeWhere((e) => e.eventId == eventId);
        }
      });
    }
  }

  void _onTodayButtonClick() {
    setState(() {
      _focusedDay = _selectedDay = _currentDay = tz.TZDateTime.now(
          tz.getLocation(context.read<AccountModel>().myUser!.timeZone));
      _selectedEvents = _getEventsForDay(_selectedDay);
    });
  }

  void _onEventFiltersChanged(
      List<EventType> eventTypes, EventDisplay eventDisplay) {
    setState(() {
      _selectedEventTypes = eventTypes;
      _eventDisplay = eventDisplay;
    });
    _setEvents();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _getEventsForDay(_selectedDay);
    });
  }

  void _onPageChanged(focusedDay) {
    _focusedDay = focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select<AccountModel, String>((a) => a.locale);
    final userType = context.select<AccountModel, UserType>((a) => a.userType);
    final teacherId = context
        .select<AccountModel, String?>((a) => a.teacherProfile?.profileId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _showLoadingIndicator
            ? LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
              )
            : const SizedBox(height: 4),
        Card(
          child: TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              leftChevronPadding: EdgeInsets.all(8),
              rightChevronPadding: EdgeInsets.all(8),
              leftChevronMargin: EdgeInsets.symmetric(horizontal: 4),
              rightChevronMargin: EdgeInsets.symmetric(horizontal: 4),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) => _CalendarHeader(
                day: day,
                availableEventTypes: _availableEventTypes,
                selectedEventTypes: _selectedEventTypes,
                eventDisplay: _eventDisplay,
                onTodayButtonClick: _onTodayButtonClick,
                onEventFiltersChanged: _onEventFiltersChanged,
              ),
            ),
            calendarFormat: CalendarFormat.week,
            daysOfWeekHeight: 20,
            locale: locale,
            currentDay: _currentDay,
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onPageChanged: _onPageChanged,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              DateFormat.yMMMMEEEEd(locale).format(_selectedDay),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              _EventList(
                events: _selectedEvents,
                firstDay: _firstDay,
                lastDay: _lastDay,
                refreshState: () {
                  setState(() {});
                },
                deleteEventsLocally: _deleteEventsLocally,
              ),
              if (canEditEvents(userType))
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(kFloatingActionButtonMargin),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => CreateEventDialog(
                          teacherId: teacherId,
                          firstDay: _firstDay,
                          lastDay: _lastDay,
                          selectedDay: _selectedDay,
                          onRefresh: _setEvents,
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(
                        S.of(context).createEvent,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarHeader extends StatefulWidget {
  final DateTime day;
  final List<EventType> availableEventTypes;
  final List<EventType> selectedEventTypes;
  final EventDisplay eventDisplay;
  final VoidCallback onTodayButtonClick;
  final void Function(List<EventType>, EventDisplay) onEventFiltersChanged;

  const _CalendarHeader({
    required this.day,
    required this.availableEventTypes,
    required this.selectedEventTypes,
    required this.eventDisplay,
    required this.onTodayButtonClick,
    required this.onEventFiltersChanged,
  });

  @override
  State<_CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<_CalendarHeader> {
  // Track local copy of event display radio and set calendar's event display
  // state together with event types when confirm is clicked.
  late EventDisplay _eventDisplay;

  @override
  void initState() {
    super.initState();
    _eventDisplay = widget.eventDisplay;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select<AccountModel, String>((a) => a.locale);
    final timeZone =
        context.select<AccountModel, String>((a) => a.myUser!.timeZone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMM(locale).format(widget.day),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              timeZone.replaceAll('_', ' '),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.filter_list),
              label: Text(S.of(context).filter),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => SizedBox(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            S.of(context).filter,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Column(
                            children: [
                              RadioListTile<EventDisplay>(
                                title: Text(EventDisplay.all.getName(context)),
                                value: EventDisplay.all,
                                groupValue: _eventDisplay,
                                onChanged: (value) {
                                  setState(() {
                                    _eventDisplay = value!;
                                  });
                                },
                              ),
                              RadioListTile<EventDisplay>(
                                title: Text(EventDisplay.mine.getName(context)),
                                value: EventDisplay.mine,
                                groupValue: _eventDisplay,
                                onChanged: (value) {
                                  setState(() {
                                    _eventDisplay = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: MultiSelectBottomSheet<EventType>(
                              items: widget.availableEventTypes
                                  .map((e) =>
                                      MultiSelectItem(e, e.getName(context)))
                                  .toList(),
                              initialValue: widget.selectedEventTypes,
                              title: Text(
                                S.of(context).eventType,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              listType: MultiSelectListType.CHIP,
                              confirmText: Text(S.of(context).confirm),
                              cancelText: Text(S.of(context).cancel),
                              initialChildSize: 1.0,
                              maxChildSize: 1.0,
                              onConfirm: (values) {
                                widget.onEventFiltersChanged(
                                    values, _eventDisplay);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton.icon(
              icon: Text(S.of(context).today),
              label: const Icon(Icons.today),
              onPressed: widget.onTodayButtonClick,
            ),
          ],
        )
      ],
    );
  }
}

class _EventList extends StatelessWidget {
  final List<EventModel> events;
  final DateTime firstDay;
  final DateTime lastDay;
  final VoidCallback refreshState;
  final void Function({
    required String eventId,
    bool isRecurrence,
    DateTime? from,
  }) deleteEventsLocally;

  const _EventList({
    required this.events,
    required this.firstDay,
    required this.lastDay,
    required this.refreshState,
    required this.deleteEventsLocally,
  });

  Widget _getEventActions(BuildContext context, EventModel event) {
    final account = context.read<AccountModel>();

    if (account.userType == UserType.student) {
      if (isStudentInEvent(account.studentProfile!.profileId, event)) {
        return FilledButton.tonalIcon(
          icon: const Icon(Icons.check),
          label: Text(S.of(context).signedUp),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => QuitEventDialog(
              event: event,
              refresh: refreshState,
            ),
          ),
        );
      } else if (isEventFull(event)) {
        return OutlinedButton(
          onPressed: null,
          child: Text(S.of(context).eventFull),
        );
      } else {
        return OutlinedButton(
          child: Text(S.of(context).signup),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => SignupEventDialog(
              event: event,
              refresh: refreshState,
            ),
          ),
        );
      }
    }
    if (account.userType == UserType.teacher) {
      if (isTeacherInEvent(account.teacherProfile!.profileId, event)) {
        return SizedBox(
          width: 80,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => EditEventDialog(
                    event: event,
                    firstDay: firstDay,
                    lastDay: lastDay,
                    onRefresh: refreshState,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DeleteEventDialog(
                    event: event,
                    deleteEventsLocally: deleteEventsLocally,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    if (account.userType == UserType.admin) {
      return SizedBox(
        width: 80,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => EditEventDialog(
                  event: event,
                  firstDay: firstDay,
                  lastDay: lastDay,
                  onRefresh: () {},
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => DeleteEventDialog(
                  event: event,
                  deleteEventsLocally: deleteEventsLocally,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select<AccountModel, String>((a) => a.locale);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: events.length,
      itemBuilder: (context, index) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Card(
            elevation: 4,
            color: events[index].eventType.getColor(context),
            child: ListTile(
              leading: events[index].eventType.getIcon(context),
              trailing: _getEventActions(context, events[index]),
              title: Text(
                events[index].summary,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    events[index].eventType.getName(context),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    '${DateFormat.jm(locale).format(events[index].startTime)} - ${DateFormat.jm(locale).format(events[index].endTime)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => ViewEventDialog(
                  event: events[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

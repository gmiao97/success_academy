import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/calendar/create_event_dialog.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/view_event_dialog.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/event_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CalendarV2 extends StatefulWidget {
  const CalendarV2({super.key});

  @override
  State<CalendarV2> createState() => _CalendarV2State();
}

class _CalendarV2State extends State<CalendarV2> {
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  late DateTime _currentDay;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  bool _showLoadingIndicator = false;
  final ValueNotifier<List<EventModel>> _selectedEvents = ValueNotifier([]);
  final Map<DateTime, List<EventModel>> _events = HashMap(
    equals: (a, b) => isSameDay(a, b),
    hashCode: (e) => DateUtils.dateOnly(e).hashCode,
  );

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final account = context.read<AccountModel>();
    _currentDay = _focusedDay = _selectedDay =
        tz.TZDateTime.now(tz.getLocation(account.myUser!.timeZone));
    _firstDay = _currentDay.subtract(const Duration(days: 365));
    _lastDay = _currentDay.add(const Duration(days: 365));
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
    final account = context.watch<AccountModel>();
    final location = tz.getLocation(account.myUser!.timeZone);

    final singleEvents = (await listEvents(
        location: location,
        timeMin:
            _currentDay.subtract(const Duration(days: 28)).toIso8601String(),
        timeMax: _currentDay.add(const Duration(days: 28)).toIso8601String(),
        singleEvents: true));

    setState(() {
      _events.clear();
      _events.addAll(buildEventMap(singleEvents));
      _showLoadingIndicator = false;
    });
    _selectedEvents.value = _getEventsForDay(_selectedDay);
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onTodayButtonClick() {
    setState(() {
      _focusedDay = _selectedDay = _currentDay = tz.TZDateTime.now(
          tz.getLocation(context.read<AccountModel>().myUser!.timeZone));
    });
    _selectedEvents.value = _getEventsForDay(_selectedDay);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select<AccountModel, String>((a) => a.locale);
    final userType = context.select<AccountModel, UserType>((a) => a.userType);
    final timeZone =
        context.select<AccountModel, String>((a) => a.myUser!.timeZone);
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
              headerTitleBuilder: (context, day) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat.yMMM(locale).format(day),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _onTodayButtonClick,
                    icon: const Icon(Icons.today),
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
            ),
            calendarFormat: CalendarFormat.week,
            daysOfWeekHeight: 20,
            locale: locale,
            currentDay: _currentDay,
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
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
              ValueListenableBuilder<List<EventModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, child) => _EventList(events: value),
              ),
              if (canCreateEvents(userType))
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
                          onRefresh: () {},
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

class _EventList extends StatelessWidget {
  final List<EventModel> events;

  const _EventList({
    required this.events,
  });

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

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
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
  final List<EventModel> _selectedEvents = [];
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
      _selectedEvents.clear();
      _selectedEvents.addAll(_getEventsForDay(_selectedDay));
      _showLoadingIndicator = false;
    });
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onTodayButtonClick() {
    setState(() {
      _focusedDay = _selectedDay = _currentDay;
      _selectedEvents.clear();
      _selectedEvents.addAll(_getEventsForDay(_selectedDay));
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.clear();
      _selectedEvents.addAll(_getEventsForDay(_selectedDay));
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

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
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat.yMMM(account.locale).format(day),
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
                    account.myUser!.timeZone.replaceAll('_', ' '),
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
            locale: account.locale,
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
        Align(
          child: Text(
            DateFormat.yMMMMEEEEd(account.locale).format(_selectedDay),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedEvents.length,
            itemBuilder: (context, index) =>
                Text(_selectedEvents[index].startTime.toString()),
          ),
        ),
      ],
    );
  }
}

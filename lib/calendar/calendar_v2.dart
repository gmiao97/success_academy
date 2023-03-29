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
  void didChangeDependencies() {
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
    final timeZone = account.myUser!.timeZone;
    final location = tz.getLocation(timeZone);

    final singleEvents = (await listEvents(
        timeZone: timeZone,
        location: location,
        timeMin: tz.TZDateTime.from(
                _currentDay.subtract(const Duration(days: 28)), location)
            .toIso8601String(),
        timeMax: tz.TZDateTime.from(
                _currentDay.add(const Duration(days: 28)), location)
            .toIso8601String(),
        singleEvents: true));

    setState(() {
      _events.clear();
      _events.addAll(buildEventMap(singleEvents));
      _showLoadingIndicator = false;
    });
  }

  void _onTodayButtonClick() {
    setState(() {
      _focusedDay = _selectedDay = _currentDay;
    });
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
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
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
          ),
        ),
        Align(
          child: Text(
            DateFormat.yMMMMEEEEd(account.locale).format(_selectedDay),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

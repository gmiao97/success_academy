import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.selectedDay,
    required this.eventTypes,
    required this.onRefresh,
  }) : super(key: key);

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? selectedDay;
  final List<EventType> eventTypes;
  final void Function() onRefresh;

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  late DateTime _day;
  late String _summary;
  late String _description;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  late String _timeZoneName;
  late EventType _eventType;
  List<String> _recurrence = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _timeZoneName = context.read<AccountModel>().myUser!.timeZone;
    setState(() {
      _day = widget.selectedDay ??
          tz.TZDateTime.now(tz.getLocation(_timeZoneName));
      _dayController.text = dateFormatter.format(_day);
      _eventType = widget.eventTypes[0];
    });
  }

  void _selectDay(BuildContext context) async {
    final DateTime? day = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: widget.firstDay,
      lastDate: widget.lastDay,
    );
    if (day != null) {
      setState(() {
        _day = day;
        _dayController.text = dateFormatter.format(day);
      });
    }
  }

  void _selectStartTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (time != null) {
      setState(() {
        _startTime = time;
        _startTimeController.text = time.format(context);
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (time != null) {
      setState(() {
        _endTime = time;
        _endTimeController.text = time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _account = context.read<AccountModel>();

    Map<EventType, String> _eventTypeNames = {
      EventType.free: S.of(context).free,
      EventType.preschool: S.of(context).preschool,
      EventType.private: S.of(context).private,
    };

    Map<Recurrence, String> _recurrenceNames = {
      Recurrence.none: S.of(context).recurNone,
      Recurrence.daily: S.of(context).recurDaily,
      Recurrence.weekly: S.of(context).recurWeekly,
      Recurrence.monthly: S.of(context).recurMonthly,
    };

    return AlertDialog(
      title: Text(
        S.of(context).createEvent,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<EventType>(
                items: widget.eventTypes
                    .map((eventType) => DropdownMenuItem(
                          value: eventType,
                          child: Text(_eventTypeNames[eventType]!),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
                value: _eventType,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.text_snippet_outlined),
                  labelText: S.of(context).eventSummaryLabel,
                ),
                onChanged: (value) {
                  setState(() {
                    _summary = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).eventSummaryValidation;
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  icon: const Icon(Icons.text_snippet_outlined),
                  labelText: S.of(context).eventDescriptionLabel,
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).eventDescriptionValidation;
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                readOnly: true,
                controller: _dayController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_month),
                  labelText: S.of(context).eventDateLabel,
                ),
                onTap: () {
                  _selectDay(context);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                readOnly: true,
                controller: _startTimeController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.watch_later_outlined),
                  labelText: S.of(context).eventStartLabel,
                ),
                onTap: () {
                  _selectStartTime(context);
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).eventStartValidation;
                  }
                  if (timeOfDayToInt(_startTime) >= timeOfDayToInt(_endTime)) {
                    return S.of(context).eventValidTimeValidation;
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                readOnly: true,
                controller: _endTimeController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.watch_later_outlined),
                  labelText: S.of(context).eventEndLabel,
                ),
                onTap: () {
                  _selectEndTime(context);
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).eventEndValidation;
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Recurrence>(
                items: Recurrence.values
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(_recurrenceNames[r]!),
                        ))
                    .toList(),
                value: Recurrence.none,
                onChanged: (value) {
                  switch (value) {
                    case Recurrence.none:
                      _recurrence = [];
                      break;
                    case Recurrence.daily:
                      _recurrence = [
                        RecurrenceRule(frequency: Frequency.daily).toString()
                      ];
                      break;
                    case Recurrence.weekly:
                      _recurrence = [
                        RecurrenceRule(frequency: Frequency.weekly).toString()
                      ];
                      break;
                    case Recurrence.monthly:
                      _recurrence = [
                        RecurrenceRule(frequency: Frequency.monthly).toString()
                      ];
                      break;
                    default:
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(S.of(context).confirm),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final event = EventModel(
                  eventType: _eventType,
                  summary: _summary,
                  description: _description,
                  startTime: tz.TZDateTime(
                    tz.getLocation(_timeZoneName),
                    _day.year,
                    _day.month,
                    _day.day,
                    _startTime.hour,
                    _startTime.minute,
                  ),
                  endTime: tz.TZDateTime(
                    tz.getLocation(_timeZoneName),
                    _day.year,
                    _day.month,
                    _day.day,
                    _endTime.hour,
                    _endTime.minute,
                  ),
                  recurrence: _recurrence,
                  timeZone: _timeZoneName,
                  teacherId: _account.teacherProfile!.profileId);
              event_service
                  .insertEvent(event)
                  .then((unused) => widget.onRefresh());
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

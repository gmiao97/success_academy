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

class EditEventDialog extends StatefulWidget {
  const EditEventDialog({
    Key? key,
    required this.event,
    required this.firstDay,
    required this.lastDay,
    required this.eventTypes,
    required this.onRefresh,
  }) : super(key: key);

  final EventModel event;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<EventType> eventTypes;
  final void Function() onRefresh;

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  late DateTime _day;
  late String _summary;
  late String _description;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _timeZoneName;
  late EventType _eventType;
  late List<String> _recurrence;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _timeZoneName = context.read<AccountModel>().myUser!.timeZone;
    setState(() {
      _day = DateTime(widget.event.startTime.year, widget.event.startTime.month,
          widget.event.startTime.day);
      _summary = widget.event.summary;
      _description = widget.event.description;
      _startTime = TimeOfDay.fromDateTime(widget.event.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event.endTime);
      _eventType = widget.event.eventType;
      _recurrence = widget.event.recurrence;
      _dayController.text = dateFormatter.format(_day);
    });
  }

  void _selectDay() async {
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

  void _selectStartTime() async {
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

  void _selectEndTime() async {
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
    _startTimeController.text = _startTime.format(context);
    _endTimeController.text = _endTime.format(context);

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

    Map<Recurrence, List<String>> _recurrenceRules = {
      Recurrence.none: [],
      Recurrence.daily: [RecurrenceRule(frequency: Frequency.daily).toString()],
      Recurrence.weekly: [
        RecurrenceRule(frequency: Frequency.weekly).toString()
      ],
      Recurrence.monthly: [
        RecurrenceRule(frequency: Frequency.monthly).toString()
      ],
    };

    Map<String, Recurrence> _rRuleMap = {
      RecurrenceRule(frequency: Frequency.daily).toString(): Recurrence.daily,
      RecurrenceRule(frequency: Frequency.weekly).toString(): Recurrence.weekly,
      RecurrenceRule(frequency: Frequency.monthly).toString():
          Recurrence.monthly,
    };

    return AlertDialog(
      title: Text(
        S.of(context).editEvent,
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
                initialValue: _summary,
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
                initialValue: _description,
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
                  _selectDay();
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
                  _selectStartTime();
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
                  _selectEndTime();
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
                value: _recurrence.isNotEmpty
                    ? _rRuleMap[_recurrence[0]] ?? Recurrence.none
                    : Recurrence.none,
                onChanged: (value) {
                  _recurrence = _recurrenceRules[value]!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(S.of(context).delete),
          style: ElevatedButton.styleFrom(
            primary: Colors.red.shade400,
          ),
          onPressed: () {
            event_service.deleteEvent(eventId: widget.event.eventId!).then(
              (unused) {
                widget.onRefresh();
              },
            );
            Navigator.of(context).pop();
          },
        ),
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
                  eventId: widget.event.eventId,
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
              event_service.updateEvent(event).then(
                (unused) {
                  widget.onRefresh();
                },
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

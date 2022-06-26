import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
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
  }) : super(key: key);

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? selectedDay;
  final List<EventType> eventTypes;

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

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _timeZoneName = context.read<AccountModel>().myUser!.timeZone;
    setState(() {
      _day = widget.selectedDay ??
          tz.TZDateTime.now(tz.getLocation(_timeZoneName));
      _dayController.text = dateFormatter.format(_day);
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
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

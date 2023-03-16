import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.teacherId,
    required this.firstDay,
    required this.lastDay,
    required this.selectedDay,
    required this.eventTypes,
    required this.onRefresh,
  }) : super(key: key);

  final String? teacherId;
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
  final TextEditingController _recurUntilController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  late DateTime _recurUntilInitialValue;
  late DateTime _day;
  DateTime? _recurUntil;
  late String _summary;
  late String _description;
  int? _numPoints;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  late String _timeZoneName;
  late EventType _eventType;
  Frequency? _recurFrequency;
  bool _submitClicked = false;
  String? _teacherId;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _timeZoneName = context.read<AccountModel>().myUser!.timeZone;
    setState(() {
      _day = widget.selectedDay ?? DateTime.now();
      _recurUntilInitialValue = _day.add(const Duration(days: 30));
      _dayController.text = dateFormatter.format(_day);
      _eventType = widget.eventTypes[0];
      _teacherId = widget.teacherId;
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

  void _selectRecurUntil() async {
    final DateTime? day = await showDatePicker(
      context: context,
      initialDate: _recurUntilInitialValue,
      firstDate: widget.firstDay,
      lastDate: widget.lastDay,
    );
    if (day != null) {
      setState(() {
        _recurUntil = day;
        _recurUntilController.text = dateFormatter.format(day);
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
    final account = context.read<AccountModel>();

    Map<EventType, String> eventTypeNames = {
      EventType.free: S.of(context).free,
      EventType.preschool: S.of(context).preschool,
      EventType.private: S.of(context).private,
    };

    Map<Frequency?, String> frequencyNames = {
      null: S.of(context).recurNone,
      Frequency.daily: S.of(context).recurDaily,
      Frequency.weekly: S.of(context).recurWeekly,
      Frequency.monthly: S.of(context).recurMonthly,
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
                          child: Text(eventTypeNames[eventType]!),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
                value: _eventType,
              ),
              account.userType == UserType.admin
                  ? DropdownButtonFormField<String>(
                      items: account.teacherProfileList!
                          .map((profile) => DropdownMenuItem(
                                value: profile.profileId,
                                child: Text(
                                    '${profile.lastName}, ${profile.firstName}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _teacherId = value;
                        });
                      },
                      value: _teacherId,
                      decoration: InputDecoration(
                          hintText: 'Teacher',
                          icon: const Icon(Icons.person_outline),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _teacherId = null;
                              });
                            },
                          )),
                    )
                  : const SizedBox.shrink(),
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
              SizedBox(
                width: 500,
                child: TextFormField(
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
              ),
              _eventType == EventType.private
                  ? TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        icon: const Icon(Icons.add),
                        labelText: S.of(context).eventPointsLabel,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _numPoints = int.parse(value);
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).eventPointsValidation;
                        }
                        return null;
                      },
                    )
                  : const SizedBox.shrink(),
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
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  S.of(context).recurTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              DropdownButtonFormField<Frequency>(
                items: recurFrequencies
                    .map((f) => DropdownMenuItem(
                          value: f,
                          child: Text(frequencyNames[f]!),
                        ))
                    .toList(),
                value: _recurFrequency,
                onChanged: (value) {
                  setState(() {
                    _recurFrequency = value;
                  });
                },
              ),
              if (_recurFrequency != null)
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _recurUntil != null,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _recurUntil = _recurUntilInitialValue;
                                _recurUntilController.text = dateFormatter
                                    .format(_recurUntilInitialValue);
                              } else {
                                _recurUntil = null;
                              }
                            });
                          },
                        ),
                        Text(S.of(context).recurEnd),
                      ],
                    ),
                    if (_recurUntil != null)
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        controller: _recurUntilController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.calendar_month),
                          labelText: S.of(context).eventDateLabel,
                        ),
                        onTap: () {
                          _selectRecurUntil();
                        },
                      ),
                  ],
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
        _submitClicked
            ? const CircularProgressIndicator(
                value: null,
              )
            : ElevatedButton(
                child: Text(S.of(context).confirm),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _submitClicked = true;
                    });
                    final event = EventModel(
                        eventType: _eventType,
                        summary: _summary,
                        description: _description,
                        numPoints:
                            _eventType == EventType.private ? _numPoints : 0,
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
                        recurrence: buildRecurrence(
                            frequency: _recurFrequency,
                            recurUntil: _recurUntil != null
                                ? tz.TZDateTime(
                                        tz.getLocation(_timeZoneName),
                                        _recurUntil!.year,
                                        _recurUntil!.month,
                                        _recurUntil!.day)
                                    .add(const Duration(days: 1))
                                : null),
                        timeZone: _timeZoneName,
                        teacherId: _teacherId);
                    event_service.insertEvent(event).then(
                      (unused) {
                        widget.onRefresh();
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
              ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class EditEventDialog extends StatefulWidget {
  final EventModel event;
  final DateTime firstDay;
  final DateTime lastDay;
  final VoidCallback onRefresh;

  const EditEventDialog({
    super.key,
    required this.event,
    required this.firstDay,
    required this.lastDay,
    required this.onRefresh,
  });

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _recurUntilController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  late final tz.Location _location;
  late final String _locale;

  late tz.TZDateTime _start;
  late tz.TZDateTime _end;
  late String _summary;
  late String _description;
  late int _numPoints;
  String? _teacherId;
  late bool _isRecur;
  Frequency _recurFrequency = Frequency.daily;
  tz.TZDateTime? _recurUntil;
  bool _submitClicked = false;
  bool _isLoadingRecurringEvent = true;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    final account = context.read<AccountModel>();
    assert(canEditEvents(account.userType));
    _location = tz.getLocation(account.myUser!.timeZone);
    _locale = account.locale;

    _start = widget.event.startTime;
    _end = widget.event.endTime;
    _startController.text = DateFormat.yMMMMd(_locale).add_jm().format(_start);
    _endController.text = DateFormat.yMMMMd(_locale).add_jm().format(_end);
    _summary = widget.event.summary;
    _description = widget.event.description;
    _numPoints = widget.event.numPoints;
    _teacherId = widget.event.teacherId;
    if (account.userType == UserType.teacher) {
      assert(account.teacherProfile!.profileId == _teacherId);
    }
    _loadRecurrenceEvent();
  }

  void _loadRecurrenceEvent() async {
    final recurrenceId = widget.event.recurrenceId;
    if (recurrenceId != null) {
      _isRecur = true;
      try {
        final event = await event_service.getEvent(
          eventId: recurrenceId,
          location:
              tz.getLocation(context.read<AccountModel>().myUser!.timeZone),
        );
        final rrule = RecurrenceRule.fromString(event.recurrence[0]);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _isLoadingRecurringEvent = false;
            if (rrule.until != null) {
              _recurUntil = tz.TZDateTime.from(rrule.until!, _location);
              _recurUntilController.text =
                  DateFormat.yMMMMd(_locale).format(_recurUntil!);
            }
            _recurFrequency = rrule.frequency;
          });
        });
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).failedGetRecurrenceEvent),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        });
      }
    } else {
      _isLoadingRecurringEvent = false;
      _isRecur = false;
    }
  }

  Future<tz.TZDateTime?> _pickDateTime({required tz.TZDateTime initial}) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: widget.firstDay,
        lastDate: widget.lastDay);
    // ignore: use_build_context_synchronously
    if (date == null || !context.mounted) {
      return null;
    }

    TimeOfDay? time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (time == null) {
      return null;
    }
    return tz.TZDateTime(
        _location, date.year, date.month, date.day, time.hour, time.minute);
  }

  void _selectStartTime() async {
    final tz.TZDateTime? dateTime = await _pickDateTime(initial: _start);
    if (dateTime != null) {
      setState(() {
        final delta = _end.difference(_start);
        _start = dateTime;
        _startController.text =
            DateFormat.yMMMMd(_locale).add_jm().format(_start);
        _end = _start.add(delta);
        _endController.text = DateFormat.yMMMMd(_locale).add_jm().format(_end);
      });
    }
  }

  void _selectEndTime() async {
    final tz.TZDateTime? dateTime = await _pickDateTime(initial: _end);
    if (dateTime != null) {
      setState(() {
        _end = dateTime;
        _endController.text = DateFormat.yMMMMd(_locale).add_jm().format(_end);
      });
    }
  }

  void _selectRecurUntil() async {
    final DateTime? day = await showDatePicker(
      context: context,
      initialDate: _recurUntil ?? _end,
      firstDate: widget.firstDay,
      lastDate: widget.lastDay,
    );
    if (day != null) {
      setState(() {
        _recurUntil = tz.TZDateTime(_location, day.year, day.month, day.day)
            .add(const Duration(days: 1));
        _recurUntilController.text = DateFormat.yMMMMd(_locale).format(day);
      });
    }
  }

  // TODO: Use returned event id from Google Calendar API to refresh.
  void _updateLocalEvent(EventModel event) {
    widget.event.summary = event.summary;
    widget.event.description = event.description;
    widget.event.numPoints = event.numPoints;
    widget.event.startTime = event.startTime;
    widget.event.endTime = event.endTime;
    widget.event.teacherId = event.teacherId;
  }

  @override
  Widget build(BuildContext context) {
    final timeZone =
        context.select<AccountModel, String>((a) => a.myUser!.timeZone);
    final userType = context.select<AccountModel, UserType>((a) => a.userType);
    final teacherProfiles =
        context.select<AccountModel, List<TeacherProfileModel>>(
            (a) => a.teacherProfileList);

    return AlertDialog(
      title: Text(S.of(context).editEvent),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 350,
          minHeight: 300,
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.eventType.getName(context),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                if (userType == UserType.admin)
                  DropdownButtonFormField<String>(
                    items: teacherProfiles
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
                        hintText: S.of(context).teacherTitle,
                        icon: const Icon(Icons.person),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _teacherId = null;
                            });
                          },
                        )),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.text_fields),
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
                    icon: const Icon(Icons.text_snippet),
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
                widget.event.eventType == EventType.private
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          icon: const Icon(Icons.add),
                          labelText: S.of(context).eventPointsLabel,
                        ),
                        initialValue: _numPoints.toString(),
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
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).timeZoneLabel}: ${timeZone.replaceAll('_', ' ')}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                TextFormField(
                  controller: _startController,
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.access_time),
                    labelText: S.of(context).eventStartLabel,
                  ),
                  onTap: () {
                    _selectStartTime();
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).eventStartValidation;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endController,
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.access_time),
                    labelText: S.of(context).eventEndLabel,
                  ),
                  onTap: () {
                    _selectEndTime();
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).eventEndValidation;
                    }
                    if (!_start.isBefore(_end)) {
                      return S.of(context).eventValidTimeValidation;
                    }
                    if (_end.difference(_start) >= const Duration(hours: 24)) {
                      return S.of(context).eventTooLongValidation;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isRecur,
                      onChanged: null,
                      // (value) {
                      //   setState(() {
                      //     _isRecur = value!;
                      //   });
                      // },
                    ),
                    Text(S.of(context).recurTitle),
                    if (_isLoadingRecurringEvent)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
                if (_isRecur)
                  Column(
                    children: [
                      DropdownButtonFormField<Frequency>(
                        items: recurFrequencies
                            .map((f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(frequencyToString(context, f)),
                                ))
                            .toList(),
                        value: _recurFrequency,
                        onChanged: null,
                        // (value) {
                        //   setState(() {
                        //     _recurFrequency = value!;
                        //   });
                        // },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _recurUntil != null,
                            onChanged: null,
                            // (value) {
                            //   setState(() {
                            //     if (value!) {
                            //       _recurUntil = _end;
                            //       _recurUntilController.text =
                            //           DateFormat.yMMMMd(_locale)
                            //               .format(_recurUntil!);
                            //     } else {
                            //       _recurUntil = null;
                            //     }
                            //   });
                            // },
                          ),
                          Text(S.of(context).recurEnd),
                        ],
                      ),
                      if (_recurUntil != null)
                        TextFormField(
                          controller: _recurUntilController,
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.calendar_month),
                            labelText: S.of(context).recurUntilLabel,
                          ),
                          onTap: null,
                          // () {
                          //   _selectRecurUntil();
                          // },
                        ),
                    ],
                  ),
              ],
            ),
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
            ? Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator(),
              )
            : TextButton(
                child: Text(S.of(context).confirm),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _submitClicked = true;
                    });
                    final event = EventModel(
                        eventId: widget.event.eventId,
                        eventType: widget.event.eventType,
                        summary: _summary,
                        description: _description,
                        numPoints: widget.event.eventType == EventType.private
                            ? _numPoints
                            : 0,
                        startTime: _start,
                        endTime: _end,
                        timeZone: widget.event.timeZone,
                        teacherId: _teacherId);
                    try {
                      await event_service.updateEvent(event);
                      _updateLocalEvent(event);
                      widget.onRefresh();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).editEventSuccess),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).editEventFailure),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    } finally {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
      ],
    );
  }
}

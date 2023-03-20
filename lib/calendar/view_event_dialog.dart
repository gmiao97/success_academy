import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

class ViewEventDialog extends StatefulWidget {
  const ViewEventDialog({super.key, required this.event});

  final EventModel event;

  @override
  State<ViewEventDialog> createState() => _ViewEventDialogState();
}

class _ViewEventDialogState extends State<ViewEventDialog> {
  late AccountModel _accountContext;
  late DateTime _day;
  late DateTime? _recurUntil;
  late String _summary;
  String? _teacherName;
  List<String> _studentIds = [];
  late String _description;
  int? _numPoints;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late EventType _eventType;
  late Frequency? _recurFrequency;

  @override
  void initState() {
    super.initState();
    _accountContext = context.read<AccountModel>();
    tz.initializeTimeZones();
    final RecurrenceRule? rrule = widget.event.recurrence.isNotEmpty
        ? RecurrenceRule.fromString(widget.event.recurrence[0])
        : null;
    setState(() {
      _day = DateTime(widget.event.startTime.year, widget.event.startTime.month,
          widget.event.startTime.day);
      _summary = widget.event.summary;
      _teacherName = widget.event.teacherId != null
          ? '${_accountContext.teacherProfileModelMap![widget.event.teacherId]!.lastName} ${_accountContext.teacherProfileModelMap![widget.event.teacherId]!.firstName}'
          : null;
      _studentIds = widget.event.studentIdList;
      _description = widget.event.description;
      _numPoints = widget.event.numPoints;
      _startTime = TimeOfDay.fromDateTime(widget.event.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event.endTime);
      _eventType = widget.event.eventType;
      _recurFrequency = rrule?.frequency;
      _recurUntil = rrule?.until;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        S.of(context).viewEvent,
        style: Theme.of(context).textTheme.headline6,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _summary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(eventTypeNames[_eventType]!),
            Text(S.of(context).eventPointsDisplay(_numPoints ?? 0)),
            Text(
              _teacherName ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                '${dateFormatter.format(_day)} | ${_startTime.format(context)} - ${_endTime.format(context)}'),
            Text(
                '${frequencyNames[_recurFrequency]!}${_recurUntil != null ? ', ${S.of(context).recurEnd} ${dateFormatter.format(_recurUntil!)}' : ''}'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.of(context).studentListTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Column(
              children: _studentIds.map(
                (id) {
                  final studentProfile =
                      _accountContext.studentProfileMap![id]!;
                  return Text(
                      '${studentProfile.lastName} ${studentProfile.firstName}');
                },
              ).toList(),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: 400,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Text(_description),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

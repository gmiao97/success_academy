import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

class SignupEventDialog extends StatefulWidget {
  const SignupEventDialog({
    Key? key,
    required this.event,
    required this.firstDay,
    required this.lastDay,
    required this.onRefresh,
  }) : super(key: key);

  final EventModel event;
  final DateTime firstDay;
  final DateTime lastDay;
  final void Function() onRefresh;

  @override
  State<SignupEventDialog> createState() => _SignupEventDialogState();
}

class _SignupEventDialogState extends State<SignupEventDialog> {
  late AccountModel _accountContext;
  late DateTime _day;
  late DateTime? _recurUntil;
  late String _summary;
  late String? _teacherName;
  late String _description;
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
      _teacherName =
          '${_accountContext.teacherProfileModelMap![widget.event.teacherId]!.lastName} ${_accountContext.teacherProfileModelMap![widget.event.teacherId]!.firstName}';
      _description = widget.event.description;
      _startTime = TimeOfDay.fromDateTime(widget.event.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event.endTime);
      _eventType = widget.event.eventType;
      _recurFrequency = rrule?.frequency;
      _recurUntil = rrule?.until;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<EventType, String> _eventTypeNames = {
      EventType.free: S.of(context).free,
      EventType.preschool: S.of(context).preschool,
      EventType.private: S.of(context).private,
    };

    Map<Frequency?, String> _frequencyNames = {
      null: S.of(context).recurNone,
      Frequency.daily: S.of(context).recurDaily,
      Frequency.weekly: S.of(context).recurWeekly,
      Frequency.monthly: S.of(context).recurMonthly,
    };

    return AlertDialog(
      title: Text(
        S.of(context).signupEvent,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _summary,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              _teacherName ?? '',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(_eventTypeNames[_eventType]!),
            Text(
                '${dateFormatter.format(_day)} | ${_startTime.format(context)} - ${_endTime.format(context)}'),
            Text(
                '${_frequencyNames[_recurFrequency]!}${_recurUntil != null ? ', ' + S.of(context).recurEnd + ' ' + dateFormatter.format(_recurUntil!) : ''}'),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 500,
              child: Text(_description),
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
        TextButton(
          child: Text(S.of(context).confirm),
          onPressed: () {},
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:timezone/data/latest_10y.dart' as tz;

class SignupEventDialog extends StatefulWidget {
  const SignupEventDialog({
    super.key,
    required this.event,
    required this.onRefresh,
  });

  final EventModel event;
  final void Function() onRefresh;

  @override
  State<SignupEventDialog> createState() => _SignupEventDialogState();
}

class _SignupEventDialogState extends State<SignupEventDialog> {
  late AccountModel _accountContext;
  late DateTime _day;
  late String _summary;
  String? _teacherName;
  late String _description;
  int? _numPoints;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late EventType _eventType;
  late bool _isSignedUp;
  bool _submitClicked = false;

  @override
  void initState() {
    super.initState();
    _accountContext = context.read<AccountModel>();
    tz.initializeTimeZones();
    setState(() {
      _day = DateTime(widget.event.startTime.year, widget.event.startTime.month,
          widget.event.startTime.day);
      _summary = widget.event.summary;
      _teacherName = widget.event.teacherId != null
          ? '${_accountContext.teacherProfileModelMap[widget.event.teacherId]!.lastName} ${_accountContext.teacherProfileModelMap[widget.event.teacherId]!.firstName}'
          : null;
      _description = widget.event.description;
      _numPoints = widget.event.numPoints;
      _startTime = TimeOfDay.fromDateTime(widget.event.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event.endTime);
      _eventType = widget.event.eventType;
      _isSignedUp = widget.event.studentIdList
          .contains(_accountContext.studentProfile!.profileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rrule = widget.event.recurrence.isNotEmpty
        ? RecurrenceRule.fromString(widget.event.recurrence[0])
        : null;

    return AlertDialog(
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
            Text(_eventType.getName(context)),
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
            Text(rruleToString(context, rrule)),
            const SizedBox(
              height: 20,
            ),
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
        _submitClicked
            ? const CircularProgressIndicator(
                value: null,
              )
            : Tooltip(
                message: _isSignedUp
                    ? S.of(context).refundPoints(_numPoints ?? 0)
                    : _accountContext.studentProfile!.numPoints <
                            (_numPoints ?? 0)
                        ? S.of(context).notEnoughPoints
                        : S.of(context).usePoints(_numPoints ?? 0,
                            _accountContext.studentProfile!.numPoints),
                child: ElevatedButton(
                  onPressed: _day.isAfter(DateTime.now()
                              .subtract(const Duration(days: 1))) &&
                          _accountContext.studentProfile!.numPoints >=
                              (_numPoints ?? 0)
                      ? () {
                          setState(() {
                            _submitClicked = true;
                          });

                          StudentProfileModel updatedProfile =
                              _accountContext.studentProfile!;
                          final event = widget.event;
                          event.recurrence.clear();
                          if (_isSignedUp) {
                            event.studentIdList.remove(
                                _accountContext.studentProfile!.profileId);
                            updatedProfile.numPoints += _numPoints ?? 0;
                          } else {
                            if (!event.studentIdList.contains(
                                _accountContext.studentProfile!.profileId)) {
                              event.studentIdList.add(
                                  _accountContext.studentProfile!.profileId);
                              updatedProfile.numPoints -= _numPoints ?? 0;
                            }
                          }
                          event_service.updateEvent(event).then((unused) {
                            widget.onRefresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: _isSignedUp
                                    ? Text(S.of(context).cancelSignupSuccess)
                                    : Text(S.of(context).signupSuccess),
                              ),
                            );
                          }).then((unused) {
                            return profile_service.updateStudentProfile(
                                _accountContext.firebaseUser!.uid,
                                updatedProfile);
                          }).catchError((err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: _isSignedUp
                                    ? Text(S.of(context).cancelSignupFailure)
                                    : Text(S.of(context).signupFailure),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                            debugPrint('Failed to update sign up status: $err');
                          }).whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        }
                      : null,
                  child: _isSignedUp
                      ? Text(S.of(context).cancelSignup)
                      : Text(S.of(context).signup),
                ),
              ),
      ],
    );
  }
}

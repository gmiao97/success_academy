import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/services/profile_service.dart'
    as profile_service;

class SignupEventDialog extends StatefulWidget {
  final EventModel event;
  final VoidCallback refresh;

  const SignupEventDialog({
    super.key,
    required this.event,
    required this.refresh,
  });

  @override
  State<SignupEventDialog> createState() => _SignupEventDialogState();
}

class _SignupEventDialogState extends State<SignupEventDialog> {
  bool _submitClicked = false;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();
    final studentProfile = context
        .select<AccountModel, StudentProfileModel>((a) => a.studentProfile!);
    final isAtLeast24HoursBefore =
        widget.event.startTime.difference(DateTime.now()) >
            const Duration(hours: 24);
    final enoughPoints =
        account.studentProfile!.numPoints >= widget.event.numPoints;

    return AlertDialog(
      title: Text(S.of(context).signup),
      content: !isAtLeast24HoursBefore
          ? Text(S.of(context).signupWindowPassed)
          : enoughPoints
              ? Text(S.of(context).usePoints(
                  widget.event.numPoints, account.studentProfile!.numPoints))
              : Text(S.of(context).notEnoughPoints),
      actions: [
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
                onPressed: !isAtLeast24HoursBefore || !enoughPoints
                    ? null
                    : () async {
                        setState(() {
                          _submitClicked = true;
                        });
                        if (!isStudentInEvent(
                            studentProfile.profileId, widget.event)) {
                          widget.event.studentIdList
                              .add(studentProfile.profileId);
                          try {
                            await event_service.updateEvent(widget.event);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).signupSuccess),
                                ),
                              );
                              // TODO: Handle/log error.
                              studentProfile.numPoints -=
                                  widget.event.numPoints;
                              account.studentProfile = studentProfile;
                              profile_service.updateStudentProfile(
                                  account.firebaseUser!.uid, studentProfile);
                              event_service.emailAttendees(
                                  widget.event, studentProfile.profileId);
                            }
                          } catch (e) {
                            widget.event.studentIdList.removeWhere(
                                (id) => id == studentProfile.profileId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).signupFailure),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          } finally {
                            Navigator.of(context).pop();
                            widget.refresh();
                          }
                        }
                      },
                child: Text(S.of(context).confirm),
              ),
      ],
    );
  }
}

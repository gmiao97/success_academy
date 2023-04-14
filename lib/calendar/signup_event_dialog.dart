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
    final pointsBalance =
        context.select<AccountModel, int>((a) => a.studentProfile!.numPoints);
    final userId =
        context.select<AccountModel, String>((a) => a.firebaseUser!.uid);
    final studentProfile = context
        .select<AccountModel, StudentProfileModel>((a) => a.studentProfile!);
    final isPast = widget.event.startTime.isBefore(DateTime.now());

    return AlertDialog(
      title: Text(S.of(context).signup),
      content: isPast
          ? Text(S.of(context).signupPastEvent)
          : Text(
              S.of(context).usePoints(widget.event.numPoints, pointsBalance)),
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
                onPressed: isPast
                    ? null
                    : () async {
                        setState(() {
                          _submitClicked = true;
                        });
                        if (!isStudentInEvent(
                            studentProfile.profileId, widget.event)) {
                          widget.event.studentIdList
                              .add(studentProfile.profileId);
                          studentProfile.numPoints -= widget.event.numPoints;
                          try {
                            await event_service.updateEvent(widget.event);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).signupSuccess),
                                ),
                              );
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
                            // TODO: Handle/log error.
                            profile_service.updateStudentProfile(
                                userId, studentProfile);
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

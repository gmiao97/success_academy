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

class QuitEventDialog extends StatefulWidget {
  final EventModel event;
  final VoidCallback refresh;

  const QuitEventDialog({
    super.key,
    required this.event,
    required this.refresh,
  });

  @override
  State<QuitEventDialog> createState() => _QuitEventDialogState();
}

class _QuitEventDialogState extends State<QuitEventDialog> {
  bool _submitClicked = false;

  @override
  Widget build(BuildContext context) {
    final userId =
        context.select<AccountModel, String>((a) => a.firebaseUser!.uid);
    final studentProfile = context
        .select<AccountModel, StudentProfileModel>((a) => a.studentProfile!);
    final isPast = widget.event.startTime.isBefore(DateTime.now());

    return AlertDialog(
      title: Text(S.of(context).cancelSignup),
      content: isPast
          ? Text(S.of(context).cancelSignupPastEvent)
          : Text(S.of(context).refundPoints(widget.event.numPoints)),
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
            : ElevatedButton(
                onPressed: isPast
                    ? null
                    : () async {
                        setState(() {
                          _submitClicked = true;
                        });
                        if (isStudentInEvent(
                            studentProfile.profileId, widget.event)) {
                          widget.event.studentIdList.removeWhere(
                              (id) => id == studentProfile.profileId);

                          studentProfile.numPoints += widget.event.numPoints;
                          try {
                            await event_service.updateEvent(widget.event);
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(S.of(context).cancelSignupSuccess),
                              ),
                            );
                          } catch (e) {
                            widget.event.studentIdList
                                .add(studentProfile.profileId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(S.of(context).cancelSignupFailure),
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

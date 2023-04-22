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
    final account = context.watch<AccountModel>();
    final studentProfile = context
        .select<AccountModel, StudentProfileModel>((a) => a.studentProfile!);
    final isAtLeast24HoursBefore =
        widget.event.startTime.difference(DateTime.now()) >
            const Duration(hours: 24);

    return AlertDialog(
      title: Text(S.of(context).cancelSignup),
      content: !isAtLeast24HoursBefore
          ? Text(S.of(context).cancelSignupWindowPassed)
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
            : TextButton(
                onPressed: !isAtLeast24HoursBefore
                    ? null
                    : () async {
                        setState(() {
                          _submitClicked = true;
                        });
                        if (isStudentInEvent(
                            studentProfile.profileId, widget.event)) {
                          widget.event.studentIdList.removeWhere(
                              (id) => id == studentProfile.profileId);
                          try {
                            await event_service.updateEvent(widget.event);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(S.of(context).cancelSignupSuccess),
                                ),
                              );
                            }
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
                            studentProfile.numPoints += widget.event.numPoints;
                            account.studentProfile = studentProfile;
                            profile_service.updateStudentProfile(
                                account.firebaseUser!.uid, studentProfile);
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/generated/l10n.dart';

int timeOfDayToInt(TimeOfDay time) => time.hour * 60 + time.minute;

String frequencyToString(BuildContext context, Frequency? frequency) {
  if (frequency == null) {
    return S.of(context).recurNone;
  }
  if (frequency == Frequency.daily) {
    return S.of(context).recurDaily;
  }
  if (frequency == Frequency.weekly) {
    return S.of(context).recurWeekly;
  }
  if (frequency == Frequency.monthly) {
    return S.of(context).recurMonthly;
  }
  return "¯\\_(ツ)_/¯";
}

String rruleToString(BuildContext context, RecurrenceRule? rrule) {
  if (rrule == null) {
    return S.of(context).recurNone;
  }

  final locale = context.select<AccountModel, String>((a) => a.locale);

  StringBuffer buffer =
      StringBuffer(frequencyToString(context, rrule.frequency));
  final until = rrule.until;
  if (until != null) {
    buffer.write(S
        .of(context)
        .recurUntil(DateFormat.yMMMMd(locale).format(rrule.until!)));
  }
  return buffer.toString();
}

bool canCreateEvents(UserType userType) {
  return userType == UserType.admin || userType == UserType.teacher;
}

List<EventType> getEventTypesCanCreate(UserType userType) {
  switch (userType) {
    case UserType.admin:
      return [EventType.free, EventType.preschool, EventType.private];
    case UserType.teacher:
      return [EventType.private];
    default:
      return [];
  }
}

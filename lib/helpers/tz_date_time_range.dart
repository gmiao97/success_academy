import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' show TZDateTime;

class TZDateTimeRange extends DateTimeRange {
  TZDateTimeRange({required TZDateTime start, required TZDateTime end})
      : super(start: start, end: end);

  @override
  TZDateTime get start => super.start as TZDateTime;

  @override
  TZDateTime get end => super.end as TZDateTime;
}

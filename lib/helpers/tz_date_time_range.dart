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

List<TZDateTimeRange> mergeTZDateTimeRanges(
  List<TZDateTimeRange> dateTimeRanges,
) {
  if (dateTimeRanges.isEmpty) {
    return [];
  }

  dateTimeRanges.sort((a, b) => a.start.compareTo(b.start));
  final mergedDateTimeRanges = <TZDateTimeRange>[];
  var merged = dateTimeRanges[0];
  for (var i = 1; i < dateTimeRanges.length; i++) {
    if (dateTimeRanges[i].start.isAfter(merged.end)) {
      mergedDateTimeRanges.add(merged);
      merged = dateTimeRanges[i];
    } else {
      merged = TZDateTimeRange(
        start: merged.start,
        end: merged.end.isAfter(dateTimeRanges[i].end)
            ? merged.end
            : dateTimeRanges[i].end,
      );
    }
  }
  mergedDateTimeRanges.add(merged);
  dateTimeRanges
    ..clear()
    ..addAll(
      mergedDateTimeRanges,
    );
  return dateTimeRanges;
}

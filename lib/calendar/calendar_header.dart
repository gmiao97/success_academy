import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/generated/l10n.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key? key,
    required this.header,
    required this.timeZone,
    required this.onTodayButtonTap,
    required this.availableEventFilters,
    required this.eventFilters,
    required this.onEventFilterConfirm,
  }) : super(key: key);

  final String header;
  final String timeZone;
  final VoidCallback onTodayButtonTap;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final void Function(List<EventType>) onEventFilterConfirm;

  @override
  Widget build(BuildContext context) {
    final Map<EventType, String> _filterNames = {
      EventType.free: S.of(context).freeFilter,
      EventType.preschool: S.of(context).preschoolFilter,
      EventType.private: S.of(context).privateFilter,
      EventType.myPreschool: S.of(context).myPreschoolFilter,
      EventType.myPrivate: S.of(context).myPrivateFilter,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            S.of(context).calendarHeader(header),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            S.of(context).timeZone(timeZone.replaceAll('_', ' ')),
            style: Theme.of(context).textTheme.headline6,
          ),
          ElevatedButton.icon(
            onPressed: onTodayButtonTap,
            label: Text(S.of(context).today),
            icon: const Icon(Icons.calendar_today),
          ),
          MultiSelectDialogField<EventType>(
            items: availableEventFilters
                .map((type) => MultiSelectItem(type, _filterNames[type]!))
                .toList(),
            initialValue: eventFilters,
            onConfirm: onEventFilterConfirm,
            dialogHeight: 400,
            dialogWidth: 500,
            buttonText: Text(S.of(context).filter),
            buttonIcon: const Icon(Icons.filter_alt),
            confirmText: Text(S.of(context).confirm),
            cancelText: Text(S.of(context).cancel),
            title: Text(S.of(context).filterTitle),
          ),
        ],
      ),
    );
  }
}

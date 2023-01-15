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
    required this.shouldShowEventDisplay,
    this.eventDisplay,
    this.onEventDisplayChanged,
  }) : super(key: key);

  final String header;
  final String timeZone;
  final VoidCallback onTodayButtonTap;
  final List<EventType> availableEventFilters;
  final List<EventType> eventFilters;
  final void Function(List<EventType>) onEventFilterConfirm;
  final bool shouldShowEventDisplay;
  final EventDisplay? eventDisplay;
  final void Function(EventDisplay?)? onEventDisplayChanged;

  @override
  Widget build(BuildContext context) {
    final Map<EventType, String> filterNames = {
      EventType.free: S.of(context).freeFilter,
      EventType.preschool: S.of(context).preschoolFilter,
      EventType.private: S.of(context).privateFilter,
    };
    final Map<EventDisplay, String> displayNames = {
      EventDisplay.all: S.of(context).allEvents,
      EventDisplay.mine: S.of(context).myEvents,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).calendarHeader(header),
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  S.of(context).timeZone(timeZone.replaceAll('_', ' ')),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          Column(
            children: [
              MultiSelectDialogField<EventType>(
                items: availableEventFilters
                    .map((type) => MultiSelectItem(type, filterNames[type]!))
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
              shouldShowEventDisplay
                  ? DropdownButton<EventDisplay>(
                      value: eventDisplay,
                      items: EventDisplay.values
                          .map((e) => DropdownMenuItem<EventDisplay>(
                                value: e,
                                child: Text(displayNames[e]!),
                              ))
                          .toList(),
                      onChanged: onEventDisplayChanged)
                  : const SizedBox(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: onTodayButtonTap,
              label: Text(S.of(context).today),
              icon: const Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }
}

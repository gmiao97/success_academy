import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/calendar_utils.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final List<bool> _selectedToggle = [true, false];
  List<EventModel> _allEvents = [];
  List<EventModel> _events = [];
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _init();
  }

  void _init() async {
    final location =
        tz.getLocation(context.read<AccountModel>().myUser!.timeZone);
    _dateRange = DateTimeRange(
        start: _getDateFromDateTime(tz.TZDateTime.now(location), location)
            .subtract(const Duration(days: 30)),
        end: _getDateFromDateTime(tz.TZDateTime.now(location), location));
    _allEvents = (await event_service.listEvents(
        location: location,
        timeMin: _dateRange.start.toIso8601String(),
        timeMax: _dateRange.end.toIso8601String(),
        singleEvents: true));
    _events = _allEvents
        .where((event) =>
            event.startTime.isAfter(_dateRange.start) &&
            event.startTime.isBefore(_dateRange.end))
        .toList();
  }

  DateTime _getDateFromDateTime(DateTime dateTime, tz.Location timeZone) {
    return tz.TZDateTime(timeZone, dateTime.year, dateTime.month, dateTime.day);
  }

  void _selectDateRange() async {
    final timeZoneName = context.read<AccountModel>().myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);

    final dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020, 1, 1),
        lastDate: tz.TZDateTime.now(timeZone));
    if (dateRange != null) {
      setState(() {
        _dateRange = DateTimeRange(
            start: _getDateFromDateTime(dateRange.start, timeZone),
            end: _getDateFromDateTime(dateRange.end, timeZone));
        _events = _allEvents
            .where((event) =>
                event.startTime.isAfter(_dateRange.start) &&
                event.startTime.isBefore(_dateRange.end))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                S.of(context).manageProfile,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ToggleButtons(
                onPressed: (index) {
                  setState(() {
                    for (int i = 0; i < _selectedToggle.length; i++) {
                      _selectedToggle[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                constraints: const BoxConstraints(
                  minHeight: 40,
                  minWidth: 80,
                ),
                isSelected: _selectedToggle,
                children: [
                  Text(S.of(context).student),
                  Text(S.of(context).teacher),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _selectedToggle[0]
                    ? _StudentTable()
                    : _TeacherTable(
                        dateRange: _dateRange,
                        onSelectDateRange: _selectDateRange,
                        events: _events,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TeacherTable extends StatelessWidget {
  final DateTimeRange dateRange;
  final VoidCallback onSelectDateRange;
  final List<EventModel> events;

  const _TeacherTable(
      {required this.dateRange,
      required this.onSelectDateRange,
      required this.events});

  @override
  Widget build(BuildContext context) {
    final teacherProfiles =
        context.select<AccountModel, List<TeacherProfileModel>>(
            (a) => a.teacherProfileList);

    return PaginatedDataTable(
      header: TextButton.icon(
        icon: const Icon(Icons.edit),
        label: Text(
            '${dateFormatter.format(dateRange.start)} - ${dateFormatter.format(dateRange.end)}'),
        onPressed: onSelectDateRange,
      ),
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).id,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).email,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).lastName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).firstName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).freeNum,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).preschoolNum,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).privateNum,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      source: _TeacherData(
        data: teacherProfiles,
        events: events,
      ),
    );
  }
}

class _StudentTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentProfiles =
        context.select<AccountModel, List<StudentProfileModel>>(
            (a) => a.studentProfileList);

    return PaginatedDataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).id,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).email,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).lastName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).firstName,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).eventPointsLabel,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              S.of(context).referrerLabel,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      source: _StudentData(data: studentProfiles),
    );
  }
}

class _TeacherData extends DataTableSource {
  _TeacherData(
      {required List<TeacherProfileModel> data,
      required List<EventModel> events})
      : _data = data,
        _events = events;

  final List<TeacherProfileModel> _data;
  final List<EventModel> _events;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(SelectableText(_data[index].profileId)),
      DataCell(SelectableText(_data[index].email)),
      DataCell(SelectableText(_data[index].lastName)),
      DataCell(SelectableText(_data[index].firstName)),
      DataCell(
        SelectableText(
          '${_events.where((e) => e.eventType == EventType.free && isTeacherInEvent(_data[index].profileId, e)).length}',
        ),
      ),
      DataCell(
        SelectableText(
          '${_events.where((e) => e.eventType == EventType.preschool && isTeacherInEvent(_data[index].profileId, e)).length}',
        ),
      ),
      DataCell(
        SelectableText(
          '${_events.where((e) => e.eventType == EventType.private && isTeacherInEvent(_data[index].profileId, e)).toList().map((event) => event.numPoints).fold(0, (int a, int b) => a + b)}',
        ),
      ),
    ]);
  }
}

class _StudentData extends DataTableSource {
  final List<StudentProfileModel> _data;

  _StudentData({
    required List<StudentProfileModel> data,
  }) : _data = data;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(SelectableText(_data[index].profileId)),
      DataCell(SelectableText(_data[index].email)),
      DataCell(SelectableText(_data[index].lastName)),
      DataCell(SelectableText(_data[index].firstName)),
      DataCell(SelectableText('${_data[index].numPoints}')),
      DataCell(SelectableText(_data[index].referrer ?? '')),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return const _Manage();
  }
}

class _Manage extends StatefulWidget {
  const _Manage({Key? key}) : super(key: key);

  @override
  State<_Manage> createState() => _ManageState();
}

class _ManageState extends State<_Manage> {
  late AccountModel _accountContext;
  bool _isInitialized = false;
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
    _accountContext = context.read<AccountModel>();

    final timeZoneName = _accountContext.myUser!.timeZone;
    final timeZone = tz.getLocation(timeZoneName);
    _dateRange = DateTimeRange(
        start: _getDateFromDateTime(tz.TZDateTime.now(timeZone), timeZone)
            .subtract(const Duration(days: 30)),
        end: _getDateFromDateTime(tz.TZDateTime.now(timeZone), timeZone));
    _allEvents = (await event_service.listEvents(
            timeZone: timeZoneName,
            timeMin: _dateRange.start.toIso8601String(),
            timeMax: _dateRange.end.toIso8601String(),
            singleEvents: true))
        .map((event) => EventModel.fromJson(event, timeZone))
        .toList();
    _events = _allEvents
        .where((event) =>
            event.startTime.isAfter(_dateRange.start) &&
            event.startTime.isBefore(_dateRange.end))
        .toList();
    setState(() {
      _isInitialized = true;
    });
  }

  DateTime _getDateFromDateTime(DateTime dateTime, tz.Location timeZone) {
    return tz.TZDateTime(timeZone, dateTime.year, dateTime.month, dateTime.day);
  }

  void _selectDateRange() async {
    final timeZoneName = _accountContext.myUser!.timeZone;
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
    return !_isInitialized
        ? const Center(
            child: CircularProgressIndicator(
              value: null,
            ),
          )
        : TabBarView(children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: PaginatedDataTable(
                  header: Column(
                    children: [
                      Text(
                          '${dateFormatter.format(_dateRange.start)} - ${dateFormatter.format(_dateRange.end)}'),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: _selectDateRange,
                          child: const Text('期間を変える'))
                    ],
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
                    data: _accountContext.teacherProfileList!,
                    events: _events,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: PaginatedDataTable(
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
                  source:
                      _StudentData(data: _accountContext.studentProfileList!),
                ),
              ),
            ),
          ]);
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
      DataCell(Text(_data[index].profileId)),
      DataCell(Text(_data[index].lastName)),
      DataCell(Text(_data[index].firstName)),
      DataCell(
        Text(
          '${_events.where((e) => e.eventType == EventType.free && e.teacherId == _data[index].profileId).toList().length}',
        ),
      ),
      DataCell(
        Text(
          '${_events.where((e) => e.eventType == EventType.preschool && e.teacherId == _data[index].profileId).toList().length}',
        ),
      ),
      DataCell(
        Text(
          '${_events.where((e) => e.eventType == EventType.private && e.teacherId == _data[index].profileId).toList().map((event) => event.numPoints).fold(0, (int a, int? b) => a + (b ?? 0))}',
        ),
      ),
    ]);
  }
}

class _StudentData extends DataTableSource {
  _StudentData({required List<StudentProfileModel> data}) : _data = data;

  final List<StudentProfileModel> _data;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index].profileId)),
      DataCell(Text(_data[index].lastName)),
      DataCell(Text(_data[index].firstName)),
      DataCell(Text('${_data[index].numPoints}')),
      DataCell(Text(_data[index].referrer ?? '')),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/event_service.dart' as event_service;
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/utils.dart';
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
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    }
    if (account.authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.userType == UserType.admin) {
      return buildAdminProfileScaffold(
        context: context,
        body: const _Manage(),
      );
    }
    return buildLoggedInScaffold(
      context: context,
      body: const Center(
        child: Text("NOT SUPPORTED"),
      ),
    );
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
  List<TeacherProfileModel> teachers = [];
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
    teachers = await profile_service.getAllTeacherProfiles();

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
        : Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Text(
                  '${dateFormatter.format(_dateRange.start)} - ${dateFormatter.format(_dateRange.end)}',
                ),
                ElevatedButton(
                  onPressed: _selectDateRange,
                  child: const Text('Select date range'),
                ),
                PaginatedDataTable(
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
                    teachers: teachers,
                    events: _events,
                  ),
                ),
              ],
            ),
          );
  }
}

class _TeacherData extends DataTableSource {
  _TeacherData(
      {required List<TeacherProfileModel> teachers,
      required List<EventModel> events})
      : _teachers = teachers,
        _events = events;

  final List<TeacherProfileModel> _teachers;
  final List<EventModel> _events;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _teachers.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_teachers[index].profileId)),
      DataCell(Text(_teachers[index].lastName)),
      DataCell(Text(_teachers[index].firstName)),
      DataCell(Text(
          '${_events.where((e) => e.eventType == EventType.free && e.teacherId == _teachers[index].profileId).toList().length}')),
      DataCell(Text(
          '${_events.where((e) => e.eventType == EventType.preschool && e.teacherId == _teachers[index].profileId).toList().length}')),
      DataCell(Text(
          '${_events.where((e) => e.eventType == EventType.private && e.teacherId == _teachers[index].profileId).toList().length}')),
    ]);
  }
}

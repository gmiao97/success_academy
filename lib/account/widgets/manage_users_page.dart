import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../account_model.dart';
import '../../calendar/calendar_utils.dart';
import '../../calendar/event_model.dart';
import '../../constants.dart';
import '../../generated/l10n.dart';
import '../../services/event_service.dart' as event_service;
import '../../profile/profile_model.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final List<bool> _selectedToggle = [true, false];
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
      start: tz.TZDateTime.now(location).subtract(const Duration(days: 30)),
      end: tz.TZDateTime.now(location),
    );
    _events = await event_service.listEvents(
      location: location,
      timeMin: _dateRange.start.toIso8601String(),
      timeMax: _dateRange.end.toIso8601String(),
      singleEvents: true,
    );
  }

  void _selectDateRange() async {
    final location =
        tz.getLocation(context.read<AccountModel>().myUser!.timeZone);

    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 1, 1),
      lastDate: tz.TZDateTime.now(location),
    );
    if (dateRange != null) {
      final start = tz.TZDateTime.from(dateRange.start, location);
      final end = tz.TZDateTime.from(dateRange.end, location);
      await event_service
          .listEvents(
            location: location,
            timeMin: start.toIso8601String(),
            timeMax: end.toIso8601String(),
            singleEvents: true,
          )
          .then(
            (events) => setState(
              () {
                _dateRange = DateTimeRange(start: start, end: end);
                _events = events;
              },
            ),
          );
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

  const _TeacherTable({
    required this.dateRange,
    required this.onSelectDateRange,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final teacherProfiles =
        context.select<AccountModel, List<TeacherProfileModel>>(
      (a) => a.teacherProfileList,
    );

    return PaginatedDataTable(
      header: TextButton.icon(
        icon: const Icon(Icons.edit),
        label: Text(
          '${dateFormatter.format(dateRange.start)} - ${dateFormatter.format(dateRange.end)}',
        ),
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
        context: context,
        data: teacherProfiles,
        events: events,
      ),
    );
  }
}

class _StudentTable extends StatefulWidget {
  @override
  State<_StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<_StudentTable> {
  final List<StudentProfileModel> _studentProfiles = [];
  String? _searchEmail;

  @override
  void initState() {
    super.initState();
    _studentProfiles.addAll(context.read<AccountModel>().studentProfileList);
  }

  Iterable<Widget> _getSuggestions(SearchController controller) {
    if (controller.text.isEmpty) {
      return _studentProfiles.map(
        (e) => ListTile(
          title: Text(e.email),
          onTap: () {
            controller.closeView(e.email);
            setState(() {
              _searchEmail = e.email;
            });
          },
        ),
      );
    }
    return _studentProfiles
        .where(
          (e) => e.email.toLowerCase().contains(controller.text.toLowerCase()),
        )
        .map(
          (e) => ListTile(
            title: Text(e.email),
            onTap: () {
              controller.closeView(e.email);
              setState(() {
                _searchEmail = e.email;
              });
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAnchor(
          builder: (context, controller) => SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            hintText: S.of(context).searchEmail,
            trailing: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    _searchEmail = null;
                  });
                },
              ),
            ],
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          ),
          viewHintText: S.of(context).searchEmail,
          viewTrailing: const [],
          suggestionsBuilder: (context, controller) =>
              _getSuggestions(controller),
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
          source: _StudentData(
            data: _searchEmail?.isEmpty ?? true
                ? _studentProfiles
                : _studentProfiles
                    .where((e) => e.email == _searchEmail)
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _TeacherData extends DataTableSource {
  _TeacherData({
    required BuildContext context,
    required List<TeacherProfileModel> data,
    required List<EventModel> events,
  })  : _context = context,
        _data = data,
        _events = events;

  final BuildContext _context;
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
    final account = _context.read<AccountModel>();

    final completedPrivateEvents = _events
        .where(
          (e) =>
              e.eventType == EventType.private &&
              isTeacherInEvent(_data[index].profileId, e) &&
              e.studentIdList.isNotEmpty,
        )
        .toList();

    return DataRow(
      cells: [
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
            '${completedPrivateEvents.map((event) => event.numPoints).fold(0, (int a, int b) => a + b)}',
          ),
          onTap: () => showDialog(
            context: _context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                width: 500,
                height: 500,
                child: ListView(
                  children: completedPrivateEvents
                      .map(
                        (event) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(event.summary),
                            Text(
                              DateFormat.yMd(account.locale)
                                  .add_jm()
                                  .format(event.startTime),
                            ),
                            Text('${event.numPoints}'),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
    return DataRow(
      cells: [
        DataCell(SelectableText(_data[index].profileId)),
        DataCell(SelectableText(_data[index].email)),
        DataCell(SelectableText(_data[index].lastName)),
        DataCell(SelectableText(_data[index].firstName)),
        DataCell(SelectableText('${_data[index].numPoints}')),
        DataCell(SelectableText(_data[index].referrer ?? '')),
      ],
    );
  }
}

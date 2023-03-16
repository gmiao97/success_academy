import 'dart:html' as html;

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/lesson_info/lesson_model.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/lesson_info_service.dart'
    as lesson_info_service;
import 'package:webviewx/webviewx.dart';

class LessonInfo extends StatefulWidget {
  const LessonInfo({super.key});

  @override
  State<LessonInfo> createState() => _LessonInfoState();
}

class _LessonInfoState extends State<LessonInfo> {
  late WebViewXController webviewController;
  bool _zoomInfoLoaded = false;
  List<LessonModel> _zoomInfo = [];

  @override
  void initState() {
    super.initState();
  }

  void initLessons(UserType userType, SubscriptionPlan? subscription) async {
    final lessons = await lesson_info_service.getLessons(
        includePreschool: userType != UserType.student ||
            subscription == SubscriptionPlan.minimumPreschool);
    setState(() {
      _zoomInfo = lessons;
      _zoomInfoLoaded = true;
    });
  }

  Widget _getZoomInfoTable(
      UserType userType, SubscriptionPlan? subscriptionPlan) {
    if (userType == UserType.admin) {
      return EditableZoomInfo(
        zoomInfo: _zoomInfo,
      );
    }
    if (userType == UserType.teacher ||
        (subscriptionPlan != null &&
            subscriptionPlan != SubscriptionPlan.monthly)) {
      return ZoomInfo(
        zoomInfo: _zoomInfo,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();
    initLessons(account.userType, account.subscriptionPlan);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                S.of(context).freeLessonTimeTable,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 8),
              WebViewX(
                width: 700,
                height: 300,
                onWebViewCreated: (controller) => controller.loadContent(
                    'https://drive.google.com/embeddedfolderview?id=1z5WUmx_lFVRy3YbmtEUH-tIqrwsaP8au#list',
                    SourceType.url),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).freeLessonMaterials,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 8),
              WebViewX(
                width: 700,
                height: 300,
                onWebViewCreated: (controller) => controller.loadContent(
                    'https://drive.google.com/embeddedfolderview?id=1EMhq3GkTEfsk5NiSHpqyZjS4H2N_aSak#list',
                    SourceType.url),
              ),
              const SizedBox(height: 20),
              !_zoomInfoLoaded
                  ? const CircularProgressIndicator()
                  : _getZoomInfoTable(
                      account.userType, account.subscriptionPlan),
            ],
          ),
        ),
      ),
    );
  }
}

class ZoomInfo extends StatelessWidget {
  const ZoomInfo({super.key, required this.zoomInfo});

  final List<LessonModel> zoomInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).freeLessonZoomInfo,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          width: 1000,
          child: PaginatedDataTable(
              rowsPerPage: 5,
              columns: <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      S.of(context).lesson,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      S.of(context).link,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      S.of(context).meetingId,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      S.of(context).password,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              source: _ZoomInfoDataSource(data: zoomInfo)),
        )
      ],
    );
  }
}

class _ZoomInfoDataSource extends DataTableSource {
  _ZoomInfoDataSource({required this.data});

  final List<LessonModel> data;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int i) {
    return DataRow(cells: [
      DataCell(Text(data[i].name)),
      DataCell(InkWell(
        child: Text(
          'Zoom',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: constants.linkColor,
          ),
        ),
        onTap: () {
          html.window.open(data[i].zoomLink, 'Zoom');
        },
      )),
      DataCell(Text(data[i].zoomId)),
      DataCell(Text(data[i].zoomPassword)),
    ]);
  }
}

class EditableZoomInfo extends StatelessWidget {
  const EditableZoomInfo({Key? key, required this.zoomInfo}) : super(key: key);

  final List<LessonModel> zoomInfo;

  @override
  Widget build(BuildContext context) {
    final headers = [
      {
        'title': S.of(context).lesson,
        'widthFactor': 0.15,
        'index': 1,
        'key': 'name',
      },
      {
        'title': S.of(context).link,
        'widthFactor': 0.3,
        'index': 2,
        'key': 'zoom_link',
      },
      {
        'title': S.of(context).meetingId,
        'widthFactor': 0.1,
        'index': 3,
        'key': 'zoom_id',
      },
      {
        'title': S.of(context).password,
        'index': 4,
        'key': 'zoom_pw',
      },
    ];

    return Column(
      children: [
        Text(
          S.of(context).freeLessonZoomInfo,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: 500,
          child: Editable(
            columns: headers,
            rows: zoomInfo.map((lesson) => lesson.toJson()).toList(),
            // showCreateButton: true,
            showSaveIcon: true,
            saveIconColor: Theme.of(context).primaryColor,
            onRowSaved: ((value) {
              if (value == 'no edit') {
                return;
              }

              final i = value['row'];
              value.remove('row');

              value.forEach((k, v) {
                switch (k) {
                  case 'name':
                    zoomInfo[i].name = v;
                    break;
                  case 'zoom_link':
                    zoomInfo[i].zoomLink = v;
                    break;
                  case 'zoom_id':
                    zoomInfo[i].zoomId = v;
                    break;
                  case 'zoom_pw':
                    zoomInfo[i].zoomPassword = v;
                    break;
                }
              });
              lesson_info_service
                  .updateLesson(zoomInfo[i].id, zoomInfo[i])
                  .then(
                    (unused) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).updated),
                      ),
                    ),
                  )
                  .catchError(
                (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).updateFailed),
                      backgroundColor: Theme.of(context).errorColor,
                    ),
                  );
                  debugPrint("Failed to update lesson info: $err");
                },
              );
            }),
            onSubmitted: ((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).promptSave),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

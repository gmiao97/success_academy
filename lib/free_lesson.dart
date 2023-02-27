import 'dart:html' as html;

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/lesson_info_service.dart'
    as lesson_info_service;
import 'package:success_academy/utils.dart' as utils;
import 'package:webviewx/webviewx.dart';

class FreeLesson extends StatelessWidget {
  const FreeLesson({Key? key}) : super(key: key);

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
    if (account.userType == UserType.studentNoProfile) {
      return const ProfileBrowse();
    }
    if (account.userType == UserType.admin) {
      return utils.buildAdminProfileScaffold(
        context: context,
        body: const _FreeLesson(),
      );
    }
    if (account.userType == UserType.teacher) {
      return utils.buildTeacherProfileScaffold(
        context: context,
        body: const _FreeLesson(),
      );
    }
    return utils.buildStudentProfileScaffold(
      context: context,
      body: const _FreeLesson(),
    );
  }
}

class _FreeLesson extends StatefulWidget {
  const _FreeLesson({Key? key}) : super(key: key);

  @override
  State<_FreeLesson> createState() => _FreeLessonState();
}

class _FreeLessonState extends State<_FreeLesson> {
  late WebViewXController webviewController;
  List<Map<String, Object?>>? _zoomInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initLessons();
  }

  void initLessons() async {
    final account = context.watch<AccountModel>();
    final lessons = await lesson_info_service.getLessons(
        includePreschool: account.userType != UserType.student ||
            account.subscriptionPlan == SubscriptionPlan.minimumPreschool);
    setState(() {
      _zoomInfo = lessons;
    });
  }

  Widget _getZoomInfoTable(
      UserType userType, SubscriptionPlan? subscriptionPlan) {
    if (userType == UserType.admin) {
      return EditableZoomInfo(
        zoomInfo: _zoomInfo!,
      );
    }
    if (userType == UserType.teacher ||
        (subscriptionPlan != null &&
            subscriptionPlan != SubscriptionPlan.monthly)) {
      return ZoomInfo(
        zoomInfo: _zoomInfo!,
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

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
              _zoomInfo == null
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
  const ZoomInfo({Key? key, required this.zoomInfo}) : super(key: key);

  final List<Map<String, Object?>> zoomInfo;

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

  final List<Map<String, Object?>> data;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]['name'] as String)),
      DataCell(InkWell(
        child: const Text(
          'Zoom',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () {
          html.window.open(data[index]['zoom_link'] as String, 'Zoom');
        },
      )),
      DataCell(Text(data[index]['zoom_id'] as String)),
      DataCell(Text(data[index]['zoom_pw'] as String)),
    ]);
  }
}

class EditableZoomInfo extends StatelessWidget {
  const EditableZoomInfo({Key? key, required this.zoomInfo}) : super(key: key);

  final List<dynamic> zoomInfo;

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
            rows: zoomInfo,
            // showCreateButton: true,
            showSaveIcon: true,
            saveIconColor: Colors.amber,
            onRowSaved: ((value) {
              if (value == 'no edit') {
                return;
              }

              final i = value['row'];
              value.remove('row');

              value.forEach((k, v) {
                zoomInfo[i][k] = v;
              });
              lesson_info_service
                  .updateLesson(zoomInfo[i]['id'], zoomInfo[i])
                  .then(
                    (unused) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('更新しました'),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  )
                  .catchError(
                    (err) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('更新できません'),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  );
            }),
            onSubmitted: ((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('保存ボタンを押してください'),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

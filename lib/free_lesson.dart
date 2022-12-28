import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
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

  @override
  void initState() {
    super.initState();
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
              account.userType == UserType.student
                  ? FutureBuilder<SubscriptionPlan?>(
                      future: profile_service.getSubscriptionTypeForProfile(
                          profileId: account.studentProfile?.profileId,
                          userId: account.firebaseUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Profile has subscription
                          if (snapshot.data != null &&
                              snapshot.data != SubscriptionPlan.monthly) {
                            return const ZoomInfo();
                          }
                        }
                        return const SizedBox();
                      },
                    )
                  : const ZoomInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class ZoomInfo extends StatelessWidget {
  const ZoomInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).freeLessonZoomInfo,
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}

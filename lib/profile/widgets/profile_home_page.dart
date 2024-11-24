import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../account/account_model.dart';
import 'admin_profile_view.dart';
import 'student_profile_view.dart';
import 'teacher_profile_view.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    switch (account.userType) {
      case UserType.admin:
        return const AdminProfileView();
      case UserType.teacher:
        return const TeacherProfileView();
      case UserType.student:
        return const StudentProfileView();
      default:
        return const SizedBox.shrink();
    }
  }
}

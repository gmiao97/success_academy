import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/profile/admin_profile.dart';
import 'package:success_academy/profile/student_profile.dart';
import 'package:success_academy/profile/teacher_profile.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    switch (account.userType) {
      case UserType.admin:
        return const AdminProfile();
      case UserType.teacher:
        return const TeacherProfile();
      case UserType.student:
        return const StudentProfile();
      default:
        return const SizedBox.shrink();
    }
  }
}

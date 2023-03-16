import 'package:flutter/material.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/common_widgets/desktop_scaffold.dart';
import 'package:success_academy/common_widgets/phone_scaffold.dart';

class MyScaffold extends StatelessWidget {
  static const double _breakpoint = 700;
  final UserType userType;

  const MyScaffold({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < _breakpoint) {
      return PhoneScaffold(userType: userType);
    } else {
      return DesktopScaffold(userType: userType);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:success_academy/common_widgets/desktop_scaffold.dart';
import 'package:success_academy/common_widgets/phone_scaffold.dart';

class MyScaffold extends StatelessWidget {
  static const double _breakpoint = 960;

  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < _breakpoint) {
      return const PhoneScaffold();
    } else {
      return const DesktopScaffold();
    }
  }
}

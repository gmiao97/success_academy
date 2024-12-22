import 'package:flutter/material.dart';

import 'desktop_scaffold.dart';
import 'phone_scaffold.dart';

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

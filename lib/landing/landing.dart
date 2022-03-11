import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Image.asset(
        'assets/images/classroom.jpg',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

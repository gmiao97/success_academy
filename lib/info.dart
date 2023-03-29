import 'package:flutter/material.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/constants.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Info();
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              child: Text(S.of(context).goBack),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).termsOfUse,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Divider(),
                    ...termsOfUse
                        .map((line) => Text(
                              line,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

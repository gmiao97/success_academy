import 'package:flutter/material.dart';

import 'constants.dart';
import 'generated/l10n.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: () {
                Navigator.maybePop(context);
              },
              label: Text(S.of(context).goBack),
              icon: const Icon(Icons.chevron_left),
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

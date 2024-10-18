import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:provider/provider.dart';

import 'account/account_model.dart';
import 'common_widgets/my_scaffold.dart';
import 'constants.dart' as constants;
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'info.dart';
import 'landing/landing.dart';
import 'landing/verification.dart';
import 'profile/profile_browse.dart';
import 'profile/profile_create.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (kDebugMode) {
    FirebaseFunctions.instanceFor(region: 'us-west2')
        .useFunctionsEmulator('localhost', 5001);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountModel(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.select<AccountModel, String>((a) => a.locale);

    return MaterialApp(
      title: constants.homePageAppBarName,
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.amber,
          backgroundColor: Colors.grey[200],
          cardColor: Colors.white,
        ),
      ),
      locale: Locale(locale),
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterFireUILocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Root(),
      routes: {
        constants.routeInfo: (context) => const Info(),
        constants.routeCreateProfile: (context) => const ProfileCreate(),
      },
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context
        .select<AccountModel, AuthStatus>((account) => account.authStatus);
    final userType = context.select<AccountModel, UserType>((a) => a.userType);

    if (authStatus == AuthStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    if (authStatus == AuthStatus.signedOut) {
      return const LandingPage();
    }
    if (userType == UserType.studentNoProfile) {
      return const ProfileBrowse();
    }
    return const MyScaffold();
  }
}

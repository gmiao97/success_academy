import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/account/account_settings.dart';
import 'package:success_academy/calendar/calendar.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/firebase_options.dart';
import 'package:success_academy/free_lesson.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/info.dart';
import 'package:success_academy/l10n/FlutterFireUIJaLocalizationsDelegate.dart';
import 'package:success_academy/landing/landing.dart';
import 'package:success_academy/profile/add_points.dart';
import 'package:success_academy/profile/profile_home.dart';
import 'package:success_academy/profile/profile_create.dart';
import 'package:success_academy/profile/profile_manage.dart';
import 'package:success_academy/utils.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountModel(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale =
        context.select<AccountModel, String>((account) => account.locale);

    // TODO: Import 'dart:io' show Platform; if (Platform.isIOS)
    return MaterialApp(
      title: constants.homePageAppBarName,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      locale: Locale(locale),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterFireUIJaLocalizationsDelegate(),
        // TODO: GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: constants.routeHome,
      routes: {
        constants.routeHome: (context) => const HomePage(),
        constants.routeSignIn: (context) => const SignInPage(),
        constants.routeCreateProfile: (context) => const ProfileCreate(),
        constants.routeCalendar: (context) => const Calendar(),
        constants.routeAddPoints: (context) => const AddPoints(),
        constants.routeSettings: (context) => const AccountSettings(),
        constants.routeManageUsers: (context) => const ManageUsers(),
        constants.routeInfo: (context) => const Info(),
        constants.routeFreeLesson: (context) => const FreeLesson(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
    if (account.authStatus == AuthStatus.signedIn) {
      return const ProfileHome();
    }
    return utils.buildLoggedOutScaffold(
      context: context,
      body: const LandingPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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
    if (account.authStatus == AuthStatus.signedIn) {
      return const HomePage();
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: Text(S.of(context).goBack),
          ),
        ),
        const SizedBox(
          width: 500,
          height: 500,
          child: Card(
            child: SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId: constants.googleAuthProviderConfigurationClientId,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// TODO: Make refresh after email verification automatic.
class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return utils.buildLoggedInScaffold(
      context: context,
      body: Center(
        child: Card(
          child: Container(
            height: 500,
            width: 700,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).verifyEmailMessage(
                        account.firebaseUser?.email as String,
                      ),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 50),
                Text(
                  S.of(context).verifyEmailAction,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    // BUG: Only reloads when clicked twice.
                    final firebaseUser = FirebaseAuth.instance.currentUser!;
                    await firebaseUser.reload();
                    if (firebaseUser.emailVerified) {
                      account.authStatus = AuthStatus.signedIn;
                    }
                  },
                  child: Text(S.of(context).reloadPage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

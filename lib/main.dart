import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/firebase_options.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/l10n/FlutterFireUIJaLocalizationsDelegate.dart';
import 'package:success_academy/landing/landing.dart';
import 'package:success_academy/signed_in_home.dart';
import 'package:success_academy/profile/profile_create.dart';
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
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.signedIn) {
      return const SignedInHome();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(constants.homePageAppBarName),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              style: style,
              onPressed: () {
                account.locale = account.locale == 'en' ? 'ja' : 'en';
              },
              child: Text(
                account.locale == 'en' ? '🇺🇸' : '🇯🇵',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              style: style,
              onPressed: () {
                Navigator.pushNamed(context, constants.routeSignIn);
              },
              child: Text(
                S.of(context).signIn,
              ),
            ),
          ],
        ),
        body: const LandingPage());
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.emailVerification) {
      return utils.buildLoggedInScaffold(
        context: context,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Please click the link in the verification email"),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser!;
                  await user.reload();
                  if (user.emailVerified) {
                    account.authStatus = AuthStatus.signedIn;
                  }
                },
                child: const Text("Reload"),
              ),
            ],
          ),
        ),
      );
    }
    if (account.authStatus == AuthStatus.signedIn) {
      return const HomePage();
    }
    return Column(
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: Text(S.of(context).goBack),
          ),
          margin: const EdgeInsets.all(10),
        ),
        const SizedBox(
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
          width: 500,
          height: 500,
        ),
      ],
    );
  }
}

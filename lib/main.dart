import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/firebase_options.dart';
import 'package:success_academy/landing/landing.dart';
import 'package:success_academy/signed_in_home.dart';
import 'package:success_academy/profile/profile_create.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountModel(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.homePageAppBarName,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
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
    final isSignedIn =
        context.select<AccountModel, bool>((account) => account.isSignedIn);

    if (isSignedIn) {
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
                Navigator.pushNamed(context, constants.routeSignIn);
              },
              child: const Text(constants.signInText),
            )
          ],
        ),
        body: const LandingPage());
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSignedIn =
        context.select<AccountModel, bool>((account) => account.isSignedIn);

    if (isSignedIn) {
      return const HomePage();
    }
    return Column(
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: const Text(constants.backButtonText),
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

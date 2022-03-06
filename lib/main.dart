import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

import 'authentication.dart';
import 'constants.dart' as constants;
import 'firebase_options.dart';
import 'landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthenticationState(),
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
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          constants.routeSignIn: (context) => const SignInPage(),
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return Consumer<AuthenticationState>(builder: (context, auth, _) {
      if (auth.status == Authentication.loggedOut) {
        return Scaffold(
            appBar: AppBar(
                title: const Text(constants.homePageAppBarName),
                centerTitle: false,
                actions: [
                  TextButton(
                    style: style,
                    onPressed: () {
                      Navigator.pushNamed(context, constants.routeSignIn);
                    },
                    child: const Text(constants.signInText),
                  )
                ]),
            body: const LandingPage());
      }

      return Center(
          child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const Text(constants.signOutText),
      ));
    });
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(builder: (context, auth, _) {
      if (auth.status == Authentication.loggedOut) {
        return Column(
          children: [
            Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(constants.backButtonText)),
                margin: const EdgeInsets.all(10)),
            const SizedBox(
              child: Card(
                  child: SignInScreen(providerConfigs: [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId: constants.googleAuthProviderConfigurationClientId,
                ),
              ])),
              width: 500,
              height: 500,
            )
          ],
        );
      }

      return const HomePage();
    });
  }
}

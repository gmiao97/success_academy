import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/utils.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  void initState() {
    super.initState();
  }

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
    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.userType == UserType.admin) {
      return buildAdminProfileScaffold(
        context: context,
        body: const _Manage(),
      );
    }
    return buildLoggedInScaffold(
      context: context,
      body: const Center(
        child: Text("NOT SUPPORTED"),
      ),
    );
  }
}

class _Manage extends StatelessWidget {
  const _Manage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Manage Users");
  }
}

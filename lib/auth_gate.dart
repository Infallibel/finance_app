import 'package:finance_app/multi_providers.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Login In or Register',
                      style: kFontStyleLato
                          .copyWith(color: kColorGrey3)
                          .copyWith(fontSize: 25),
                    ),
                  ));
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? Text(
                        'Welcome to FlutterFire, please sign in!',
                        style: kFontStyleLato.copyWith(color: kColorGrey3),
                      )
                    : Text(
                        'Welcome to FlutterFire, please sign up!',
                        style: kFontStyleLato.copyWith(color: kColorGrey3),
                      ),
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: kFontStyleLato.copyWith(color: kColorGrey3),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Text(
                    'Login In or Register',
                    style: kFontStyleLato
                        .copyWith(color: kColorGrey3)
                        .copyWith(fontSize: 25),
                  ),
                ),
              );
            },
          );
        }

        return const MultiProviders();
      },
    );
  }
}

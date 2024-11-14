import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold(
      {super.key,
      required this.appBarTitle,
      required this.scaffoldBody,
      this.bottomNavigationBar,
      this.leading,
      this.floatingActionButton,
      this.floatingActionButtonLocation});

  final dynamic appBarTitle;
  final Widget? bottomNavigationBar;
  final Widget scaffoldBody;
  final Widget? leading;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle is String
          ? AppBar(
              leading: leading,
              surfaceTintColor: kColorWhite,
              title: Text(
                appBarTitle,
                style: kFontStyleLato,
              ),
              centerTitle: true,
            )
          : AppBar(
              surfaceTintColor: kColorWhite,
              title: appBarTitle,
              centerTitle: true,
            ),
      body: scaffoldBody,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

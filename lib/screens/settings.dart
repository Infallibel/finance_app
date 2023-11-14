import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenScaffold(
      appBarTitle: 'Settings',
      scaffoldBody: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <IconTextAndRow>[
            IconTextAndRow(
                iconData: Icons.tune_outlined,
                iconColor: kColorBlue,
                inputText: 'General'),
            IconTextAndRow(
                iconData: Icons.person_outlined,
                iconColor: kColorBlue,
                inputText: 'Accounts'),
            IconTextAndRow(
                iconData: Icons.attach_money_outlined,
                iconColor: kColorBlue,
                inputText: 'Currency'),
            IconTextAndRow(
                iconData: Icons.notifications_outlined,
                iconColor: kColorBlue,
                inputText: 'Notifications'),
            IconTextAndRow(
                iconData: Icons.folder_copy_outlined,
                iconColor: kColorBlue,
                inputText: 'Categories'),
            IconTextAndRow(
                iconData: Icons.contrast_outlined,
                iconColor: kColorBlue,
                inputText: 'App Theme'),
            IconTextAndRow(
                iconData: Icons.lock_outline,
                iconColor: kColorBlue,
                inputText: 'Security'),
            IconTextAndRow(
                iconData: Icons.privacy_tip_outlined,
                iconColor: kColorBlue,
                inputText: 'Privacy'),
            IconTextAndRow(
                iconData: Icons.logout_outlined,
                iconColor: kColorGrey1,
                inputText: 'Log out'),
          ],
        ),
      ),
    );
  }
}

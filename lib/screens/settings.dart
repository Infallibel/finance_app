import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBarTitle: 'Settings',
      scaffoldBody: Padding(
        padding:
            const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <IconTextAndRow>[
            const IconTextAndRow(
                iconData: Icons.tune_outlined,
                iconColor: kColorBlue,
                inputText: 'General'),
            const IconTextAndRow(
                iconData: Icons.person_outlined,
                iconColor: kColorBlue,
                inputText: 'Accounts'),
            const IconTextAndRow(
                iconData: Icons.attach_money_outlined,
                iconColor: kColorBlue,
                inputText: 'Currency'),
            const IconTextAndRow(
                iconData: Icons.notifications_outlined,
                iconColor: kColorBlue,
                inputText: 'Notifications'),
            const IconTextAndRow(
                iconData: Icons.folder_copy_outlined,
                iconColor: kColorBlue,
                inputText: 'Categories'),
            IconTextAndRow(
              iconData: Icons.contrast_outlined,
              iconColor: kColorBlue,
              inputText: 'App Theme',
              trailingIcon: Icons.dark_mode_outlined,
              onTap: () {
                ///TODO change the app theme and Icon to dark mode/light mode
              },
            ),
            const IconTextAndRow(
                iconData: Icons.lock_outline,
                iconColor: kColorBlue,
                inputText: 'Security'),
            const IconTextAndRow(
                iconData: Icons.privacy_tip_outlined,
                iconColor: kColorBlue,
                inputText: 'Privacy'),
            const IconTextAndRow(
                iconData: Icons.logout_outlined,
                iconColor: kColorGrey1,
                inputText: 'Log out'),
          ],
        ),
      ),
    );
  }
}

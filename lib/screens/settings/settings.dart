import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import 'category_editor.dart';

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
            IconTextAndRow(
              iconData: Icons.attach_money_outlined,
              iconColor: kColorBlue,
              inputText: 'Currency',
              onTap: () {
                context.read<CurrencyCubit>().showCurrencyOptions(context);
              },
            ),
            const IconTextAndRow(
                iconData: Icons.notifications_outlined,
                iconColor: kColorBlue,
                inputText: 'Notifications'),
            IconTextAndRow(
              iconData: Icons.folder_copy_outlined,
              iconColor: kColorBlue,
              inputText: 'Categories',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryEditor(),
                  ),
                );
              },
            ),
            IconTextAndRow(
              iconData: Icons.contrast_outlined,
              iconColor: kColorBlue,
              inputText: 'App Theme',
              trailingIcon: Icons.dark_mode_outlined,
              onTap: () {
                ///TODO toggle app theme
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

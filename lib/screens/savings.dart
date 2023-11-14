import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/savings_goal_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBarTitle: 'Savings',
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Your Goals',
              style: kFontStyleLato.copyWith(fontSize: 20),
            ),
            Expanded(
              child: ListView(
                children: const <SavingsGoalRow>[
                  SavingsGoalRow(
                    iconData: Icons.track_changes,
                    goalName: 'Vacation in Bali',
                    goalAmount: 1500,
                    goalAccumulated: 750,
                  ),
                  SavingsGoalRow(
                    iconData: Icons.track_changes,
                    goalName: 'Mercedes-Benz GLA',
                    goalAmount: 23200,
                    goalAccumulated: 280,
                  ),
                ],
              ),
            ),

            /// make it so textbutton is higher up on screen when only a few savingsgoalrows are added if possible
            TextButtonModel(
              onPressed: () {},
              backgroundColor: kColorLightBlueSecondary,
              overlayColor: kColorLightBlue,
              buttonTextColor: kColorBlue,
              buttonText: 'Add a New Goal',
            ),
          ],
        ),
      ),
    );
  }
}

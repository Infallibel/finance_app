import 'package:finance_app/screens/savings/add_new_goal.dart';
import 'package:finance_app/utilities/CubitsBlocs/savingsCubits/goal_data_cubit.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/savings_goal_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/CubitsBlocs/addTransactionCubits/note_cubit.dart';
import 'edit_goal.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  void _showGoalInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'How Adding a New Goal Works',
            style: kFontStyleLato.copyWith(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. When you add a new goal, specify the name, target amount, and any accumulated amount so far.',
                style: kFontStyleLato.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '2. Note that the accumulated amount will be immediately deducted from your total balance. This ensures that funds already saved for this goal are not counted as available balance.',
                style: kFontStyleLato.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '3. You can view all your goals here, including their progress toward your target.',
                style: kFontStyleLato.copyWith(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return kColorLightBlueSecondary;
                    }
                    return null;
                  },
                ),
              ),
              child: Text(
                'Got it!',
                style: kFontStyleLato.copyWith(color: kColorBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBarTitle: 'Savings',
      leading: GestureDetector(
        onTap: () {
          _showGoalInfoDialog(context);
        },
        child: const Icon(
          Icons.info_outline,
          color: kColorGrey2,
        ),
      ),
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
              child: BlocBuilder<GoalDataCubit, GoalDataState>(
                builder: (context, state) {
                  if (state is GoalDataLoaded) {
                    final goals = state.goals;
                    if (goals.isEmpty) {
                      return Center(
                        child: Text(
                          'No goals added yet.',
                          style: kFontStyleLato.copyWith(color: kColorGrey2),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return SavingsGoalRow(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => NotesCubit(),
                                child: EditGoal(goal: goal),
                              ),
                            ));
                          },
                          iconData: Icons.track_changes,
                          goalName: goal.name,
                          goalAmount: goal.targetAmount,
                          goalAccumulated: goal.accumulatedAmount,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No goals added yet.',
                        style: kFontStyleLato.copyWith(color: kColorGrey2),
                      ),
                    );
                  }
                },
              ),
            ),

            ///TODO make it so textButton is higher up on screen when only a few savingsGoalRows are added if possible
            TextButtonModel(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => NotesCubit(),
                    child: AddNewGoal(),
                  ),
                ));
              },
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

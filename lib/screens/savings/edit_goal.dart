import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/CubitsBlocs/addTransactionCubits/date_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactionCubits/note_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/goal_data_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';
import '../../utilities/constants.dart';
import '../../widgets/icon_text_row.dart';
import '../../widgets/numerical_text_field.dart';
import '../../widgets/savings_goal_row.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/text_button_model.dart';

class EditGoal extends StatelessWidget {
  final SavingsGoalData goal;
  final TextEditingController goalNameController;
  final TextEditingController goalAmountController;
  final TextEditingController accumulatedAmountController;
  final TextEditingController noteController;

  EditGoal({super.key, required this.goal})
      : goalNameController = TextEditingController(text: goal.name),
        goalAmountController =
            TextEditingController(text: goal.targetAmount.toString()),
        accumulatedAmountController =
            TextEditingController(text: goal.accumulatedAmount.toString()),
        noteController = TextEditingController(text: goal.note ?? '');

  void _updateGoal(BuildContext context) {
    final dateState = context.read<DateCubit>().state;
    final notesState = context.read<NotesCubit>().state;

    double goalAmount = double.tryParse(goalAmountController.text) ?? 0.0;
    double accumulatedAmount =
        double.tryParse(accumulatedAmountController.text) ?? 0.0;

    if (goalNameController.text.isNotEmpty &&
        goalAmountController.text.isNotEmpty &&
        accumulatedAmountController.text.isNotEmpty &&
        dateState is DateSelected) {
      if (accumulatedAmount > goalAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Accumulated amount cannot exceed the goal amount',
              textAlign: TextAlign.center,
            ),
          ),
        );
        return;
      }

      final updatedGoalData = SavingsGoalData(
        name: goalNameController.text,
        targetAmount: goalAmount,
        accumulatedAmount: accumulatedAmount,
        targetDate: dateState.date,
        user: goal.user, // keep the original user
        note: notesState.note.isNotEmpty ? notesState.note : null,
      );

      context.read<GoalDataCubit>().updateGoal(goal, updatedGoalData);

      goalNameController.clear();
      goalAmountController.clear();
      accumulatedAmountController.clear();
      context.read<DateCubit>().clearDate();
      context.read<NotesCubit>().updateNote('');

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the details',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenScaffold(
        appBarTitle: 'Edit Goal',
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.clear_outlined,
            color: kColorGrey2,
          ),
        ),
        scaffoldBody: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SavingsGoalRow(
                  onTap: () {},
                  iconData: Icons.track_changes,
                  goalName: goal.name,
                  goalAmount: goal.targetAmount,
                  goalAccumulated: goal.accumulatedAmount,
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextField(
                    controller: goalNameController,
                    cursorColor: kColorGrey3,
                    textAlign: TextAlign.center,
                    style: kFontStyleLato.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Goal Name',
                      hintStyle: kFontStyleLato.copyWith(color: kColorGrey3),
                    ),
                  ),
                ),

                // Goal Amount
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal Amount:',
                        style: kFontStyleLato.copyWith(
                          fontSize: 16,
                          color: kColorGrey3,
                        ),
                      ),
                      NumericalTextField(
                        controller: goalAmountController,
                      ),
                    ],
                  ),
                ),

                // Accumulated Amount
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount Accumulated:',
                        style: kFontStyleLato.copyWith(
                          fontSize: 16,
                          color: kColorGrey3,
                        ),
                      ),
                      NumericalTextField(
                        controller: accumulatedAmountController,
                      ),
                    ],
                  ),
                ),

                Text(
                  'Target Date:',
                  style: kFontStyleLato.copyWith(
                    fontSize: 16,
                    color: kColorGrey3,
                  ),
                ),

                BlocBuilder<DateCubit, DateState>(
                  builder: (context, state) {
                    return IconTextAndRow(
                      selectionText:
                          state is DateSelected ? 'Selected' : 'Not Selected',
                      onTap: () {
                        context.read<DateCubit>().showCalendar(context);
                      },
                      iconData: Icons.calendar_month_outlined,
                      iconColor: kColorGrey2,
                      inputText: state is DateSelected
                          ? "${state.date.day}/${state.date.month}/${state.date.year}"
                          : 'Target Date',
                    );
                  },
                ),

                // Note Section
                BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, notesState) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<NotesCubit>().toggleVisibility();
                          },
                          child: IconTextAndRow(
                            iconData: Icons.note_outlined,
                            iconColor: kColorGrey2,
                            inputText:
                                notesState.isVisible ? 'Hide Note' : 'Add Note',
                            selectionText: notesState.note.isNotEmpty
                                ? 'Added'
                                : 'Not Added',
                          ),
                        ),
                        if (notesState.isVisible)
                          TextField(
                            controller: noteController,
                            onChanged: (value) {
                              context.read<NotesCubit>().updateNote(value);
                            },
                            decoration: const InputDecoration(
                              focusColor: kColorBlue,
                              hintText: 'Enter your note here',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: kColorBlue)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kColorBlue)),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButtonModel(
            onPressed: () {
              _updateGoal(context);
            },
            backgroundColor: kColorBlue,
            overlayColor: kColorLightBlue,
            buttonText: 'Save Changes',
            buttonTextColor: kColorWhite,
          ),
        ),
      ),
    );
  }
}

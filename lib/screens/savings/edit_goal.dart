import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/CubitsBlocs/addTransactionCubits/date_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactionCubits/note_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/goal_data_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';
import '../../utilities/constants.dart';
import '../../widgets/icon_text_row.dart';
import '../../widgets/numerical_text_field.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/text_button_model.dart';

class EditGoal extends StatelessWidget {
  final SavingsGoalData goalData;

  const EditGoal({super.key, required this.goalData});

  @override
  Widget build(BuildContext context) {
    context.read<DateCubit>().selectDate(goalData.targetDate);
    context.read<NotesCubit>().updateNote(goalData.note ?? '');

    final TextEditingController goalNameController =
        TextEditingController(text: goalData.name);
    final TextEditingController goalAmountController =
        TextEditingController(text: goalData.targetAmount.toString());
    final TextEditingController accumulatedAmountController =
        TextEditingController(text: goalData.accumulatedAmount.toString());
    final TextEditingController noteController =
        TextEditingController(text: goalData.note);

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
                // Goal Name Input
                TextField(
                  controller: goalNameController,
                  decoration: InputDecoration(
                    labelText: 'Goal Name',
                    labelStyle: kFontStyleLato.copyWith(color: kColorGrey1),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Goal Amount Input
                NumericalTextField(
                  controller: goalAmountController,
                ),
                const Divider(color: kColorGrey1, thickness: 1),
                const SizedBox(height: 16),

                // Target Date Selector
                BlocBuilder<DateCubit, DateState>(builder: (context, state) {
                  final selectedDate =
                      state is DateSelected ? state.date : null;

                  return IconTextAndRow(
                    selectionText:
                        selectedDate != null ? 'Selected' : 'Not Selected',
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && context.mounted) {
                        context.read<DateCubit>().selectDate(pickedDate);
                      }
                    },
                    iconData: Icons.calendar_month_outlined,
                    iconColor: kColorGrey1,
                    inputText: selectedDate != null
                        ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                        : 'Target Date',
                  );
                }),

                const SizedBox(height: 16),

                // Accumulated Amount Input
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

                // Note field
                BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, notesState) {
                    noteController.text = notesState.note;
                    return TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        focusColor: kColorBlue,
                        labelText: 'Note',
                        labelStyle: kFontStyleLato.copyWith(color: kColorGrey1),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: kColorBlue)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kColorBlue)),
                      ),
                      onChanged: (value) {
                        context.read<NotesCubit>().updateNote(value);
                      },
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
              double goalAmount =
                  double.tryParse(goalAmountController.text) ?? 0.0;
              double accumulatedAmount =
                  double.tryParse(accumulatedAmountController.text) ?? 0.0;

              if (goalAmount < accumulatedAmount) {
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

              // Construct updated goal data
              final updatedGoalData = goalData.copyWith(
                name: goalNameController.text,
                targetAmount: goalAmount,
                accumulatedAmount: accumulatedAmount,
                targetDate: context.read<DateCubit>().state is DateSelected
                    ? (context.read<DateCubit>().state as DateSelected).date
                    : goalData.targetDate,
                note: noteController.text,
              );

              // Update the goal in the cubit
              context.read<GoalDataCubit>().updateGoal(updatedGoalData);

              // Clear cubits and navigate back
              context.read<NotesCubit>().updateNote('');
              context.read<DateCubit>().clearDate();
              Navigator.pop(context);
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

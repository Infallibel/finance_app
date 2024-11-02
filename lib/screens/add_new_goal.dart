import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/numerical_text_field.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/date_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utilities/CubitsBlocs/savingsCubits/goal_data_cubit.dart';
import '../utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';

class AddNewGoal extends StatelessWidget {
  AddNewGoal({super.key});

  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController accumulatedAmountController =
      TextEditingController();

  void _saveGoal(BuildContext context) {
    final dateState = context.read<DateCubit>().state;

    // Parse amounts and perform validation check
    double goalAmount = double.tryParse(goalAmountController.text) ?? 0.0;
    double accumulatedAmount =
        double.tryParse(accumulatedAmountController.text) ?? 0.0;

    if (goalNameController.text.isNotEmpty &&
        goalAmountController.text.isNotEmpty &&
        accumulatedAmountController.text.isNotEmpty &&
        dateState is DateSelected) {
      if (accumulatedAmount > goalAmount) {
        // Show error if accumulated amount is higher than goal amount
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Accumulated amount cannot exceed the goal amount',
              textAlign: TextAlign.center,
            ),
          ),
        );
        return; // Exit the function to prevent saving
      }

      final goalData = SavingsGoalData(
        name: goalNameController.text,
        targetAmount: goalAmount,
        accumulatedAmount: accumulatedAmount,
        targetDate: dateState.date,
        user: 'Anna', // Placeholder, to be replaced with the current user
      );

      context.read<GoalDataCubit>().addGoal(goalData);

      // Reset the form
      goalNameController.clear();
      goalAmountController.clear();
      accumulatedAmountController.clear();
      context.read<DateCubit>().clearDate();

      // Pop the screen
      Navigator.of(context).pop();
    } else {
      // Show error if required fields are missing
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
        appBarTitle: 'Add New Goal',
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
                // Goal Name TextField (String Input)
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

                // NumericalTextField for Goal Amount with Label
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
                const IconTextAndRow(
                  iconData: Icons.note_outlined,
                  iconColor: kColorGrey2,
                  inputText: 'Notes',
                ),

                ///TODO adding notes, as in the add transaction
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButtonModel(
            onPressed: () {
              _saveGoal(context);
            },
            backgroundColor: kColorBlue,
            overlayColor: kColorLightBlue,
            buttonText: 'Save Goal',
            buttonTextColor: kColorWhite,
          ),
        ),
      ),
    );
  }
}

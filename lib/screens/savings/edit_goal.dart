import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/CubitsBlocs/addTransactionCubits/date_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactionCubits/note_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
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

  _clearCubits(BuildContext context) {
    context.read<DateCubit>().clearDate();
    context.read<NotesCubit>().updateNote('');
  }

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

    final double originalAccumulatedAmount = goalData.accumulatedAmount;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          _clearCubits(context);
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
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
                  TextField(
                    controller: goalNameController,
                    decoration: InputDecoration(
                      labelText: 'Goal Name',
                      labelStyle: kFontStyleLato.copyWith(color: kColorGrey1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
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
                  const Divider(color: kColorGrey1, thickness: 1),

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
                  const SizedBox(height: 16),
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
                  // Note field
                  BlocBuilder<NotesCubit, NotesState>(
                    builder: (context, notesState) {
                      noteController.text = notesState.note;
                      return TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          focusColor: kColorBlue,
                          labelText: 'Note',
                          labelStyle:
                              kFontStyleLato.copyWith(color: kColorGrey1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButtonModel(
                  onPressed: () {
                    double goalAmount =
                        double.tryParse(goalAmountController.text) ?? 0.0;
                    double accumulatedAmount =
                        double.tryParse(accumulatedAmountController.text) ??
                            0.0;

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

                    final double accumulatedDifference =
                        accumulatedAmount - originalAccumulatedAmount;

                    final updatedGoalData = goalData.copyWith(
                      name: goalNameController.text,
                      targetAmount: goalAmount,
                      accumulatedAmount: accumulatedAmount,
                      targetDate: context.read<DateCubit>().state
                              is DateSelected
                          ? (context.read<DateCubit>().state as DateSelected)
                              .date
                          : goalData.targetDate,
                      note: noteController.text,
                    );

                    context.read<GoalDataCubit>().updateGoal(updatedGoalData);

                    context
                        .read<TransactionDataCubit>()
                        .deductFromBalance(accumulatedDifference);

                    _clearCubits(context);
                    Navigator.pop(context);
                  },
                  backgroundColor: kColorBlue,
                  overlayColor: kColorLightBlue,
                  buttonText: 'Save Changes',
                  buttonTextColor: kColorWhite,
                  bottomPadding: 0,
                ),
                TextButtonModel(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            'Are you sure you want to mark this goal as complete?',
                            style: kFontStyleLato.copyWith(
                                fontSize: 20, color: kColorGrey3),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                  (states) => kColorWarning,
                                ),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) => kColorLightWarning,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No',
                                  style: kFontStyleLato.copyWith(
                                      color: kColorWhite)),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                  (states) => kColorSuccess,
                                ),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) => kColorLightSuccess,
                                ),
                              ),
                              onPressed: () {
                                context.read<GoalDataCubit>().completeGoal(
                                    goalData,
                                    context.read<TransactionDataCubit>());
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Yes',
                                  style: kFontStyleLato.copyWith(
                                      color: kColorWhite)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: kColorSuccess,
                  overlayColor: kColorLightSuccess,
                  buttonText: 'Complete Goal',
                  buttonTextColor: kColorWhite,
                  bottomPadding: 0,
                ),
                TextButtonModel(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            'Are you sure you want to delete this goal?',
                            style: kFontStyleLato.copyWith(
                                fontSize: 20, color: kColorGrey3),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                  (states) => kColorBlue,
                                ),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) => kColorLightBlue,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style:
                                    kFontStyleLato.copyWith(color: kColorWhite),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                  (states) => kColorWarning,
                                ),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) => kColorLightWarning,
                                ),
                              ),
                              onPressed: () {
                                context.read<GoalDataCubit>().deleteGoal(
                                    goalData,
                                    context.read<TransactionDataCubit>());
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Yes',
                                  style: kFontStyleLato.copyWith(
                                      color: kColorWhite)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: kColorWarning,
                  overlayColor: kColorLightWarning,
                  buttonText: 'Delete Goal',
                  buttonTextColor: kColorWhite,
                  bottomPadding: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

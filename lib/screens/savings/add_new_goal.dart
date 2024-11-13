import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/numerical_text_field.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/date_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../utilities/CubitsBlocs/addTransactionCubits/note_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/goal_data_cubit.dart';
import '../../utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';

class AddNewGoal extends StatelessWidget {
  AddNewGoal({super.key});

  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController accumulatedAmountController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final String goalId = const Uuid().v4();

  _clearCubits(BuildContext context) {
    goalNameController.clear();
    goalAmountController.clear();
    accumulatedAmountController.clear();
    context.read<DateCubit>().clearDate();
    context.read<NotesCubit>().updateNote('');
  }

  void _saveGoal(BuildContext context) {
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

      final goalData = SavingsGoalData(
        id: goalId,
        name: goalNameController.text,
        targetAmount: goalAmount,
        accumulatedAmount: accumulatedAmount,
        targetDate: dateState.date,
        user: 'Anna',
        note: notesState.note.isNotEmpty ? notesState.note : null,
      );

      context.read<GoalDataCubit>().addGoal(goalData);

      context.read<TransactionDataCubit>().deductFromBalance(accumulatedAmount);

      _clearCubits(context);

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
                              inputText: notesState.isVisible
                                  ? 'Hide Note'
                                  : 'Add Note',
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
                _saveGoal(context);
              },
              backgroundColor: kColorBlue,
              overlayColor: kColorLightBlue,
              buttonText: 'Save Goal',
              buttonTextColor: kColorWhite,
            ),
          ),
        ),
      ),
    );
  }
}

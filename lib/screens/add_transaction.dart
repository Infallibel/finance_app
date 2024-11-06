import 'package:finance_app/services/transaction_data.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/payment_type_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/transaction_type_cubit.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';
import 'package:finance_app/widgets/transactions_selection.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/numerical_text_field.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/date_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/note_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';

class AddTransactionPage extends StatelessWidget {
  AddTransactionPage({super.key});

  final String user = 'Anna';

  /// TODO handle user selection (login etc.) and make it so when transaction is added it is picked automatically as a logged user

  final TextEditingController numberTextController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final FocusNode numberTextFocusNode = FocusNode();

  void _saveTransaction(BuildContext context) {
    final categoryState = context.read<CategoryCubit>().state;
    final dateState = context.read<DateCubit>().state;
    final paymentTypeState = context.read<PaymentTypeCubit>().state;
    final transactionTypeState = context.read<TransactionTypeCubit>().state;
    final notesState = context.read<NotesCubit>().state;

    final amount = double.tryParse(numberTextController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount greater than 0',
              textAlign: TextAlign.center),
        ),
      );
      return;
    }
    if (categoryState is CategorySelected &&
        dateState is DateSelected &&
        paymentTypeState is PaymentTypeSelected &&
        transactionTypeState is TransactionTypeSelected) {
      final String transactionId = const Uuid().v4();
      final transactionData = TransactionData(
        id: transactionId,
        category: categoryState.category,
        amount: double.tryParse(numberTextController.text) ?? 0.0,
        date: dateState.date,
        paymentType: paymentTypeState.paymentType,
        transactionType: transactionTypeState.transactionType,
        user: user,
        note: notesState.note.isNotEmpty ? notesState.note : null,
      );

      context.read<TransactionDataCubit>().addTransaction(transactionData);

      // Reset the state
      context.read<CategoryCubit>().clearCategory();
      context.read<DateCubit>().clearDate();
      context.read<PaymentTypeCubit>().clearPaymentType();
      context.read<TransactionTypeCubit>().clearTransactionType();
      numberTextController.clear();
      context.read<NotesCubit>().updateNote('');

      // Pop the screen
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill all the details', textAlign: TextAlign.center),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (numberTextController.text.isEmpty) {
      numberTextFocusNode.unfocus();
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenScaffold(
        appBarTitle: 'Add Transaction',
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
                const TransactionSelection(),
                NumericalTextField(
                  controller: numberTextController,
                ),
                const Divider(
                  color: kColorGrey1,
                  thickness: 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconTextAndRow(
                        selectionText: 'Selected',
                        iconData: Icons.person_outlined,
                        iconColor: kColorGrey1,
                        inputText: user),
                    BlocBuilder<DateCubit, DateState>(
                      builder: (context, state) {
                        if (state is DateSelected) {
                          return IconTextAndRow(
                            selectionText: 'Selected',
                            onTap: () {
                              context.read<DateCubit>().showCalendar(context);
                            },
                            iconData: Icons.calendar_month_outlined,
                            iconColor: kColorGrey1,
                            inputText:
                                "${state.date.day}/${state.date.month}/${state.date.year}",
                          );
                        } else {
                          return IconTextAndRow(
                            selectionText: 'Not Selected',
                            onTap: () {
                              context.read<DateCubit>().showCalendar(context);
                            },
                            iconData: Icons.calendar_month_outlined,
                            iconColor: kColorGrey1,
                            inputText: 'Date',
                          );
                        }
                      },
                    ),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        return IconTextAndRow(
                            selectionText: state is CategorySelected
                                ? 'Selected'
                                : 'Not Selected',
                            onTap: () {
                              context
                                  .read<CategoryCubit>()
                                  .showOptions(context);
                            },
                            iconData: state is CategorySelected
                                ? state.category['iconData']
                                : Icons.folder_copy_outlined,
                            iconColor: kColorGrey1,
                            inputText: state is CategorySelected
                                ? state.category['inputText']
                                : 'Category');
                      },
                    ),
                    BlocBuilder<PaymentTypeCubit, PaymentTypeState>(
                      builder: (context, state) {
                        return IconTextAndRow(
                            selectionText: state is PaymentTypeSelected
                                ? 'Selected'
                                : 'Not Selected',
                            onTap: () {
                              context
                                  .read<PaymentTypeCubit>()
                                  .showOptions(context);
                            },
                            iconData: state is PaymentTypeSelected
                                ? state.paymentType['iconData']
                                : Icons.credit_card_outlined,
                            iconColor: kColorGrey1,
                            inputText: state is PaymentTypeSelected
                                ? state.paymentType['inputText']
                                : 'Card');
                      },
                    ),
                    const IconTextAndRow(
                        iconData: Icons.photo_camera_outlined,
                        iconColor: kColorGrey1,
                        inputText: 'Photo'),

                    ///TODO make it so taking photos is possible
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
                              iconColor: kColorGrey1,
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
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButtonModel(
            onPressed: () {
              _saveTransaction(context);
            },
            backgroundColor: kColorBlue,
            overlayColor: kColorLightBlue,
            buttonText: 'Save',
            buttonTextColor: kColorWhite,
          ),
        ),
      ),
    );
  }
}

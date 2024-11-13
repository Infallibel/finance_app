import 'package:finance_app/widgets/transactions_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/transaction_data.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/date_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/note_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/payment_type_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/transaction_type_cubit.dart';
import '../utilities/constants.dart';
import '../widgets/icon_text_row.dart';
import '../widgets/numerical_text_field.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/text_button_model.dart';

class EditTransactionPage extends StatelessWidget {
  final TransactionData transactionData;

  const EditTransactionPage({super.key, required this.transactionData});

  void _clearCubits(BuildContext context) {
    context.read<CategoryCubit>().clearCategory();
    context.read<DateCubit>().clearDate();
    context.read<PaymentTypeCubit>().clearPaymentType();
    context.read<TransactionTypeCubit>().clearTransactionType();
    context.read<NotesCubit>().updateNote('');
  }

  @override
  Widget build(BuildContext context) {
    context.read<CategoryCubit>().selectCategory(transactionData.category);
    context.read<DateCubit>().selectDate(transactionData.date);
    context
        .read<PaymentTypeCubit>()
        .selectPaymentType(transactionData.paymentType);
    context
        .read<TransactionTypeCubit>()
        .selectTransactionType(transactionData.transactionType);
    context.read<NotesCubit>().updateNote(transactionData.note ?? '');

    final TextEditingController amountController =
        TextEditingController(text: transactionData.amount.toString());
    final TextEditingController noteController =
        TextEditingController(text: transactionData.note ?? '');

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
          appBarTitle: 'Edit Transaction',
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
                  TransactionSelection(),

                  NumericalTextField(
                    controller: amountController,
                  ),
                  const Divider(
                    color: kColorGrey1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<DateCubit, DateState>(
                    builder: (context, state) {
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
                            : 'Date',
                      );
                    },
                  ),

                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return IconTextAndRow(
                        selectionText: state is CategorySelected
                            ? 'Selected'
                            : 'Not Selected',
                        onTap: () {
                          context.read<CategoryCubit>().showOptions(context);
                        },
                        iconData: state is CategorySelected
                            ? state.category['iconData']
                            : Icons.folder_copy_outlined,
                        iconColor: kColorGrey1,
                        inputText: state is CategorySelected
                            ? state.category['inputText']
                            : 'Category',
                      );
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

                  ///TODO make it so taking photos, or deleting them is possible
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
                    final updatedTransaction = transactionData.copyWith(
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      category: context.read<CategoryCubit>().state
                              is CategorySelected
                          ? (context.read<CategoryCubit>().state
                                  as CategorySelected)
                              .category
                          : transactionData.category,
                      paymentType: context.read<PaymentTypeCubit>().state
                              is PaymentTypeSelected
                          ? (context.read<PaymentTypeCubit>().state
                                  as PaymentTypeSelected)
                              .paymentType
                          : transactionData.paymentType,
                      transactionType: context
                              .read<TransactionTypeCubit>()
                              .state is TransactionTypeSelected
                          ? (context.read<TransactionTypeCubit>().state
                                  as TransactionTypeSelected)
                              .transactionType
                          : transactionData.transactionType,
                      date: context.read<DateCubit>().state is DateSelected
                          ? (context.read<DateCubit>().state as DateSelected)
                              .date
                          : transactionData.date,
                      note: noteController.text,
                    );

                    context
                        .read<TransactionDataCubit>()
                        .updateTransaction(updatedTransaction);

                    context.read<CategoryCubit>().clearCategory();
                    context.read<DateCubit>().clearDate();
                    context.read<PaymentTypeCubit>().clearPaymentType();
                    context.read<TransactionTypeCubit>().clearTransactionType();
                    context.read<NotesCubit>().updateNote('');

                    Navigator.pop(context);
                  },
                  backgroundColor: kColorBlue,
                  overlayColor: kColorLightBlue,
                  buttonText: 'Save Changes',
                  buttonTextColor: kColorWhite,
                  bottomPadding: 8,
                ),
                TextButtonModel(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            'Are you sure you want to delete this transaction?',
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
                            // Delete button
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
                                context
                                    .read<TransactionDataCubit>()
                                    .deleteTransaction(
                                        transactionId: transactionData.id,
                                        transactionAmount:
                                            transactionData.amount);

                                context.read<CategoryCubit>().clearCategory();
                                context.read<DateCubit>().clearDate();
                                context
                                    .read<PaymentTypeCubit>()
                                    .clearPaymentType();
                                context
                                    .read<TransactionTypeCubit>()
                                    .clearTransactionType();
                                context.read<NotesCubit>().updateNote('');

                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Yes',
                                style:
                                    kFontStyleLato.copyWith(color: kColorWhite),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: kColorWarning,
                  overlayColor: kColorLightWarning,
                  buttonText: 'Delete Transaction',
                  buttonTextColor: kColorWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

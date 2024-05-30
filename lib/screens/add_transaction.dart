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
import '../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';

class AddTransaction extends StatelessWidget {
  AddTransaction({super.key});

  final String user = 'Anna';

  /// TODO handle user selection (login etc.) and make it so when transaction is added it is picked automatically as a logged user

  final TextEditingController numberTextController = TextEditingController();
  final FocusNode numberTextFocusNode = FocusNode();

  void _saveTransaction(BuildContext context) {
    final categoryState = context.read<CategoryCubit>().state;
    final dateState = context.read<DateCubit>().state;
    final paymentTypeState = context.read<PaymentTypeCubit>().state;
    final transactionTypeState = context.read<TransactionTypeCubit>().state;

    if (categoryState is CategorySelected &&
        dateState is DateSelected &&
        paymentTypeState is PaymentTypeSelected &&
        transactionTypeState is TransactionTypeSelected) {
      final transactionData = TransactionData(
        category: categoryState.category,
        amount: double.tryParse(numberTextController.text) ?? 0.0,
        date: dateState.date,
        paymentType: paymentTypeState.paymentType,
        transactionType: transactionTypeState.transactionType,
        user: user,
      );

      context.read<TransactionDataCubit>().addTransaction(transactionData);

      // Reset the state
      context.read<CategoryCubit>().clearCategory();
      context.read<DateCubit>().clearDate();
      context.read<PaymentTypeCubit>().clearPaymentType();
      context.read<TransactionTypeCubit>().clearTransactionType();
      numberTextController.clear();

      // Pop the screen
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Please fill all the details',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  bool _hasValue() {
    return numberTextController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasValue()) {
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
                    const IconTextAndRow(
                        iconData: Icons.note_outlined,
                        iconColor: kColorGrey1,
                        inputText: 'Note'),

                    ///TODO make it so taking notes is possible
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
              buttonTextColor: kColorWhite),
        ),
      ),
    );
  }
}

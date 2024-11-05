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
import '../widgets/screen_scaffold.dart';

class EditTransactionPage extends StatelessWidget {
  final TransactionData transactionData;

  const EditTransactionPage({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    // Load initial data into Cubits
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

    return GestureDetector(
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
                // Amount field
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(height: 16),

                // Category dropdown
                // BlocBuilder<CategoryCubit, CategoryState>(
                //   builder: (context, state) {
                //     return DropdownButton<String>(
                //       value: state is CategorySelected
                //           ? state.category['inputText']
                //           : null,
                //       items: <String>['Category1', 'Category2', 'Category3']
                //           .map((category) => DropdownMenuItem(
                //                 value: category,
                //                 child: Text(category),
                //               ))
                //           .toList(),
                //       onChanged: (value) {
                //         context
                //             .read<CategoryCubit>()
                //             .selectCategory({'inputText': value});
                //       },
                //     );
                //   },
                // ),
                const SizedBox(height: 16),

                // Payment type dropdown
                // BlocBuilder<PaymentTypeCubit, PaymentTypeState>(
                //   builder: (context, state) {
                //     return DropdownButton<String>(
                //       value: state is PaymentTypeSelected
                //           ? state.paymentType['inputText']
                //           : null,
                //       items: <String>['Card', 'Cash']
                //           .map((type) => DropdownMenuItem(
                //                 value: type,
                //                 child: Text(type),
                //               ))
                //           .toList(),
                //       onChanged: (value) {
                //         context
                //             .read<PaymentTypeCubit>()
                //             .selectPaymentType({'inputText': value});
                //       },
                //     );
                //   },
                // ),
                const SizedBox(height: 16),

                // Transaction type dropdown
                // BlocBuilder<TransactionTypeCubit, TransactionTypeState>(
                //   builder: (context, state) {
                //     return DropdownButton<String>(
                //       value: state is TransactionTypeSelected
                //           ? state.transactionType
                //           : null,
                //       items: <String>['Expense', 'Income']
                //           .map((type) => DropdownMenuItem(
                //                 value: type,
                //                 child: Text(type),
                //               ))
                //           .toList(),
                //       onChanged: (value) {
                //         context
                //             .read<TransactionTypeCubit>()
                //             .selectTransactionType(value!);
                //       },
                //     );
                //   },
                // ),
                const SizedBox(height: 16),

                // Date selector
                BlocBuilder<DateCubit, DateState>(
                  builder: (context, state) {
                    final selectedDate =
                        state is DateSelected ? state.date : DateTime.now();
                    return GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && context.mounted) {
                          context.read<DateCubit>().selectDate(pickedDate);
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Note field
                BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, notesState) {
                    noteController.text = notesState.note;
                    return TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Note'),
                      onChanged: (value) {
                        context.read<NotesCubit>().updateNote(value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Save button
                ElevatedButton(
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
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

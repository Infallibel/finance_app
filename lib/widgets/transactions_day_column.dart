import 'package:finance_app/screens/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/transaction_data.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import 'icon_text_row.dart';
import 'package:finance_app/utilities/constants.dart';

class TransactionDayColumn extends StatelessWidget {
  const TransactionDayColumn({
    super.key,
    required this.day,
    required this.transactions,
  });

  final String day;
  final List<TransactionData> transactions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        print('Current State: $state');

        final updatedTransactions = transactions.map((transaction) {
          print('Transaction before update: ${transaction.category}');

          if (state is CategoryUpdated) {
            if (transaction.category['id'] == state.category['id']) {
              print(
                  'Updating category for transaction: ${transaction.category['id']}');
              return transaction.copyWith(category: state.category);
            }
          } else if (state is CategoryDeleted) {
            if (transaction.category['id'] == state.categoryId) {
              print('Resetting category for transaction: $transaction');
              // Match by ID
              return transaction.copyWith(category: null); // Reset category
            }
          }
          print('Transaction after update: ${transaction.category}');
          return transaction;
        }).toList();
        print('Updated transactions: $updatedTransactions');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                day,
                style: kFontStyleLato.copyWith(color: kColorGrey2),
              ),
            ),
            ...updatedTransactions.map((transaction) {
              return IconTextAndRow(
                iconData: transaction.category['iconData'],
                iconColor: transaction.category['iconColor'],
                inputText: transaction.category['inputText'],
                transactionType: transaction.transactionType,
                amount: transaction.transactionType == 'Expenses'
                    ? -transaction.amount
                    : transaction.amount,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTransactionPage(transactionData: transaction),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}

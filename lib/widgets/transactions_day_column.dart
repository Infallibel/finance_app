import 'package:flutter/material.dart';
import '../services/transaction_data.dart';
import 'icon_text_row.dart';
import 'package:finance_app/utilities/constants.dart';

class TransactionDayColumn extends StatelessWidget {
  const TransactionDayColumn(
      {super.key, required this.day, required this.transactions});

  final String day;
  final List<TransactionData> transactions;

  @override
  Widget build(BuildContext context) {
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
        ...transactions.map((transaction) {
          return IconTextAndRow(
            iconData: transaction.category['iconData'],
            iconColor: transaction.category['iconColor'],
            inputText: transaction.category['inputText'],
            transactionType: transaction.transactionType,
            amount: transaction.transactionType == 'Expenses'
                ? -transaction.amount
                : transaction.amount,
          );
        }),
      ],
    );
  }
}

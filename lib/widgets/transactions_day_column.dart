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
    final state = context.read<CategoryCubit>();
    final categories = state.categories;
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
          final category = categories.firstWhere(
            (cat) => cat['id'] == transaction.categoryId,
            orElse: () => <String, dynamic>{},
          );
          bool hasCategory = category.isNotEmpty;
          return IconTextAndRow(
            iconData: hasCategory ? category['iconData'] : Icons.error,
            iconColor: hasCategory ? category['iconColor'] : kColorGrey1,
            inputText: hasCategory ? category['inputText'] : 'Unknown',
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
  }
}

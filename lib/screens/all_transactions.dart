import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import 'package:finance_app/widgets/transactions_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../utilities/CubitsBlocs/addTransactioncubits/transaction_type_cubit.dart';
import '../utilities/constants.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/transactions_day_column.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionTypeCubit, TransactionTypeState>(
      builder: (context, transactionTypeState) {
        if (transactionTypeState is TransactionTypeSelected) {
          final transactionsByDay =
              context.read<TransactionDataCubit>().transactionsByDay;
          final transactionDays = transactionsByDay.keys.toList()
            ..sort((a, b) {
              final dateA = DateFormat('dd/MM/yyyy').parse(a);
              final dateB = DateFormat('dd/MM/yyyy').parse(b);
              return dateB.compareTo(dateA);
            });

          final selectedTransactionType = transactionTypeState.transactionType;

          return ScreenScaffold(
            appBarTitle: 'All Transactions',
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.clear_outlined,
                color: kColorGrey2,
              ),
            ),
            scaffoldBody: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  const TransactionSelection(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactionDays.length,
                      itemBuilder: (context, index) {
                        final day = transactionDays[index];
                        final transactions = transactionsByDay[day]!
                            .where((transaction) =>
                                transaction.transactionType ==
                                selectedTransactionType)
                            .toList();

                        if (transactions.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return TransactionDayColumn(
                          day: day,
                          transactions: transactions,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (transactionTypeState is TransactionTypeError) {
          return Center(child: Text(transactionTypeState.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

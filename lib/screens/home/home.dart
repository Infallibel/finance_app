import 'package:finance_app/utilities/CubitsBlocs/transaction_load_cubit.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/total_balance_home.dart';
import 'package:finance_app/widgets/transactions_day_column.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../services/transaction_data.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import 'all_transactions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionLoadCubit(pageSize: 20),
      child: ScreenScaffold(
        appBarTitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kColorBlue, width: 2)),
                    child: const Icon(
                      Icons.person_outlined,
                      color: kColorBlue,
                      size: 26,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Anna',
                      style: kFontStyleLato.copyWith(
                          color: kColorBlue, fontSize: 16),
                    ),
                  )
                ],
              ),
              const Icon(
                Icons.notification_add_outlined,

                ///albo Icons.notification_add_outlined w zaleznosci czy jest notification nowe
                color: kColorBlue,
                size: 26,
              )
            ],
          ),
        ),
        scaffoldBody: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Column(
              children: [
                const TotalBalance(),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: BlocBuilder<TransactionLoadCubit, int>(
                    builder: (context, transactionLimit) {
                      return BlocBuilder<TransactionDataCubit,
                          List<TransactionData>>(
                        builder: (context, transactions) {
                          final transactionsByDay = context
                              .read<TransactionDataCubit>()
                              .transactionsByDay;
                          final transactionDays = transactionsByDay.keys
                              .toList()
                            ..sort((a, b) {
                              final dateA = DateFormat('dd/MM/yyyy').parse(a);
                              final dateB = DateFormat('dd/MM/yyyy').parse(b);
                              return dateB.compareTo(dateA);
                            });

                          return NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent) {
                                context.read<TransactionLoadCubit>().loadMore();
                                return true;
                              }
                              return false;
                            },
                            child: ListView.builder(
                              itemCount:
                                  (transactionLimit < transactionDays.length)
                                      ? transactionLimit
                                      : transactionDays.length,
                              itemBuilder: (context, index) {
                                if (index >= transactionDays.length) {
                                  return null;
                                }
                                final day = transactionDays[index];
                                final transactions = transactionsByDay[day]!;

                                return TransactionDayColumn(
                                  day: day,
                                  transactions: transactions,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 98,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AllTransactionsPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'All Transactions',
                      style: kFontStyleLato.copyWith(
                          color: kColorBlue, fontSize: 16),
                    ),
                    const Icon(
                      Icons.chevron_right_outlined,
                      color: kColorBlue,
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/transactions_day_column.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/transaction_data.dart';
import '../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import '../utilities/CubitsBlocs/month_year_cubit.dart';
import '../widgets/pie_chart_analytics.dart';
import '../widgets/transactions_selection.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBarTitle: 'Analytics',
      scaffoldBody: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<MonthYearCubit, MonthYearState>(
                builder: (context, monthYearState) {
                  final transactionDataCubit =
                      context.watch<TransactionDataCubit>();
                  final transactionsByDay = transactionDataCubit.state
                      .where((transaction) =>
                          transaction.date.month == monthYearState.month &&
                          transaction.date.year == monthYearState.year)
                      .fold<Map<String, List<TransactionData>>>({},
                          (map, transaction) {
                    final day =
                        "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}";
                    if (!map.containsKey(day)) {
                      map[day] = [];
                    }
                    map[day]!.add(transaction);
                    return map;
                  });

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.chevron_left_outlined,
                                size: 30,
                              ),
                              onTap: () {
                                context.read<MonthYearCubit>().previousMonth();
                              },
                            ),
                            Text(
                              '${DateFormat.MMMM().format(DateTime(0, monthYearState.month))} ${monthYearState.year}',
                              style: kFontStyleLato.copyWith(fontSize: 20),
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.chevron_right_outlined,
                                size: 30,
                              ),
                              onTap: () {
                                context.read<MonthYearCubit>().nextMonth();
                              },
                            ),
                          ],
                        ),
                      ),
                      PieChartAnalytics(),
                      TransactionSelection(),

                      ///TODO add TransactionSelection Screen, but detach it from the other one used in AddTransaction screen
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Categories',
                                style: kFontStyleLato.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('- \$12500.00',
                                style: kFontStyleLato.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      ...transactionsByDay.entries.map((entry) {
                        return TransactionDayColumn(
                          day: entry.key,
                          transactions: entry.value,
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

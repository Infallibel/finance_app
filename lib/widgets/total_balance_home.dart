import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';

class TotalBalance extends StatefulWidget {
  const TotalBalance({super.key});

  @override
  State<TotalBalance> createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  bool isVisible = true;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = context.watch<TransactionDataCubit>().totalBalance;

    return Container(
      decoration: BoxDecoration(
        color: kColorLightBlueSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Balance',
              style: kFontStyleLato.copyWith(color: kColorGrey2, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CurrencyCubit, CurrencyState>(
                  builder: (context, state) {
                    String symbol = '\$';
                    bool symbolBefore = true;

                    if (state is CurrencySelected) {
                      symbol = state.currency.values.first;

                      symbolBefore = !['€', 'CHF', 'zł'].contains(symbol);
                    }

                    String formattedBalance = symbolBefore
                        ? '$symbol ${totalBalance.toStringAsFixed(2)}'
                        : '${totalBalance.toStringAsFixed(2)} $symbol';

                    return Text(
                      isVisible ? formattedBalance : '*********',
                      style: kFontStyleLato.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: toggleVisibility,
                  child: Icon(
                    isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: kColorGrey2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

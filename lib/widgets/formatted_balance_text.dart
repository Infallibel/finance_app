import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import '../utilities/constants.dart';

class FormattedBalanceText extends StatelessWidget {
  const FormattedBalanceText({
    super.key,
    required this.balance,
    this.textStyle,
  });

  final double balance;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        String symbol = '\$';
        bool symbolBefore = true;

        if (state is CurrencySelected) {
          symbol = state.currency.values.first;

          symbolBefore = !['€', 'CHF', 'zł'].contains(symbol);
        }

        String formattedBalance = symbolBefore
            ? '$symbol${balance.abs().toStringAsFixed(2)}'
            : '${balance.abs().toStringAsFixed(2)} $symbol';

        if (balance < 0) {
          formattedBalance = '- $formattedBalance';
        }

        return Text(
          formattedBalance,
          style: textStyle ??
              kFontStyleLato.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        );
      },
    );
  }
}

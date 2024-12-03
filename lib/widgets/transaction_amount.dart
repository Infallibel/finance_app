import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';

class TransactionAmount extends StatelessWidget {
  const TransactionAmount(
      {super.key, required this.amount, required this.transactionType});

  final double amount;
  final String transactionType;

  @override
  Widget build(BuildContext context) {
    String amountText = amount.toStringAsFixed(2);
    List<String> parts = amountText.split('.');
    String wholePart = parts[0];
    String fractionPart = parts[1];

    Color wholePartColor;
    Color fractionPartColor;

    switch (transactionType) {
      case 'Income':
        wholePartColor = kColorSuccess;
        fractionPartColor = kColorSuccess;
        break;
      case 'Expenses':
        wholePartColor = kColorBlack;
        fractionPartColor = kColorGrey2;
        break;
      case 'Transfer':
        wholePartColor = kColorBlue;
        fractionPartColor = kColorBlue;
        break;
      default:
        wholePartColor = kColorGrey2;
        fractionPartColor = kColorGrey2;
    }

    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        String symbol = '\$';
        bool symbolBefore = true;

        if (state is CurrencySelected) {
          symbol = state.currency.values.first;

          symbolBefore = !['€', 'CHF', 'zł'].contains(symbol);
        }
        return Row(
          children: [
            Text(symbolBefore ? symbol : '',
                style: kFontStyleLato.copyWith(
                  fontWeight: FontWeight.bold,
                  color: wholePartColor,
                )),
            Text(
              wholePart,
              style: kFontStyleLato.copyWith(
                fontWeight: FontWeight.bold,
                color: wholePartColor,
              ),
            ),
            Text(
              '.$fractionPart',
              style: kFontStyleLato.copyWith(
                fontWeight: FontWeight.bold,
                color: fractionPartColor,
              ),
            ),
            Text(symbolBefore ? '' : ' $symbol',
                style: kFontStyleLato.copyWith(
                  fontWeight: FontWeight.bold,
                  color: wholePartColor,
                )),
          ],
        );
      },
    );
  }
}

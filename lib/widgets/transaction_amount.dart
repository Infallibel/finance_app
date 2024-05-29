import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';

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

    return Row(
      children: [
        Text(
          '\$$wholePart',
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
        )
      ],
    );
  }
}

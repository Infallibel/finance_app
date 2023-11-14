import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';

class TransactionAmount extends StatelessWidget {
  const TransactionAmount({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    String amountText = amount.toStringAsFixed(2);
    List<String> parts = amountText.split('.');
    String wholePart = parts[0];
    String fractionPart = parts[1];

    return Row(
      children: [
        Text(
          '\$$wholePart',
          style: amount >= 0
              ? kFontStyleLato.copyWith(
                  fontWeight: FontWeight.bold, color: kColorSuccess)
              : kFontStyleLato.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '.$fractionPart',
          style: amount >= 0
              ? kFontStyleLato.copyWith(
                  fontWeight: FontWeight.bold, color: kColorSuccess)
              : kFontStyleLato.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kColorGrey2,
                ),
        )
      ],
    );
  }
}

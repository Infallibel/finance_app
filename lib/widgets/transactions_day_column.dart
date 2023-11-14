import 'package:flutter/material.dart';
import 'icon_text_row.dart';
import 'package:finance_app/utilities/constants.dart';

class TransactionDayColumn extends StatelessWidget {
  const TransactionDayColumn({super.key, required this.day});

  final String day;

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
        IconTextAndRow(
          iconData: Icons.coffee_outlined,
          iconColor: kColorBrown,
          inputText: 'Coffee',
          amount: -538.00,
        ),
        IconTextAndRow(
          iconData: Icons.shopping_cart_outlined,
          iconColor: kColorRed,
          inputText: 'Grocery',
          amount: -444.7,
        ),
        IconTextAndRow(
          iconData: Icons.money_outlined,
          iconColor: kColorGreen,
          inputText: 'Salary',
          amount: 26500,
        ),
        IconTextAndRow(
          iconData: Icons.local_taxi_outlined,
          iconColor: kColorYellow,
          inputText: 'Taxi',
          amount: -358.63,
        ),
        IconTextAndRow(
          iconData: Icons.health_and_safety_outlined,
          iconColor: kColorTurquoise,
          inputText: 'Health',
          amount: -25.12,
        ),
      ],
    );
  }
}

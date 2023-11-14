import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import '../widgets/pie_chart_analytics.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import '../widgets/transactions_selection.dart';

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
                      onTap: () {},
                    ),
                    Text(
                      'June',

                      ///maybe add month picker here
                      style: kFontStyleLato.copyWith(fontSize: 20),
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.chevron_right_outlined,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              PieChartAnalytics(),
              TransactionSelection(),
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
          ),
        ),
      ),
    );
  }
}

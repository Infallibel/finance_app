import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_with_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingsGoalRow extends StatelessWidget {
  const SavingsGoalRow(
      {super.key,
      required this.goalName,
      required this.goalAmount,
      required this.goalAccumulated,
      required this.iconData,
      this.onTap});

  final String goalName;
  final double goalAmount;
  final double goalAccumulated;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            IconWithBorder(
              iconData: iconData,
              iconColor: kColorLightBlue,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                width: 250,
                child: BlocBuilder<CurrencyCubit, CurrencyState>(
                  builder: (context, state) {
                    String symbol = '\$';
                    bool symbolBefore = true;

                    if (state is CurrencySelected) {
                      symbol = state.currency.values.first;

                      symbolBefore = !['€', 'CHF', 'zł'].contains(symbol);
                    }

                    String formattedBalanceAmount = symbolBefore
                        ? '$symbol$goalAmount'
                        : '$goalAmount $symbol';

                    String formattedBalanceAccumulated = symbolBefore
                        ? '$symbol$goalAccumulated'
                        : '$goalAccumulated $symbol';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goalName,

                              ///add max length of signs
                              style: kFontStyleLato.copyWith(fontSize: 16),
                            ),
                            Text(
                              formattedBalanceAmount,
                              style: kFontStyleLato.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(2),
                          minHeight: 4,
                          value: goalAccumulated / goalAmount,
                          color: kColorBlue,
                          backgroundColor: kColorGrey1,
                        ),
                        Text(
                          formattedBalanceAccumulated,
                          style: kFontStyleLato.copyWith(
                              color: kColorGrey1, fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

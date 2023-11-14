import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_with_border.dart';

class SavingsGoalRow extends StatelessWidget {
  const SavingsGoalRow(
      {super.key,
      required this.goalName,
      required this.goalAmount,
      required this.goalAccumulated,
      required this.iconData});

  final String goalName;
  final int goalAmount;
  final int goalAccumulated;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              child: Column(
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
                        '\$$goalAmount',
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
                    '\$$goalAccumulated',
                    style: kFontStyleLato.copyWith(
                        color: kColorGrey1, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

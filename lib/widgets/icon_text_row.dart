import 'package:flutter/material.dart';
import 'icon_text_combined.dart';
import 'transaction_amount.dart';
import 'package:finance_app/utilities/constants.dart';

class IconTextAndRow extends StatelessWidget {
  const IconTextAndRow(
      {super.key,
      required this.iconData,
      required this.iconColor,
      required this.inputText,
      this.amount,
      this.onTap,
      this.selectionText});

  final IconData iconData;
  final Color iconColor;
  final String inputText;
  final double? amount;
  final VoidCallback? onTap;
  final String? selectionText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconTextCombined(
                iconData: iconData, iconColor: iconColor, inputText: inputText),
            amount != null
                ? TransactionAmount(
                    amount: amount!,
                  )
                : selectionText != null
                    ? Row(
                        children: [
                          Text(
                            selectionText!,
                            style: kFontStyleLato.copyWith(color: kColorGrey1),
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                            size: 30,
                            color: kColorGrey1,
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.chevron_right_outlined,
                        size: 30,
                        color: kColorGrey1,
                      ),
          ],
        ),
      ),
    );
  }
}

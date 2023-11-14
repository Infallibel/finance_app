import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class TransactionSelection extends StatefulWidget {
  const TransactionSelection({
    super.key,
  });

  @override
  State<TransactionSelection> createState() => _TransactionSelectionState();
}

class _TransactionSelectionState extends State<TransactionSelection> {
  int indexTransaction = 0;

  List transactions = ['Expenses', 'Income', 'Transfer'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kColorLightBlueSecondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          transactionSelectionComponents(
            indexTransaction: 0,
            transactionBackgroundColor:
                indexTransaction == 0 ? kColorBlue : kColorLightBlueSecondary,
            transactionTextColor:
                indexTransaction == 0 ? kColorWhite : kColorGrey2,
          ),
          indexTransaction == 2
              ? const Text(
                  '|',
                  style: TextStyle(color: kColorGrey2),
                )
              : const SizedBox(
                  width: 3,
                ),
          transactionSelectionComponents(
            indexTransaction: 1,
            transactionBackgroundColor:
                indexTransaction == 1 ? kColorBlue : kColorLightBlueSecondary,
            transactionTextColor:
                indexTransaction == 1 ? kColorWhite : kColorGrey2,
          ),
          indexTransaction == 0
              ? const Text(
                  '|',
                  style: TextStyle(color: kColorGrey2),
                )
              : const SizedBox(
                  width: 3,
                ),
          transactionSelectionComponents(
            indexTransaction: 2,
            transactionBackgroundColor:
                indexTransaction == 2 ? kColorBlue : kColorLightBlueSecondary,
            transactionTextColor:
                indexTransaction == 2 ? kColorWhite : kColorGrey2,
          ),
        ],
      ),
    );
  }

  Expanded transactionSelectionComponents(
      {required int indexTransaction,
      required Color transactionBackgroundColor,
      required Color transactionTextColor}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            this.indexTransaction = indexTransaction;
          });
        },
        child: Container(
          height: 32,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: transactionBackgroundColor),
          child: Center(
            child: Text(
              transactions[indexTransaction],
              style: kFontStyleLato.copyWith(color: transactionTextColor),
            ),
          ),
        ),
      ),
    );
  }
}

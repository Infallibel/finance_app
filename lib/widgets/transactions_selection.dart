import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/transaction_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/constants.dart';

class TransactionSelection extends StatelessWidget {
  const TransactionSelection({super.key});

  final List<String> transactionTypes = const [
    'Expenses',
    'Income',
    'Transfer'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kColorLightBlueSecondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < transactionTypes.length; i++) ...[
            _TransactionSelectionComponent(
                index: i, transactionTypes: transactionTypes),
          ]
        ],
      ),
    );
  }
}

class _TransactionSelectionComponent extends StatelessWidget {
  final int index;
  final List<String> transactionTypes;

  const _TransactionSelectionComponent({
    required this.index,
    required this.transactionTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context
              .read<TransactionTypeCubit>()
              .selectTransactionType(transactionTypes[index]);
        },
        child: BlocBuilder<TransactionTypeCubit, TransactionTypeState>(
          builder: (context, state) {
            bool isSelected = false;
            if (state is TransactionTypeSelected) {
              isSelected = state.transactionType == transactionTypes[index];
            }
            return Container(
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? kColorBlue : kColorLightBlueSecondary,
              ),
              child: Center(
                child: Text(
                  transactionTypes[index],
                  style: kFontStyleLato.copyWith(
                    color: isSelected ? kColorWhite : kColorGrey2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

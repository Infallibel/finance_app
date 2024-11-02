import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';

class NumericalTextField extends StatelessWidget {
  const NumericalTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          String hintSymbol = '\$'; // Default symbol

          if (state is CurrencySelected) {
            hintSymbol = state.currency.values.first;
          }

          return TextField(
            controller: controller,
            cursorColor: kColorGrey2,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            style: kFontStyleLato.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(\d{0,10})?\.?\d{0,2}'))
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintSymbol,
              hintStyle: kFontStyleLato.copyWith(
                color: kColorGrey2,
              ),
            ),
          );
        },
      ),
    );
  }
}

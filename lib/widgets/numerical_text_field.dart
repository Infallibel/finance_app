import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/services.dart';

class NumericalTextField extends StatelessWidget {
  NumericalTextField({
    super.key,
  });
  final numberTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: numberTextController,
        cursorColor: kColorGrey2,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        style:
            kFontStyleLato.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^(\d{0,10})?\.?\d{0,2}'))
        ],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '\$',
            hintStyle: kFontStyleLato.copyWith(
              color: kColorGrey2,
            )),
      ),
    );
  }
}

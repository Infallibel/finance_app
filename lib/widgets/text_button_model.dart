import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class TextButtonModel extends StatelessWidget {
  const TextButtonModel(
      {super.key,
      required this.backgroundColor,
      required this.overlayColor,
      required this.buttonText,
      required this.buttonTextColor,
      required this.onPressed});

  final Color backgroundColor;
  final Color overlayColor;
  final Color buttonTextColor;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => backgroundColor,
          ),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => overlayColor,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: kFontStyleLato.copyWith(color: buttonTextColor, fontSize: 20),
        ),
      ),
    );
  }
}

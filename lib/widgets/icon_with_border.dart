import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';

class IconWithBorder extends StatelessWidget {
  const IconWithBorder(
      {super.key, required this.iconData, required this.iconColor});

  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          iconData,
          size: 28,
          color: kColorWhite,
        ),
      ),
    );
  }
}

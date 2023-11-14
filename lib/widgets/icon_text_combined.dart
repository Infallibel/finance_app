import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import 'icon_with_border.dart';

class IconTextCombined extends StatelessWidget {
  const IconTextCombined(
      {super.key,
      required this.iconData,
      required this.iconColor,
      required this.inputText,
      this.onTap});

  final IconData iconData;
  final Color iconColor;
  final String inputText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          IconWithBorder(iconData: iconData, iconColor: iconColor),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              inputText,
              style: kFontStyleLato.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

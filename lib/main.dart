import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: kColorLightBlue,
            cursorColor: kColorLightBlue,
            selectionHandleColor: kColorLightBlue),
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      home: const BottomBar(),
    );
  }
}

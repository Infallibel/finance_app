import 'package:finance_app/screens/add_transaction.dart';
import 'package:finance_app/screens/analytics/analytics.dart';
import 'package:finance_app/screens/home/home.dart';
import 'package:finance_app/screens/savings/savings.dart';
import 'package:finance_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/utilities/constants.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int indexPage = 0;
  List screens = [
    const HomePage(),
    const SavingsPage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[indexPage],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffffa05c),
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddTransactionPage()));
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color:
              kColorWhite, //ColorScheme == ColorScheme.light() ? Colors.white : Colors.black, coś z tym może?
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: kColorGrey1, width: 1))),
        child: BottomAppBar(
          height: 54,
          color: kColorWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bottomBarComponents(
                  componentName: 'Home',
                  iconData: indexPage == 0
                      ? Icons.grid_view_sharp
                      : Icons.grid_view_outlined,
                  indexPage: 0,
                  componentColor: indexPage == 0 ? kColorBlue : kColorGrey1),
              bottomBarComponents(
                  componentName: 'Savings',
                  iconData:
                      indexPage == 1 ? Icons.savings : Icons.savings_outlined,
                  indexPage: 1,
                  componentColor: indexPage == 1 ? kColorBlue : kColorGrey1),
              const SizedBox(),
              const SizedBox(),
              bottomBarComponents(
                  componentName: 'Analytics',
                  iconData: indexPage == 2
                      ? Icons.equalizer
                      : Icons.equalizer_outlined,
                  indexPage: 2,
                  componentColor: indexPage == 2 ? kColorBlue : kColorGrey1),
              bottomBarComponents(
                  componentName: 'Settings',
                  iconData:
                      indexPage == 3 ? Icons.settings : Icons.settings_outlined,
                  indexPage: 3,
                  componentColor: indexPage == 3 ? kColorBlue : kColorGrey1),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector bottomBarComponents(
      {required String componentName,
      required IconData iconData,
      required int indexPage,
      required Color componentColor}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.indexPage = indexPage;
        });
      },
      child: SizedBox(
        width: 45,
        child: Column(
          children: [
            Icon(
              iconData,
              color: componentColor,
              size: 28,
            ),
            Text(
              componentName,
              style: TextStyle(color: componentColor, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

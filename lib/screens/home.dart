import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/total_balance_home.dart';
import 'package:finance_app/widgets/transactions_day_column.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBarTitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kColorBlue, width: 2)),
                  child: const Icon(
                    Icons.person_outlined,
                    color: kColorBlue,
                    size: 26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Anna',
                    style: kFontStyleLato.copyWith(
                        color: kColorBlue, fontSize: 16),
                  ),
                )
              ],
            ),
            Icon(
              Icons.notification_add_outlined,

              ///albo Icons.notification_add_outlined w zaleznosci czy jest notification nowe
              color: kColorBlue,
              size: 26,
            )
          ],
        ),
      ),
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(children: [
          Column(
            children: [
              TotalBalance(),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Change this to the actual number of items
                  itemBuilder: (context, index) {
                    return TransactionDayColumn(
                      day: index == 0
                          ? 'Today'
                          : index == 1
                              ? '04 June 2023'
                              : '02 June 2023',
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 98,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                color: kColorWhite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'All Transactions',
                      style: kFontStyleLato.copyWith(
                          color: kColorBlue, fontSize: 16),
                    ),
                    const Icon(
                      Icons.chevron_right_outlined,
                      color: kColorBlue,
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

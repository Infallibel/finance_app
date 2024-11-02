import 'package:finance_app/utilities/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../currencies.dart';

// Define currency states
abstract class CurrencyState {}

class InitialCurrencyState extends CurrencyState {}

class CurrencySelected extends CurrencyState {
  final Map<String, String> currency;
  CurrencySelected(this.currency);
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}

// Define the CurrencyCubit
class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(InitialCurrencyState());

  Future<void> showCurrencyOptions(BuildContext context) async {
    final selectedCurrency = await showModalBottomSheet<Map<String, String>>(
      elevation: 0,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.5, // Adjust height ratio as needed
            children: currencies.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop({entry.key: entry.value});
                },
                child: Card(
                  elevation: 0,
                  color: kColorGrey1, // Optional background color
                  margin: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      '${entry.key} (${entry.value})',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedCurrency != null) {
      emit(CurrencySelected(selectedCurrency));
    }
  }

  void selectCurrency(Map<String, String> currency) {
    try {
      emit(CurrencySelected(currency));
    } catch (e) {
      emit(CurrencyError('Error selecting currency: $e'));
    }
  }

  void clearCurrency() {
    emit(InitialCurrencyState());
  }
}

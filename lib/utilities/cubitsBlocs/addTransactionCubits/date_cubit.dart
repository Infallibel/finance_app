import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DateState {}

class DateSelected extends DateState {
  final DateTime date;
  DateSelected(this.date);
}

class DateError extends DateState {
  final String message;
  DateError(this.message);
}

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateSelected(DateTime.now()));

  Future<void> showCalendar(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kColorBlue,
              onPrimary: kColorBlack,
              onSurface: kColorGrey3,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kColorBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      selectDate(picked);
    }
  }

  void selectDate(DateTime date) {
    try {
      emit(DateSelected(date));
    } catch (e) {
      emit(DateError('Error selecting date: $e'));
    }
  }

  void clearDate() {
    emit(DateSelected(DateTime.now()));
  }
}

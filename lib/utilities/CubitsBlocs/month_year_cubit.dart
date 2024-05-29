import 'package:flutter_bloc/flutter_bloc.dart';

class MonthYearState {
  final int month;
  final int year;

  MonthYearState({required this.month, required this.year});
}

class MonthYearCubit extends Cubit<MonthYearState> {
  MonthYearCubit()
      : super(MonthYearState(
            month: DateTime.now().month, year: DateTime.now().year));

  void previousMonth() {
    final currentMonth = state.month;
    final currentYear = state.year;
    if (currentMonth == 1) {
      emit(MonthYearState(month: 12, year: currentYear - 1));
    } else {
      emit(MonthYearState(month: currentMonth - 1, year: currentYear));
    }
  }

  void nextMonth() {
    final currentMonth = state.month;
    final currentYear = state.year;
    if (currentMonth == 12) {
      emit(MonthYearState(month: 1, year: currentYear + 1));
    } else {
      emit(MonthYearState(month: currentMonth + 1, year: currentYear));
    }
  }
}

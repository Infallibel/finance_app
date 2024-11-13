import 'package:finance_app/utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../addTransactioncubits/transaction_data_cubit.dart';

class GoalDataCubit extends Cubit<List<SavingsGoalData>> {
  GoalDataCubit() : super([]) {
    _calculateInitialAccumulatedAmount();
  }

  double _accumulatedAmount = 0.0;

  void _calculateInitialAccumulatedAmount() {
    _accumulatedAmount = state.fold<double>(0.0, (current, goal) {
      return current + goal.accumulatedAmount;
    });
  }

  double get totalAccumulatedAmount => _accumulatedAmount;

  void addGoal(SavingsGoalData goal) {
    state.add(goal);

    _accumulatedAmount += goal.accumulatedAmount;
    emit(List.from(state));
  }

  void updateGoal(SavingsGoalData updatedGoal) {
    final index = state.indexWhere((goal) => goal.id == updatedGoal.id);
    if (index != -1) {
      final updatedGoals = List<SavingsGoalData>.from(state);
      final oldGoal = updatedGoals[index];

      _accumulatedAmount -= oldGoal.accumulatedAmount;
      _accumulatedAmount += updatedGoal.accumulatedAmount;

      updatedGoals[index] = updatedGoal;
      emit(updatedGoals);
    }
  }

  void completeGoal(
      SavingsGoalData goal, TransactionDataCubit transactionCubit) {
    final double remainingAmount = goal.targetAmount - goal.accumulatedAmount;

    if (remainingAmount > 0) {
      transactionCubit.deductFromBalance(remainingAmount);
    }

    state.removeWhere((g) => g.id == goal.id);
    _accumulatedAmount -= goal.accumulatedAmount;

    emit(List.from(state));
  }

  void deleteGoal(SavingsGoalData goal, TransactionDataCubit transactionCubit) {
    final double returnedAmount = -goal.accumulatedAmount;

    transactionCubit.deductFromBalance(returnedAmount);

    state.removeWhere((g) => g.id == goal.id);
    _accumulatedAmount -= goal.accumulatedAmount;

    emit(List.from(state));
  }

  Map<String, List<SavingsGoalData>> get goalsByDay {
    var groupedGoals = <String, List<SavingsGoalData>>{};
    for (var goal in state) {
      String day =
          "${goal.targetDate.day}/${goal.targetDate.month}/${goal.targetDate.year}";
      if (groupedGoals.containsKey(day)) {
        groupedGoals[day]!.add(goal);
      } else {
        groupedGoals[day] = [goal];
      }
    }
    return groupedGoals;
  }

  List<SavingsGoalData> paginatedGoals(int limit) {
    return state.take(limit).toList();
  }
}

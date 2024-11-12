import 'package:finance_app/utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalDataCubit extends Cubit<List<SavingsGoalData>> {
  GoalDataCubit() : super([]) {
    _calculateInitialAccumulatedAmount();
  }

  double _accumulatedAmount = 0.0;

  // Initialize accumulated amount based on initial goal data
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

      // Adjust accumulated amount based on the difference in goal's accumulated amount
      _accumulatedAmount -= oldGoal.accumulatedAmount;
      _accumulatedAmount += updatedGoal.accumulatedAmount;

      updatedGoals[index] = updatedGoal;
      emit(updatedGoals);
    }
  }

  // Group goals by target date or other criteria if needed
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

  // Paginate goals based on a limit
  List<SavingsGoalData> paginatedGoals(int limit) {
    return state.take(limit).toList();
  }
}

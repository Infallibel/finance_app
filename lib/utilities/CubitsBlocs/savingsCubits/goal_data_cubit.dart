import 'package:finance_app/utilities/CubitsBlocs/savingsCubits/savings_goal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class GoalDataState {}

class GoalDataInitial extends GoalDataState {}

class GoalDataLoaded extends GoalDataState {
  final List<SavingsGoalData> goals;

  GoalDataLoaded(this.goals);
}

class GoalDataCubit extends Cubit<GoalDataState> {
  GoalDataCubit() : super(GoalDataInitial());

  // List to store goals
  final List<SavingsGoalData> _goals = [];

  // Method to add a new goal
  void addGoal(SavingsGoalData goal) {
    _goals.add(goal);
    emit(GoalDataLoaded(
        List.from(_goals))); // Emit a new state with updated goals
  }

// Optional: Additional methods to retrieve goals or clear them
}

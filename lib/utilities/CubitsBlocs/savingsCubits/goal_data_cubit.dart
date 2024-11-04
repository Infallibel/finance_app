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

  final List<SavingsGoalData> _goals = [];

  void addGoal(SavingsGoalData goal) {
    _goals.add(goal);
    emit(GoalDataLoaded(List.from(_goals)));
  }
}

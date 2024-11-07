class SavingsGoalData {
  final String name;
  final double targetAmount;
  final double accumulatedAmount;
  final DateTime targetDate;
  final String user;
  final String? note;

  SavingsGoalData(
      {required this.name,
      required this.targetAmount,
      required this.accumulatedAmount,
      required this.targetDate,
      required this.user,
      this.note});
}

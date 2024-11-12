class SavingsGoalData {
  final String id;
  final String name;
  final double targetAmount;
  final double accumulatedAmount;
  final DateTime targetDate;
  final String user;
  final String? note;

  SavingsGoalData({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.accumulatedAmount,
    required this.targetDate,
    required this.user,
    this.note,
  });

  // Create a copy of SavingsGoalData with updated fields
  SavingsGoalData copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? accumulatedAmount,
    DateTime? targetDate,
    String? user,
    String? note,
  }) {
    return SavingsGoalData(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      accumulatedAmount: accumulatedAmount ?? this.accumulatedAmount,
      targetDate: targetDate ?? this.targetDate,
      user: user ?? this.user,
      note: note ?? this.note,
    );
  }
}

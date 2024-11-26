class TransactionData {
  final String id;
  final String transactionType;
  final double amount;
  final String user;
  final DateTime date;
  final String categoryId;
  final Map<String, dynamic> paymentType;

  ///tu nie będą tylko String, bo będzie to też to wyboru, np photo, czy notes
  final String? photo;
  final String? note;

  TransactionData({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.user,
    required this.date,
    required this.categoryId,
    required this.paymentType,
    this.photo,
    this.note,
  });
  // Create a copy of TransactionData with updated fields
  TransactionData copyWith({
    String? id,
    String? categoryId,
    double? amount,
    DateTime? date,
    Map<String, dynamic>? paymentType,
    String? transactionType,
    String? user,
    String? note,
    String? photo,
  }) {
    return TransactionData(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentType: paymentType ?? this.paymentType,
      transactionType: transactionType ?? this.transactionType,
      user: user ?? this.user,
      note: note ?? this.note,
      photo: photo ?? this.photo,
    );
  }
}

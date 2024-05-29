class TransactionData {
  final String transactionType;
  final double amount;
  final String user;
  final DateTime date;
  final Map<String, dynamic> category;
  final Map<String, dynamic> paymentType;

  ///tu nie będą tylko String, bo będzie to też to wyboru, np photo, czy notes
  final String? photo;
  final String? note;

  TransactionData({
    required this.transactionType,
    required this.amount,
    required this.user,
    required this.date,
    required this.category,
    required this.paymentType,
    this.photo,
    this.note,
  });
}

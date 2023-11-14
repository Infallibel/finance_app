class TransactionData {
  final String transactionType;
  final int amount;
  final String user;
  final String date;
  final String category;

  ///raczej tu nie będą tylko String, bo będzie to też to wyboru, np paymentType, czy category
  final String paymentType;
  final String photo;
  final String note;

  TransactionData({
    required this.transactionType,
    required this.amount,
    required this.user,
    required this.date,
    required this.category,
    required this.paymentType,
    required this.photo,
    required this.note,
  });
}

List<TransactionData> transactions = [];

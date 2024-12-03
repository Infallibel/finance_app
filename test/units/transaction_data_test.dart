import 'package:finance_app/services/transaction_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionData', () {
    late TransactionData transaction;

    setUp(() {
      transaction = TransactionData(
        id: '1',
        transactionType: 'Expense',
        amount: 100.0,
        user: 'JohnDoe',
        date: DateTime(2023, 12, 1),
        categoryId: 'food',
        paymentType: {'method': 'credit'},
      );
    });

    test('should create a valid TransactionData object', () {
      expect(transaction.id, '1');
      expect(transaction.transactionType, 'Expense');
      expect(transaction.amount, 100.0);
      expect(transaction.user, 'JohnDoe');
      expect(transaction.date, DateTime(2023, 12, 1));
      expect(transaction.categoryId, 'food');
      expect(transaction.paymentType, {'method': 'credit'});
      expect(transaction.photo, isNull);
      expect(transaction.note, isNull);
    });

    test('should return a copy of TransactionData with updated fields', () {
      final updatedTransaction = transaction.copyWith(
        amount: 150.0,
        note: 'Updated note',
      );

      expect(
          updatedTransaction.id, transaction.id); // id should remain the same
      expect(updatedTransaction.transactionType,
          transaction.transactionType); // same transactionType
      expect(updatedTransaction.amount, 150.0); // amount should be updated
      expect(updatedTransaction.note, 'Updated note'); // note should be updated
      expect(updatedTransaction.photo, isNull); // photo should remain null
      expect(updatedTransaction.categoryId,
          transaction.categoryId); // categoryId should remain the same
    });

    test('copyWith should return the same object when no fields are updated',
        () {
      final copy = transaction.copyWith();

      expect(copy.id, transaction.id);
      expect(copy.transactionType, transaction.transactionType);
      expect(copy.amount, transaction.amount);
      expect(copy.user, transaction.user);
      expect(copy.date, transaction.date);
      expect(copy.categoryId, transaction.categoryId);
      expect(copy.paymentType, transaction.paymentType);
      expect(copy.photo, transaction.photo);
      expect(copy.note, transaction.note);
    });

    test('copyWith should update only specified fields', () {
      final updatedTransaction = transaction.copyWith(
        amount: 200.0,
        user: 'JaneDoe',
      );

      expect(updatedTransaction.amount, 200.0);
      expect(updatedTransaction.user, 'JaneDoe');
      expect(updatedTransaction.id, transaction.id);
      expect(updatedTransaction.transactionType, transaction.transactionType);
      expect(updatedTransaction.categoryId, transaction.categoryId);
      expect(updatedTransaction.paymentType, transaction.paymentType);
    });
  });
}

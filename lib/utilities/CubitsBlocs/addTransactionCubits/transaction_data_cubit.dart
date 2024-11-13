import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/transaction_data.dart';

class TransactionDataCubit extends Cubit<List<TransactionData>> {
  TransactionDataCubit() : super([]) {
    _calculateInitialBalance();
  }

  double _balance = 0.0;

  void _calculateInitialBalance() {
    _balance = state.fold<double>(0.0, (currentBalance, transaction) {
      return transaction.transactionType == 'Income'
          ? currentBalance + transaction.amount
          : currentBalance - transaction.amount;
    });
  }

  double get totalBalance => _balance;

  void addTransaction(TransactionData transactionData) {
    state.add(transactionData);
    emit(List.from(state));

    if (transactionData.transactionType == 'Income') {
      _balance += transactionData.amount;
    } else if (transactionData.transactionType == 'Expenses') {
      _balance -= transactionData.amount;
    }
  }

  void deductFromBalance(double amount) {
    _balance -= amount;
    emit(List.from(state));
  }

  void updateTransaction(TransactionData updatedTransaction) {
    final index = state.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      final oldTransaction = state[index];

      if (oldTransaction.transactionType == 'Income') {
        _balance -= oldTransaction.amount;
      } else {
        _balance += oldTransaction.amount;
      }

      if (updatedTransaction.transactionType == 'Income') {
        _balance += updatedTransaction.amount;
      } else {
        _balance -= updatedTransaction.amount;
      }

      state[index] = updatedTransaction;
      emit(List.from(state));
    }
  }

  void deleteTransaction(String transactionId) {
    state.removeWhere((transaction) => transaction.id == transactionId);
    emit(List.from(state));
    _calculateInitialBalance();

    /// TODO this just removes balance and it is 0 when there are goals added, because initial balance is not taking goal cubits into consideration
  }

  Map<String, List<TransactionData>> get transactionsByDay {
    var transactionsGroupedByDay = <String, List<TransactionData>>{};

    for (var transactionData in state) {
      String day =
          "${transactionData.date.day}/${transactionData.date.month}/${transactionData.date.year}";
      if (transactionsGroupedByDay.containsKey(day)) {
        transactionsGroupedByDay[day]!.add(transactionData);
      } else {
        transactionsGroupedByDay[day] = [transactionData];
      }
    }
    return transactionsGroupedByDay;
  }

  double balanceForMonth(int month, int year) {
    double balance = 0.0;
    for (var transaction in state) {
      if (transaction.date.month == month && transaction.date.year == year) {
        if (transaction.transactionType == 'Income') {
          balance += transaction.amount;
        } else if (transaction.transactionType == 'Expenses') {
          balance -= transaction.amount;
        }
      }
    }
    return balance;
  }
}

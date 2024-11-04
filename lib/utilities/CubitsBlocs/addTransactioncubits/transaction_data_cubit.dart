import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/transaction_data.dart';

class TransactionDataCubit extends Cubit<List<TransactionData>> {
  TransactionDataCubit() : super([]) {
    _calculateInitialBalance(); // Initialize balance from existing transactions, if any
  }

  double _balance = 0.0;

  // Initializes _balance based on existing transactions
  void _calculateInitialBalance() {
    _balance = state.fold<double>(0.0, (currentBalance, transaction) {
      return transaction.transactionType == 'Income'
          ? currentBalance + transaction.amount
          : currentBalance - transaction.amount;
    });
  }

  // Getter for total balance, returns current balance
  double get totalBalance => _balance;

  // Method to add a new transaction
  void addTransaction(TransactionData transactionData) {
    state.add(transactionData); // Adds transaction to the state list
    emit(List.from(state)); // Emits updated state list for listeners

    // Update balance based on the type of transaction
    if (transactionData.transactionType == 'Income') {
      _balance += transactionData.amount;
    } else if (transactionData.transactionType == 'Expenses') {
      _balance -= transactionData.amount;
    }
  }

  // Method to deduct a specified amount directly from the balance
  void deductFromBalance(double amount) {
    _balance -= amount; // Deducts amount from _balance
    emit(List.from(state)); // Emits updated state to notify listeners
  }

  // Groups transactions by day for easier access and display
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

  // Calculates balance for a specific month and year
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

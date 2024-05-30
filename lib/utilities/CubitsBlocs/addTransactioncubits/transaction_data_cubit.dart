import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/transaction_data.dart';

class TransactionDataCubit extends Cubit<List<TransactionData>> {
  TransactionDataCubit() : super([]);

  void addTransaction(TransactionData transactionData) {
    state.add(transactionData);
    emit(List.from(state));
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

  double get totalBalance {
    double balance = 0.0;
    for (var transaction in state) {
      if (transaction.transactionType == 'Income') {
        balance += transaction.amount;
      } else if (transaction.transactionType == 'Expenses') {
        balance -= transaction.amount;
      }
    }
    return balance;
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

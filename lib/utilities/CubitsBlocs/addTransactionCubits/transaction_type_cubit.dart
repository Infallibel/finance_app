import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TransactionTypeState {}

class TransactionTypeSelected extends TransactionTypeState {
  final String transactionType;
  TransactionTypeSelected(this.transactionType);
}

class TransactionTypeError extends TransactionTypeState {
  final String message;
  TransactionTypeError(this.message);
}

class TransactionTypeCubit extends Cubit<TransactionTypeState> {
  TransactionTypeCubit() : super(TransactionTypeSelected('Expenses'));

  void selectTransactionType(String transactionType) {
    try {
      emit(TransactionTypeSelected(transactionType));
    } catch (e) {
      emit(TransactionTypeError('Error selecting transaction type: $e'));
    }
  }

  void clearTransactionType() {
    emit(TransactionTypeSelected('Expenses'));
  }
}

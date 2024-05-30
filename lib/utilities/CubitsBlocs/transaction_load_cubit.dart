import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionLoadCubit extends Cubit<int> {
  final int pageSize;
  TransactionLoadCubit({required this.pageSize}) : super(pageSize);

  void loadMore() {
    emit(state + pageSize);
  }
}

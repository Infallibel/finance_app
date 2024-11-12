import 'package:flutter_bloc/flutter_bloc.dart';

class GoalLoadCubit extends Cubit<int> {
  final int pageSize;

  GoalLoadCubit({required this.pageSize}) : super(pageSize);

  void loadMore() {
    emit(state + pageSize);
  }
}

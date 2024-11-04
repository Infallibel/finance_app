import 'package:flutter_bloc/flutter_bloc.dart';

class NotesState {
  final String note;
  final bool isVisible;

  NotesState({this.note = '', this.isVisible = false});
}

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesState());

  void toggleVisibility() {
    emit(NotesState(note: state.note, isVisible: !state.isVisible));
  }

  void updateNote(String note) {
    emit(NotesState(note: note, isVisible: state.isVisible));
  }
}

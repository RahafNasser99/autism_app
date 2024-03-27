part of 'notes_list_cubit.dart';

abstract class NotesListState {
  final List<Note> notes;
  const NotesListState(this.notes);
}

class NotesListInitial extends NotesListState {
  const NotesListInitial(super.notes);
}

class NotesListLoading extends NotesListState {
  const NotesListLoading(super.notes);
}

class NotesListDone extends NotesListState {
  const NotesListDone({required notes}) : super(notes);
}

class NotesListIsEmpty extends NotesListState {
   NotesListIsEmpty({required notes}) : super([]);
}

class NotesListFailed extends NotesListState {
  final String failedMessage;

  const NotesListFailed(super.notes, {required this.failedMessage});
}

class NotesListError extends NotesListState {
  final String errorMessage;

  const NotesListError(super.notes,{required this.errorMessage});
}

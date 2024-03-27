part of 'crud_note_cubit.dart';

abstract class CrudNoteState {
  const CrudNoteState();
}

class CrudNoteInitial extends CrudNoteState {}

class CrudNoteLoading extends CrudNoteState {}

class CrudNoteDone extends CrudNoteState {}

class CrudNoteFailed extends CrudNoteState {
  final String failedMessage;

  CrudNoteFailed({required this.failedMessage});
}

class CrudNoteError extends CrudNoteState {
  final String errorMessage;

  CrudNoteError({required this.errorMessage});
}

part of 'update_password_cubit.dart';

@immutable
abstract class UpdatePasswordState {}

class UpdatePasswordLoading extends UpdatePasswordState {}

class UpdatePasswordDone extends UpdatePasswordState {
  final String doneMessage;

  UpdatePasswordDone({required this.doneMessage});
}

class UpdatePasswordFailed extends UpdatePasswordState {
  final String failedMessage;

  UpdatePasswordFailed({required this.failedMessage});
}

class UpdatePasswordError extends UpdatePasswordState {
  final String errorMessage;

  UpdatePasswordError({required this.errorMessage});
}

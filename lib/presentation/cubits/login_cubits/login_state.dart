part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginDone extends LoginState {}

class LoginFailed extends LoginState {
  final String failedMessage;

  LoginFailed({required this.failedMessage});
}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError({required this.errorMessage});
}

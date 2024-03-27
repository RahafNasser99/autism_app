part of 'send_mail_cubit.dart';

abstract class SendMailState {
  const SendMailState();
}

class SendMailInitial extends SendMailState {}

class SendMailLoading extends SendMailState {}

class SendMailDone extends SendMailState {}

class SendMailFailed extends SendMailState {
  final String failedMessage;

  SendMailFailed({required this.failedMessage});
}

class SendMailError extends SendMailState {
  final String errorMessage;

  SendMailError({required this.errorMessage});
}

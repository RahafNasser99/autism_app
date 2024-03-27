part of 'get_un_read_messages_cubit.dart';

abstract class GetUnReadMessagesState {
  const GetUnReadMessagesState();
}

class GetUnReadMessagesInitial extends GetUnReadMessagesState {}

class GetUnReadMessagesEmpty extends GetUnReadMessagesState {}

class GetUnReadMessagesDone extends GetUnReadMessagesState {}

class GetUnReadMessagesFailed extends GetUnReadMessagesState {
  final String failedMessage;

  GetUnReadMessagesFailed({required this.failedMessage});
}

class GetUnReadMessagesError extends GetUnReadMessagesState {
  final String errorMessage;

  GetUnReadMessagesError({required this.errorMessage});
}

part of 'chats_cubit.dart';

abstract class ChatsState {
  final List<MailModel> mails;
  const ChatsState(this.mails);
}

class ChatsInitial extends ChatsState {
  ChatsInitial(super.mails);
}

class ChatsLoading extends ChatsState {
  ChatsLoading(super.mails);
}

class ChatsDone extends ChatsState {
  ChatsDone({required mails}) : super(mails);
}

class ChatsFailed extends ChatsState {
  final String failedMessage;

  ChatsFailed(super.mails, {required this.failedMessage});
}

class ChatsError extends ChatsState {
  final String errorMessage;

  ChatsError(super.mails, {required this.errorMessage});
}

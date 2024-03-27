part of 'inbox_cubit.dart';

abstract class InboxState {
  final List<MailsModel> mails;
  const InboxState(this.mails);
}

class InboxInitial extends InboxState {
  InboxInitial(super.mails);
}

class InboxLoading extends InboxState {
  InboxLoading(super.mails);
}

class InboxDone extends InboxState {
  InboxDone({required List<MailsModel> mails}) : super(mails);
}

class InboxEmpty extends InboxState {
  InboxEmpty() : super([]);
}

class InboxFailed extends InboxState {
  final String failedMessage;

  InboxFailed(super.mails, {required this.failedMessage});
}

class InboxError extends InboxState {
  final String errorMessage;

  InboxError(super.mails, {required this.errorMessage});
}

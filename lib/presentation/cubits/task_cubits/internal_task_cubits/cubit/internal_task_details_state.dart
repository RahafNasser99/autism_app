part of 'internal_task_details_cubit.dart';

abstract class InternalTaskDetailsState {
  const InternalTaskDetailsState();
}

class InternalTaskDetailsInitial extends InternalTaskDetailsState {}

class InternalTaskDetailsLoading extends InternalTaskDetailsState {}

class InternalTaskDetailsDone extends InternalTaskDetailsState {
  final List<InternalTaskDetails> internalTaskDetails;
  final Exercise exercise;

  InternalTaskDetailsDone(
      {required this.internalTaskDetails, required this.exercise});
}

class InternalTaskDetailsFailed extends InternalTaskDetailsState {
  final String failedMessage;

  InternalTaskDetailsFailed({required this.failedMessage});
}

class InternalTaskDetailsError extends InternalTaskDetailsState {
  final String errorMessage;

  InternalTaskDetailsError({required this.errorMessage});
}

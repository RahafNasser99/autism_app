part of 'external_task_cubit.dart';

abstract class ExternalTaskState {
  const ExternalTaskState();
}

class ExternalTaskInitial extends ExternalTaskState {}

class ExternalTaskLoading extends ExternalTaskState {}

class ExternalTaskDone extends ExternalTaskState {
  final List<Task> externalTasks;

  ExternalTaskDone(this.externalTasks);
}

class ExternalTaskEmpty extends ExternalTaskState {}

class ExternalTaskFailed extends ExternalTaskState {
  final String failedMessage;

  ExternalTaskFailed({required this.failedMessage});
}

class ExternalTaskError extends ExternalTaskState {
  final String errorMessage;

  ExternalTaskError({required this.errorMessage});
}


class ExternalTaskEvaluationDone extends ExternalTaskState {}

class ExternalTaskEvaluationFailed extends ExternalTaskState {
  final String failedMessage;

  ExternalTaskEvaluationFailed({required this.failedMessage});
}

class ExternalTaskEvaluationError extends ExternalTaskState {
  final String errorMessage;

  ExternalTaskEvaluationError({required this.errorMessage});
}

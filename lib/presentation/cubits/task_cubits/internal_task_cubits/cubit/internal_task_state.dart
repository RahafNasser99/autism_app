part of 'internal_task_cubit.dart';

abstract class InternalTaskState {
  List<Task> internalTasks;
  InternalTaskState(this.internalTasks);
}

class InternalTaskInitial extends InternalTaskState {
  InternalTaskInitial(super.internalTasks);
}

class InternalTaskLoading extends InternalTaskState {
  InternalTaskLoading(super.internalTasks);
}

class InternalTaskDone extends InternalTaskState {
  InternalTaskDone({required internalTasks}) : super(internalTasks);
}

class InternalTaskEmpty extends InternalTaskState {
  InternalTaskEmpty({required internalTasks}) : super([]);
}

class InternalTaskFailed extends InternalTaskState {
  final String failedMessage;

 InternalTaskFailed(super.internalTasks, {required this.failedMessage});
}

class InternalTaskError extends InternalTaskState {
  final String errorMessage;

   InternalTaskError(super.internalTasks,{required this.errorMessage});
}

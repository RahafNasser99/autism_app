part of 'exercise_cubit.dart';

abstract class ExerciseState {
  const ExerciseState();
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseDone extends ExerciseState {
  int taskId;
  Exercise exercise;

  ExerciseDone({required this.exercise,required this.taskId});
}

class ExerciseEmpty extends ExerciseState {}

class ExerciseFailed extends ExerciseState {
  final String failedMessage;

  ExerciseFailed({required this.failedMessage});
}

class ExerciseError extends ExerciseState {
  final String errorMessage;

  ExerciseError({required this.errorMessage});
}

class ExerciseAnswerDone extends ExerciseState {}

class ExerciseAnswerFailed extends ExerciseState {
  final String failedMessage;

  ExerciseAnswerFailed({required this.failedMessage});
}

class ExerciseAnswerError extends ExerciseState {
  final String errorMessage;

  ExerciseAnswerError({required this.errorMessage});
}

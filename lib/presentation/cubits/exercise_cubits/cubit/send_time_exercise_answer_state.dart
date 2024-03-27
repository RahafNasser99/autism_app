part of 'send_time_exercise_answer_cubit.dart';

abstract class SendTimeExerciseAnswerState {
  const SendTimeExerciseAnswerState();
}

class SendTimeExerciseAnswerInitial extends SendTimeExerciseAnswerState {}

class SendTimeExerciseAnswerDone extends SendTimeExerciseAnswerState {}

class SendTimeExerciseAnswerFailed extends SendTimeExerciseAnswerState {
  final String failedMessage;

  SendTimeExerciseAnswerFailed({required this.failedMessage});
}

class SendTimeExerciseAnswerError extends SendTimeExerciseAnswerState {
  final String errorMessage;

  SendTimeExerciseAnswerError({required this.errorMessage});
}

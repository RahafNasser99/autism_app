part of 'time_exercise_cubit.dart';

abstract class TimeExerciseState {
  final List<TimeExercise> exercises;
  const TimeExerciseState(this.exercises);
}

class TimeExerciseInitial extends TimeExerciseState {
  TimeExerciseInitial(super.exercises);
}

class TimeExerciseLoading extends TimeExerciseState {
  TimeExerciseLoading(super.exercises);
}

class TimeExerciseDone extends TimeExerciseState {
  TimeExerciseDone({required List<TimeExercise> exercises}) : super(exercises);
}

class TimeExerciseEmpty extends TimeExerciseState {
  TimeExerciseEmpty(super.exercises);
}

class TimeExerciseFailed extends TimeExerciseState {
  final String failedMessage;
  TimeExerciseFailed(super.exercises, {required this.failedMessage});
}

class TimeExerciseError extends TimeExerciseState {
  final String errorMessage;
  TimeExerciseError(super.exercises, {required this.errorMessage});
}

class TimeExerciseAnswerDone extends TimeExerciseState {
  TimeExerciseAnswerDone(super.exercises);
}

class TimeExerciseAnswerFailed extends TimeExerciseState {
  final String failedMessage;

  TimeExerciseAnswerFailed(super.exercises,{required this.failedMessage});
}

class TimeExerciseAnswerError extends TimeExerciseState {
  final String errorMessage;

  TimeExerciseAnswerError(super.exercises,{required this.errorMessage});
}

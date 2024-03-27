part of 'time_exercise_details_cubit.dart';

abstract class TimeExerciseDetailsState {
  final List<TimeExerciseDetails> timeExerciseDetails;
  const TimeExerciseDetailsState(this.timeExerciseDetails);
}

class TimeExerciseDetailsInitial extends TimeExerciseDetailsState {
  TimeExerciseDetailsInitial(super.timeExerciseDetails);
}

class TimeExerciseDetailsLoading extends TimeExerciseDetailsState {
  TimeExerciseDetailsLoading(super.timeExerciseDetails);
}

class TimeExerciseDetailsDone extends TimeExerciseDetailsState {
  TimeExerciseDetailsDone(
      {required List<TimeExerciseDetails> timeExerciseDetails})
      : super(timeExerciseDetails);
}

class TimeExerciseDetailsFailed extends TimeExerciseDetailsState {
  final String failedMessage;
  TimeExerciseDetailsFailed(super.timeExerciseDetails,
      {required this.failedMessage});
}

class TimeExerciseDetailsError extends TimeExerciseDetailsState {
  final String errorMessage;
  TimeExerciseDetailsError(super.timeExerciseDetails,
      {required this.errorMessage});
}

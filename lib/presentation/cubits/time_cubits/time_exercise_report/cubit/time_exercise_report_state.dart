part of 'time_exercise_report_cubit.dart';

abstract class TimeExerciseReportState {
  final List<TimeExerciseLog> timeExerciseLog;
  const TimeExerciseReportState(this.timeExerciseLog);
}

class TimeExerciseReportInitial extends TimeExerciseReportState {
  TimeExerciseReportInitial(super.timeExerciseLog);
}

class TimeExerciseReportLoading extends TimeExerciseReportState {
  TimeExerciseReportLoading(super.timeExerciseLog);
}

class TimeExerciseReportDone extends TimeExerciseReportState {
  TimeExerciseReportDone({required List<TimeExerciseLog> timeExerciseLog}) : super(timeExerciseLog);
}

class TimeExerciseReportEmpty extends TimeExerciseReportState {
  TimeExerciseReportEmpty(super.timeExerciseLog);
}

class TimeExerciseReportFailed extends TimeExerciseReportState {
  final String failedMessage;
  TimeExerciseReportFailed(super.timeExerciseLog,
      {required this.failedMessage});
}

class TimeExerciseReportError extends TimeExerciseReportState {
  final String errorMessage;
  TimeExerciseReportError(super.timeExerciseLog, {required this.errorMessage});
}

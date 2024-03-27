part of 'daily_program_cubit.dart';

abstract class DailyProgramState {
  const DailyProgramState();
}

class DailyProgramInitial extends DailyProgramState {}

class DailyProgramLoading extends DailyProgramState {}

class DailyProgramDone extends DailyProgramState {
  final DailyProgram dailyProgram;

  DailyProgramDone({required this.dailyProgram});
}

class DailyProgramNotFound extends DailyProgramState {}

class DailyProgramFailed extends DailyProgramState {
  final String failedMessage;

  DailyProgramFailed({required this.failedMessage});
}

class DailyProgramError extends DailyProgramState {
  final String errorMessage;

  DailyProgramError({required this.errorMessage});
}

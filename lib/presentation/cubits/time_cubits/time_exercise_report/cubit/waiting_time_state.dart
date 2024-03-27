part of 'waiting_time_cubit.dart';

abstract class WaitingTimeState {
  const WaitingTimeState();
}

class WaitingTimeInitial extends WaitingTimeState {}

class WaitingTimeLoading extends WaitingTimeState {}

class WaitingTimeZeroTime extends WaitingTimeState {}

class WaitingTimeDone extends WaitingTimeState {
  // final WaitingTime waitingTime;
  // WaitingTimeDone({required this.waitingTime});
}

class WaitingTimeFailed extends WaitingTimeState {
  final String failedMessage;

  const WaitingTimeFailed({required this.failedMessage});
}

class WaitingTimeError extends WaitingTimeState {
  final String errorMessage;

  const WaitingTimeError({required this.errorMessage});
}

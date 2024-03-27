part of 'get_child_profile_cubit.dart';

abstract class GetChildProfileState {
  const GetChildProfileState();
}

class GetChildProfileLoading extends GetChildProfileState {}

class GetChildProfileDone extends GetChildProfileState {}

class GetChildProfileFailed extends GetChildProfileState {
  final String failedMessage;

  GetChildProfileFailed({required this.failedMessage});
}

class GetChildProfileError extends GetChildProfileState {
  final String errorMessage;

  GetChildProfileError({required this.errorMessage});
}

part of 'edit_profile_cubit.dart';

abstract class EditProfileState {
  const EditProfileState();
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileDone extends EditProfileState {}

class EditProfileFailed extends EditProfileState {
  final String failedMessage;

  EditProfileFailed({required this.failedMessage});
}

class EditProfileError extends EditProfileState {
  final String errorMessage;

  EditProfileError({required this.errorMessage});
}

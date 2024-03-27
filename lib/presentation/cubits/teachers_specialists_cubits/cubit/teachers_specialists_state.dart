part of 'teachers_specialists_cubit.dart';

abstract class TeachersSpecialistsState extends Equatable {
  const TeachersSpecialistsState();

  @override
  List<Object> get props => [];
}

class TeachersSpecialistsLoading extends TeachersSpecialistsState {}

class TeachersSpecialistsDone extends TeachersSpecialistsState {}

class TeachersSpecialistsNoMember extends TeachersSpecialistsState {}

class TeachersSpecialistsFailed extends TeachersSpecialistsState {
  final String failedMessage;

  const TeachersSpecialistsFailed({required this.failedMessage});
}

class TeachersSpecialistsError extends TeachersSpecialistsState {
  final String errorMessage;

  const TeachersSpecialistsError({required this.errorMessage});
}

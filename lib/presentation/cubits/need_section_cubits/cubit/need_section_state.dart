part of 'need_section_cubit.dart';

abstract class NeedSectionState {
  const NeedSectionState();
}

class NeedSectionLoading extends NeedSectionState {}

class NeedSectionDone extends NeedSectionState {}

class NeedSectionNoNeeds extends NeedSectionState {}

class NeedSectionFailed extends NeedSectionState {
  final String failedMessage;

  NeedSectionFailed({required this.failedMessage});
}

class NeedSectionError extends NeedSectionState {
  final String errorMessage;

  NeedSectionError({required this.errorMessage});
}

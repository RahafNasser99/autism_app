part of 'need_expression_handle_cubit.dart';

abstract class NeedExpressionHandleState extends Equatable {
  const NeedExpressionHandleState();

  @override
  List<Object?> get props => [];
}

class NeedExpressionHandleInitial extends NeedExpressionHandleState {}

class NeedExpressionHandleLoading extends NeedExpressionHandleState {}

class NeedExpressionHandleDone extends NeedExpressionHandleState {}

class NeedExpressionHandleFailed extends NeedExpressionHandleState {
  final String failedMessage;

  const NeedExpressionHandleFailed({required this.failedMessage});
}

class NeedExpressionHandleError extends NeedExpressionHandleState {
  final String errorMessage;

  const NeedExpressionHandleError({required this.errorMessage});
}

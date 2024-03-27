part of 'need_expression_report_cubit.dart';

abstract class NeedExpressionReportState {
  final List<NeedExpression> needsExpression;
  const NeedExpressionReportState(this.needsExpression);
}

class NeedExpressionReportInitial extends NeedExpressionReportState {
  NeedExpressionReportInitial(super.needsExpression);
}

class NeedExpressionReportLoading extends NeedExpressionReportState {
  NeedExpressionReportLoading(super.needsExpression);
}

class NeedExpressionReportDone extends NeedExpressionReportState {
  NeedExpressionReportDone({required needsExpression}) : super(needsExpression);
}

class NeedExpressionReportIsEmpty extends NeedExpressionReportState {
  NeedExpressionReportIsEmpty({required needsExpression}) : super([]);
}

class NeedExpressionReportFailed extends NeedExpressionReportState {
  final String failedMessage;

  const NeedExpressionReportFailed(super.needsExpression,
      {required this.failedMessage});
}

class NeedExpressionReportError extends NeedExpressionReportState {
  final String errorMessage;

  const NeedExpressionReportError(super.needsExpression,
      {required this.errorMessage});
}

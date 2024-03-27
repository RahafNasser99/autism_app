part of 'plan_report_cubit.dart';

abstract class PlanReportState {
  final List<Target> report;

  const PlanReportState(this.report);
}

class PlanReportInitial extends PlanReportState {
  PlanReportInitial(super.report);
}

class PlanReportLoading extends PlanReportState {
  PlanReportLoading(super.report);
}

class PlanReportEmpty extends PlanReportState {
  PlanReportEmpty(super.report);
}

class PlanReportDone extends PlanReportState {
  PlanReportDone({required List<Target> report}) : super(report);
}

class PlanReportFailed extends PlanReportState {
  final String failedMessage;
  PlanReportFailed(
    super.report, {
    required this.failedMessage,
  });
}

class PlanReportError extends PlanReportState {
  final String errorMessage;
  PlanReportError(
    super.report, {
    required this.errorMessage,
  });
}

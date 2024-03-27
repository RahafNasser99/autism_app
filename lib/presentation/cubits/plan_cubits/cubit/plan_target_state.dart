part of 'plan_target_cubit.dart';

abstract class PlanTargetState {
  const PlanTargetState();
}

class PlanTargetInitial extends PlanTargetState {
  PlanTargetInitial();
}

class PlanTargetLoading extends PlanTargetState {
  PlanTargetLoading();
}

class PlanTargetDone extends PlanTargetState {
  Plan plan;
  PlanTargetDone({required this.plan});
}

class PlanTargetEmpty extends PlanTargetState {
  PlanTargetEmpty();
}

class PlanTargetFailed extends PlanTargetState {
  final String failedMessage;
  PlanTargetFailed({required this.failedMessage});
}

class PlanTargetError extends PlanTargetState {
  final String errorMessage;
  PlanTargetError({required this.errorMessage});
}

part of 'all_plans_cubit.dart';

abstract class AllPlansState {
  final List<PlansForChild> plans;

  const AllPlansState(this.plans);
}

class AllPlansInitial extends AllPlansState {
  AllPlansInitial(super.plans);
}

class AllPlansLoading extends AllPlansState {
  AllPlansLoading(super.plans);
}

class AllPlansDone extends AllPlansState {
  AllPlansDone({required List<PlansForChild> plans}) : super(plans);
}

class AllPlansEmpty extends AllPlansState {
  AllPlansEmpty(super.plans);
}

class AllPlansFailed extends AllPlansState {
  final String failedMessage;
  AllPlansFailed(super.plans, {required this.failedMessage});
}

class AllPlansError extends AllPlansState {
  final String errorMessage;
  AllPlansError(super.plans, {required this.errorMessage});
}

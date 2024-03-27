part of 'plan_domains_cubit.dart';

abstract class PlanDomainsState {
  final List<Domain> domains;
  const PlanDomainsState(this.domains);
}

class PlanDomainsInitial extends PlanDomainsState {
  PlanDomainsInitial(super.domains);
}

class PlanDomainsLoading extends PlanDomainsState {
  PlanDomainsLoading(super.domains);
}

class PlanDomainsDone extends PlanDomainsState {
  PlanDomainsDone({required List<Domain> domains}) : super(domains);
}

class PlanDomainsFailed extends PlanDomainsState {
  final String failedMessage;
  PlanDomainsFailed(super.domains, {required this.failedMessage});
}

class PlanDomainsError extends PlanDomainsState {
  final String errorMessage;
  PlanDomainsError(super.domains, {required this.errorMessage});
}

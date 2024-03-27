part of 'pep_3_tests_cubit.dart';

abstract class Pep3TestsState {
  final List<Pep3TestsForChild> pep3ListsForChild;
  const Pep3TestsState(this.pep3ListsForChild);
}

class Pep3TestsInitial extends Pep3TestsState {
  Pep3TestsInitial(super.pep3ListsForChild);
}

class Pep3TestsLoading extends Pep3TestsState {
  Pep3TestsLoading(super.pep3ListsForChild);
}

class Pep3TestsDone extends Pep3TestsState {
  Pep3TestsDone({required pep3TestsForChild}) : super(pep3TestsForChild);
}

class Pep3TestsEmpty extends Pep3TestsState {
  Pep3TestsEmpty(super.pep3ListsForChild);
}

class Pep3TestsFailed extends Pep3TestsState {
  final String failedMessage;
  Pep3TestsFailed({required this.failedMessage}) : super([]);
}

class Pep3TestsError extends Pep3TestsState {
  final String errorMessage;
  Pep3TestsError({required this.errorMessage}) : super([]);
}

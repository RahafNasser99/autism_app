part of 'pep_3_cubit.dart';

abstract class Pep3State {
  const Pep3State();
}

class Pep3Initial extends Pep3State {
  Pep3Initial();
}

class Pep3Loading extends Pep3State {
  Pep3Loading();
}

class Pep3Done extends Pep3State {
  final Pep3Test pep3test;
  Pep3Done({required this.pep3test});
}

class Pep3Failed extends Pep3State {
  final String failedMessage;

  Pep3Failed({required this.failedMessage});
}

class Pep3Error extends Pep3State {
  final String errorMessage;

  Pep3Error({required this.errorMessage});
}

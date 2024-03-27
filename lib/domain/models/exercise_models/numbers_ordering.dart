import 'dart:convert';

import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';

NumbersOrderingExercise numbersOrderingFromJson(String str) =>
    NumbersOrderingExercise.fromJson(json.decode(str));

class NumbersOrderingExercise extends Exercise {
  final List<int> numbers;
  final List<int> answer;

  NumbersOrderingExercise({
    required super.id,
    required super.exerciseType,
    required this.numbers,
    required this.answer,
  });

  List<String> getNumbersAsString() {
    List<String> stringNumbers =
        numbers.map((number) => number.toString()).toList();
    return [...stringNumbers];
  }

  bool checkCurrentAnswer(List<String> solve) {
    List<String> stringAnswer =
        answer.map((number) => number.toString()).toList();
    for (int i = 0; i < solve.length; i++) {
      if (solve[i] == stringAnswer[i]) {
        continue;
      } else {
        return false;
      }
    }
    return true;
  }

  bool checkAnswer(List<String> solve) {
    List<String> stringAnswer =
        answer.map((number) => number.toString()).toList();
    if (solve.length == stringAnswer.length && checkCurrentAnswer(solve)) {
      return true;
    }
    return false;
  }

  bool checkColor(List<String> solve, int index) {
    List<String> stringAnswer =
        answer.map((number) => number.toString()).toList();
    if (solve[index] == stringAnswer[index]) {
      return true;
    }
    return false;
  }

  factory NumbersOrderingExercise.fromJson(Map<String, dynamic> json) =>
      NumbersOrderingExercise(
        id: json['id'],
        exerciseType: json['exerciseType'],
        numbers: json['exercise']['numberOrder']['numbers'].cast<int>(),
        answer: json['exercise']['numberOrder']['answer'].cast<int>(),
      );

  @override
  String toString() =>
      super.toString() +
      'NumbersOrdering ( \n'
          'numbers: $numbers, \n'
          'answer: $answer\n'
          ') \n'
          ')';
}

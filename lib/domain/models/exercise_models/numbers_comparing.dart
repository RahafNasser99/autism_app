// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';

NumbersComparingExercise numbersComparingFromJson(String str) =>
    NumbersComparingExercise.fromJson(json.decode(str));

class NumbersComparingExercise extends Exercise {
  final int number1; //left side
  final int number2; // right side
  final String answer;

  NumbersComparingExercise({
    required super.id,
    required super.exerciseType,
    required this.number1,
    required this.number2,
    required this.answer,
  });

  bool checkAnswer(String sign) {
    if (sign == answer) {
      return true;
    }
    return false;
  }

  factory NumbersComparingExercise.fromJson(
          Map<String, dynamic> json) =>
      NumbersComparingExercise(
        id: json['id'],
        exerciseType: json['exerciseType'],
        number1: json['exercise']['numberCompare']['number1'],
        number2: json['exercise']['numberCompare']['number2'],
        answer: json['exercise']['numberCompare']['answer'],
      );

  @override
  String toString() =>
      super.toString() +
      'NumbersComparing (\n'
          'number1: $number1, \n'
          'number2: $number2, \n'
          'answer: $answer \n'
          ') \n'
          ')';
}

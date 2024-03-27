// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';

StatementCompositionExercise statementCompositionFromJson(String str) =>
    StatementCompositionExercise.fromJson(json.decode(str));

class StatementCompositionExercise extends Exercise {
  final List<String> statement;
  final List<String> answer;

  StatementCompositionExercise({
    required super.id,
    required super.exerciseType,
    required this.statement,
    required this.answer,
  });

  bool checkCurrentAnswer(List<String> solve) {
    for (int i = 0; i < solve.length; i++) {
      if (solve[i] == answer[i]) {
        continue;
      } else {
        return false;
      }
    }
    return true;
  }

  bool checkAnswer(List<String> solve) {
    if (solve.length == answer.length && checkCurrentAnswer(solve)) {
      return true;
    }
    return false;
  }

  bool checkColor(List<String> solve, int index) {
    if (solve[index] == answer[index]) {
      return true;
    }
    return false;
  }

  factory StatementCompositionExercise.fromJson(Map<String, dynamic> json) =>
      StatementCompositionExercise(
        id: json['id'],
        exerciseType: json['exerciseType'],
        statement:
            (json['exercise']['statementComposition']['statement'] as List)
                .map((word) => word as String)
                .toList(),
        answer: (json['exercise']['statementComposition']['answer'] as List)
            .map((word) => word as String)
            .toList(),
      );

  @override
  String toString() =>
      super.toString() +
      'StatementComposition (\n'
          'statement: $statement, \n'
          'answer: $answer, \n'
          ') \n'
          ')';
}

import 'dart:convert';

import 'package:autism_mobile_app/domain/models/exercise_models/items_matching.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_ordering.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_comparing.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/statements_composition.dart';

Exercise exerciseFromJson(String str) => Exercise.fromJson(json.decode(str));

abstract class Exercise {
  final int id;
  final String exerciseType;

  Exercise({
    required this.exerciseType,
    required this.id,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    if (json['exerciseType'] == 'matching') {
      return ItemsMatchingExercise.fromJson(json);
    } else if (json['exerciseType'] == 'statement-composition') {
      return StatementCompositionExercise.fromJson(json);
    } else if (json['exerciseType'] == 'number-compare') {
      return NumbersComparingExercise.fromJson(json);
    }
    return NumbersOrderingExercise.fromJson(json);
  }

  @override
  String toString() => 'Exercise ( \n'
      'id: $id, \n'
      'taskType: $exerciseType,\n';
}

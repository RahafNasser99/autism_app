import 'dart:convert';

import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/exercise.dart';

ItemsMatchingExercise itemsMatchingFromJson(String str) =>
    ItemsMatchingExercise.fromJson(json.decode(str));

class ItemsMatchingExercise extends Exercise {
  final String mainItem;
  final List<String> itemsUrl;
  final int answer;

  ItemsMatchingExercise({
    required super.id,
    required super.exerciseType,
    required this.mainItem,
    required this.itemsUrl,
    required this.answer,
  });

  bool checkAnswer(int index) {
    if (index + 1 == answer) {
      return true;
    }
    return false;
  }

  factory ItemsMatchingExercise.fromJson(Map<String, dynamic> json) {
    List<String> items = [];
    items.add(Constant.ipAddress + '/' + json['exercise']['matching']['item1']);
    items.add(Constant.ipAddress + '/' + json['exercise']['matching']['item2']);
    items.add(Constant.ipAddress + '/' + json['exercise']['matching']['item3']);
    return ItemsMatchingExercise(
      id: json['id'],
      exerciseType: json['exerciseType'],
      mainItem:
          Constant.ipAddress + '/' + json['exercise']['matching']['mainItem'],
      itemsUrl: items,
      answer: json['exercise']['matching']['answer'],
    );
  }

  @override
  String toString() =>
      super.toString() +
      'ItemsMatching ( \n'
          'mainItem: $mainItem, \n'
          'itemsUrl: $itemsUrl, \n'
          'answer: $answer,\n'
          ') \n'
          ')';
}

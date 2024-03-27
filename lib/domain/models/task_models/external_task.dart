import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/domain/models/task_models/task.dart';

Task externalTaskFromJson(String str, String taskPlace) =>
    ExternalTask.fromJson(json.decode(str), taskPlace);

class ExternalTask extends Task {
  String childPerformance;
  String? note;

  ExternalTask({
    required super.id,
    required super.taskName,
    required super.taskType,
    required super.date,
    required this.childPerformance,
    required this.note,
  });

  bool getCheckValue(String performance) {
    if (childPerformance == 'غير محقق' && performance == 'unrealized') {
      return true;
    } else if (childPerformance == 'محقق' && performance == 'realized') {
      return true;
    } else if (childPerformance == 'محقق بشكل جزئي' &&
        performance == 'partially realized') {
      return true;
    } else {
      return false;
    }
  }

  String setChildPerformance(int performance) {
    if (performance == 0) {
      return 'unrealized';
    } else if (performance == 1) {
      return 'partially realized';
    } else if (performance == 2) {
      return 'realized';
    } else {
      return 'not evaluated';
    }
  }

  factory ExternalTask.fromJson(Map<String, dynamic> json, String taskPlace) {
    String evaluation;
    if (json['childPerformance'] == 'unrealized') {
      evaluation = 'غير محقق';
    } else if (json['childPerformance'] == 'partially realized') {
      evaluation = 'محقق بشكل جزئي';
    } else if (json['childPerformance'] == 'realized') {
      evaluation = 'محقق';
    } else {
      evaluation = 'لم يتم التقييم';
    }
    return ExternalTask(
      id: json[taskPlace]['id'],
      taskName: json[taskPlace]['taskName'],
      taskType: json[taskPlace]['taskType'],
      date: Date(
              comingDate: json[taskPlace]['createdAt']
                  .substring(0, json[taskPlace]['createdAt'].indexOf('T')))
          .handleDate(),
      childPerformance: evaluation,
      note: json['note'],
    );
  }

  @override
  String toString() =>
      super.toString() +
      'ExternalTask (\n'
          'childPerformance: $childPerformance, \n'
          'note: $note\n'
          ')\n'
          ')';
}

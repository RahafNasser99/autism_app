import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/domain/models/task_models/task.dart';

Task internalTaskFromJson(
        String str, int exerciseId, String exerciseType, String taskPlace) =>
    InternalTask.fromJson(
        json.decode(str), exerciseId, exerciseType, taskPlace);

class InternalTask extends Task {
  final int exerciseId;
  final String exerciseType;
  final int attempts;
  final int duration;
  final bool status;

  InternalTask({
    required super.id,
    required super.taskName,
    required super.taskType,
    required super.date,
    required this.exerciseId,
    required this.exerciseType,
    required this.attempts,
    required this.duration,
    required this.status,
  });

  String getTaskImage() {
    if (exerciseType == 'number-order') {
      return 'assets/images/tasks/number-ordering-task.jpg';
    } else if (exerciseType == 'statement-composition') {
      return 'assets/images/tasks/statement-composition-task.jpg';
    } else if (exerciseType == 'number-compare') {
      return 'assets/images/tasks/number-comparing-task.jpg';
    } else {
      return 'assets/images/tasks/item-matching-task.jpg';
    }
  }

  factory InternalTask.fromJson(Map<String, dynamic> json, int exerciseId,
      String exerciseType, String taskPlace) {
    return InternalTask(
      id: json[taskPlace]['id'],
      taskName: json[taskPlace]['taskName'],
      taskType: json[taskPlace]['taskType'],
      date: Date(
              comingDate: json[taskPlace]['createdAt']
                  .substring(0, json[taskPlace]['createdAt'].indexOf('T')))
          .handleDate(),
      exerciseType: exerciseType,
      exerciseId: exerciseId,
      attempts: json['totalTries'],
      duration: json['totalTime'],
      status: json['status'],
    );
  }

  @override
  String toString() {
    return super.toString() +
        'InternalTask (\n'
            'exerciseId: $exerciseId, \n'
            'exerciseType: $exerciseType, \n'
            'attempts: $attempts, \n'
            'duration: $duration, \n'
            'status: $status\n'
            ') \n'
            ')';
  }
}

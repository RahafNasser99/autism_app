import 'dart:convert';

import 'package:autism_mobile_app/domain/models/task_models/external_task.dart';
import 'package:autism_mobile_app/domain/models/task_models/internal_task.dart';

Task taskFromJson(
        String str, int exerciseId, String exerciseType, String taskPlace) =>
    Task.fromJson(json.decode(str), exerciseId, exerciseType, taskPlace);

abstract class Task {
  final int id;
  final String taskName;
  final String taskType;
  final DateTime date;

  Task({
    required this.id,
    required this.taskName,
    required this.taskType,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json, int exerciseId,
      String exerciseType, String taskPlace) {
    if (json[taskPlace]['taskType'] == 'external-task') {
      return ExternalTask.fromJson(json, taskPlace);
    } else {
      return InternalTask.fromJson(json, exerciseId, exerciseType, taskPlace);
    }
  }

  @override
  String toString() {
    return 'Task ( \n'
        'id: $id, \n'
        'taskName: $taskName, \n'
        'taskType: $taskType, \n'
        'date: $date\n';
  }
}

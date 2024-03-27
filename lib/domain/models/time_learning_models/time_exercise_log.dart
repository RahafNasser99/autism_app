import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise.dart';

TimeExerciseLog timeExerciseLogFromJson(String str) =>
    TimeExerciseLog.fromJson(json.decode(str));

class TimeExerciseLog {
  final int totalTries;
  final int totalTime;
  final bool status;
  final DateTime date;
  final TimeExercise timeExercise;

  TimeExerciseLog({
    required this.totalTries,
    required this.totalTime,
    required this.status,
    required this.date,
    required this.timeExercise,
  });


  factory TimeExerciseLog.fromJson(Map<String, dynamic> json) =>
      TimeExerciseLog(
        totalTries: json['totalTries'],
        totalTime: json['totalTime'],
        status: json['status'],
        date: Date(
                comingDate: json['timeExercise']['createdAt'].substring(
                    0, json['timeExercise']['createdAt'].indexOf('T')))
            .handleDate(),
        timeExercise: TimeExercise.fromJson(json['timeExercise']),
      );

  @override
  String toString() {
    return 'TimeExerciseLog ( \n'
        'totalTries: $totalTries, \n'
        'totalTime: $totalTime, \n'
        'status: $status, \n'
        'date: $date, \n'
        'timeExercise: $timeExercise\n'
        ')';
  }
}

import 'dart:convert';

TimeExercise timeExerciseFromJson(String str) =>
    TimeExercise.fromJson(json.decode(str));

class TimeExercise {
  final int id;
  final String exerciseType;
  final String mainTime;
  final List<String> options;
  final int answer;
  final String timeType;

  TimeExercise({
    required this.id,
    required this.exerciseType,
    required this.mainTime,
    required this.options,
    required this.answer,
    required this.timeType,
  });

  String getExerciseImage() {
    if (timeType == 'digital') {
      return 'assets/images/tasks/digital-matching-task.jpg';
    } else {
      return 'assets/images/tasks/analog-matching-task.jpg';
    }
  }

  bool checkAnswer(int choice) {
    if (choice == answer) {
      return true;
    }
    return false;
  }

  factory TimeExercise.fromJson(Map<String, dynamic> json) {
    List<String> extractedDate = [];
    extractedDate.add(json['exercise']['time']['time1']);
    extractedDate.add(json['exercise']['time']['time2']);
    extractedDate.add(json['exercise']['time']['time3']);
    return TimeExercise(
      id: json['id'],
      exerciseType: json['exerciseType'],
      mainTime: json['exercise']['time']['mainTime'],
      options: extractedDate,
      answer: json['exercise']['time']['answer'],
      timeType: json['exercise']['time']['type'],
    );
  }

  @override
  String toString() {
    return 'TimeExercise ( \n'
        'id: $id, \n'
        'exerciseType: $exerciseType, \n'
        'mainTime: $mainTime, \n'
        'options: $options, \n'
        'answer: $answer, \n'
        'timeType: $timeType, \n'
        ')';
  }
}

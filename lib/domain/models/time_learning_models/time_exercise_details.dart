import 'dart:convert';

TimeExerciseDetails timeExerciseDetailsFromJson(String str) =>
    TimeExerciseDetails.fromJson(json.decode(str));

class TimeExerciseDetails {
  final int id;
  final int attempts;
  final int duration;
  final bool status;

  TimeExerciseDetails({
    required this.id,
    required this.attempts,
    required this.duration,
    required this.status,
  });

   String getDuration() {
    int seconds = duration % 60;
    int minutes = duration ~/ 60;
    if (minutes == 0) {
      return '${seconds.toString()} ثانية';
    }
    return '${minutes.toString()} دقائق و ${seconds.toString()}  ثانية';
  }

  factory TimeExerciseDetails.fromJson(Map<String, dynamic> json) =>
      TimeExerciseDetails(
        id: json['id'],
        attempts: json['numOfTry'],
        duration: json['time'],
        status: json['status'],
      );

  @override
  String toString() {
    return 'TimeExerciseDetails ( \n'
        'id: $id, \n'
        'attempts: $attempts, \n'
        'duration: $duration, \n'
        'status: $status\n'
        ')';
  }
}

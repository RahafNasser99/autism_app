// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

InternalTaskDetails internalTaskDetailsFromJson(String str) =>
    InternalTaskDetails.fromJson(json.decode(str));

class InternalTaskDetails {
  final int attempts;
  final int duration;
  final bool status;

  InternalTaskDetails({
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

  factory InternalTaskDetails.fromJson(Map<String, dynamic> json) =>
      InternalTaskDetails(
        attempts: json['numOfTry'],
        duration: json['time'],
        status: json['status'],
      );

  @override
  String toString() {
    return 'InternalTaskDetails ( \n'
        'attempts: $attempts, \n'
        'duration: $duration, \n'
        'status: $status\n'
        ')';
  }
}

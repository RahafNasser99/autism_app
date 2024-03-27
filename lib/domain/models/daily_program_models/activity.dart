import 'dart:convert';

import 'package:autism_mobile_app/utils/date/time.dart';
import 'package:autism_mobile_app/domain/models/content_models/content.dart';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

class Activity {
  final int id;
  final String name;
  final String time;
  final DateTime comparedTime;
  final String duration;
  final DateTime comparedDuration;
  final Content content;

  Activity({
    required this.id,
    required this.name,
    required this.time,
    required this.comparedTime,
    required this.duration,
    required this.comparedDuration,
    required this.content,
  });

  bool checkTimeBeforeAndAfter() {
    if (DateTime.now().isAfter(comparedTime) &&
        DateTime.now().isBefore(comparedDuration)) {
      return true;
    }
    return false;
  }

  bool checkTimeBefore() {
    if (comparedTime.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool checkTimeAfter() {
    if (comparedTime.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool checkTimeEqual() {
    if (comparedTime.isAtSameMomentAs((DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        0)))) {
      return true;
    }
    return false;
  }

  bool checkDurationEqual() {
    if (comparedDuration.isAtSameMomentAs((DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        0)))) {
      return true;
    }
    return false;
  }

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'],
        name: json['name'],
        time: Time(comingDuration: 0, comingTime: json['time'])
            .handleTimeDisplay(),
        comparedTime:
            Time(comingDuration: 0, comingTime: json['time']).handleTime(),
        duration: Time(comingDuration: json['duration'], comingTime: '')
            .handleDurationDisplay(),
        comparedDuration:
            Time(comingDuration: json['duration'], comingTime: json['time'])
                .handleDuration(),
        content: Content.fromJson(json['content']),
      );

  @override
  String toString() {
    return 'Activity ( \n'
        'id: $id, \n'
        'name: $name, \n'
        'time: $time, \n'
        'duration: $duration, \n'
        'comparedTime: $comparedTime'
        'comparedDuration: $comparedDuration'
        'content: ${content.toString()}\n'
        ')';
  }
}

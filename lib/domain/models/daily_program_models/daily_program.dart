// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:autism_mobile_app/domain/models/daily_program_models/activity.dart';

DailyProgram dailyProgramFromJson(String str) =>
    DailyProgram.fromJson(json.decode(str));

class DailyProgram {
  final List<Activity> activities;
  DailyProgram({
    required this.activities,
  });

  factory DailyProgram.fromJson(Map<String, dynamic> json) {
    final extractedData = json['activities'] as List;
    List<Activity> extractedActivities = [];
    for (var activity in extractedData) {
      extractedActivities.add(Activity.fromJson(activity));
    }
    return DailyProgram(activities: extractedActivities);
  }

  @override
  String toString() =>
      'DailyProgram [ \n' 'activities: ${activities.toString()} \n' ']';
}

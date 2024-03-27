import 'dart:convert';

import 'package:autism_mobile_app/domain/models/plan_models/target.dart';

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));

class Plan {
  final int id;
  final String name;
  final List<Target> targets;

  Plan({
    required this.id,
    required this.name,
    required this.targets,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    var extractedData = json['goal'] as List;
    List<Target> extractedTargets = [];
    for (var target in extractedData) {
      extractedTargets.add(Target.fromJson(target));
    }
    return Plan(
      id: json['id'],
      name: json['name'],
      targets: extractedTargets,
    );
  }

  @override
  String toString() {
    return 'Plan ( \n'
        'id: $id, \n'
        'name: $name, \n'
        'targets: $targets, \n'
        ')';
  }
}

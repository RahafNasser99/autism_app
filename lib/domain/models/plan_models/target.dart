import 'dart:convert';

import 'package:autism_mobile_app/domain/models/pep_3_test_models/domain.dart';

Target targetFromJson(String str) => Target.fromJson(json.decode(str));

class Target {
  final int id;
  final String target;
  final String technique;
  final String evaluation;
  final String? note;
  final String? motivation;
  final Domain domain;

  Target({
    required this.id,
    required this.target,
    required this.technique,
    required this.evaluation,
    required this.note,
    required this.motivation,
    required this.domain,
  });

  factory Target.fromJson(Map<String, dynamic> json) {
    String evaluation;
    if (json['evaluation'] == 'unrealized') {
      evaluation = 'غير محقق';
    } else if (json['evaluation'] == 'partially realized') {
      evaluation = 'محقق بشكل جزئي';
    } else if (json['evaluation'] == 'realized') {
      evaluation = 'محقق';
    } else {
      evaluation = 'لم يتم التقييم';
    }

    String technique;
    if (json['technique'] == 'physical') {
      technique = 'أسلوب جسدي';
    } else if (json['technique'] == 'verbal') {
      technique = 'أسلوب لفظي';
    } else {
      technique = 'أسلوب بصري';
    }

    return Target(
        id: json['id'],
        target: json['pep3Question']['goal'],
        technique: technique,
        evaluation: evaluation,
        note: json['note'],
        motivation: json['motivation'],
        domain: Domain.fromJson(
          json['pep3Question']['pep3Domain'],
        ));
  }

  @override
  String toString() {
    return 'Target ( \n'
        'id: $id, \n'
        'name: $target, \n'
        'technique: $technique, \n'
        'evaluation: $evaluation, \n'
        'note: $note, \n'
        'motivation: $motivation\n'
        'domain: $domain\n'
        ')';
  }
}

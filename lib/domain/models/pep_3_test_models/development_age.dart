import 'dart:convert';

import 'package:autism_mobile_app/domain/models/pep_3_test_models/domain.dart';

DevelopmentAge developmentAgeFromJson(String str) =>
    DevelopmentAge.fromJson(json.decode(str));

class DevelopmentAge {
  final int developmentAgeId;
  final int age;
  final Domain domain;
  final int ageInYear;
  final int ageInMonth;

  DevelopmentAge({
    required this.developmentAgeId,
    required this.age,
    required this.domain,
    required this.ageInYear,
    required this.ageInMonth,
  });

  factory DevelopmentAge.fromJson(Map<String, dynamic> json) { 
    return DevelopmentAge(
        developmentAgeId: json['id'],
        age: json['age'],
        domain: Domain.fromJson(
          json['pep3Domain'],
        ),
        ageInYear: json['age'] ~/ 12,
        ageInMonth: json['age'] % 12,
      );}

  @override
  String toString() => 'DevelopmentAge ( \n'
      'developmentAgeId: $developmentAgeId,  \n'
      'age: $age,  \n'
      'domain: ${domain.toString()} \n'
      ')';
}

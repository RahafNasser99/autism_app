import 'dart:convert';

import 'package:autism_mobile_app/domain/models/pep_3_test_models/development_age.dart';

Pep3Test pep3TestFromJson(String str) => Pep3Test.fromJson(json.decode(str));

class Pep3Test {
  final int realAge;
  final List<DevelopmentAge> developmentAge;
  final int communicativeDevelopmentalAge;
  final int motorDevelopmentalAge;
  final int communicativeDevelopmentalAgeInYear;
  final int communicativeDevelopmentalAgeInMonth;
  final int motorDevelopmentalAgeInYear;
  final int motorDevelopmentalAgeInMonth;

  Pep3Test({
    required this.realAge,
    required this.developmentAge,
    required this.communicativeDevelopmentalAge,
    required this.motorDevelopmentalAge,
    required this.communicativeDevelopmentalAgeInYear,
    required this.communicativeDevelopmentalAgeInMonth,
    required this.motorDevelopmentalAgeInYear,
    required this.motorDevelopmentalAgeInMonth,
  });

  factory Pep3Test.fromJson(Map<String, dynamic> json) {
    final extractedData = json['pep3Age'] as List;
    final List<DevelopmentAge> extractedDevelopmentAge = [];
    
    for (var pep3Age in extractedData) {
      String domainName = pep3Age['pep3Domain']['domain'];
      if (domainName.contains('CVP') ||
          domainName.contains('EL') ||
          domainName.contains('RL') ||
          domainName.contains('FM') ||
          domainName.contains('GM') ||
          domainName.contains('VMI') ||
          domainName.contains('PSC')) {
        extractedDevelopmentAge.add(DevelopmentAge.fromJson(pep3Age));
      } else {
        continue;
      }
    }
    return Pep3Test(
      realAge: json['realAge']['age'],
      developmentAge: extractedDevelopmentAge,
      communicativeDevelopmentalAge: json['communicativeDevelopmentalAge']
          ['age'],
      motorDevelopmentalAge: json['motorDevelopmentalAge']['age'],
      communicativeDevelopmentalAgeInYear:
          json['communicativeDevelopmentalAge']['age'] ~/ 12,
      communicativeDevelopmentalAgeInMonth:
          json['communicativeDevelopmentalAge']['age'] % 12,
      motorDevelopmentalAgeInYear: json['motorDevelopmentalAge']['age'] ~/ 12,
      motorDevelopmentalAgeInMonth: json['motorDevelopmentalAge']['age'] % 12,
    );
  }

  @override
  String toString() => 'Pep3Test ( \n'
      'realAge: $realAge,  \n'
      'developmentAge: ${developmentAge.toString()} \n'
      'communicativeDevelopmentalAge: $communicativeDevelopmentalAge \n'
      'communicativeDevelopmentalAgeInYear: $communicativeDevelopmentalAgeInYear \n'
      'communicativeDevelopmentalAgeInMonth: $communicativeDevelopmentalAgeInMonth \n'
      'motorDevelopmentalAgeInYear: $motorDevelopmentalAgeInYear \n'
      'motorDevelopmentalAgeInMonth: $motorDevelopmentalAgeInMonth \n'
      'motorDevelopmentalAge: $motorDevelopmentalAge \n'
      ')';
}

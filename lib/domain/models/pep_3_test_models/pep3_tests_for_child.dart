import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';

Pep3TestsForChild pep3TestsForChildFromJson(String str) =>
    Pep3TestsForChild.fromJson(json.decode(str));

class Pep3TestsForChild {
  final int pep3TestId;
  final String pep3Name;
  final String bodyDescription;
  final String behaviorDescription;
  final DateTime createdDate;
  final int? planId;
  final String? planName;

  Pep3TestsForChild({
    required this.pep3TestId,
    required this.pep3Name,
    required this.bodyDescription,
    required this.behaviorDescription,
    required this.createdDate,
    required this.planId,
    required this.planName,
  });

  factory Pep3TestsForChild.fromJson(Map<String, dynamic> json) {
    print(json);
    return Pep3TestsForChild(
      pep3TestId: json['id'],
      pep3Name: json['name'].toString(),
      bodyDescription: json['bodyDescription'].toString(),
      behaviorDescription: json['behaviorDescription'].toString(),
      createdDate: Date(
              comingDate: json['createdAt']
                  .substring(0, json['createdAt'].indexOf('T')))
          .handleDate(),
      planId: json['plan'] == null ? null : json['plan']['id'],
      planName: json['plan'] == null ? null : json['plan']['name'].toString(),
    );
  }

  @override
  String toString() {
    return 'Pep3TestsForChild ( \n'
        'pep3TestId: $pep3TestId, \n'
        'pep3Name: $pep3Name, \n'
        'bodyDescription: $bodyDescription, \n'
        'behaviorDescription: $behaviorDescription, \n'
        'createdDate: $createdDate\n'
        'planId: $planId\n'
        'planName: $planName\n'
        ')';
  }
}

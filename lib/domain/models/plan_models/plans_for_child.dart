import 'dart:convert';

import 'package:autism_mobile_app/utils/date/date.dart';

PlansForChild plansFromJson(String str) =>
    PlansForChild.fromJson(json.decode(str));

class PlansForChild {
  final int id;
  final String name;
  final DateTime date;

  PlansForChild({required this.id, required this.name, required this.date});

  factory PlansForChild.fromJson(Map<String, dynamic> json) => PlansForChild(
        id: json['id'],
        name: json['name'],
        date: Date(
                comingDate: json['createdAt']
                    .substring(0, json['createdAt'].indexOf('T')))
            .handleDate(),
      );

  @override
  String toString() =>
      'PlansForChild ( \n' 'id: $id, \n' 'name: $name,\n' 'date: $date, \n' ')';
}

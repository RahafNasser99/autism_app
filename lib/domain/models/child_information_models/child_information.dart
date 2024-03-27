import 'dart:convert';

ChildInformation childInformationFromJson(String str) =>
    ChildInformation.fromJson(json.decode(str));

class ChildInformation {
  final String motherName;
  final String fatherName;
  final int childId;
  final int? childClassId;
  final String? childClassName;
  final String? childClassLevel;
  final int childNeedLevel;

  ChildInformation({
    required this.motherName,
    required this.fatherName,
    required this.childId,
    required this.childClassId,
    required this.childClassName,
    required this.childClassLevel,
    required this.childNeedLevel,
  });

  String getNeedsLevel() {
    if (childNeedLevel == 1) {
      return 'الأول';
    } else if (childNeedLevel == 2) {
      return 'الثاني';
    } else if (childNeedLevel == 3) {
      return 'الثالث';
    } else {
      return 'لا يوجد';
    }
  }

  factory ChildInformation.fromJson(Map<String, dynamic> json) =>
      ChildInformation(
        motherName: json['motherName'],
        fatherName: json['guardianName'],
        childId: json['id'],
        childClassId: (json['classChild'] != null)
            ? json['classChild']['cls']['id']
            : null,
        childClassName: (json['classChild'] != null)
            ? json['classChild']['cls']['name']
            : null,
        childClassLevel: (json['classChild'] != null)
            ? json['classChild']['cls']['level']
            : null,
        childNeedLevel: (json['childNeedLevel'] != null)
            ? json['childNeedLevel']['needLevel']
            : 0,
      );
}

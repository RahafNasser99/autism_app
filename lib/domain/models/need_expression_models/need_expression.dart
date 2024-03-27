import 'dart:convert';

import 'package:autism_mobile_app/domain/models/need_expression_models/need.dart';

NeedExpression needExpressionFromJson(String str) =>
    NeedExpression.fromJson(json.decode(str));

class NeedExpression {
  final int needExpressionId;
  final bool needStatus;
  final List<Need> needs;

  NeedExpression({
    required this.needExpressionId,
    required this.needStatus,
    required this.needs,
  });

  factory NeedExpression.fromJson(Map<String, dynamic> json) {
    final extractedNeeds = json['needs'] as List;
    List<Need> comingNeeds = [];
    for (var need in extractedNeeds) {
      comingNeeds.add(Need.fromJson(need));
    }
    return NeedExpression(
      needExpressionId: json['id'],
      needStatus: json['status'],
      needs: comingNeeds,
    );
  }

  @override
  String toString() {
    return 'NeedExpression ( \n'
        'needExpressionId: $needExpressionId, \n'
        'need: ${needs.toString()} \n'
        ')';
  }
}

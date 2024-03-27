import 'dart:convert';

import 'package:autism_mobile_app/domain/models/content_models/content.dart';
import 'package:autism_mobile_app/domain/models/content_models/sound_content.dart';

Need needFromJson(String str) => Need.fromJson(json.decode(str));

class Need {
  final int needId;
  final int needLevel;
  final Content needContent;
  SoundContent? soundNeedContent;

  Need({
    required this.needId,
    required this.needLevel,
    required this.needContent,
    required this.soundNeedContent,
  });

  factory Need.fromJson(Map<String, dynamic> json) {
    return Need(
      needId: json['id'],
      needLevel: json['level'],
      needContent: Content.fromJson(json['content']),
      soundNeedContent: json['sound'] == null
          ? null
          : SoundContent.fromJson(json['sound']),
    );
  }

  @override
  String toString() {
    return 'Need ( \n'
        'needId: $needId \n'
        ', needLevel: $needLevel \n'
        ', needContent: ${needContent.toString()} \n'
        ', soundNeedContent: ${soundNeedContent.toString()} \n'
        ')';
  }
}

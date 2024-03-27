import 'dart:convert';

import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/content_models/content.dart';

SoundContent soundContentFromJson(String str) =>
    SoundContent.fromJson(json.decode(str));

class SoundContent extends Content {
  SoundContent({required int soundId, required String soundUrl})
      : super(contentId: soundId, content: soundUrl);

  factory SoundContent.fromJson(Map<String, dynamic> json) =>
      SoundContent(
        soundId: json['id'],
        soundUrl: Constant.ipAddress + '/' + json['media']['url'],
      );

  @override
  String toString() => 'SoundContent ( \n'
      'contentId: $contentId, \n'
      'content: $content \n'
      ')';
}

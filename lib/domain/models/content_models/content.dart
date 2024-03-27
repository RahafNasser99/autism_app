import 'dart:convert';

import 'package:autism_mobile_app/domain/models/content_models/image_content.dart';
import 'package:autism_mobile_app/domain/models/content_models/word_content.dart';

Content contentFromJson(String str) =>
    Content.fromJson(json.decode(str));

abstract class Content {
  final int contentId;
  final String content;

  const Content({required this.contentId, required this.content});

  factory Content.fromJson(Map<String, dynamic> json) {
    if (json['contentType'] == 'word') {
      return WordContent.fromJson(json);
    }
    return ImageContent.fromJson(json);
  }

  @override
  String toString() => 'Content ( \n'
      'contentId: $contentId, \n'
      'content: $content \n'
      ')';
}

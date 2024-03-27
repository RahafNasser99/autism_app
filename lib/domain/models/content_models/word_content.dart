import 'dart:convert';

import 'package:autism_mobile_app/domain/models/content_models/content.dart';

WordContent wordContentFromJson(String str) =>
    WordContent.fromJson(json.decode(str));

class WordContent extends Content {
  WordContent({required int wordId, required String word})
      : super(contentId: wordId, content: word);

  factory WordContent.fromJson(Map<String, dynamic> json) =>
      WordContent(
        wordId: json['id'],
        word: json['media']['word'],
      );
}

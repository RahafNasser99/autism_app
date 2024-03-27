import 'dart:convert';

import 'package:autism_mobile_app/utils/constant/constant.dart';
import 'package:autism_mobile_app/domain/models/content_models/content.dart';

ImageContent imageContentFromJson(String str) =>
    ImageContent.fromJson(json.decode(str));

class ImageContent extends Content {
  ImageContent({required int imageId, required String imageUrl})
      : super(contentId: imageId, content: imageUrl);

  factory ImageContent.fromJson(Map<String, dynamic> json) =>
      ImageContent(
        imageId: json['id'],
        imageUrl: Constant.ipAddress + '/' + json['media']['url'],
      );
}

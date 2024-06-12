import 'dart:typed_data';

import 'package:flutter_instancy_2/packages/flipcard/flip_card_controller.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class FlashcardModel {
  String flashcard_back = "";
  String flashcard_front = "";
  String imageUrl = '';
  String assetImagePath = '';
  Uint8List? imageBytes;
  FlipCardController controller = FlipCardController();

  FlashcardModel({
    this.flashcard_back = "",
    this.flashcard_front = "",
    this.imageUrl = "",
    this.assetImagePath = "",
    this.imageBytes,
    FlipCardController? controller,
  }) {
    this.controller = controller ?? FlipCardController();
  }

  FlashcardModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    flashcard_back = map["flashcard_back"] != null ? ParsingHelper.parseStringMethod(map["flashcard_back"]) : flashcard_back;
    flashcard_front = map["flashcard_front"] != null ? ParsingHelper.parseStringMethod(map["flashcard_front"]) : flashcard_front;
    imageUrl = map["imageUrl"] != null ? ParsingHelper.parseStringMethod(map["imageUrl"]) : imageUrl;
    assetImagePath = map["assetImagePath"] != null ? ParsingHelper.parseStringMethod(map["assetImagePath"]) : assetImagePath;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "flashcard_back": flashcard_back,
      "flashcard_front": flashcard_front,
      "imageUrl": imageUrl,
      "assetImagePath": assetImagePath,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

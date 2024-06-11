import 'dart:typed_data';

import 'package:flutter_instancy_2/packages/flipcard/flip_card_controller.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class FlashcardResponseModel {
  List<FlashcardModel> flashcards = const [];

  FlashcardResponseModel({this.flashcards = const []});

  FlashcardResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['flashcards'] != null) {
      flashcards = <FlashcardModel>[];
      json['flashcards'].forEach((v) {
        flashcards.add(FlashcardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flashcards'] = flashcards.map((v) => v.toJson()).toList();
    return data;
  }
}

class FlashcardModel {
  String flashcardFront = "";
  String flashcardBack = "";
  String imageUrl = '';
  String assetImagePath = '';
  Uint8List? imageBytes;
  FlipCardController controller = FlipCardController();

  FlashcardModel({
    this.flashcardFront = "",
    this.flashcardBack = "",
    this.imageUrl = "",
    this.assetImagePath = "",
    this.imageBytes,
    FlipCardController? controller,
  }) {
    this.controller = controller ?? FlipCardController();
  }

  FlashcardModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    flashcardFront = ParsingHelper.parseStringMethod(map['flashcard_front']);
    flashcardBack = ParsingHelper.parseStringMethod(map['flashcard_back']);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "flashcard_front": flashcardFront,
      "flashcard_back": flashcardBack,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}

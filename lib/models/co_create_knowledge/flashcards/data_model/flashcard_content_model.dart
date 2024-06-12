import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import 'flashcard_model.dart';

class FlashcardContentModel {
  String backgroundColor = "";
  String queryUrl = "";
  int cardCount = 0;
  List<FlashcardModel> flashcards = <FlashcardModel>[];

  FlashcardContentModel({
    this.backgroundColor = "",
    this.queryUrl = "",
    this.cardCount = 0,
    List<FlashcardModel>? flashcards,
  }) {
    flashcards = flashcards ?? <FlashcardModel>[];
  }

  FlashcardContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    backgroundColor = map["backgroundColor"] != null ? ParsingHelper.parseStringMethod(map["backgroundColor"]) : backgroundColor;
    queryUrl = map["queryUrl"] != null ? ParsingHelper.parseStringMethod(map["queryUrl"]) : queryUrl;
    cardCount = map["cardCount"] != null ? ParsingHelper.parseIntMethod(map["cardCount"]) : cardCount;

    if (map["flashcards"] != null) {
      List<Map<String, dynamic>> flashcardMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["flashcards"]);
      flashcards = flashcardMapsList.map((e) => FlashcardModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "backgroundColor": backgroundColor,
      "queryUrl": queryUrl,
      "cardCount": cardCount,
      "flashcards": flashcards.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GeneratedFlashcardResponseModel {
  List<FlashcardModel> flashcards = <FlashcardModel>[];

  GeneratedFlashcardResponseModel({
    List<FlashcardModel>? flashcards,
  }) {
    this.flashcards = flashcards ?? <FlashcardModel>[];
  }

  GeneratedFlashcardResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["flashcards"] != null) {
      flashcards.clear();
      List<Map<String, dynamic>> flashcardMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["flashcards"]);
      flashcards.addAll(flashcardMapsList.map((e) => FlashcardModel.fromMap(e)));
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "flashcards": flashcards.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learningt_page_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MicroLearningContentModel {
  // MicroLearningSourceSelectionTypes value
  String selectedSourceType = "";
  String contentUrl = "";
  int pageCount = 0;
  int wordsPerPageCount = 0;
  bool isGenerateTextEnabled = false;
  bool isGenerateImageEnabled = false;
  bool isGenerateAudioEnabled = false;
  bool isGenerateVideoEnabled = false;
  bool isGenerateQuizEnabled = false;
  List<String> selectedTopics = <String>[];
  List<MicroLearningPageModel> pages = <MicroLearningPageModel>[];

  MicroLearningContentModel({
    this.selectedSourceType = "",
    this.contentUrl = "",
    this.pageCount = 0,
    this.wordsPerPageCount = 0,
    this.isGenerateTextEnabled = false,
    this.isGenerateImageEnabled = false,
    this.isGenerateAudioEnabled = false,
    this.isGenerateVideoEnabled = false,
    this.isGenerateQuizEnabled = false,
    List<String>? selectedTopics,
    List<MicroLearningPageModel>? pages,
  }) {
    this.selectedTopics = selectedTopics ?? <String>[];
    this.pages = pages ?? <MicroLearningPageModel>[];
  }

  MicroLearningContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    selectedSourceType = map["selectedSourceType"] != null ? ParsingHelper.parseStringMethod(map["selectedSourceType"]) : selectedSourceType;
    contentUrl = map["contentUrl"] != null ? ParsingHelper.parseStringMethod(map["contentUrl"]) : contentUrl;
    pageCount = map["pageCount"] != null ? ParsingHelper.parseIntMethod(map["pageCount"]) : pageCount;
    wordsPerPageCount = map["wordsPerPageCount"] != null ? ParsingHelper.parseIntMethod(map["wordsPerPageCount"]) : wordsPerPageCount;
    isGenerateTextEnabled = map["isGenerateTextEnabled"] != null ? ParsingHelper.parseBoolMethod(map["isGenerateTextEnabled"]) : isGenerateTextEnabled;
    isGenerateImageEnabled = map["isGenerateImageEnabled"] != null ? ParsingHelper.parseBoolMethod(map["isGenerateImageEnabled"]) : isGenerateImageEnabled;
    isGenerateAudioEnabled = map["isGenerateAudioEnabled"] != null ? ParsingHelper.parseBoolMethod(map["isGenerateAudioEnabled"]) : isGenerateAudioEnabled;
    isGenerateVideoEnabled = map["isGenerateVideoEnabled"] != null ? ParsingHelper.parseBoolMethod(map["isGenerateVideoEnabled"]) : isGenerateVideoEnabled;
    isGenerateQuizEnabled = map["isGenerateQuizEnabled"] != null ? ParsingHelper.parseBoolMethod(map["isGenerateQuizEnabled"]) : isGenerateQuizEnabled;
    selectedTopics = map["selectedTopics"] != null ? ParsingHelper.parseListMethod<dynamic, String>(map["selectedTopics"]) : selectedTopics;

    if (map["pages"] != null) {
      List<Map<String, dynamic>> pagesMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["pages"]);
      pages = pagesMapsList.map((e) => MicroLearningPageModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "selectedSourceType": selectedSourceType,
      "contentUrl": contentUrl,
      "pageCount": pageCount,
      "wordsPerPageCount": wordsPerPageCount,
      "isGenerateTextEnabled": isGenerateTextEnabled,
      "isGenerateImageEnabled": isGenerateImageEnabled,
      "isGenerateAudioEnabled": isGenerateAudioEnabled,
      "isGenerateVideoEnabled": isGenerateVideoEnabled,
      "isGenerateQuizEnabled": isGenerateQuizEnabled,
      "selectedTopics": selectedTopics,
      "pages": pages.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

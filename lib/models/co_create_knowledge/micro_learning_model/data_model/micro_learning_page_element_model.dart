import 'dart:typed_data';

import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:video_player/video_player.dart';

class MicroLearningPageElementModel {
  String htmlContentCode = "";
  String elementType = MicroLearningElementType.Text;
  String imageUrl = "";
  String videoUrl = "";
  String audioUrl = "";
  String imageFileName = "";
  String videoFileName = "";
  String audioFileName = "";
  Uint8List? imageBytes;
  Uint8List? videoBytes;
  Uint8List? audioBytes;
  List<QuizQuestionModel> quizQuestionModels = <QuizQuestionModel>[];
  HtmlEditorController? htmlEditorController;
  VideoPlayerController? videoPlayerController;

  MicroLearningPageElementModel({
    this.htmlContentCode = "",
    this.elementType = MicroLearningElementType.Text,
    this.imageUrl = "",
    this.videoUrl = "",
    this.audioUrl = "",
    this.imageFileName = "",
    this.videoFileName = "",
    this.audioFileName = "",
    this.imageBytes,
    this.videoBytes,
    this.audioBytes,
    List<QuizQuestionModel>? quizQuestionModels,
    this.htmlEditorController,
    this.videoPlayerController,
  }) {
    this.quizQuestionModels = quizQuestionModels ?? <QuizQuestionModel>[];
  }

  MicroLearningPageElementModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    htmlContentCode = map["htmlContentCode"] != null ? ParsingHelper.parseStringMethod(map["htmlContentCode"]) : htmlContentCode;
    elementType = map["elementType"] != null ? ParsingHelper.parseStringMethod(map["elementType"]) : elementType;
    imageUrl = map["imageUrl"] != null ? ParsingHelper.parseStringMethod(map["imageUrl"]) : imageUrl;
    videoUrl = map["videoUrl"] != null ? ParsingHelper.parseStringMethod(map["videoUrl"]) : videoUrl;
    audioUrl = map["audioUrl"] != null ? ParsingHelper.parseStringMethod(map["audioUrl"]) : audioUrl;
    imageFileName = map["imageFileName"] != null ? ParsingHelper.parseStringMethod(map["imageFileName"]) : imageFileName;
    videoFileName = map["videoFileName"] != null ? ParsingHelper.parseStringMethod(map["videoFileName"]) : videoFileName;
    audioFileName = map["audioFileName"] != null ? ParsingHelper.parseStringMethod(map["audioFileName"]) : audioFileName;

    imageBytes = map["imageBytes"] is Uint8List ? map["imageBytes"] : imageBytes;
    videoBytes = map["videoBytes"] is Uint8List ? map["videoBytes"] : videoBytes;
    audioBytes = map["audioBytes"] is Uint8List ? map["audioBytes"] : audioBytes;

    if (map["quizQuestionModels"] != null) {
      quizQuestionModels.clear();
      List<Map<String, dynamic>> quizQuestionModelMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["quizQuestionModel"]);
      for (Map<String, dynamic> quizQuestionModelMap in quizQuestionModelMapsList) {
        if (quizQuestionModelMap.isNotEmpty) {
          QuizQuestionModel quizQuestionModel = QuizQuestionModel.fromMap(quizQuestionModelMap);
          quizQuestionModels.add(quizQuestionModel);
        }
      }
    }
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "htmlContentCode": htmlContentCode,
      "elementType": elementType,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "audioUrl": audioUrl,
      "imageFileName": imageFileName,
      "videoFileName": videoFileName,
      "audioFileName": audioFileName,
      "imageBytes": toJson ? null : imageBytes,
      "videoBytes": toJson ? null : videoBytes,
      "audioBytes": toJson ? null : audioBytes,
      "quizQuestionModels": quizQuestionModels.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

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
  String contentUrl = "";
  String contentFileName = "";
  Uint8List? contentBytes;
  List<QuizQuestionModel> quizQuestionModels = <QuizQuestionModel>[];
  HtmlEditorController? htmlEditorController;
  VideoPlayerController? videoPlayerController;

  MicroLearningPageElementModel({
    this.htmlContentCode = "",
    this.elementType = MicroLearningElementType.Text,
    this.contentUrl = "",
    this.contentFileName = "",
    this.contentBytes,
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
    contentUrl = map["contentUrl"] != null ? ParsingHelper.parseStringMethod(map["contentUrl"]) : contentUrl;
    contentFileName = map["contentFileName"] != null ? ParsingHelper.parseStringMethod(map["contentFileName"]) : contentFileName;

    contentBytes = map["contentBytes"] is Uint8List ? map["contentBytes"] : contentBytes;

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
      "contentUrl": contentUrl,
      "contentFileName": contentFileName,
      "contentBytes": toJson ? (contentBytes != null ? MyUtils.convertBytesToBase64(bytes: contentBytes!, fileName: contentFileName) : null) : contentBytes,
      "quizQuestionModels": quizQuestionModels.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

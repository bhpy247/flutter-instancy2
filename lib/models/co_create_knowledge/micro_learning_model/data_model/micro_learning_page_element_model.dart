import 'dart:typed_data';

import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MicroLearningPageElementModel {
  String htmlContentCode = "";
  String elementType = MicroLearningElementType.Text;
  String title = "";
  String imageUrl = "";
  String videoUrl = "";
  String audioUrl = "";
  Uint8List? imageBytes;
  Uint8List? videoBytes;
  Uint8List? audioBytes;
  QuizQuestionModel? quizQuestionModel;

  MicroLearningPageElementModel({
    this.htmlContentCode = "",
    this.elementType = MicroLearningElementType.Text,
    this.title = "",
    this.imageUrl = "",
    this.videoUrl = "",
    this.audioUrl = "",
    this.imageBytes,
    this.videoBytes,
    this.audioBytes,
    this.quizQuestionModel,
  });

  MicroLearningPageElementModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    htmlContentCode = map["htmlContentCode"] != null ? ParsingHelper.parseStringMethod(map["htmlContentCode"]) : htmlContentCode;
    elementType = map["elementType"] != null ? ParsingHelper.parseStringMethod(map["elementType"]) : elementType;
    title = map["title"] != null ? ParsingHelper.parseStringMethod(map["title"]) : title;
    imageUrl = map["imageUrl"] != null ? ParsingHelper.parseStringMethod(map["imageUrl"]) : imageUrl;
    videoUrl = map["videoUrl"] != null ? ParsingHelper.parseStringMethod(map["videoUrl"]) : videoUrl;
    audioUrl = map["audioUrl"] != null ? ParsingHelper.parseStringMethod(map["audioUrl"]) : audioUrl;

    Map<String, dynamic>? quizQuestionModelMap = map["quizQuestionModel"] != null ? ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["quizQuestionModel"]) : null;
    if (quizQuestionModelMap.checkNotEmpty) {
      quizQuestionModel = QuizQuestionModel.fromMap(quizQuestionModelMap!);
    } else {
      quizQuestionModel = null;
    }
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "htmlContentCode": htmlContentCode,
      "elementType": elementType,
      "title": title,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "audioUrl": audioUrl,
      "quizQuestionModel": quizQuestionModel?.toMap(toJson: toJson),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/event/data_model/event_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

class CoCreateContentAuthoringModel {
  int contentTypeId = 0;
  String contentType = "Test";
  String title = "";
  String description = "";
  List<String> skills = <String>[];
  Uint8List? thumbNailImageBytes;
  Uint8List? uploadedDocumentBytes;
  String? uploadedDocumentName;
  String? referenceUrl;
  String? articleHtmlCode;
  String? selectedArticleSourceType;
  CourseDTOModel? courseDTOModel;
  CourseDTOModel? newCurrentCourseDTOModel;
  bool isEdit = false;
  FlashcardContentModel? flashcardContentModel;
  QuizContentModel? quizContentModel;
  RoleplayContentModel? roleplayContentModel;
  EventModel? eventModel;

  CoCreateContentAuthoringModel({
    this.contentTypeId = 0,
    this.contentType = "Test",
    this.title = "",
    this.description = "",
    List<String>? skills,
    this.thumbNailImageBytes,
    this.uploadedDocumentBytes,
    this.articleHtmlCode,
    this.selectedArticleSourceType,
    this.courseDTOModel,
    this.newCurrentCourseDTOModel,
    this.isEdit = false,
    this.flashcardContentModel,
    this.quizContentModel,
    this.roleplayContentModel,
    this.uploadedDocumentName,
    this.referenceUrl,
    this.eventModel,
  }) {
    this.skills = skills ?? <String>[];
  }
}

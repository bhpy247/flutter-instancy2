import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

class CoCreateContentAuthoringModel {
  int contentTypeId = 0;
  String contentType = "Test";
  String title = "";
  String description = "";
  List<String> skills = <String>[];
  Uint8List? thumbNailImageBytes;
  Uint8List? uploadedDocumentBytes;
  String? articleHtmlCode;
  String? selectedArticleSourceType;
  CourseDTOModel? courseDTOModel;
  CourseDTOModel? newCurrentCourseDTOModel;
  bool isEdit = false;
  FlashcardContentModel? flashcardContentModel;

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
  }) {
    this.skills = skills ?? <String>[];
  }
}

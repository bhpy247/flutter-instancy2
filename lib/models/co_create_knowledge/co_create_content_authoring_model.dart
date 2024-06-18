import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/data_model/article_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/event/data_model/event_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/learning_path/data_model/learning_path_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/data_model/podcast_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

class CoCreateContentAuthoringModel {
  CoCreateAuthoringType coCreateAuthoringType;
  int contentTypeId = 0;
  int mediaTypeId = 0;
  String contentId = "";
  String contentType = "Test";
  String title = "";
  String description = "";
  String ThumbnailImagePath = "";
  String ThumbnailImageName = "";
  Uint8List? thumbNailImageBytes;
  Uint8List? uploadedDocumentBytes;
  String? uploadedDocumentName;
  String? referenceUrl;
  String startPage = "";
  CourseDTOModel? courseDTOModel;
  CourseDTOModel? newCurrentCourseDTOModel;
  bool isEdit = false;
  FlashcardContentModel? flashcardContentModel;
  QuizContentModel? quizContentModel;
  ArticleContentModel? articleContentModel;
  PodcastContentModel? podcastContentModel;
  EventModel? eventModel;
  MicroLearningContentModel? microLearningContentModel;
  RoleplayContentModel? roleplayContentModel;
  LearningPathContentModel? learningPathContentModel;
  VideoContentModel? videoContentModel;
  List<String> skills = <String>[];
  Map<String, String> skillsMap = <String, String>{};
  Map<String, String> oldSkillsMap = <String, String>{};

  CoCreateContentAuthoringModel({
    required this.coCreateAuthoringType,
    this.contentTypeId = 0,
    this.mediaTypeId = 0,
    this.contentId = "",
    this.contentType = "Test",
    this.title = "",
    this.description = "",
    this.ThumbnailImagePath = "",
    this.ThumbnailImageName = "",
    this.thumbNailImageBytes,
    this.uploadedDocumentBytes,
    this.courseDTOModel,
    this.newCurrentCourseDTOModel,
    this.isEdit = false,
    this.uploadedDocumentName,
    this.referenceUrl,
    this.startPage = "",
    this.flashcardContentModel,
    this.quizContentModel,
    this.articleContentModel,
    this.podcastContentModel,
    this.eventModel,
    this.microLearningContentModel,
    this.roleplayContentModel,
    this.learningPathContentModel,
    this.videoContentModel,
    List<String>? skills,
    Map<String, String>? skillsMap,
    Map<String, String>? oldSkillsMap,
  }) {
    this.skills = skills ?? <String>[];
    this.skillsMap = skillsMap ?? <String, String>{};
    this.oldSkillsMap = oldSkillsMap ?? <String, String>{};
  }
}

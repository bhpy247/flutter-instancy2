import 'flashcard_model.dart';

class FlashcardRequestModel {
  String topicName = "";
  String difficultyLevel = "";
  String clientUrl = "";
  int flashcardCount = 0;
  String requestedBy = "";
  List<FlashcardModel> flashcards = const [];
  List<FlashcardModel> regenerateCards = const [];
  int userID = 0;
  int siteID = 0;
  String description = "";

  FlashcardRequestModel(
      {this.topicName = "",
      this.difficultyLevel = "",
      this.clientUrl = "",
      this.flashcardCount = 0,
      this.requestedBy = "",
      this.flashcards = const [],
      this.regenerateCards = const [],
      this.userID = 0,
      this.siteID = 0,
      this.description = ""});

  Map<String, dynamic> toMap() {
    return {
      'topic_name': topicName,
      'difficulty_level': difficultyLevel,
      'client_url': clientUrl,
      'flashcard_count': flashcardCount,
      'requestedBy': requestedBy,
      'Flashcards': flashcards.map((v) => v.toJson()).toList(),
      'RegenerateCards': regenerateCards.map((v) => v.toJson()).toList(),
      'userId': userID,
      'siteId': siteID,
      'description': description,
    };
  }
}

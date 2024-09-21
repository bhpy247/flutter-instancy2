import 'package:flutter_chat_bot/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class GenerateWholeArticleContentRequestModel {
  String title = "";
  String clientUrl = "";
  String source = "";
  int numberOfTopics = 0;
  int wordsCount = 0;

  GenerateWholeArticleContentRequestModel({
    this.title = "",
    this.clientUrl = "",
    this.source = "",
    this.numberOfTopics = 0,
    this.wordsCount = 0,
  });

  GenerateWholeArticleContentRequestModel.fromJson(Map<String, dynamic> json) {
    title = ParsingHelper.parseStringMethod(json['topicTitle']);
    clientUrl = ParsingHelper.parseStringMethod(json['client_url']);
    source = ParsingHelper.parseStringMethod(json['source']);
    numberOfTopics = ParsingHelper.parseIntMethod(json['numberOfTopics']);
    wordsCount = ParsingHelper.parseIntMethod(json['words_count']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'topicTitle': title,
      'client_url': clientUrl,
      'source': source,
      'numberOfTopics': numberOfTopics,
      'words_count': wordsCount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

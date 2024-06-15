import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class ArticleResponseModel {
  List<Article> article = [];

  ArticleResponseModel({this.article = const []});

  ArticleResponseModel.fromMap(Map<String, dynamic> map) {
    if (map["article"] != null) {
      article.clear();
      List<Map<String, dynamic>> articleMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["article"]);
      article.addAll(articleMapsList.map((e) => Article.fromJson(e)));
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "article": article.map((v) => v.toJson()).toList(),
    };
  }
}

class Article {
  String content = "";
  String title = "";

  Article({this.content = "", this.title = ""});

  Article.fromJson(Map<String, dynamic> json) {
    _initializeMap(json);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeMap(map);
  }

  void _initializeMap(Map<String, dynamic> map) {
    content = ParsingHelper.parseStringMethod(map['content']);
    title = ParsingHelper.parseStringMethod(map['title']);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return {
      'content': content,
      'title': title,
    };
  }
}

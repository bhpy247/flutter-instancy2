import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ArticleContentModel {
  String articleHtmlCode = "";
  String selectedArticleSourceType = "";
  String contentUrl = "";

  ArticleContentModel({
    this.articleHtmlCode = "",
    this.selectedArticleSourceType = "",
    this.contentUrl = "",
  });

  ArticleContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    articleHtmlCode = map["articleHtmlCode"] != null ? ParsingHelper.parseStringMethod(map["articleHtmlCode"]) : articleHtmlCode;
    selectedArticleSourceType = map["selectedArticleSourceType"] != null ? ParsingHelper.parseStringMethod(map["selectedArticleSourceType"]) : selectedArticleSourceType;
    contentUrl = map["contentUrl"] != null ? ParsingHelper.parseStringMethod(map["contentUrl"]) : contentUrl;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "articleHtmlCode": articleHtmlCode,
      "contentUrl": contentUrl,
      "selectedArticleSourceType": selectedArticleSourceType,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

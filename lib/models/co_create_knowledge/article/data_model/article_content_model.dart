import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ArticleContentModel {
  String articleHtmlCode = "";
  String selectedArticleSourceType = "";

  ArticleContentModel({
    this.articleHtmlCode = "",
    this.selectedArticleSourceType = "",
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
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "articleHtmlCode": articleHtmlCode,
      "selectedArticleSourceType": selectedArticleSourceType,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

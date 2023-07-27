import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/forum_model.dart';

class ForumListingDTOResponseModel {
  List<ForumModel> forumList = [];
  int TotalRecordCount = 0;

  ForumListingDTOResponseModel({
    List<ForumModel>? forumList,
    this.TotalRecordCount = 0
  }) {
    this.forumList = forumList ?? <ForumModel>[];
  }

  ForumListingDTOResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> forumListMapsList = ParsingHelper.parseMapsListMethod(json["forumList"]);
    forumList.addAll(forumListMapsList.map((e) => ForumModel.fromJson(e)).toList());

    TotalRecordCount = ParsingHelper.parseIntMethod(json["TotalRecordCount"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "forumList" : forumList.map((e) => e.toJson()).toList(),
      "TotalRecordCount" : TotalRecordCount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
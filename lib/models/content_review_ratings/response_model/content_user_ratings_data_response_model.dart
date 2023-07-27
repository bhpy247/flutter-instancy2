import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../data_model/content_user_rating_model.dart';

class ContentUserRatingsDataResponseModel {
  int recordCount = 0;
  List<ContentUserRatingModel> userRatingDetails = [];
  ContentUserRatingModel? editRating;

  ContentUserRatingsDataResponseModel({
    this.recordCount = 0,
    List<ContentUserRatingModel>? userRatingDetails,
    this.editRating,
  }) {
    this.userRatingDetails = userRatingDetails ?? <ContentUserRatingModel>[];
  }

  ContentUserRatingsDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    recordCount = ParsingHelper.parseIntMethod(map["RecordCount"]);
    userRatingDetails = ParsingHelper.parseMapsListMethod<String, dynamic>(map['UserRatingDetails']).map((e) => ContentUserRatingModel.fromJson(e)).toList();

    Map<String, dynamic> editRatingMap = ParsingHelper.parseMapMethod(map['EditRating']);
    if(editRatingMap.isNotEmpty) {
      editRating = ContentUserRatingModel.fromJson(editRatingMap);
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "RecordCount" : recordCount,
      "UserRatingDetails" : userRatingDetails.map((e) => e.toJson()).toList(),
      "EditRating" : editRating?.toJson(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}


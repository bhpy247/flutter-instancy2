import '../data_model/topic_model.dart';
import 'like_dislike_list_response_model.dart';

class LikeDislikeDtoResponseModel {
  List<LikeDislikeListResponse> likeDislikeList = [];

  LikeDislikeDtoResponseModel({this.likeDislikeList = const []});

  LikeDislikeDtoResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['TopicList'] != null) {
      json['TopicList'].forEach((v) {
        likeDislikeList.add(LikeDislikeListResponse.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TopicList'] = likeDislikeList.map((v) => v.toMp()).toList();
    return data;
  }
}

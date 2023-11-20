import '../data_model/topic_model.dart';

class DiscussionTopicDTOResponseModel {
  List<TopicModel> topicList = [];

  DiscussionTopicDTOResponseModel({this.topicList = const []});

  DiscussionTopicDTOResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['TopicList'] != null) {
      json['TopicList'].forEach((v) {
        topicList.add(TopicModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TopicList'] = topicList.map((v) => v.toJson()).toList();
    return data;
  }
}

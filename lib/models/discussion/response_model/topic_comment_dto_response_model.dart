import '../data_model/topic_comment_model.dart';

class TopicCommentDtoResponseModel {
  List<TopicCommentModel> table = [];

  /*DiscussionTopicCommentResponse({
    this.table,
  });*/

  TopicCommentDtoResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(TopicCommentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = table.map((v) => v.toJson()).toList();

    return data;
  }
}

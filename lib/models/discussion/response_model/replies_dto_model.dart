import '../data_model/comment_reply_model.dart';

class RepliesDTOModel {
  List<CommentReplyModel>? Table;

  RepliesDTOModel({
    this.Table,
  });

  RepliesDTOModel.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      Table = <CommentReplyModel>[];
      json['Table'].forEach((v) {
        Table!.add(CommentReplyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (Table != null) {
      data['Table'] = Table!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CommentReplyModel {
  String topicID = "";
  String message = "";
  String postedDate = "";
  String replyBy = "";
  String picture = "";
  String replyProfile = "";
  String dtPostedDate = "";
  int replyID = 0;
  int commentID = 0;
  int forumID = 0;
  int postedBy = 0;
  bool likeState = false;

  CommentReplyModel({
    this.topicID = "",
    this.message = "",
    this.postedDate = "",
    this.replyBy = "",
    this.picture = "",
    this.replyProfile = "",
    this.dtPostedDate = "",
    this.forumID = 0,
    this.replyID = 0,
    this.commentID = 0,
    this.postedBy = 0,
    this.likeState = false,
  });

  CommentReplyModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    replyID = ParsingHelper.parseIntMethod(json["ReplyID"]);
    commentID = ParsingHelper.parseIntMethod(json["CommentID"]);
    topicID = ParsingHelper.parseStringMethod(json["TopicID"]);
    forumID = ParsingHelper.parseIntMethod(json["ForumID"]);
    message = ParsingHelper.parseStringMethod(json["Message"]);
    postedBy = ParsingHelper.parseIntMethod(json["PostedBy"]);
    postedDate = ParsingHelper.parseStringMethod(json["PostedDate"]);
    replyBy = ParsingHelper.parseStringMethod(json["ReplyBy"]);
    picture = ParsingHelper.parseStringMethod(json["Picture"]);
    likeState = ParsingHelper.parseBoolMethod(json["likeState"]);
    replyProfile = ParsingHelper.parseStringMethod(json["ReplyProfile"]);
    dtPostedDate = ParsingHelper.parseStringMethod(json["dtPostedDate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ReplyID": replyID,
      "CommentID": commentID,
      "TopicID": topicID,
      "ForumID": forumID,
      "Message": message,
      "PostedBy": postedBy,
      "PostedDate": postedDate,
      "ReplyBy": replyBy,
      "Picture": picture,
      "likeState": likeState,
      "ReplyProfile": replyProfile,
      "dtPostedDate": dtPostedDate,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

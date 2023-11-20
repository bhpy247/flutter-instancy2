class DiscussionCommentListResponse {
  int commentID = 0;
  String topicID = "";
  int forumID = 0;
  String postedDate = "";
  String message = "";
  int postedBy = 0;
  int siteID = 0;
  String replyID = "";
  String commentedBy = "";
  String commentedFromDays = "";
  String commentFileUploadPath = "";
  String commentFileUploadName = "";
  String commentImageUploadName = "";
  String commentUploadIconPath = "";
  bool likeState = false;
  int commentLikes = 0;
  int commentRepliesCount = 0;
  String commentUserProfile = "";
  dynamic likedUserList;

  DiscussionCommentListResponse.fromJson(Map<String, dynamic> json) {
    commentID = json['commentid'];
    topicID = json['topicid'];
    forumID = json['forumid'];
    postedDate = json['posteddate'];
    message = json['message'];
    postedBy = json['postedby'];
    siteID = json['siteid'];
    replyID = json['ReplyID'];
    commentedBy = json['CommentedBy'];
    commentedFromDays = json['CommentedFromDays'];
    commentFileUploadPath = json['CommentFileUploadPath'];
    commentFileUploadName = json['CommentFileUploadName'];
    commentImageUploadName = json['CommentImageUploadName'];
    commentUploadIconPath = json['CommentUploadIconPath'];
    likeState = json['likeState'];
    commentLikes = json['CommentLikes'];
    commentRepliesCount = json['CommentRepliesCount'];
    commentUserProfile = json['CommentUserProfile'];
    likedUserList = json['LikedUserList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentid'] = commentID;
    data['topicid'] = topicID;
    data['forumid'] = forumID;
    data['posteddate'] = postedDate;
    data['message'] = message;
    data['postedby'] = postedBy;
    data['siteid'] = siteID;
    data['ReplyID'] = replyID;
    data['CommentedBy'] = commentedBy;
    data['CommentedFromDays'] = commentedFromDays;
    data['CommentFileUploadPath'] = commentFileUploadPath;
    data['CommentFileUploadName'] = commentFileUploadName;
    data['CommentImageUploadName'] = commentImageUploadName;
    data['CommentUploadIconPath'] = commentUploadIconPath;
    data['likeState'] = likeState;
    data['CommentLikes'] = commentLikes;
    data['CommentRepliesCount'] = commentRepliesCount;
    data['CommentUserProfile'] = commentUserProfile;
    data['LikedUserList'] = likedUserList;
    return data;
  }
}

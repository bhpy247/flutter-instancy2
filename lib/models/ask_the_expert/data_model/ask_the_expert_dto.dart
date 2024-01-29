import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/answer_comment_dto.dart';

class AskTheExpertDto {
  List<UserQuestionListDto> userQuestionListDto = [];
  List<QuestionAnswerResponse> questionAnswerResponse = [];

  // List<QuestionAnswerResponse1>? table2;
  List<UpVotesUsers>? upVotesUsers;

  AskTheExpertDto({
    this.userQuestionListDto = const [],
    this.questionAnswerResponse = const [],
    this.upVotesUsers,
  });

  AskTheExpertDto.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      userQuestionListDto = <UserQuestionListDto>[];
      json['Table'].forEach((v) {
        userQuestionListDto.add(UserQuestionListDto.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      questionAnswerResponse = <QuestionAnswerResponse>[];
      json['Table1'].forEach((v) {
        questionAnswerResponse.add(QuestionAnswerResponse.fromJson(v));
      });
    }
    // if (json['Table2'] != null) {
    //   table2 = <Table2>[];
    //   json['Table2'].forEach((v) {
    //     table2!.add(new Table2.fromJson(v));
    //   });
    // }
    // if (json['Table3'] != null) {
    //   table3 = <Table3>[];
    //   json['Table3'].forEach((v) {
    //     table3!.add(new Table3.fromJson(v));
    //   });
    // }
    if (json['UpVotesUsers'] != null) {
      upVotesUsers = <UpVotesUsers>[];
      json['UpVotesUsers'].forEach((v) {
        upVotesUsers!.add(UpVotesUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = userQuestionListDto.map((v) => v.toJson()).toList();
    data['Table1'] = questionAnswerResponse.map((v) => v.toJson()).toList();
    // if (table2 != null) {
    //   data['Table2'] = table2!.map((v) => v.toJson()).toList();
    // }
    // if (table3 != null) {
    //   data['Table3'] = table3!.map((v) => v.toJson()).toList();
    // }
    if (upVotesUsers != null) {
      data['UpVotesUsers'] = upVotesUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserQuestionListDto {
  int questionID = 0;
  int userID = 0;
  int views = 0;
  int objectID = 0;
  String userName = "";
  String userImage = "";
  String Answers = "";

  String picture = "";
  String userQuestion = "";
  String postedDate = "";
  String createdDate = "";
  String questionCategories = "";
  String userQuestionImage = "";
  String userQuestionDescription = "";
  String lastActivatedDate = "";
  String lastActiveDate = "";
  String titleWithLink = "";
  String answersWithLink = "";
  String answerBtnWithLink = "";
  String deleteBtnWithLink = "";
  String actionsLink = "";
  String actionSuggestConnection = "";
  String actionSharewithFriends = "";
  String userQuestionImagePath = "";
  String userQuestionImageUploadName = "";
  String userQuestionUploadIconPath = "";
  bool isPublic = false;
  bool isLoadingTopics = false;

  List<QuestionAnswerResponse> questionsAnswerList = [];

  UserQuestionListDto({
    this.questionID = 0,
    this.userID = 0,
    this.views = 0,
    this.objectID = 0,
    this.userName = "",
    this.picture = "",
    this.userQuestion = "",
    this.Answers = "",
    this.postedDate = "",
    this.createdDate = "",
    this.questionCategories = "",
    this.userQuestionImage = "",
    this.userQuestionDescription = "",
    this.lastActivatedDate = "",
    this.lastActiveDate = "",
    this.titleWithLink = "",
    this.answersWithLink = "",
    this.userImage = "",
    this.answerBtnWithLink = "",
    this.deleteBtnWithLink = "",
    this.actionsLink = "",
    this.actionSuggestConnection = "",
    this.actionSharewithFriends = "",
    this.userQuestionImagePath = "",
    this.userQuestionImageUploadName = "",
    this.userQuestionUploadIconPath = "",
    this.isPublic = false,
    this.isLoadingTopics = false,
    List<QuestionAnswerResponse>? questionsAnswerList,
  }) {
    this.questionsAnswerList = questionsAnswerList ?? List<QuestionAnswerResponse>.empty(growable: true);
  }

  UserQuestionListDto.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    questionID = ParsingHelper.parseIntMethod(json['QuestionID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    views = ParsingHelper.parseIntMethod(json['Views']);
    objectID = ParsingHelper.parseIntMethod(json['ObjectID']);
    userName = ParsingHelper.parseStringMethod(json['UserName']);
    Answers = ParsingHelper.parseStringMethod(json['Answers']);
    picture = ParsingHelper.parseStringMethod(json['Picture']);
    userQuestion = ParsingHelper.parseStringMethod(json['UserQuestion']);
    postedDate = ParsingHelper.parseStringMethod(json['PostedDate']);
    createdDate = ParsingHelper.parseStringMethod(json['CreatedDate']);
    questionCategories = ParsingHelper.parseStringMethod(json['QuestionCategories']);
    userQuestionImage = ParsingHelper.parseStringMethod(json['UserQuestionImage']);
    userQuestionDescription = ParsingHelper.parseStringMethod(json['UserQuestionDescription']);
    lastActivatedDate = ParsingHelper.parseStringMethod(json['LastActivatedDate']);
    lastActiveDate = ParsingHelper.parseStringMethod(json['LastActiveDate']);
    titleWithLink = ParsingHelper.parseStringMethod(json['TitleWithLink']);
    answersWithLink = ParsingHelper.parseStringMethod(json['AnswersWithLink']);
    userImage = ParsingHelper.parseStringMethod(json['UserImage']);
    answerBtnWithLink = ParsingHelper.parseStringMethod(json['AnswerBtnWithLink']);
    deleteBtnWithLink = ParsingHelper.parseStringMethod(json['DeleteBtnWithLink']);
    actionsLink = ParsingHelper.parseStringMethod(json['ActionsLink']);
    actionSuggestConnection = ParsingHelper.parseStringMethod(json['actionSuggestConnection']);
    actionSharewithFriends = ParsingHelper.parseStringMethod(json['actionSharewithFriends']);
    userQuestionImagePath = ParsingHelper.parseStringMethod(json['UserQuestionImagePath']);
    userQuestionImageUploadName = ParsingHelper.parseStringMethod(json['UserQuestionImageUploadName']);
    userQuestionUploadIconPath = ParsingHelper.parseStringMethod(json['UserQuestionUploadIconPath']);
    isPublic = ParsingHelper.parseBoolMethod(json['IsPublic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'QuestionID': questionID,
      'UserID': userID,
      'Views': views,
      'ObjectID': objectID,
      'UserName': userName,
      'Picture': picture,
      'Answers': Answers,
      'UserQuestion': userQuestion,
      'PostedDate': postedDate,
      'CreatedDate': createdDate,
      'QuestionCategories': questionCategories,
      'UserQuestionImage': userQuestionImage,
      'UserQuestionDescription': userQuestionDescription,
      'LastActivatedDate': lastActivatedDate,
      'LastActiveDate': lastActiveDate,
      'TitleWithLink': titleWithLink,
      'AnswersWithLink': answersWithLink,
      'UserImage': userImage,
      'AnswerBtnWithLink': answerBtnWithLink,
      'DeleteBtnWithLink': deleteBtnWithLink,
      'ActionsLink': actionsLink,
      'actionSuggestConnection': actionSuggestConnection,
      'actionSharewithFriends': actionSharewithFriends,
      'UserQuestionImagePath': userQuestionImagePath,
      'UserQuestionImageUploadName': userQuestionImageUploadName,
      'UserQuestionUploadIconPath': userQuestionUploadIconPath,
      'IsPublic': isPublic,
    };
  }
}

class QuestionAnswerResponse {
  int responseID = 0;
  int questionID = 0;
  int respondedUserID = 0;
  int commentCount = 0;
  int upvotesCount = 0;
  String response = "";
  String respondedUserName = "";
  String respondedDate = "";
  String responseDate = "";
  String userResponseImage = "";
  String picture = "";
  String userResponseImagePath = "";
  String days = "";
  String responseUpVoters = "";
  String actionSuggestConnection = "";
  String actionSharewithFriends = "";
  String commentAction = "";
  String responseImageUploadName = "";
  String responseUploadIconPath = "";
  String noImageText = "";
  bool? isLiked;
  bool isPublic = false;
  bool isLoadingComments = false;

  List<AnswerCommentsModel> answersCommentList = [];

  QuestionAnswerResponse({
    this.responseID = 0,
    this.questionID = 0,
    this.respondedUserID = 0,
    this.commentCount = 0,
    this.upvotesCount = 0,
    this.response = "",
    this.respondedUserName = "",
    this.respondedDate = "",
    this.responseDate = "",
    this.userResponseImage = "",
    this.picture = "",
    this.userResponseImagePath = "",
    this.days = "",
    this.responseUpVoters = "",
    this.actionSuggestConnection = "",
    this.actionSharewithFriends = "",
    this.commentAction = "",
    this.responseImageUploadName = "",
    this.responseUploadIconPath = "",
    this.noImageText = "",
    this.isLiked,
    this.isPublic = false,
    this.isLoadingComments = false,
    List<AnswerCommentsModel>? answersCommentsList,
  }) {
    this.answersCommentList = answersCommentsList ?? List<AnswerCommentsModel>.empty(growable: true);
  }

  QuestionAnswerResponse.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    responseID = ParsingHelper.parseIntMethod(json['ResponseID']);
    questionID = ParsingHelper.parseIntMethod(json['QuestionID']);
    respondedUserID = ParsingHelper.parseIntMethod(json['RespondedUserID']);
    commentCount = ParsingHelper.parseIntMethod(json['CommentCount']);
    upvotesCount = ParsingHelper.parseIntMethod(json['UpvotesCount']);

    response = ParsingHelper.parseStringMethod(json['Response']);
    respondedUserName = ParsingHelper.parseStringMethod(json['RespondedUserName']);
    respondedDate = ParsingHelper.parseStringMethod(json['RespondedDate']);
    responseDate = ParsingHelper.parseStringMethod(json['ResponseDate']);
    userResponseImage = ParsingHelper.parseStringMethod(json['UserResponseImage']);
    picture = ParsingHelper.parseStringMethod(json['Picture']);

    userResponseImagePath = ParsingHelper.parseStringMethod(json['UserResponseImagePath']);
    days = ParsingHelper.parseStringMethod(json['Days']);
    responseUpVoters = ParsingHelper.parseStringMethod(json['ResponseUpVoters']);
    actionSuggestConnection = ParsingHelper.parseStringMethod(json['actionSuggestConnection']);
    actionSharewithFriends = ParsingHelper.parseStringMethod(json['actionSharewithFriends']);
    commentAction = ParsingHelper.parseStringMethod(json['CommentAction']);
    responseImageUploadName = ParsingHelper.parseStringMethod(json['ResponseImageUploadName']);
    responseUploadIconPath = ParsingHelper.parseStringMethod(json['ResponseUploadIconPath']);
    noImageText = ParsingHelper.parseStringMethod(json['NoImageText']);

    isLiked = ParsingHelper.parseBoolNullableMethod(json['IsLiked']);
    isPublic = ParsingHelper.parseBoolMethod(json['IsPublic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseID': responseID,
      'QuestionID': questionID,
      'RespondedUserID': respondedUserID,
      'CommentCount': commentCount,
      'UpvotesCount': upvotesCount,
      'Response': response,
      'RespondedUserName': respondedUserName,
      'RespondedDate': respondedDate,
      'ResponseDate': responseDate,
      'UserResponseImage': userResponseImage,
      'Picture': picture,
      'UserResponseImagePath': userResponseImagePath,
      'Days': days,
      'ResponseUpVoters': responseUpVoters,
      'actionSuggestConnection': actionSuggestConnection,
      'actionSharewithFriends': actionSharewithFriends,
      'CommentAction': commentAction,
      'ResponseImageUploadName': responseImageUploadName,
      'ResponseUploadIconPath': responseUploadIconPath,
      'NoImageText': noImageText,
      'IsLiked': isLiked,
      'IsPublic': isPublic,
    };
  }
}

class UpVotesUsers {
  int? likeID;
  bool? isLiked;
  int? userID;
  String? objectID;
  String? picture;
  String? userName;
  String? jobTitle;

  UpVotesUsers({this.likeID, this.isLiked, this.userID, this.objectID, this.picture, this.userName, this.jobTitle});

  UpVotesUsers.fromJson(Map<String, dynamic> json) {
    likeID = json['LikeID'];
    isLiked = json['IsLiked'];
    userID = json['UserID'];
    objectID = json['ObjectID'];
    picture = json['Picture'];
    userName = json['UserName'];
    jobTitle = json['JobTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LikeID'] = likeID;
    data['IsLiked'] = isLiked;
    data['UserID'] = userID;
    data['ObjectID'] = objectID;
    data['Picture'] = picture;
    data['UserName'] = userName;
    data['JobTitle'] = jobTitle;
    return data;
  }
}

// class UserQuestionListDto{
//
// }

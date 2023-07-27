import './../../../utils/parsing_helper.dart';
import '../../../utils/my_utils.dart';

class PeopleListingItemDTOModel {
  int ConnectionUserID = 0;
  int ObjectID = 0;
  int NotaMember = 0;
  String JobTitle = "";
  String MainOfficeAddress = "";
  String MemberProfileImage = "";
  String NoImageText = "";
  String UserDisplayname = "";
  String connectionstate = "";
  String connectionstateAccept = "";
  String ViewProfileAction = "";
  String AskTheQuestion = "";
  String AcceptAction = "";
  String IgnoreAction = "";
  String ViewContentAction = "";
  String SendMessageAction = "";
  String AddToMyConnectionAction = "";
  String RemoveFromMyConnectionAction = "";
  String InterestAreas = "";
  String ConnectedDays = "";
  String GroupByActionName = "";
  String GroupByActionValue = "";

  PeopleListingItemDTOModel({
    this.ConnectionUserID = 0,
    this.ObjectID = 0,
    this.NotaMember = 0,
    this.JobTitle = "",
    this.MainOfficeAddress = "",
    this.MemberProfileImage = "",
    this.NoImageText = "",
    this.UserDisplayname = "",
    this.connectionstate = "",
    this.connectionstateAccept = "",
    this.ViewProfileAction = "",
    this.AskTheQuestion = "",
    this.AcceptAction = "",
    this.IgnoreAction = "",
    this.ViewContentAction = "",
    this.SendMessageAction = "",
    this.AddToMyConnectionAction = "",
    this.RemoveFromMyConnectionAction = "",
    this.InterestAreas = "",
    this.ConnectedDays = "",
    this.GroupByActionName = "",
    this.GroupByActionValue = "",
  });

  PeopleListingItemDTOModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    ConnectionUserID = ParsingHelper.parseIntMethod(json["ConnectionUserID"]);
    ObjectID = ParsingHelper.parseIntMethod(json["ObjectID"]);
    NotaMember = ParsingHelper.parseIntMethod(json["NotaMember"]);
    JobTitle = ParsingHelper.parseStringMethod(json["JobTitle"]);
    MainOfficeAddress = ParsingHelper.parseStringMethod(json["MainOfficeAddress"]);
    MemberProfileImage = ParsingHelper.parseStringMethod(json["MemberProfileImage"]);
    NoImageText = ParsingHelper.parseStringMethod(json["NoImageText"]);
    UserDisplayname = ParsingHelper.parseStringMethod(json["UserDisplayname"]);
    connectionstate = ParsingHelper.parseStringMethod(json["connectionstate"]);
    connectionstateAccept = ParsingHelper.parseStringMethod(json["connectionstateAccept"]);
    ViewProfileAction = ParsingHelper.parseStringMethod(json["ViewProfileAction"]);
    AskTheQuestion = ParsingHelper.parseStringMethod(json["AskTheQuestion"]);
    AcceptAction = ParsingHelper.parseStringMethod(json["AcceptAction"]);
    IgnoreAction = ParsingHelper.parseStringMethod(json["IgnoreAction"]);
    ViewContentAction = ParsingHelper.parseStringMethod(json["ViewContentAction"]);
    SendMessageAction = ParsingHelper.parseStringMethod(json["SendMessageAction"]);
    AddToMyConnectionAction = ParsingHelper.parseStringMethod(json["AddToMyConnectionAction"]);
    RemoveFromMyConnectionAction = ParsingHelper.parseStringMethod(json["RemoveFromMyConnectionAction"]);
    InterestAreas = ParsingHelper.parseStringMethod(json["InterestAreas"]);
    ConnectedDays = ParsingHelper.parseStringMethod(json["ConnectedDays"]);
    GroupByActionName = ParsingHelper.parseStringMethod(json["GroupByActionName"]);
    GroupByActionValue = ParsingHelper.parseStringMethod(json["GroupByActionValue"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ConnectionUserID" : ConnectionUserID,
      "ObjectID" : ObjectID,
      "NotaMember" : NotaMember,
      "JobTitle" : JobTitle,
      "MainOfficeAddress" : MainOfficeAddress,
      "MemberProfileImage" : MemberProfileImage,
      "NoImageText" : NoImageText,
      "UserDisplayname" : UserDisplayname,
      "connectionstate" : connectionstate,
      "connectionstateAccept" : connectionstateAccept,
      "ViewProfileAction" : ViewProfileAction,
      "AskTheQuestion" : AskTheQuestion,
      "AcceptAction" : AcceptAction,
      "IgnoreAction" : IgnoreAction,
      "ViewContentAction" : ViewContentAction,
      "SendMessageAction" : SendMessageAction,
      "AddToMyConnectionAction" : AddToMyConnectionAction,
      "RemoveFromMyConnectionAction" : RemoveFromMyConnectionAction,
      "InterestAreas" : InterestAreas,
      "ConnectedDays" : ConnectedDays,
      "GroupByActionName" : GroupByActionName,
      "GroupByActionValue" : GroupByActionValue,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EcommerceProcessPaymentResponseModel {
  String Result = "";
  String LaunchURL = "";
  String FirstName = "";
  String LastName = "";
  String PaymentDate = "";
  String ConvertedPrice = "";
  String ConvertedInitialPrice = "";
  String ContentIDList = "";
  String MyLearningURL = "";
  String NotifyMessage = "";
  String KbankOrderID = "";
  String loginID = "";
  String loginPwd = "";
  int NewUserID = 0;

  EcommerceProcessPaymentResponseModel({
    this.Result = "",
    this.LaunchURL = "",
    this.FirstName = "",
    this.LastName = "",
    this.PaymentDate = "",
    this.ConvertedPrice = "",
    this.ConvertedInitialPrice = "",
    this.ContentIDList = "",
    this.MyLearningURL = "",
    this.NotifyMessage = "",
    this.KbankOrderID = "",
    this.loginID = "",
    this.loginPwd = "",
    this.NewUserID = 0,
  });

  EcommerceProcessPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    Result = ParsingHelper.parseStringMethod(json["Result"]);
    LaunchURL = ParsingHelper.parseStringMethod(json["LaunchURL"]);
    FirstName = ParsingHelper.parseStringMethod(json["FirstName"]);
    LastName = ParsingHelper.parseStringMethod(json["LastName"]);
    PaymentDate = ParsingHelper.parseStringMethod(json["PaymentDate"]);
    ConvertedPrice = ParsingHelper.parseStringMethod(json["ConvertedPrice"]);
    ConvertedInitialPrice = ParsingHelper.parseStringMethod(json["ConvertedInitialPrice"]);
    ContentIDList = ParsingHelper.parseStringMethod(json["ContentIDList"]);
    MyLearningURL = ParsingHelper.parseStringMethod(json["MyLearningURL"]);
    NotifyMessage = ParsingHelper.parseStringMethod(json["NotifyMessage"]);
    KbankOrderID = ParsingHelper.parseStringMethod(json["KbankOrderID"]);
    loginID = ParsingHelper.parseStringMethod(json["loginID"]);
    loginPwd = ParsingHelper.parseStringMethod(json["loginPwd"]);
    NewUserID = ParsingHelper.parseIntMethod(json["NewUserID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "Result": Result,
      "LaunchURL": LaunchURL,
      "FirstName": FirstName,
      "LastName": LastName,
      "PaymentDate": PaymentDate,
      "ConvertedPrice": ConvertedPrice,
      "ConvertedInitialPrice": ConvertedInitialPrice,
      "ContentIDList": ContentIDList,
      "MyLearningURL": MyLearningURL,
      "NotifyMessage": NotifyMessage,
      "KbankOrderID": KbankOrderID,
      "loginID": loginID,
      "loginPwd": loginPwd,
      "NewUserID": NewUserID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

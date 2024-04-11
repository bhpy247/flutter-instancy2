import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class SocialLoginCredentialDataModel {
  String id = "";
  String firstName = "";
  String lastName = "";
  String userDisplayName = "";
  String profileImageUrl = "";
  String email = "";
  String socialLoginType = "";

  SocialLoginCredentialDataModel({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.userDisplayName = "",
    this.profileImageUrl = "",
    this.email = "",
    this.socialLoginType = "",
  });

  SocialLoginCredentialDataModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseStringMethod(json['id']);
    firstName = ParsingHelper.parseStringMethod(json['firstName']);
    lastName = ParsingHelper.parseStringMethod(json['lastName']);
    userDisplayName = ParsingHelper.parseStringMethod(json['userDisplayName']);
    profileImageUrl = ParsingHelper.parseStringMethod(json['profileImageUrl']);
    email = ParsingHelper.parseStringMethod(json['email']);
    socialLoginType = ParsingHelper.parseStringMethod(json['socialLoginType']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "userDisplayName": userDisplayName,
      "profileImageUrl": profileImageUrl,
      "email": email,
      "socialLoginType": socialLoginType,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

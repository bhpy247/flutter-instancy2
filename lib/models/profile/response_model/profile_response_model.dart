import 'package:flutter_instancy_2/models/profile/data_model/site_user_info_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../data_model/profile_data_field_name_model.dart';
import '../data_model/profile_group_model.dart';
import '../data_model/user_education_data_model.dart';
import '../data_model/user_experience_data_model.dart';
import '../data_model/user_membership_detail_model.dart';
import '../data_model/user_privilege_model.dart';

class ProfileResponseModel {
  ProfileResponseModel({
    this.userProfileDetails = const [],
    this.profileDataFieldName = const [],
    this.profileGroups = const [],
    this.userEducationData = const [],
    this.userExperienceData = const [],
    this.userProfileGroups = const [],
    this.siteUsersInfo = const [],
    this.userPrivileges = const [],
    this.userMembershipDetails = const [],
  });

  List<UserProfileDetailsModel> userProfileDetails = [];
  List<ProfileDataFieldNameModel> profileDataFieldName = [];
  List<UserEducationDataModel> userEducationData = [];
  List<UserExperienceDataModel> userExperienceData = [];
  List<SiteUserInfoModel> siteUsersInfo = [];
  List<UserPrivilegeModel> userPrivileges = [];
  List<UserMembershipDetailModel> userMembershipDetails = [];
  List<ProfileGroupModel> userProfileGroups = [];
  List<ProfileGroupModel> profileGroups = [];

  ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    userProfileDetails = ParsingHelper.parseMapsListMethod<String, dynamic>(json["userprofiledetails"]).map((x) => UserProfileDetailsModel.fromJson(x)).toList();
    profileDataFieldName = ParsingHelper.parseMapsListMethod<String, dynamic>(json["profiledatafieldname"]).map((x) => ProfileDataFieldNameModel.fromJson(x)).toList();
    userEducationData = ParsingHelper.parseMapsListMethod<String, dynamic>(json["usereducationdata"]).map((x) => UserEducationDataModel.fromJson(x)).toList();
    userExperienceData = ParsingHelper.parseMapsListMethod<String, dynamic>(json["userexperiencedata"]).map((x) => UserExperienceDataModel.fromJson(x)).toList();
    siteUsersInfo = ParsingHelper.parseMapsListMethod<String, dynamic>(json["siteusersinfo"]).map((x) => SiteUserInfoModel.fromJson(x)).toList();
    userPrivileges = ParsingHelper.parseMapsListMethod<String, dynamic>(json["userprivileges"]).map((x) => UserPrivilegeModel.fromJson(x)).toList();
    userMembershipDetails = ParsingHelper.parseMapsListMethod<String, dynamic>(json["usermembershipdetails"]).map((x) => UserMembershipDetailModel.fromJson(x)).toList();
    userProfileGroups = ParsingHelper.parseMapsListMethod<String, dynamic>(json["userprofilegroups"]).map((x) => ProfileGroupModel.fromJson(x)).toList();
    profileGroups = ParsingHelper.parseMapsListMethod<String, dynamic>(json["profilegroups"]).map((x) => ProfileGroupModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "userprofiledetails": userProfileDetails.map((x) => x.toJson()).toList(),
      "profiledatafieldname": profileDataFieldName.map((x) => x.toJson()).toList(),
      "usereducationdata": userEducationData.map((x) => x.toJson()).toList(),
      "userexperiencedata": userExperienceData.map((x) => x.toJson()).toList(),
      "siteusersinfo": siteUsersInfo.map((x) => x.toJson()).toList(),
      "userprivileges": userPrivileges.map((x) => x.toJson()).toList(),
      "usermembershipdetails": userMembershipDetails.map((x) => x.toJson()).toList(),
      "userprofilegroups": userProfileGroups.map((x) => x.toJson()).toList(),
      "profilegroups": profileGroups.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

/*class ProfileEditList {
  ProfileEditList(
      {this.datafieldname = "",
      this.aliasname = "",
      this.attributedisplaytext = "",
      this.groupid = 0,
      this.displayorder = 0,
      this.attributeconfigid = 0,
      this.isrequired = false,
      this.iseditable = false,
      this.enduservisibility = false,
      this.uicontroltypeid = 0,
      this.name = "",
      this.minlength = 0,
      this.maxlength = 0,
      this.valueName = "",
      this.table5});

  String datafieldname;
  String aliasname;
  String attributedisplaytext;
  int groupid;
  int displayorder;
  int attributeconfigid;
  bool isrequired;
  bool iseditable;
  bool enduservisibility;
  int uicontroltypeid;
  String name;
  int minlength;
  int maxlength;
  String valueName = "";
  Table5? table5;
}

class ProfileHeader {
  ProfileHeader({
    this.backgroundImgProfilepath = "",
    this.profilepath = "",
    this.userProfilePath = "",
    this.socialSection,
    this.userJobTitle = "",
    this.aboutme = "",
    this.displayname = "",
    this.nodataiamge = "",
    this.intConnStatus = 0,
    this.acceptAction,
    this.rejectAction,
    this.connectionState = "",
  });

  String backgroundImgProfilepath;
  String profilepath;
  String userProfilePath;
  dynamic socialSection;
  String userJobTitle;
  String aboutme;
  String displayname;
  String nodataiamge;
  int intConnStatus = 0;
  dynamic acceptAction;
  dynamic rejectAction;
  String connectionState;

  factory ProfileHeader.fromJson(Map<String, dynamic> json) => ProfileHeader(
        backgroundImgProfilepath: json["BackgroundImgProfilepath"],
        profilepath: json["Profilepath"],
        userProfilePath: json["UserProfilePath"],
        socialSection: json["SocialSection"],
        userJobTitle: json["UserJobTitle"],
        aboutme: json["Aboutme"],
        displayname: json["Displayname"],
        nodataiamge: json["Nodataiamge"],
        intConnStatus: json["intConnStatus"],
        acceptAction: json["AcceptAction"],
        rejectAction: json["RejectAction"],
        connectionState: json["ConnectionState"],
      );

  Map<String, dynamic> toJson() => {
        "BackgroundImgProfilepath": backgroundImgProfilepath,
        "Profilepath": profilepath,
        "UserProfilePath": userProfilePath,
        "SocialSection": socialSection,
        "UserJobTitle": userJobTitle,
        "Aboutme": aboutme,
        "Displayname": displayname,
        "Nodataiamge": nodataiamge,
        "intConnStatus": intConnStatus,
        "AcceptAction": acceptAction,
        "RejectAction": rejectAction,
        "ConnectionState": connectionState,
      };
}*/

import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserProfileDetailsModel {
  String picture = "", picture1 = "", userid = "", firstname = "", lastname = "", displayname = "", organization = "", email = "", usersite = "",
      supervisoremployeeid = "", addressline1 = "", addresscity = "", addressstate = "", addresszip = "0", addresscountry = "",
      phone = "", mobilephone = "", imaddress = "", dateofbirth = "", gender = "", paymentmode = "", nvarchar7 = "", nvarchar8 = "",
      nvarchar9 = "", securepaypalid = "", nvarchar10 = "", highschool = "", college = "", highestdegree = "", primaryjobfunction = "",
      payeeaccountno = "", payeename = "", paypalaccountname = "", paypalemail = "", shipaddline1 = "", shipaddcity = "", shipaddstate = "",
      shipaddzip = "", shipaddcountry = "", shipaddphone = "", profileimagepath = "", objetId = "", nvarchar103 = "", nvarchar105 = "",
      nvarchar6 = "", jobroleid = "", jobtitle = "";
  int objectid = 0, accounttype = 0, orgunitid = 0, siteid = 0, approvalstatus = 0;
  bool isProfilexist = false;
  dynamic businessfunction;

  UserProfileDetailsModel({
    this.picture = "",
    this.picture1 = "",
    this.userid = "",
    this.firstname = "",
    this.lastname = "",
    this.displayname = "",
    this.organization = "",
    this.email = "",
    this.usersite = "",
    this.supervisoremployeeid = "",
    this.addressline1 = "",
    this.addresscity = "",
    this.addressstate = "",
    this.addresszip = "",
    this.addresscountry = "",
    this.phone = "",
    this.mobilephone = "",
    this.imaddress = "",
    this.dateofbirth = "",
    this.gender = "",
    this.paymentmode = "",
    this.nvarchar7 = "",
    this.nvarchar8 = "",
    this.nvarchar9 = "",
    this.securepaypalid = "",
    this.nvarchar10 = "",
    this.highschool = "",
    this.college = "",
    this.highestdegree = "",
    this.primaryjobfunction = "",
    this.payeeaccountno = "",
    this.payeename = "",
    this.paypalaccountname = "",
    this.paypalemail = "",
    this.shipaddline1 = "",
    this.shipaddcity = "",
    this.shipaddstate = "",
    this.shipaddzip = "",
    this.shipaddcountry = "",
    this.shipaddphone = "",
    this.profileimagepath = "",
    this.objetId = "",
    this.nvarchar6 = "",
    this.jobroleid = "",
    this.jobtitle = "",
    this.nvarchar105 = "",
    this.nvarchar103 = "",
    this.objectid = 0,
    this.accounttype = 0,
    this.orgunitid = 0,
    this.siteid = 0,
    this.approvalstatus = 0,
    this.isProfilexist = false,
    this.businessfunction,
  });

  UserProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    firstname = ParsingHelper.parseStringMethod(json["firstname"]);
    lastname = ParsingHelper.parseStringMethod(json["lastname"]);
    email = ParsingHelper.parseStringMethod(json["email"]);
    nvarchar6 = ParsingHelper.parseStringMethod(json["nvarchar6"]);
    jobroleid = ParsingHelper.parseStringMethod(json["jobroleid"]);
    jobtitle = ParsingHelper.parseStringMethod(json["jobtitle"]);
    nvarchar105 = ParsingHelper.parseStringMethod(json['nvarchar105']);
    nvarchar103 = ParsingHelper.parseStringMethod(json['nvarchar103']);
    objetId = ParsingHelper.parseStringMethod(json['objetId']);
    profileimagepath = ParsingHelper.parseStringMethod(json['profileimagepath']);
    shipaddphone = ParsingHelper.parseStringMethod(json['shipaddphone']);
    shipaddcountry = ParsingHelper.parseStringMethod(json['shipaddcountry']);
    shipaddstate = ParsingHelper.parseStringMethod(json['shipaddstate']);
    shipaddzip = ParsingHelper.parseStringMethod(json['shipaddzip']);
    shipaddcity = ParsingHelper.parseStringMethod(json['shipaddcity']);
    shipaddline1 = ParsingHelper.parseStringMethod(json['shipaddline1']);
    paypalemail = ParsingHelper.parseStringMethod(json['paypalemail']);
    payeeaccountno = ParsingHelper.parseStringMethod(json['payeeaccountno']);
    primaryjobfunction = ParsingHelper.parseStringMethod(json['primaryjobfunction']);
    highestdegree = ParsingHelper.parseStringMethod(json['highestdegree']);
    college = ParsingHelper.parseStringMethod(json['college']);
    highschool = ParsingHelper.parseStringMethod(json['highschool']);
    nvarchar10 = ParsingHelper.parseStringMethod(json['nvarchar10']);
    securepaypalid = ParsingHelper.parseStringMethod(json['securepaypalid']);
    nvarchar9 = ParsingHelper.parseStringMethod(json['nvarchar9']);
    nvarchar8 = ParsingHelper.parseStringMethod(json['nvarchar8']);
    nvarchar7 = ParsingHelper.parseStringMethod(json['nvarchar7']);
    paymentmode = ParsingHelper.parseStringMethod(json['paymentmode']);
    gender = ParsingHelper.parseStringMethod(json['gender']);
    dateofbirth = ParsingHelper.parseStringMethod(json['dateofbirth']);
    imaddress = ParsingHelper.parseStringMethod(json['imaddress']);
    mobilephone = ParsingHelper.parseStringMethod(json['mobilephone']);
    phone = ParsingHelper.parseStringMethod(json['phone']);
    addresscountry = ParsingHelper.parseStringMethod(json['addresscountry']);
    addresszip = ParsingHelper.parseStringMethod(json['addresszip']);
    addressstate = ParsingHelper.parseStringMethod(json['addressstate']);
    addresscity = ParsingHelper.parseStringMethod(json['addresscity']);
    addressline1 = ParsingHelper.parseStringMethod(json['addressline1']);
    supervisoremployeeid = ParsingHelper.parseStringMethod(json['supervisoremployeeid']);
    usersite = ParsingHelper.parseStringMethod(json['usersite']);
    organization = ParsingHelper.parseStringMethod(json['organization']);
    displayname = ParsingHelper.parseStringMethod(json['displayname']);
    userid = ParsingHelper.parseStringMethod(json['userid']);
    picture1 = ParsingHelper.parseStringMethod(json['picture1']);
    picture = ParsingHelper.parseStringMethod(json['picture']);
    objectid = ParsingHelper.parseIntMethod(json["objectid"]);
    accounttype = ParsingHelper.parseIntMethod(json["accounttype"]);
    orgunitid = ParsingHelper.parseIntMethod(json["orgunitid"]);
    siteid = ParsingHelper.parseIntMethod(json["siteid"]);
    approvalstatus = ParsingHelper.parseIntMethod(json["approvalstatus"]);
    isProfilexist = ParsingHelper.parseBoolMethod(json["isProfilexist"]);
    businessfunction = json["businessfunction"];
  }

  Map<String, dynamic> toJson() {
    return {
      "objectid": objectid,
      "accounttype": accounttype,
      "orgunitid": orgunitid,
      "siteid": siteid,
      "approvalstatus": approvalstatus,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "nvarchar6": nvarchar6,
      "jobroleid": jobroleid,
      "jobtitle": jobtitle,
      "businessfunction": businessfunction,
      // "languageselection": languageselection,
      "picture": picture,
      "userid": userid,
      "displayname": displayname,
      "organization": organization,
      "usersite": usersite,
      "supervisoremployeeid": supervisoremployeeid,
      "addressline1": addressline1,
      "addresscity": addresscity,
      "addressstate": addressstate,
      "addresszip": addresszip,
      "addresscountry": addresscountry,
      "phone": phone,
      "mobilephone": mobilephone,
      "imaddress": imaddress,
      "dateofbirth": dateofbirth,
      "gender": gender,
      "paymentmode": paymentmode,
      "nvarchar7": nvarchar7,
      "nvarchar8": nvarchar8,
      "nvarchar9": nvarchar9,
      "securepaypalid": securepaypalid,
      "nvarchar10": nvarchar10,
      "highschool": highschool,
      "college": college,
      "highestdegree": highestdegree,
      "primaryjobfunction": primaryjobfunction,
      "payeeaccountno": payeeaccountno,
      "payeename": payeename,
      "paypalaccountname": paypalaccountname,
      "paypalemail": paypalemail,
      "shipaddline1": shipaddline1,
      "shipaddcity": shipaddcity,
      "shipaddstate": shipaddstate,
      "shipaddzip": shipaddzip,
      "shipaddcountry": shipaddcountry,
      "shipaddphone": shipaddphone,
      "profileimagepath": profileimagepath,
      "objetId": objetId,
      "isProfilexist": isProfilexist,
      "nvarchar103": nvarchar103,
      "nvarchar105": nvarchar105,
      "picture1": picture1
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
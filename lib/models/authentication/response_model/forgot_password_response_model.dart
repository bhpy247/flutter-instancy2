class ForgotPasswordResponseModel {
  ForgotPasswordResponseModel({
    required this.userStatus,
  });

  List<UserStatus> userStatus = [];

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponseModel(
        userStatus: List<UserStatus>.from(
            json["userstatus"].map((x) => UserStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "userstatus": List<dynamic>.from(userStatus.map((x) => x.toJson())),
  };
}

class UserStatus {
  UserStatus({
    this.userid = 0,
    this.siteid = 0,
    this.active = false,
    this.userstatus = 0,
    this.email = "",
  });

  int userid = 0;
  int siteid = 0;
  bool active = false;
  int userstatus = 0;
  String email = "";

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
    userid: json["userid"],
    siteid: json["siteid"],
    active: json["active"],
    userstatus: json["userstatus"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "siteid": siteid,
    "active": active,
    "userstatus": userstatus,
    "email": email,
  };
}
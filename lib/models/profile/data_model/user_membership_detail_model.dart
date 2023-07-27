import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserMembershipDetailModel {
  String usermembership = "";
  String status = "";
  String renewaltype = "";
  String expirystatus = "";
  int membershiplevel = 0;
  DateTime? startdate;
  DateTime? expirydate;
  double amount = 0;

  UserMembershipDetailModel({
    this.usermembership = "",
    this.status = "",
    this.renewaltype = "",
    this.expirystatus = "",
    this.membershiplevel = 0,
    this.startdate,
    this.expirydate,
    this.amount = 0,
  });

  UserMembershipDetailModel.fromJson(Map<String, dynamic> json) {
    usermembership = ParsingHelper.parseStringMethod(json["usermembership"]);
    status = ParsingHelper.parseStringMethod(json["status"]);
    renewaltype = ParsingHelper.parseStringMethod(json["renewaltype"]);
    expirystatus = ParsingHelper.parseStringMethod(json["expirystatus"]);
    membershiplevel = ParsingHelper.parseIntMethod(json["membershiplevel"]);
    startdate = ParsingHelper.parseDateTimeMethod(json["startdate"]);
    expirydate = ParsingHelper.parseDateTimeMethod(json["expirydate"]);
    amount = ParsingHelper.parseDoubleMethod(json["amount"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "usermembership": usermembership,
      "status": status,
      "renewaltype": renewaltype,
      "expirystatus": expirystatus,
      "membershiplevel": membershiplevel,
      "startdate": startdate?.toIso8601String(),
      "expirydate": expirydate?.toIso8601String(),
      "amount": amount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
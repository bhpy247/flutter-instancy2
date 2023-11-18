import 'package:flutter_instancy_2/utils/my_utils.dart';

class MembershipPlanRequestModel {
  String Locale = "";
  String PaymentGatway = "";
  String CurrencySign = "";
  String Country = "";
  String CouponCode = "";
  int UserID = -1;
  int SiteID = -1;
  int DurationID = -1;
  int ExpiredRenewalUserID = -1;
  bool enablegroupmembership = false;

  MembershipPlanRequestModel({
    this.Locale = "",
    this.PaymentGatway = "",
    this.CurrencySign = "",
    this.Country = "",
    this.CouponCode = "",
    this.UserID = -1,
    this.SiteID = -1,
    this.DurationID = -1,
    this.ExpiredRenewalUserID = -1,
    this.enablegroupmembership = false,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "PaymentGatway": PaymentGatway,
      "CurrencySign": CurrencySign,
      "Country": Country,
      "CouponCode": CouponCode,
      "UserID": UserID.toString(),
      "SiteID": SiteID.toString(),
      "DurationID": DurationID.toString(),
      "ExpiredRenewalUserID": ExpiredRenewalUserID.toString(),
      "enablegroupmembership": enablegroupmembership.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

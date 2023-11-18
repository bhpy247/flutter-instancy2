import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MembershipPlanDetailsModel {
  String MembershipName = "";
  String DurationName = "";
  String DurationValue = "";
  String FreeTrialPeriod = "";
  String Coupondiscountamount = "";
  String DurationType = "";
  String FreeTrialType = "";
  String BrainTreePlanID = "";
  String isActive = "";
  String TotalAmount = "";
  String MembershiptaxAmount = "";
  String MerchantTaxPercentage = "";
  String DiscountAmount = "";
  String DiscountTotalAmount = "";
  String DiscountMembershiptaxAmount = "";
  String WrongCouponApplied = "";
  String CouponMessage = "";
  String CouponType = "";
  String GoogleSubscriptionID = "";
  String AppleSubscriptionID = "";
  String RenewalDate = "";
  String InitialAmount = "";
  String ExcludeVATTag = "";
  int MemberShipDurationID = -1;
  int MemberShipID = -1;
  int MemberShipDurationLevel = -1;
  int SubscriptionType = -1;
  double Amount = 0;

  MembershipPlanDetailsModel({
    this.MembershipName = "",
    this.DurationName = "",
    this.DurationValue = "",
    this.FreeTrialPeriod = "",
    this.Coupondiscountamount = "",
    this.DurationType = "",
    this.FreeTrialType = "",
    this.BrainTreePlanID = "",
    this.isActive = "",
    this.TotalAmount = "",
    this.MembershiptaxAmount = "",
    this.MerchantTaxPercentage = "",
    this.DiscountAmount = "",
    this.DiscountTotalAmount = "",
    this.DiscountMembershiptaxAmount = "",
    this.WrongCouponApplied = "",
    this.CouponMessage = "",
    this.CouponType = "",
    this.GoogleSubscriptionID = "",
    this.AppleSubscriptionID = "",
    this.RenewalDate = "",
    this.InitialAmount = "",
    this.ExcludeVATTag = "",
    this.MemberShipDurationID = -1,
    this.MemberShipID = -1,
    this.MemberShipDurationLevel = -1,
    this.SubscriptionType = -1,
    this.Amount = 0,
  });

  MembershipPlanDetailsModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    MembershipName = ParsingHelper.parseStringMethod(map['MembershipName']);
    DurationName = ParsingHelper.parseStringMethod(map['DurationName']);
    DurationValue = ParsingHelper.parseStringMethod(map['DurationValue']);
    FreeTrialPeriod = ParsingHelper.parseStringMethod(map['FreeTrialPeriod']);
    Coupondiscountamount = ParsingHelper.parseStringMethod(map['Coupondiscountamount']);
    DurationType = ParsingHelper.parseStringMethod(map['DurationType']);
    FreeTrialType = ParsingHelper.parseStringMethod(map['FreeTrialType']);
    BrainTreePlanID = ParsingHelper.parseStringMethod(map['BrainTreePlanID']);
    isActive = ParsingHelper.parseStringMethod(map['isActive']);
    TotalAmount = ParsingHelper.parseStringMethod(map['TotalAmount']);
    MembershiptaxAmount = ParsingHelper.parseStringMethod(map['MembershiptaxAmount']);
    MerchantTaxPercentage = ParsingHelper.parseStringMethod(map['MerchantTaxPercentage']);
    DiscountAmount = ParsingHelper.parseStringMethod(map['DiscountAmount']);
    DiscountTotalAmount = ParsingHelper.parseStringMethod(map['DiscountTotalAmount']);
    DiscountMembershiptaxAmount = ParsingHelper.parseStringMethod(map['DiscountMembershiptaxAmount']);
    WrongCouponApplied = ParsingHelper.parseStringMethod(map['WrongCouponApplied']);
    CouponMessage = ParsingHelper.parseStringMethod(map['CouponMessage']);
    CouponType = ParsingHelper.parseStringMethod(map['CouponType']);
    GoogleSubscriptionID = ParsingHelper.parseStringMethod(map['GoogleSubscriptionID']);
    AppleSubscriptionID = ParsingHelper.parseStringMethod(map['AppleSubscriptionID']);
    RenewalDate = ParsingHelper.parseStringMethod(map['RenewalDate']);
    InitialAmount = ParsingHelper.parseStringMethod(map['InitialAmount']);
    ExcludeVATTag = ParsingHelper.parseStringMethod(map['ExcludeVATTag']);
    MemberShipDurationID = ParsingHelper.parseIntMethod(map['MemberShipDurationID'], defaultValue: -1);
    MemberShipID = ParsingHelper.parseIntMethod(map['MemberShipID'], defaultValue: -1);
    MemberShipDurationLevel = ParsingHelper.parseIntMethod(map['MemberShipDurationLevel'], defaultValue: -1);
    SubscriptionType = ParsingHelper.parseIntMethod(map['SubscriptionType'], defaultValue: -1);
    Amount = ParsingHelper.parseDoubleMethod(map['Amount']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "MembershipName": MembershipName,
      "DurationName": DurationName,
      "DurationValue": DurationValue,
      "FreeTrialPeriod": FreeTrialPeriod,
      "Coupondiscountamount": Coupondiscountamount,
      "DurationType": DurationType,
      "FreeTrialType": FreeTrialType,
      "BrainTreePlanID": BrainTreePlanID,
      "isActive": isActive,
      "TotalAmount": TotalAmount,
      "MembershiptaxAmount": MembershiptaxAmount,
      "MerchantTaxPercentage": MerchantTaxPercentage,
      "DiscountAmount": DiscountAmount,
      "DiscountTotalAmount": DiscountTotalAmount,
      "DiscountMembershiptaxAmount": DiscountMembershiptaxAmount,
      "WrongCouponApplied": WrongCouponApplied,
      "CouponMessage": CouponMessage,
      "CouponType": CouponType,
      "GoogleSubscriptionID": GoogleSubscriptionID,
      "AppleSubscriptionID": AppleSubscriptionID,
      "RenewalDate": RenewalDate,
      "InitialAmount": InitialAmount,
      "ExcludeVATTag": ExcludeVATTag,
      "MemberShipDurationID": MemberShipDurationID,
      "MemberShipID": MemberShipID,
      "MemberShipDurationLevel": MemberShipDurationLevel,
      "SubscriptionType": SubscriptionType,
      "Amount": Amount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

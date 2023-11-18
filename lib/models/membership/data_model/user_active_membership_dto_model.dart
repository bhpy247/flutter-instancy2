import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../utils/parsing_helper.dart';

class UserActiveMembershipDTOModel {
  String DisplayEnddate = "";
  String DisplayExpirydate = "";
  String DisplayStartDate = "";
  String ExpiryStatus = "";
  String PurchasedAmount = "";
  String RenewalType = "";
  String StartDate = "";
  String ExpiryDate = "";
  String Status = "";
  String UserMembership = "";
  String ActualEndDate = "";
  String ActualEndDateTimeString = "";
  String ActualStartDate = "";
  String CouponCode = "";
  String CouponTrialMessage = "";
  String CouponType = "";
  String CouponValue = "";
  String Currency = "";
  String DurationName = "";
  String DurationType = "";
  String DurationValue = "";
  String Email = "";
  String FreeTrialPeriod = "";
  String FreeTrialType = "";
  String MembershipName = "";
  String Name = "";
  String Notes = "";
  String PaymentMode = "";
  String PaymentMode1 = "";
  bool IsChangePlan = false;
  bool IsMembershipData = false;
  int MembershipID = -1;
  int MembershipLevel = -1;
  int IsAutoRenewalCanceled = 0;
  int MembershipDurationID = 0;
  int duration = 0;
  double Amount = 0;
  DateTime? ActualEndDateTime;

  UserActiveMembershipDTOModel({
    this.DisplayEnddate = "",
    this.DisplayExpirydate = "",
    this.DisplayStartDate = "",
    this.ExpiryStatus = "",
    this.PurchasedAmount = "",
    this.RenewalType = "",
    this.StartDate = "",
    this.ExpiryDate = "",
    this.Status = "",
    this.UserMembership = "",
    this.ActualEndDate = "",
    this.ActualStartDate = "",
    this.CouponCode = "",
    this.CouponTrialMessage = "",
    this.CouponType = "",
    this.CouponValue = "",
    this.Currency = "",
    this.DurationName = "",
    this.DurationType = "",
    this.DurationValue = "",
    this.Email = "",
    this.FreeTrialPeriod = "",
    this.FreeTrialType = "",
    this.MembershipName = "",
    this.Name = "",
    this.Notes = "",
    this.PaymentMode = "",
    this.PaymentMode1 = "",
    this.IsChangePlan = false,
    this.IsMembershipData = false,
    this.MembershipID = -1,
    this.MembershipLevel = -1,
    this.IsAutoRenewalCanceled = 0,
    this.MembershipDurationID = 0,
    this.duration = 0,
    this.Amount = 0,
    this.ActualEndDateTime,
  });

  UserActiveMembershipDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    DisplayEnddate = ParsingHelper.parseStringMethod(map['DisplayEnddate']);
    DisplayExpirydate = ParsingHelper.parseStringMethod(map['DisplayExpirydate']);
    DisplayStartDate = ParsingHelper.parseStringMethod(map['DisplayStartDate']);
    ExpiryStatus = ParsingHelper.parseStringMethod(map['ExpiryStatus']);
    PurchasedAmount = ParsingHelper.parseStringMethod(map['PurchasedAmount']);
    RenewalType = ParsingHelper.parseStringMethod(map['RenewalType']);
    StartDate = ParsingHelper.parseStringMethod(map['StartDate']);
    ExpiryDate = ParsingHelper.parseStringMethod(map['ExpiryDate']);
    Status = ParsingHelper.parseStringMethod(map['Status']);
    UserMembership = ParsingHelper.parseStringMethod(map['UserMembership']);
    ActualEndDate = ParsingHelper.parseStringMethod(map['ActualEndDate']);
    ActualStartDate = ParsingHelper.parseStringMethod(map['ActualStartDate']);
    CouponCode = ParsingHelper.parseStringMethod(map['CouponCode']);
    CouponTrialMessage = ParsingHelper.parseStringMethod(map['CouponTrialMessage']);
    CouponType = ParsingHelper.parseStringMethod(map['CouponType']);
    CouponValue = ParsingHelper.parseStringMethod(map['CouponValue']);
    Currency = ParsingHelper.parseStringMethod(map['Currency']);
    DurationName = ParsingHelper.parseStringMethod(map['DurationName']);
    DurationType = ParsingHelper.parseStringMethod(map['DurationType']);
    DurationValue = ParsingHelper.parseStringMethod(map['DurationValue']);
    Email = ParsingHelper.parseStringMethod(map['Email']);
    FreeTrialPeriod = ParsingHelper.parseStringMethod(map['FreeTrialPeriod']);
    FreeTrialType = ParsingHelper.parseStringMethod(map['FreeTrialType']);
    MembershipName = ParsingHelper.parseStringMethod(map['MembershipName']);
    Name = ParsingHelper.parseStringMethod(map['Name']);
    Notes = ParsingHelper.parseStringMethod(map['Notes']);
    PaymentMode = ParsingHelper.parseStringMethod(map['PaymentMode']);
    PaymentMode1 = ParsingHelper.parseStringMethod(map['PaymentMode1']);
    IsChangePlan = ParsingHelper.parseBoolMethod(map['IsChangePlan']);
    IsMembershipData = ParsingHelper.parseBoolMethod(map['IsMembershipData']);
    MembershipID = ParsingHelper.parseIntMethod(map['MembershipID'], defaultValue: -1);
    MembershipLevel = ParsingHelper.parseIntMethod(map['MembershipLevel'], defaultValue: -1);
    IsAutoRenewalCanceled = ParsingHelper.parseIntMethod(map['IsAutoRenewalCanceled']);
    MembershipDurationID = ParsingHelper.parseIntMethod(map['MembershipDurationID']);
    duration = ParsingHelper.parseIntMethod(map['duration']);
    Amount = ParsingHelper.parseDoubleMethod(map['Amount']);

    ActualEndDateTime = ParsingHelper.parseDateTimeMethod(ActualEndDate);
    ActualEndDateTimeString = DatePresentation.getFormattedDate(dateFormat: "MMM dd, yyyy", dateTime: ActualEndDateTime) ?? "";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "DisplayEnddate": DisplayEnddate,
      "DisplayExpirydate": DisplayExpirydate,
      "DisplayStartDate": DisplayStartDate,
      "ExpiryStatus": ExpiryStatus,
      "PurchasedAmount": PurchasedAmount,
      "RenewalType": RenewalType,
      "StartDate": StartDate,
      "ExpiryDate": ExpiryDate,
      "Status": Status,
      "UserMembership": UserMembership,
      "ActualEndDate": ActualEndDate,
      "ActualStartDate": ActualStartDate,
      "CouponCode": CouponCode,
      "CouponTrialMessage": CouponTrialMessage,
      "CouponType": CouponType,
      "CouponValue": CouponValue,
      "Currency": Currency,
      "DurationName": DurationName,
      "DurationType": DurationType,
      "DurationValue": DurationValue,
      "Email": Email,
      "FreeTrialPeriod": FreeTrialPeriod,
      "FreeTrialType": FreeTrialType,
      "MembershipName": MembershipName,
      "Name": Name,
      "Notes": Notes,
      "PaymentMode": PaymentMode,
      "PaymentMode1": PaymentMode1,
      "IsChangePlan": IsChangePlan,
      "IsMembershipData": IsMembershipData,
      "MembershipID": MembershipID,
      "MembershipLevel": MembershipLevel,
      "IsAutoRenewalCanceled": IsAutoRenewalCanceled,
      "MembershipDurationID": MembershipDurationID,
      "duration": duration,
      "Amount": Amount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import 'membership_plan_details_model.dart';

class MemberShipDTOModel {
  String MemberShipName = "";
  String DisplayText = "";
  String MemberShipShortDesc = "";
  String ExpiryDate = "";
  String CouponType = "";
  String MembershipActive = "";
  int MemberShipID = -1;
  int MemberShipLevel = -1;
  int MemberShipDurationID = -1;
  int SubscriptionTypeID = -1;
  List<MembershipPlanDetailsModel> MemberShipPlans = <MembershipPlanDetailsModel>[];

  MemberShipDTOModel({
    this.MemberShipName = "",
    this.DisplayText = "",
    this.MemberShipShortDesc = "",
    this.ExpiryDate = "",
    this.CouponType = "",
    this.MembershipActive = "",
    this.MemberShipID = -1,
    this.MemberShipLevel = -1,
    this.MemberShipDurationID = -1,
    this.SubscriptionTypeID = -1,
    List<MembershipPlanDetailsModel>? MemberShipPlans,
  }) {
    this.MemberShipPlans = MemberShipPlans ?? <MembershipPlanDetailsModel>[];
  }

  MemberShipDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    MemberShipName = ParsingHelper.parseStringMethod(map['MemberShipName']);
    DisplayText = ParsingHelper.parseStringMethod(map['DisplayText']);
    MemberShipShortDesc = ParsingHelper.parseStringMethod(map['MemberShipShortDesc']);
    ExpiryDate = ParsingHelper.parseStringMethod(map['ExpiryDate']);
    CouponType = ParsingHelper.parseStringMethod(map['CouponType']);
    MembershipActive = ParsingHelper.parseStringMethod(map['MembershipActive']);
    MemberShipID = ParsingHelper.parseIntMethod(map["MemberShipID"], defaultValue: -1);
    MemberShipLevel = ParsingHelper.parseIntMethod(map["MemberShipLevel"], defaultValue: -1);
    MemberShipDurationID = ParsingHelper.parseIntMethod(map["MemberShipDurationID"], defaultValue: -1);
    SubscriptionTypeID = ParsingHelper.parseIntMethod(map["SubscriptionTypeID"], defaultValue: -1);

    MemberShipPlans.clear();
    List<Map<String, dynamic>> MemberShipPlansMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map['MemberShipPlans']);
    MemberShipPlans.addAll(MemberShipPlansMapList.map((e) => MembershipPlanDetailsModel.fromMap(e)).toList());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "MemberShipName": MemberShipName,
      "DisplayText": DisplayText,
      "MemberShipShortDesc": MemberShipShortDesc,
      "ExpiryDate": ExpiryDate,
      "CouponType": CouponType,
      "MembershipActive": MembershipActive,
      "MemberShipID": MemberShipID,
      "MemberShipLevel": MemberShipLevel,
      "MemberShipDurationID": MemberShipDurationID,
      "SubscriptionTypeID": SubscriptionTypeID,
      "MemberShipPlans": MemberShipPlans.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

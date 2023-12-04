import 'package:flutter_instancy_2/configs/app_constants.dart';

class MyProgressReportRequestModel {
  int aintComponentID;
  int aintCompInsID;
  int aintSelectedGroupValue;
  int aintSiteID;
  int aintUserID;
  String astrLocale;

  MyProgressReportRequestModel({
    required this.aintComponentID,
    required this.aintCompInsID,
    this.aintSelectedGroupValue = 0,
    this.aintSiteID = AppConstants.defaultSiteId,
    this.aintUserID = 0,
    this.astrLocale = AppConstants.defaultLocale,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'aintComponentID': aintComponentID.toString(),
      'aintCompInsID': aintCompInsID.toString(),
      'aintSelectedGroupValue': aintSelectedGroupValue.toString(),
      'aintSiteID': aintSiteID.toString(),
      'aintUserID': aintUserID.toString(),
      'astrLocale': astrLocale,
    };
  }
}

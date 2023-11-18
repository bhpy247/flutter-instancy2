import 'package:flutter_instancy_2/utils/date_representation.dart';

class MobileSaveInAppPurchaseDetailsRequestModel {
  String userId = "";
  String siteURl = "";
  String contentID = "";
  String orderId = "";
  String purchaseToken = "";
  String productId = "";
  String deviceType = "";
  DateTime? purchaseDateTime;
  int ComponentID = 0;
  int ComponentInsID = 0;

  MobileSaveInAppPurchaseDetailsRequestModel({
    this.userId = "",
    this.siteURl = "",
    this.contentID = "",
    this.orderId = "",
    this.purchaseToken = "",
    this.productId = "",
    this.deviceType = "",
    this.purchaseDateTime,
  });

  Map<String, String> toJson() {
    return {
      "_userId": userId,
      "_siteURL": siteURl,
      "_contentId": contentID,
      "_transactionId": orderId,
      "_receipt": purchaseToken,
      "_productId": productId,
      "_purchaseDate": DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd hh:mm:ss", dateTime: purchaseDateTime) ?? "",
      "_devicetype": deviceType,
    };
  }
}

import 'package:flutter_instancy_2/utils/my_utils.dart';

class ContentUserRatingsDataRequestModel {
  String contentId;
  String locale;
  String metadata;
  String intUserId;
  String cartId;
  String iCms;
  String componentId;
  String siteId;
  String detailsCompId;
  String detailsCompInsId;
  String erItems;
  int skippedRows;
  int noOfRows;

  ContentUserRatingsDataRequestModel({
    this.contentId = "",
    this.locale = "",
    this.metadata = "",
    this.intUserId = "",
    this.cartId = "",
    this.iCms = "",
    this.componentId = "",
    this.siteId = "",
    this.detailsCompId = "",
    this.detailsCompInsId = "",
    this.erItems = "",
    this.skippedRows = 0,
    this.noOfRows = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "ContentID": contentId,
      "Locale": locale,
      "metadata": metadata,
      "intUserID": intUserId,
      "CartID": cartId,
      "iCMS": iCms,
      "ComponentID": componentId,
      "SiteID": siteId,
      "DetailsCompID": detailsCompId,
      "DetailsCompInsID": detailsCompInsId,
      "ERitems": erItems,
      "SkippedRows": skippedRows,
      "NoofRows": noOfRows,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
import '../../../configs/app_constants.dart';

class TabsListRequestModel {
  String Locale = "";
  int ComponentID = 0;
  int ComponentInsID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int aintUserID = 0;

  TabsListRequestModel({
    this.Locale = "",
    this.ComponentID = 0,
    this.ComponentInsID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.aintUserID = 0,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "ComponentID": ComponentID.toString(),
      "ComponentInsID": ComponentInsID.toString(),
      "SiteID": SiteID.toString(),
      "aintUserID": aintUserID.toString(),
    };
  }
}

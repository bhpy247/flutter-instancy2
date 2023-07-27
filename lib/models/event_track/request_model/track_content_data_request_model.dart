class TrackContentDataRequestModel {
  String ContentID;
  String localeId;
  String SiteURL;
  int TrackObjectTypeID;
  int TrackScoID;
  int IsDownload;
  int DelivoryMode;
  int UserID;
  int SiteID;
  int OrgUnitID;

  TrackContentDataRequestModel({
    required this.ContentID,
    this.localeId = "",
    this.SiteURL = "",
    required this.TrackObjectTypeID,
    required this.TrackScoID,
    this.IsDownload = 0,
    this.DelivoryMode = 0,
    this.UserID = 0,
    this.SiteID = 0,
    this.OrgUnitID = 0,
  });

  Map<String, String> toJson() {
    return {
      "ContentID" : ContentID,
      "localeId" : localeId,
      "SiteURL" : SiteURL,
      "TrackObjectTypeID" : TrackObjectTypeID.toString(),
      "TrackScoID" : TrackScoID.toString(),
      "IsDownload" : IsDownload.toString(),
      "DelivoryMode" : DelivoryMode.toString(),
      "UserID" : UserID.toString(),
      "SiteID" : SiteID.toString(),
      "OrgUnitID" : OrgUnitID.toString(),
    };
  }
}
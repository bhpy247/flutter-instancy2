class EventTrackHeadersRequestModel {
  String parentcontentID;
  String siteID;
  String userID;
  String localeID;
  int objecttypeid;
  int scoid;
  bool iscontentenrolled;

  EventTrackHeadersRequestModel({
    required this.parentcontentID,
    this.siteID = "",
    this.userID = "",
    this.localeID = "",
    required this.objecttypeid,
    required this.scoid,
    required this.iscontentenrolled,
  });

  Map<String, String> toJson() {
    return {
      "parentcontentID": parentcontentID,
      "siteID": siteID,
      "userID": userID,
      "localeID": localeID,
      "objecttypeid": objecttypeid.toString(),
      "scoid": scoid.toString(),
      "iscontentenrolled": iscontentenrolled.toString(),
    };
  }
}
class EventTrackTabRequestModel {
  String parentcontentID;
  String siteID;
  String userID;
  String localeID;
  String isRelatedContent;
  int compID;
  int compInsID;
  int objecttypeid;

  EventTrackTabRequestModel({
    required this.parentcontentID,
    this.siteID = "",
    this.userID = "",
    this.localeID = "",
    required this.isRelatedContent,
    required this.compID,
    required this.compInsID,
    required this.objecttypeid,
  });

  Map<String, String> toJson() {
    return {
      "parentcontentID": parentcontentID,
      "siteID": siteID,
      "userID": userID,
      "localeID": localeID,
      "isRelatedContent": isRelatedContent,
      "compID": compID.toString(),
      "compInsID": compInsID.toString(),
      "objecttypeid": objecttypeid.toString(),
    };
  }
}
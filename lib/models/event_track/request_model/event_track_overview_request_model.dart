class EventTrackOverviewRequestModel {
  String TrackingUserId;
  String parentContentID;
  String objectTypeID;
  String iscontentenrolled;
  String siteId;
  String localeId;

  EventTrackOverviewRequestModel({
    this.TrackingUserId = "",
    required this.parentContentID,
    required this.objectTypeID,
    required this.iscontentenrolled,
    this.siteId = "",
    this.localeId = "",
  });

  Map<String, String> toJson() {
    return {
      "TrackingUserId": TrackingUserId,
      "parentContentID": parentContentID,
      "objectTypeID": objectTypeID,
      "iscontentenrolled": iscontentenrolled,
      "siteId": siteId,
      "localeId": localeId,
    };
  }
}
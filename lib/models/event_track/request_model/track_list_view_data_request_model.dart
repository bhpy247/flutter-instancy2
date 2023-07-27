class TrackListViewDataRequestModel {
  String parentcontentID;
  String siteID;
  String userID;
  String localeID;
  String blockId;
  String wLaunchType;
  String wLastScoID;
  String TRAutoshow;
  String lIndex;
  int compID;
  int compInsID;
  int objecttypeId;
  int Trackscoid;
  int SampleContentCount;
  bool TrackFreeSample;
  bool isAssignmentTab;
  bool isAssignmentTabEnabled;

  TrackListViewDataRequestModel({
    this.parentcontentID = "",
    this.siteID = "",
    this.userID = "",
    this.localeID = "",
    this.blockId = "",
    this.wLaunchType = "",
    this.wLastScoID = "",
    this.TRAutoshow = "",
    this.lIndex = "",
    this.compID = 0,
    this.compInsID = 0,
    this.objecttypeId = 0,
    this.Trackscoid = 0,
    this.SampleContentCount = 0,
    this.TrackFreeSample = false,
    this.isAssignmentTab = false,
    this.isAssignmentTabEnabled = false,
  });

  Map<String, String> toJson() {
    return {
      "parentcontentID": parentcontentID,
      "siteID": siteID,
      "userID": userID,
      "localeID": localeID,
      "blockId": blockId,
      "wLaunchType": wLaunchType,
      "wLastScoID": wLastScoID,
      "TRAutoshow": TRAutoshow,
      "lIndex": lIndex,
      "compID": compID.toString(),
      "compInsID": compInsID.toString(),
      "objecttypeId": objecttypeId.toString(),
      "Trackscoid": Trackscoid.toString(),
      "SampleContentCount": SampleContentCount.toString(),
      "TrackFreeSample": TrackFreeSample.toString(),
      "isAssignmentTab": isAssignmentTab.toString(),
      "isAssignmentTabEnabled": isAssignmentTabEnabled.toString(),
    };
  }
}
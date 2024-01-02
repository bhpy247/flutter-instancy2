class EventRelatedContentsDataRequestModel {
  String Locale = "";
  String ContentID = "";
  int pageIndex = 0;
  int pageSize = 0;
  int UserID = 0;
  int SiteID = 0;
  int ComponentID = 0;
  int ComponentInsID = 0;
  int Categoryid = 0;
  bool isAssignmentTab = false;
  bool isAssignmentTabEnabled = false;

  EventRelatedContentsDataRequestModel({
    this.Locale = "",
    this.ContentID = "",
    this.pageIndex = 0,
    this.pageSize = 0,
    this.UserID = 0,
    this.SiteID = 0,
    this.ComponentID = 0,
    this.ComponentInsID = 0,
    this.Categoryid = 0,
    this.isAssignmentTab = false,
    this.isAssignmentTabEnabled = false,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "ContentID": ContentID,
      "pageIndex": pageIndex.toString(),
      "pageSize": pageSize.toString(),
      "UserID": UserID.toString(),
      "SiteID": SiteID.toString(),
      "ComponentID": ComponentID.toString(),
      "ComponentInsID": ComponentInsID.toString(),
      "Categoryid": Categoryid.toString(),
      "isAssignmentTab": isAssignmentTab.toString(),
      "isAssignmentTabEnabled": isAssignmentTabEnabled.toString(),
    };
  }
}

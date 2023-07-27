class EventRelatedContentDataRequestModel {
  String contentId;
  String locale;
  int parentcomponentid;
  int categoryid;
  int userId;
  int siteid;

  EventRelatedContentDataRequestModel({
    this.contentId = "",
    this.locale = "",
    this.parentcomponentid = 1,
    this.categoryid = -1,
    this.userId = 0,
    this.siteid = 0,
  });

  Map<String, String> toJson() {
    return {
    "contentId" : contentId,
    "locale" : locale,
    "parentcomponentid" : parentcomponentid.toString(),
    "categoryid" : categoryid.toString(),
    "userId" : userId.toString(),
    "siteid" : siteid.toString(),
    };
  }
}
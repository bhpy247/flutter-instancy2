class GetQuestionListRequestModel {
  int intUserID;
  int intSiteID;
  int intCompID;
  int intCompInsID;
  int pageIndex;
  int pageSize;
  String strSearchText;
  String strSortCondition;
  String sortby;
  String intSkillID;
  String questionId;
  bool IsMydiscussion;

  GetQuestionListRequestModel({
    this.intUserID = 0,
    this.intSiteID = 0,
    this.intCompID = 0,
    this.intCompInsID = 0,
    this.pageIndex = 0,
    this.pageSize = 0,
    this.strSearchText = "",
    this.strSortCondition = "",
    this.sortby = "",
    this.intSkillID = "-1",
    this.questionId = "",
    this.IsMydiscussion = false,
  });

  Map<String, String> toJson() {
    return {
      "UserID": intUserID.toString(),
      "intSiteID": intSiteID.toString(),
      "ComponentID": intCompID.toString(),
      "ComponentInsID": intCompInsID.toString(),
      "pageIndex": pageIndex.toString(),
      "pageSize": pageSize.toString(),
      "SearchText": strSearchText,
      "SortBy": sortby,
      "intSkillID": intSkillID,
    };
  }
}

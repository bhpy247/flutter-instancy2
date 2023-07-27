class GetDiscussionForumListRequestModel {
  int intUserID;
  int intSiteID;
  int intCompID;
  int intCompInsID;
  int intShowPrivateForums;
  int pageIndex;
  int pageSize;
  int RecordsCount;
  String strLocale;
  String strSearchText;
  String strSortCondition;
  String sortby;
  String sorttype;
  String CategoryIds;
  String forumcontentId;

  GetDiscussionForumListRequestModel({
    this.intUserID = 0,
    this.intSiteID = 0,
    this.intCompID = 0,
    this.intCompInsID = 0,
    this.intShowPrivateForums = 0,
    this.pageIndex = 0,
    this.pageSize = 0,
    this.RecordsCount = 0,
    this.strLocale = "",
    this.strSearchText = "",
    this.strSortCondition = "",
    this.sortby = "",
    this.sorttype = "",
    this.CategoryIds = "",
    this.forumcontentId = "",
  });

  Map<String, String> toJson() {
    return {
      "intUserID" : intUserID.toString(),
      "intSiteID" : intSiteID.toString(),
      "intCompID" : intCompID.toString(),
      "intCompInsID" : intCompInsID.toString(),
      "intShowPrivateForums" : intShowPrivateForums.toString(),
      "pageIndex" : pageIndex.toString(),
      "pageSize" : pageSize.toString(),
      "RecordsCount" : RecordsCount.toString(),
      "strLocale" : strLocale,
      "strSearchText" : strSearchText,
      "strSortCondition" : strSortCondition,
      "sortby" : sortby,
      "sorttype" : sorttype,
      "CategoryIds" : CategoryIds,
      "forumcontentId" : forumcontentId,
    };
  }
}
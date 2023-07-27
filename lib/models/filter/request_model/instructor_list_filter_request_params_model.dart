class InstructorListFilterRequestParamsModel {
  int SiteID;
  int UserID;
  int IsShowOnlyPresenter;

  InstructorListFilterRequestParamsModel({
    required this.SiteID,
    required this.UserID,
    required this.IsShowOnlyPresenter,
  });

  Map<String, String> toMap() {
    return <String, String>{
      "instSiteID" : SiteID.toString(),
      "instUserID" : UserID.toString(),
      "IsShowOnlyPresenter" : IsShowOnlyPresenter.toString(),
    };
  }
}
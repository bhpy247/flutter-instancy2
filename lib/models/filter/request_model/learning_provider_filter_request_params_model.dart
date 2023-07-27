class LearningProviderFilterRequestParamsModel {
  int SiteID;
  int UserID;
  String PrivacyType;

  LearningProviderFilterRequestParamsModel({
    required this.SiteID,
    required this.UserID,
    required this.PrivacyType,
  });

  Map<String, String> toMap() {
    return <String, String>{
      "instSiteID" : SiteID.toString(),
      "instUserID" : UserID.toString(),
      "PrivacyType" : PrivacyType,
    };
  }
}
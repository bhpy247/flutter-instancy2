class CourseLaunchModel {
  int ContentTypeId;
  int MediaTypeId;
  int ScoID;
  int SiteUserID;
  int SiteId;
  String ContentID;
  String locale;
  String ContentName;
  String FolderPath;
  String startPage;
  String jwstartpage;
  String JWVideoKey;
  String ActivityId;
  String ActualStatus;
  bool bit5;

  CourseLaunchModel({
    required this.ContentTypeId,
    required this.MediaTypeId,
    required this.ScoID,
    required this.SiteUserID,
    required this.SiteId,
    required this.ContentID,
    required this.locale,
    this.ContentName = "",
    this.FolderPath = "",
    this.startPage = "",
    this.jwstartpage = "",
    this.JWVideoKey = "",
    this.ActivityId = "",
    this.ActualStatus = "",
    this.bit5 = false,
  });
}
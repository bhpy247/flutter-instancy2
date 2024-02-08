class CourseDownloadRequestModel {
  String ContentID = "";
  String FolderPath = "";
  String JWVideoKey = "";
  String StartPage = "";
  String JWStartPage = "";
  int ContentTypeId = 0;
  int MediaTypeID = 0;
  int SiteId = 0;
  int UserID = 0;
  int ScoId = 0;

  CourseDownloadRequestModel({
    this.ContentID = "",
    this.FolderPath = "",
    this.JWVideoKey = "",
    this.StartPage = "",
    this.JWStartPage = "",
    this.ContentTypeId = 0,
    this.MediaTypeID = 0,
    this.SiteId = 0,
    this.UserID = 0,
    this.ScoId = 0,
  });
}

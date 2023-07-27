class GetCompletionCertificateParamsModel {
  int? UserID;
  String Content_ID;
  String CertificateID;
  String CertificatePage;
  String siteURL;
  int? SiteID;
  int? height;
  int? width;

  GetCompletionCertificateParamsModel({
    this.UserID,
    this.Content_ID = "",
    this.CertificateID = "",
    this.CertificatePage = "",
    this.siteURL = "",
    this.SiteID,
    this.height,
    this.width,
  });

  Map<String, String> toMap() {
    return <String, String>{
      if(UserID != null) "UserID" : UserID.toString(),
      "Content_ID" : Content_ID,
      "CertID" : CertificateID,
      "CertPage" : CertificatePage,
      "siteURL" : siteURL,
      if(SiteID != null) 'SiteID': SiteID.toString(),
      if(height != null) 'height': height.toString(),
      if(width != null) 'width': width.toString(),
    };
  }

  @override
  String toString() {
    return "GetCompletionCertificateParamsModel(${toMap()})";
  }
}
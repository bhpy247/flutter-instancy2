class EcommerceOrderRequestModel {
  String Locale = "";
  int UserID = 0;
  int SiteID = 0;

  EcommerceOrderRequestModel({
    this.Locale = "",
    this.UserID = 0,
    this.SiteID = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "Locale": Locale,
      "UserID": UserID,
      "SiteID": SiteID,
    };
  }
}

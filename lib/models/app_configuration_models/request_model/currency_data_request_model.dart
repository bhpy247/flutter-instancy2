class CurrencyDataRequestModel {
  String strUserCountry = "";
  int intSiteID = 0;

  CurrencyDataRequestModel({
    this.strUserCountry = "",
    this.intSiteID = 0,
  });

  Map<String, String> toJson() {
    return {
      "strUserCountry": strUserCountry,
      "intSiteID": intSiteID.toString(),
    };
  }
}

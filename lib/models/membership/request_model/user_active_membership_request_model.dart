class UserActiveMembershipRequestModel {
  String Locale = "";
  String PaymentGatway = "";
  String CurrencySign = "";
  int UserID = 0;
  int SiteID = 0;

  UserActiveMembershipRequestModel({
    this.Locale = "",
    this.PaymentGatway = "",
    this.CurrencySign = "",
    this.UserID = 0,
    this.SiteID = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "Locale": Locale,
      "PaymentGatway": PaymentGatway,
      "CurrencySign": CurrencySign,
      "UserID": UserID,
      "SiteID": SiteID,
    };
  }
}

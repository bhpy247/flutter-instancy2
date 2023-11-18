import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../../utils/my_utils.dart';

class EcommerceProcessPaymentRequestModel {
  String Locale = "";
  String CouponCode = "";
  String ContentID = "";
  String contentIDList = "";
  String PaymentGatway = "";
  String CurrencySign = "";
  String TransType = "";
  String Rtype = "";
  String RenewType = "";
  String PayLoadNounce = "";
  String Renew = "";
  String DurationID = "";
  String TuID = "";
  String Status = "";
  String payType = "";
  String RenewalUser = "";
  String Address1 = "";
  String Address2 = "";
  String City = "";
  String Country = "";
  String State = "";
  String Zip = "";
  String Phone = "";
  String EmailID = "";
  String ShipAddress1 = "";
  String ShipAddress2 = "";
  String ShipCity = "";
  String ShipCountry = "";
  String ShipState = "";
  String ShipZip = "";
  String ShipPhone = "";
  String ShipEmailID = "";
  String SubScriptionID = "";
  String CustomerID = "";
  String PaymentTokenID = "";
  String PaymentModetype = "";
  String PaymentGatewayType = "";
  String merc_hash_var = "";
  String hash = "";
  String txnid = "";
  String CardNO = "";
  String merc_hash_string = "";
  String unmappedStatus = "";
  String BuyItemName = "";
  String BuyAttemptValue = "";
  String TouchnetSessionIdentifierPayment = "";
  String PaymentAuthKey = "";
  String token = "";
  String PayPalToken = "";
  String PayPalPayerID = "";
  String CardType = "";
  String CardVerificationNumber = "";
  String CardName = "";
  String CardEmailID = "";
  String CardMonth = "";
  String CardYear = "";
  String IsPhysicalProduct = "";
  String TransactionID = "";
  String ObjectID = "";
  String CurrentAPPURL = "";
  String NavigationKey = "";
  String StripeCustomerid = "";
  String StripeSubScriptionid = "";
  String stripePaymentmethod = "";
  int ApplyOffer = 0;
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int? ComponentID;
  int? ComponentInsID;
  int PaymentModeID = 0;
  int MembershipTempUserID = 0;
  int MembershipUpgradeUserID = 0;
  int BuyScoID = 0;
  double TotalPrice = 0;
  double DiscountAmount = 0;
  double ConvertedPrice = 0;
  double ConvertedInitialPrice = 0;
  bool showcoupons = false;
  bool AddressAvailable = false;
  bool DirectPaymentResponse = false;
  bool DiscountFixedCoupon = false;
  bool BuyAttempt = false;
  bool CombinedTransaction = false;
  bool IsNativeApp = false;
  bool IsJoinMembershipPayment = false;

  EcommerceProcessPaymentRequestModel({
    this.Locale = "",
    this.CouponCode = "",
    this.ContentID = "",
    this.contentIDList = "",
    this.PaymentGatway = "",
    this.CurrencySign = "",
    this.TransType = "",
    this.Rtype = "",
    this.RenewType = "",
    this.PayLoadNounce = "",
    this.Renew = "",
    this.DurationID = "",
    this.TuID = "",
    this.Status = "",
    this.payType = "",
    this.RenewalUser = "",
    this.Address1 = "",
    this.Address2 = "",
    this.City = "",
    this.Country = "",
    this.State = "",
    this.Zip = "",
    this.Phone = "",
    this.EmailID = "",
    this.ShipAddress1 = "",
    this.ShipAddress2 = "",
    this.ShipCity = "",
    this.ShipCountry = "",
    this.ShipState = "",
    this.ShipZip = "",
    this.ShipPhone = "",
    this.ShipEmailID = "",
    this.SubScriptionID = "",
    this.CustomerID = "",
    this.PaymentTokenID = "",
    this.PaymentModetype = "",
    this.PaymentGatewayType = "",
    this.merc_hash_var = "",
    this.hash = "",
    this.txnid = "",
    this.CardNO = "",
    this.merc_hash_string = "",
    this.unmappedStatus = "",
    this.BuyItemName = "",
    this.BuyAttemptValue = "",
    this.TouchnetSessionIdentifierPayment = "",
    this.PaymentAuthKey = "",
    this.token = "",
    this.PayPalToken = "",
    this.PayPalPayerID = "",
    this.CardType = "",
    this.CardVerificationNumber = "",
    this.CardName = "",
    this.CardEmailID = "",
    this.CardMonth = "",
    this.CardYear = "",
    this.IsPhysicalProduct = "",
    this.TransactionID = "",
    this.ObjectID = "",
    this.CurrentAPPURL = "",
    this.NavigationKey = "",
    this.StripeCustomerid = "",
    this.StripeSubScriptionid = "",
    this.stripePaymentmethod = "",
    this.ApplyOffer = 0,
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.ComponentID,
    this.ComponentInsID,
    this.PaymentModeID = 0,
    this.MembershipTempUserID = 0,
    this.MembershipUpgradeUserID = 0,
    this.BuyScoID = 0,
    this.TotalPrice = 0,
    this.DiscountAmount = 0,
    this.ConvertedPrice = 0,
    this.ConvertedInitialPrice = 0,
    this.showcoupons = false,
    this.AddressAvailable = false,
    this.DirectPaymentResponse = false,
    this.DiscountFixedCoupon = false,
    this.BuyAttempt = false,
    this.CombinedTransaction = false,
    this.IsNativeApp = false,
    this.IsJoinMembershipPayment = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "Locale": Locale,
      "CouponCode": CouponCode,
      "ContentID": ContentID,
      "contentIDList": contentIDList,
      "PaymentGatway": PaymentGatway,
      "CurrencySign": CurrencySign,
      "TransType": TransType,
      "Rtype": Rtype,
      "RenewType": RenewType,
      "PayLoadNounce": PayLoadNounce,
      "Renew": Renew,
      "DurationID": DurationID,
      "TuID": TuID,
      "Status": Status,
      "payType": payType,
      "RenewalUser": RenewalUser,
      "Address1": Address1,
      "Address2": Address2,
      "City": City,
      "Country": Country,
      "State": State,
      "Zip": Zip,
      "Phone": Phone,
      "EmailID": EmailID,
      "ShipAddress1": ShipAddress1,
      "ShipAddress2": ShipAddress2,
      "ShipCity": ShipCity,
      "ShipCountry": ShipCountry,
      "ShipState": ShipState,
      "ShipZip": ShipZip,
      "ShipPhone": ShipPhone,
      "ShipEmailID": ShipEmailID,
      "SubScriptionID": SubScriptionID,
      "CustomerID": CustomerID,
      "PaymentTokenID": PaymentTokenID,
      "PaymentModetype": PaymentModetype,
      "PaymentGatewayType": PaymentGatewayType,
      "merc_hash_var": merc_hash_var,
      "hash": hash,
      "txnid": txnid,
      "CardNO": CardNO,
      "merc_hash_string": merc_hash_string,
      "unmappedStatus": unmappedStatus,
      "BuyItemName": BuyItemName,
      "BuyAttemptValue": BuyAttemptValue,
      "TouchnetSessionIdentifierPayment": TouchnetSessionIdentifierPayment,
      "PaymentAuthKey": PaymentAuthKey,
      "token": token,
      "PayPalToken": PayPalToken,
      "PayPalPayerID": PayPalPayerID,
      "CardType": CardType,
      "CardVerificationNumber": CardVerificationNumber,
      "CardName": CardName,
      "CardEmailID": CardEmailID,
      "CardMonth": CardMonth,
      "CardYear": CardYear,
      "IsPhysicalProduct": IsPhysicalProduct,
      "TransactionID": TransactionID,
      "ObjectID": ObjectID,
      "CurrentAPPURL": CurrentAPPURL,
      "NavigationKey": NavigationKey,
      "StripeCustomerid": StripeCustomerid,
      "StripeSubScriptionid": StripeSubScriptionid,
      "stripePaymentmethod": stripePaymentmethod,
      "ApplyOffer": ApplyOffer,
      "UserID": UserID,
      "SiteID": SiteID,
      "ComponentID": ComponentID,
      "ComponentInsID": ComponentInsID,
      "PaymentModeID": PaymentModeID,
      "MembershipTempUserID": MembershipTempUserID,
      "MembershipUpgradeUserID": MembershipUpgradeUserID,
      "BuyScoID": BuyScoID,
      "TotalPrice": TotalPrice,
      "DiscountAmount": DiscountAmount,
      "ConvertedPrice": ConvertedPrice,
      "ConvertedInitialPrice": ConvertedInitialPrice,
      "showcoupons": showcoupons,
      "AddressAvailable": AddressAvailable,
      "DirectPaymentResponse": DirectPaymentResponse,
      "DiscountFixedCoupon": DiscountFixedCoupon,
      "BuyAttempt": BuyAttempt,
      "CombinedTransaction": CombinedTransaction,
      "IsNativeApp": IsNativeApp,
      "IsJoinMembershipPayment": IsJoinMembershipPayment,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

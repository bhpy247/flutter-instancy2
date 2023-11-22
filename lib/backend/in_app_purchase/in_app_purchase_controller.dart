import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/data_model/ecommerce_order_dto_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/request_model/ecommerce_order_request_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/request_model/ecommerce_process_payment_request_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/request_model/ecommerce_purchase_data_request_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/response_model/ecommerce_order_response_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/response_model/ecommerce_process_payment_response_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/src/billing_client_wrappers/billing_client_wrapper.dart';
import 'package:in_app_purchase_android/src/types/change_subscription_param.dart';
import 'package:in_app_purchase_android/src/types/google_play_purchase_details.dart';
import 'package:in_app_purchase_android/src/types/google_play_purchase_param.dart';
import 'package:in_app_purchase_storekit/src/types/app_store_product_details.dart';
import 'package:in_app_purchase_storekit/src/types/app_store_purchase_param.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../api/api_controller.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../models/in_app_purchase/request_model/mobile_save_in_app_purchase_details_request_model.dart';
import '../../views/common/components/app_ui_components.dart';
import '../../views/common/components/platform_alert_dialog.dart';
import 'in_app_purchase_provider.dart';
import 'in_app_purchase_repository.dart';

class InAppPurchaseController {
  late InAppPurchaseProvider inAppPurchaseProvider;
  late InAppPurchaseRepository inAppPurchaseRepository;

  static bool isStoreAvailable = false;

  InAppPurchaseController({
    InAppPurchaseProvider? provider,
    InAppPurchaseRepository? repository,
    ApiController? apiController,
  }) {
    inAppPurchaseProvider = provider ?? InAppPurchaseProvider();
    inAppPurchaseRepository = repository ?? InAppPurchaseRepository(apiController: apiController ?? ApiController());
  }

  static Future<bool> checkStoreAvailable() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController().checkStoreAvailable() called", tag: tag);

    MyPrint.printOnConsole("isStoreAvailable before:$isStoreAvailable", tag: tag);
    if (!isStoreAvailable) {
      MyPrint.printOnConsole("Checking for Store Available or not", tag: tag);
      isStoreAvailable = await InAppPurchase.instance.isAvailable();
    }
    MyPrint.printOnConsole("Final isStoreAvailable:$isStoreAvailable", tag: tag);
    return isStoreAvailable;
  }

  Future<PurchaseDetails?> launchInAppPurchase(
    ProductDetails productDetails, {
    GooglePlayPurchaseDetails? oldSubscription,
    bool isConsumable = true,
    bool isShowConfirmationDialog = false,
    BuildContext? context,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController().launchInAppPurchase() called with product id:${productDetails.id}, oldSubscription:$oldSubscription", tag: tag);

    if (kIsWeb) {
      return null;
    }

    if (isShowConfirmationDialog) {
      if (context == null || !context.mounted) {
        MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because isShowConfirmationDialog is true but context is null", tag: tag);
        return null;
      }

      String productName = "";
      if (defaultTargetPlatform == TargetPlatform.android) {
        productName = productDetails.title;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        AppStoreProductDetails details = productDetails as AppStoreProductDetails;
        productName = details.skProduct.localizedTitle;
      }

      MyPrint.printOnConsole("productName:$productName", tag: tag);
      MyPrint.printOnConsole("productDetails.title:${productDetails.title}", tag: tag);
      MyPrint.printOnConsole("productDetails.description:${productDetails.description}", tag: tag);
      MyPrint.printOnConsole("productDetails.price:${productDetails.price}", tag: tag);
      MyPrint.printOnConsole("productDetails.rawPrice:${productDetails.rawPrice}", tag: tag);
      dynamic value = await AppUIComponents.showMyPlatformDialog(
        context: context,
        dialog: PlatformAlertDialog(
          title: 'Confirm Your In App Purchase',
          content: "Do you want to buy $productName for ${productDetails.price}?",
          cancelActionText: 'Cancel',
          defaultActionText: 'Buy',
        ),
        barrierDismissible: false,
      );
      MyPrint.printOnConsole("value:$value", tag: tag);

      if (value != true) {
        MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because user didn't gave confirmation", tag: tag);
        return null;
      }
    }

    bool isStoreAvailable = await checkStoreAvailable();
    if (!isStoreAvailable) {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because store is not available", tag: tag);
      return null;
    }

    Map<String, bool> completedPurchases = await _completePendingPurchases();
    MyPrint.printOnConsole("completedPurchases:'$completedPurchases'", tag: tag);

    if (completedPurchases[productDetails.id] == false) {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because Couldn't complete previous purchase for Product:${productDetails.id}", tag: tag);
      return null;
    }

    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
        changeSubscriptionParam: (oldSubscription != null)
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                prorationMode: ProrationMode.immediateWithTimeProration,
              )
            : null,
      );
    } else {
      purchaseParam = AppStorePurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }

    bool isBuyRequestSent = false;
    try {
      //Make Sure that the product you are buying if it is a subscription, don't call butConsumable for it, it must call buyNonConsumable
      if (isConsumable && !productDetails.id.endsWith(".subscription")) {
        isBuyRequestSent = await InAppPurchase.instance.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true,
        );
      } else {
        isBuyRequestSent = await InAppPurchase.instance.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in buyConsumable/buyNonConsumable:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isBuyRequestSent:$isBuyRequestSent", tag: tag);

    if (!isBuyRequestSent) {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because Buy Request Not Sent", tag: tag);
      return null;
    }

    List<PurchaseDetails> purchaseDetails = await InAppPurchase.instance.purchaseStream.first;
    /*List<PurchaseDetails> purchaseDetails = await InAppPurchase.instance.purchaseStream.where((List<PurchaseDetails> purchaseDetails) {
      return purchaseDetails.where((element) => element.productID == productDetails.id && element.status != PurchaseStatus.pending).toList().isNotEmpty;
    }).first;*/
    MyPrint.printOnConsole("purchaseDetails length:${purchaseDetails.length}", tag: tag);

    if (purchaseDetails.isEmpty) {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().launchInAppPurchase() because couldn't get purchaseDetails", tag: tag);
      return null;
    }

    PurchaseDetails purchaseDetailsModel = purchaseDetails.first;
    MyPrint.printOnConsole("Purchase productID:'${purchaseDetailsModel.productID}'", tag: tag);
    MyPrint.printOnConsole("Purchase Status:${purchaseDetailsModel.status}", tag: tag);
    MyPrint.printOnConsole("Purchase Error:${purchaseDetailsModel.error?.code} | ${purchaseDetailsModel.error?.message}", tag: tag);

    if (purchaseDetailsModel.status == PurchaseStatus.pending) {
      purchaseDetails = await InAppPurchase.instance.purchaseStream.first;
      MyPrint.printOnConsole("again purchaseDetails length:${purchaseDetails.length}", tag: tag);

      if (purchaseDetails.isNotEmpty) {
        PurchaseDetails purchaseDetailsModel = purchaseDetails.first;
        MyPrint.printOnConsole("Again Purchase Status:${purchaseDetailsModel.status}", tag: tag);
        MyPrint.printOnConsole("Again Purchase Error:${purchaseDetailsModel.error?.code} | ${purchaseDetailsModel.error?.message}", tag: tag);

        if ([PurchaseStatus.purchased, PurchaseStatus.restored].contains(purchaseDetailsModel.status) && purchaseDetailsModel.pendingCompletePurchase) {
          MyPrint.printOnConsole("Complete Purchase Started", tag: tag);
          try {
            await InAppPurchase.instance.completePurchase(purchaseDetailsModel);
            purchaseDetailsModel.pendingCompletePurchase = false;
          } on InAppPurchaseException catch (e, s) {
            MyPrint.printOnConsole("InAppPurchaseException when colpleting purchase in InAppPurchaseController().buyConsumable():$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          } catch (e, s) {
            MyPrint.printOnConsole("Error when colpleting purchase in InAppPurchaseController().buyConsumable():$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }
          MyPrint.printOnConsole("Complete Purchase Finished", tag: tag);
        } else if (purchaseDetailsModel.status == PurchaseStatus.pending) {
          return null;
        }

        return purchaseDetailsModel;
      } else {
        return null;
      }
    }
    if ([PurchaseStatus.purchased, PurchaseStatus.restored].contains(purchaseDetailsModel.status) && purchaseDetailsModel.pendingCompletePurchase) {
      MyPrint.printOnConsole("Complete Purchase Started", tag: tag);
      try {
        await InAppPurchase.instance.completePurchase(purchaseDetailsModel);
        purchaseDetailsModel.pendingCompletePurchase = false;
      } on InAppPurchaseException catch (e, s) {
        MyPrint.printOnConsole("InAppPurchaseException when completing purchase in InAppPurchaseController().buyConsumable():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      } catch (e, s) {
        MyPrint.printOnConsole("Error when colpleting purchase in InAppPurchaseController().buyConsumable():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
      MyPrint.printOnConsole("Complete Purchase Finished", tag: tag);
    }

    return purchaseDetailsModel;
  }

  Future<Map<String, bool>> _completePendingPurchases() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController()._completePendingPurchases() called", tag: tag);

    Map<String, bool> completedPurchases = {};

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      MyPrint.printOnConsole("Checking for iOS platform", tag: tag);
      try {
        List<SKPaymentTransactionWrapper> transactions = await SKPaymentQueueWrapper().transactions();
        MyPrint.printOnConsole("ios transactions length:${transactions.length}", tag: tag);

        for (SKPaymentTransactionWrapper transaction in transactions) {
          MyPrint.printOnConsole(
              "productIdentifier:${transaction.payment.productIdentifier}, transactionState:${transaction.transactionState}, transactionIdentifier:${transaction.transactionIdentifier}",
              tag: tag);
          try {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            completedPurchases[transaction.payment.productIdentifier] = true;
          } catch (e, s) {
            MyPrint.printOnConsole("Error clearing pending ios purchase for productIdentifier ${transaction.payment.productIdentifier}:$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
            completedPurchases[transaction.payment.productIdentifier] = false;
            rethrow;
          }
        }
      } catch (e, s) {
        MyPrint.printOnConsole("Error clearing pending ios purchases:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
        rethrow;
      }
    }

    return completedPurchases;
  }

  Future<Map<String, ProductDetails>> getProductDetails(List<String> productIds) async {
    Map<String, ProductDetails> map = {};

    //This Check is
    if (await checkStoreAvailable()) {
      try {
        ProductDetailsResponse productDetailsResponse = await InAppPurchase.instance.queryProductDetails(productIds.toSet());
        productDetailsResponse.productDetails.forEach((element) {
          map[element.id] = element;
        });

        if (productDetailsResponse.notFoundIDs.isNotEmpty) {
          MyPrint.printOnConsole("Not Found Ids:${productDetailsResponse.notFoundIDs}");
          await Future.delayed(const Duration(seconds: 1));
          ProductDetailsResponse productDetailsResponseNew = await InAppPurchase.instance.queryProductDetails(productDetailsResponse.notFoundIDs.toSet());
          productDetailsResponseNew.productDetails.forEach((element) {
            map[element.id] = element;
          });
        }
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Getting Purchase Details in InAppPurchaseController().getProductDetails():$e");
        MyPrint.printOnConsole(s);
      }
    }

    return map;
  }

  Future<bool> saveInAppPurchaseDetails({required MobileSaveInAppPurchaseDetailsRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController().saveInAppPurchaseDetails() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    DataResponseModel<String> dataResponseModel = await inAppPurchaseRepository.saveInAppPurchaseDetails(requestModel: requestModel);
    MyPrint.printOnConsole("dataResponseModel statusCode:${dataResponseModel.statusCode}");
    MyPrint.printOnConsole("dataResponseModel data:'${dataResponseModel.data}'");

    isSuccess = dataResponseModel.statusCode == 200 && dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess");

    return isSuccess;
  }

  Future<bool> purchaseProduct({required EcommerceProcessPaymentRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController().purchaseProduct() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = inAppPurchaseRepository.apiController.apiDataProvider;

    if (requestModel.PaymentGatway.isEmpty) {
      requestModel.PaymentGatway = !kIsWeb ? (defaultTargetPlatform == TargetPlatform.android ? "Android" : (defaultTargetPlatform == TargetPlatform.iOS ? "IOS" : "")) : "";
    }
    requestModel.PaymentModetype = "store";
    requestModel.PaymentGatewayType = "F";
    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();

    DataResponseModel<EcommerceProcessPaymentResponseModel> processPaymentDataResponseModel = await inAppPurchaseRepository.processPayments(requestModel: requestModel);
    MyPrint.printOnConsole("processPaymentDataResponseModel statusCode:${processPaymentDataResponseModel.statusCode}");
    MyPrint.printOnConsole("processPaymentDataResponseModel data:'${processPaymentDataResponseModel.data}'");

    isSuccess = processPaymentDataResponseModel.statusCode == 200 && processPaymentDataResponseModel.data?.Result == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess");

    if (!isSuccess) {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().purchaseProduct() because Payment Couldn't Process", tag: tag);
      return false;
    }

    if (requestModel.TransType == "membership") {
      MyPrint.printOnConsole("Returning from InAppPurchaseController().purchaseProduct() because requestModel.TransType is membership", tag: tag);
      MyPrint.printOnConsole("Final isSuccess:$isSuccess", tag: tag);
      return isSuccess;
    }

    DataResponseModel<dynamic> purchaseDataResponseModel = await inAppPurchaseRepository.purchaseData(
      requestModel: EcommercePurchaseDataRequestModel(
        UserID: requestModel.UserID,
        contentIDList: requestModel.ContentID,
        CouponCode: requestModel.CouponCode,
      ),
    );
    MyPrint.printOnConsole("purchaseDataResponseModel statusCode:${purchaseDataResponseModel.statusCode}");
    MyPrint.printOnConsole("purchaseDataResponseModel data:'${purchaseDataResponseModel.data}'");

    isSuccess = purchaseDataResponseModel.statusCode == 200;
    MyPrint.printOnConsole("Final isSuccess:$isSuccess");

    return isSuccess;
  }

  Future<List<EcommerceOrderResponseModel>> getPurchaseHistoryData({
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InAppPurchaseController().getPurchaseHistoryData() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    InAppPurchaseProvider provider = inAppPurchaseProvider;

    List<EcommerceOrderResponseModel> monthwiseOrderList = provider.purchaseHistoryOrdersList.getList();

    if (isRefresh || monthwiseOrderList.isEmpty) {
      monthwiseOrderList.clear();

      provider.isPurchaseHistoryOrdersLoading.set(value: true, isNotify: isNotify);

      DataResponseModel<EcommerceOrderResponseModel> response = await inAppPurchaseRepository.GetEcommerceOrderByUser(
        requestModel: EcommerceOrderRequestModel(
          UserID: inAppPurchaseRepository.apiController.apiDataProvider.getCurrentUserId(),
        ),
      );
      MyPrint.logOnConsole("GetEcommerceOrderByUser response:$response", tag: tag);

      provider.isPurchaseHistoryOrdersLoading.set(value: false, isNotify: true);

      if (response.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from InAppPurchaseController().getPurchaseHistoryData() because GetEcommerceOrderByUser had some error", tag: tag);
        return monthwiseOrderList;
      }

      if (response.data != null) {
        // response.data!.Table[1].PurchaseDateTime = DateTime(2023, 9, 2);
        // response.data!.Table[2].PurchaseDateTime = DateTime(2023, 10, 2);
        DateTime now = DateTime.now();

        EcommerceOrderResponseModel? monthModel;
        for (EcommerceOrderDTOModel model in response.data!.Table) {
          DateTime? PurchaseDateTime = model.PurchaseDateTime;

          if (PurchaseDateTime == null) continue;

          bool isSameMonth = DatePresentation.isSameMonth(PurchaseDateTime, now);

          String monthString = isSameMonth ? "This Month" : (DatePresentation.getFormattedDate(dateFormat: "MMM yyyy", dateTime: PurchaseDateTime) ?? "");

          if (monthString.isEmpty) continue;

          if (monthModel?.monthString == monthString) {
            monthModel!.Table.add(model);
          } else {
            monthModel = EcommerceOrderResponseModel(
              monthString: monthString,
              Table: [
                model,
              ],
            );
            monthwiseOrderList.add(monthModel);
          }
        }
      }
    }

    MyPrint.logOnConsole("final orderList length:${monthwiseOrderList.length}", tag: tag);
    provider.purchaseHistoryOrdersList.setList(list: monthwiseOrderList, isClear: true, isNotify: true);

    return monthwiseOrderList;
  }
}

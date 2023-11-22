import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_hive_repository.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/content_review_ratings/content_review_ratings_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_repository.dart';
import 'package:flutter_instancy_2/backend/progress_report/progress_report_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/currency_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/successful_user_login_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/user_sign_up_details_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/forgot_password_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/mobile_create_sign_up_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/signup_field_response_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/sign_up_response_dto_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/user_save_profile_data_request_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/sign_up_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/authentication/screens/login_signup_selection_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../api/api_controller.dart';
import '../../hive/hive_operation_controller.dart';
import '../../models/authentication/data_model/profile_config_data_model.dart';
import '../../models/authentication/data_model/profile_config_data_ui_control_model.dart';
import '../../models/authentication/request_model/email_login_request_model.dart';
import '../../models/authentication/response_model/email_login_response_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/in_app_purchase/request_model/ecommerce_process_payment_request_model.dart';
import '../../models/membership/data_model/membership_plan_details_model.dart';
import '../../utils/my_utils.dart';
import '../app/app_provider.dart';
import '../in_app_purchase/in_app_purchase_controller.dart';
import '../main_screen/main_screen_provider.dart';
import 'authentication_repository.dart';

class AuthenticationController {
  late AuthenticationProvider authenticationProvider;
  late AuthenticationRepository authenticationRepository;
  late AuthenticationHiveRepository authenticationHiveRepository;

  AuthenticationController({AuthenticationProvider? provider, AuthenticationRepository? repository, AuthenticationHiveRepository? hiveRepository, ApiController? apiController}) {
    authenticationProvider = provider ?? AuthenticationProvider();
    authenticationRepository = repository ?? AuthenticationRepository(apiController: apiController ?? ApiController());
    authenticationHiveRepository = hiveRepository ?? AuthenticationHiveRepository(hiveOperationController: HiveOperationController());
  }

  Future<bool> isUserLoggedIn() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().isUserLoggedIn() called", tag: tag);

    bool isLoggedIn = false;

    EmailLoginResponseModel? emailLoginResponseModel = await authenticationHiveRepository.getLoggedInUserData();
    SuccessfulUserLoginModel? successfulUserLoginModel = emailLoginResponseModel?.successFullUserLogin.firstElement;
    MyPrint.printOnConsole("successfulUserLoginModel:$successfulUserLoginModel", tag: tag);

    isLoggedIn = successfulUserLoginModel != null;
    MyPrint.printOnConsole("isLoggedIn:$isLoggedIn", tag: tag);

    authenticationProvider.setSuccessfulUserLoginModel(successfulUserLoginModel: successfulUserLoginModel);
    _initializeUserDataInApiControllerFromSuccessfulUserLoginModel(successfulUserLoginModel: successfulUserLoginModel);

    return isLoggedIn;
  }

  Future<bool> loginWithEmailEnaPassword({
    required String username,
    required String password,
    String downloadContent = "",
    bool isFromSignup = false,
  }) async {
    bool isUserLoggedId = false;
    // EmailLoginResponseModel? emailLoginResponseModel;

    try {
      ApiUrlConfigurationProvider apiUrlConfigurationProvider = authenticationRepository.apiController.apiDataProvider;

      EmailLoginRequestModel login = EmailLoginRequestModel(
        userName: username,
        password: password,
        mobileSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
        downloadContent: downloadContent,
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        isFromSignUp: isFromSignup,
      );

      DataResponseModel<EmailLoginResponseModel> responseModel = await authenticationRepository.loginWithEmailAndPassword(login: login);

      EmailLoginResponseModel? emailLoginResponseModel = responseModel.data;
      SuccessfulUserLoginModel? successfulUserLoginModel = (emailLoginResponseModel?.successFullUserLogin).firstElement;
      successfulUserLoginModel?.email = username;
      successfulUserLoginModel?.password = password;
      MyPrint.printOnConsole("successfulUserLoginModel:$successfulUserLoginModel");

      isUserLoggedId = successfulUserLoginModel != null;

      if (isUserLoggedId) {
        successfulUserLoginModel.image = '${apiUrlConfigurationProvider.getCurrentSiteUrl()}/Content/SiteFiles/374/ProfileImages/${successfulUserLoginModel.image}';
      }
      authenticationProvider.setSuccessfulUserLoginModel(successfulUserLoginModel: successfulUserLoginModel);
      _initializeUserDataInApiControllerFromSuccessfulUserLoginModel(successfulUserLoginModel: successfulUserLoginModel);

      authenticationHiveRepository.setLoggedInUserData(responseModel: emailLoginResponseModel);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationController().loginWithEmailEnaPassword():$e");
      MyPrint.printOnConsole(s);
    }

    return isUserLoggedId;
  }

  Future<bool> forgotPassword({required String email}) async {
    bool isMailSent = false;
    try {
      DataResponseModel<ForgotPasswordResponseModel> responseModel = await authenticationRepository.getForgotPasswordStatus(email: email);
      ForgotPasswordResponseModel? forgotPasswordResponseModel = responseModel.data;
      MyPrint.printOnConsole("successfulUserLoginModel:${forgotPasswordResponseModel?.userStatus}");
      if (forgotPasswordResponseModel?.userStatus.isNotEmpty ?? true) {
        UserStatus userStatus = forgotPasswordResponseModel?.userStatus.first ?? UserStatus();

        String resetId = const Uuid().v4().toString();

        DataResponseModel response = await authenticationRepository.resetUserdata(
          userStatus: userStatus,
          resetId: resetId,
        );
        MyPrint.printOnConsole("resetUserdata:${response.data}");
        if (response.data == "true") {
          DataResponseModel sendPassword = await authenticationRepository.sendPassword(
            siteId: userStatus.siteid,
            userId: userStatus.userid,
            email: email,
            resetId: resetId,
          );
          MyPrint.printOnConsole("sendPassword:${sendPassword.data}");
          if (sendPassword.data == "true") {
            isMailSent = true;
          }
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationController().forgotPassword():$e");
      MyPrint.printOnConsole(s);
    }
    return isMailSent;
  }

  Future<bool> logout() async {
    bool isLoggedOut = false;

    authenticationHiveRepository.setLoggedInUserData(responseModel: null);
    authenticationProvider.setSuccessfulUserLoginModel(successfulUserLoginModel: null);

    BuildContext context = NavigationController.mainNavigatorKey.currentContext!;
    context.read<MainScreenProvider>().resetData(
          appProvider: context.read<AppProvider>(),
          appThemeProvider: context.read<AppThemeProvider>(),
        );
    context.read<HomeProvider>().resetData();
    context.read<ProfileProvider>().resetData();
    context.read<FilterProvider>().resetData();
    context.read<CatalogProvider>().resetData();
    context.read<WikiProvider>().resetData();
    context.read<MyLearningProvider>().resetData();
    context.read<EventProvider>().resetData();
    context.read<ShareProvider>().resetData();
    context.read<ProgressReportProvider>().resetData();
    context.read<ContentReviewRatingsProvider>().resetData();
    context.read<MessageProvider>().resetData();
    context.read<MembershipProvider>().resetData();
    context.read<InAppPurchaseProvider>().resetData();
    context.read<DiscussionProvider>().resetData();

    Navigator.pushNamedAndRemoveUntil(NavigationController.mainNavigatorKey.currentContext!, LoginSignUpSelectionScreen.routeName, (route) => false);

    return isLoggedOut;
  }

  void _initializeUserDataInApiControllerFromSuccessfulUserLoginModel({required SuccessfulUserLoginModel? successfulUserLoginModel}) {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;

    if (successfulUserLoginModel != null) {
      apiUrlConfigurationProvider.setCurrentUserId(successfulUserLoginModel.userid);
      apiUrlConfigurationProvider.setAuthToken(successfulUserLoginModel.jwttoken);
    } else {
      apiUrlConfigurationProvider.setCurrentUserId(-1);
      apiUrlConfigurationProvider.setAuthToken("");
    }
  }

  Future<SignupFieldResponseModel?> getSignupFieldsData({bool isGetFromOffline = true, bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().getSignupFieldsData called", tag: newId);

    SignupFieldResponseModel? signupFieldResponseModel;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<SignupFieldResponseModel> hiveResponseModel = await authenticationRepository.getSignupFields(
        componentId: 47,
        componentInstanceId: 3104,
        isFromOffline: true,
        isStoreDataInHive: false,
      );

      signupFieldResponseModel = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("signupFieldResponseModel not null:${signupFieldResponseModel != null}", tag: newId);

    if (isGetFromOffline && signupFieldResponseModel != null) {
      getSignupFieldsDataAndStoreInHive(isSaveInOffline: isSaveInOffline);
      authenticationProvider.setProfileConfigDataList(profileConfigDataList: signupFieldResponseModel.profileConfigData);
    } else {
      signupFieldResponseModel = await getSignupFieldsDataAndStoreInHive(isSaveInOffline: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("AuthenticationController().getSignupFieldsData Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: newId);

    return signupFieldResponseModel;
  }

  Future<SignupFieldResponseModel?> getSignupFieldsDataAndStoreInHive({bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().getSignupFieldsDataAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<SignupFieldResponseModel> signupFieldResponseDataModel = await authenticationRepository.getSignupFields(
      componentId: 47,
      componentInstanceId: 3104,
      isFromOffline: false,
      isStoreDataInHive: isSaveInOffline,
    );

    MyPrint.printOnConsole(signupFieldResponseDataModel, tag: newId);

    List<ProfileConfigDataModel> profileConfigDataList = signupFieldResponseDataModel.data?.profileConfigData ?? <ProfileConfigDataModel>[];
    MyPrint.printOnConsole("AuthenticationController ProfileConfigDataList: ${profileConfigDataList.length}", tag: newId);

    authenticationProvider.setProfileConfigDataList(profileConfigDataList: profileConfigDataList);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("AuthenticationController().getSignupFieldsDataAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: newId);

    return signupFieldResponseDataModel.data;
  }

  Future<bool> signUpUserWithSelfRegistration({required BuildContext? context, required List<ProfileConfigDataModel> data, bool enableMembership = false}) async {
    bool isRegistered = false;

    String signUpVal = "";
    for (int i = 0; i < data.length; i++) {
      ProfileConfigDataModel profileConfigData = data[i];

      ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

      if (uiControlModel != null) {
        String fieldVal = ''' '${uiControlModel.value}' ''';

        var dividerVal = enableMembership ? ':' : '=';
        signUpVal = '$signUpVal${profileConfigData.datafieldname.toLowerCase()}$dividerVal${fieldVal.trim()},';
      }
    }
    if (signUpVal.endsWith(",")) {
      signUpVal = signUpVal.substring(0, signUpVal.length - 1);
    }

    DataResponseModel<MobileCreateSignUpResponseModel> responseModel = await authenticationRepository.signUpUser(val: signUpVal);

    UserSignUpDetailsModel? userSignUpDetail = responseModel.data?.userSignUpDetails.firstElement;
    if (userSignUpDetail != null) {
      if (userSignUpDetail.action == "selfregistration") {
        isRegistered = true;

        if (context != null && context.mounted) MyToast.showSuccess(context: context, msg: userSignUpDetail.message);
      } else {
        if (context != null && context.mounted) MyToast.showError(context: context, msg: userSignUpDetail.message);
      }
    } else {
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Sign Up Failed");
    }

    return isRegistered;
  }

  Future<SignUpResponseDTOModel?> signUpUser({required BuildContext context, required List<ProfileConfigDataModel> data, MembershipPlanDetailsModel? membershipPlanDetailsModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().signUpUser() called with data:${data.length}, membershipPlanDetailsModel:$membershipPlanDetailsModel", tag: tag);

    Map<String, dynamic> profileJson = <String, dynamic>{};
    for (int i = 0; i < data.length; i++) {
      ProfileConfigDataModel profileConfigData = data[i];

      ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

      if (uiControlModel != null) {
        profileJson[profileConfigData.datafieldname] = uiControlModel.value;
      }
    }

    MyPrint.printOnConsole("profileJson:'$profileJson'", tag: tag);
    MyPrint.printOnConsole("profileJson encoded:'${MyUtils.encodeJson(profileJson)}'", tag: tag);

    bool isPaidPlan = (membershipPlanDetailsModel?.Amount ?? 0) > 0;

    UserSaveProfileDataRequestModel userSaveProfileDataRequestModel = UserSaveProfileDataRequestModel(
      strProfileJSON: MyUtils.encodeJson(profileJson),
      type: isPaidPlan ? "membershipselfregistration" : "selfregistration",
      RenewType: isPaidPlan ? MembershipRenewType.auto : "",
      MemberShipDurationID: membershipPlanDetailsModel?.MemberShipDurationID ?? 0,
    );

    DataResponseModel<SignUpResponseModel> responseModel = await ProfileRepository(apiController: authenticationRepository.apiController).saveProfileData(
      requestModel: userSaveProfileDataRequestModel,
    );

    SignUpResponseDTOModel? signUpResponseModel = responseModel.data?.Response;
    MyPrint.printOnConsole("signUpResponseModel:'$signUpResponseModel'", tag: tag);

    if (signUpResponseModel == null) {
      MyPrint.printOnConsole("signUpResponseModel is null", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Sign Up Failed");
      return null;
    }

    if (signUpResponseModel.UserID == 0 || (!isPaidPlan && (signUpResponseModel.loginID.isEmpty || signUpResponseModel.loginPwd.isEmpty))) {
      MyPrint.printOnConsole("couldn't get new user credentials:${signUpResponseModel.Message}", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: signUpResponseModel.Message);
      return null;
    }

    //Handle Payment
    if (isPaidPlan) {
      PurchaseDetails? purchaseDetails = await launchMembershipPlanInAppPurchase(
        membershipPlanDetailsModel: membershipPlanDetailsModel!,
        isShowConfirmationDialog: true,
        context: context,
      );

      if (purchaseDetails == null) {
        MyPrint.printOnConsole("Couldn't complete payment", tag: tag);
        if (context.mounted) MyToast.showError(context: context, msg: "Couldn't complete payment");
        return null;
      }

      CurrencyModel? currencyModel = context.mounted ? context.read<AppProvider>().currencyModel.get() : null;

      bool isPurchaseSaved = await InAppPurchaseController().purchaseProduct(
        requestModel: EcommerceProcessPaymentRequestModel(
          TransType: EcommerceTransactionType.membership,
          token: purchaseDetails.purchaseID ?? "",
          RenewType: userSaveProfileDataRequestModel.RenewType,
          MembershipTempUserID: signUpResponseModel.UserID,
          DurationID: userSaveProfileDataRequestModel.MemberShipDurationID.toString(),
          IsNativeApp: true,
          CurrencySign: currencyModel?.UserCurrency ?? "",
        ),
      );

      if (!isPurchaseSaved) {
        MyPrint.printOnConsole("Couldn't process payment", tag: tag);
        if (context.mounted) MyToast.showError(context: context, msg: "Couldn't process payment");
        return null;
      } else {
        MyPrint.printOnConsole("User Signed Up Successfully:'${signUpResponseModel.Message}'", tag: tag);
        if (context.mounted) {
          MyToast.showSuccess(
            context: context,
            msg: "Congratulations! Your membership account has been created/updated/renewed. Account login details have been sent to your email address. "
                "Now you can access your new membership account.",
          );
        }
        return signUpResponseModel;
      }
    }

    MyPrint.printOnConsole("User Signed Up Successfully:'${signUpResponseModel.Message}'", tag: tag);
    if (context.mounted) MyToast.showSuccess(context: context, msg: signUpResponseModel.Message);
    return signUpResponseModel;
  }

  Future<PurchaseDetails?> launchMembershipPlanInAppPurchase({
    required MembershipPlanDetailsModel membershipPlanDetailsModel,
    BuildContext? context,
    bool isShowConfirmationDialog = false,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().launchMembershipPlanInAppPurchase() called for MemberShipDurationID:'${membershipPlanDetailsModel.MemberShipDurationID}'", tag: tag);

    String productId = switch (defaultTargetPlatform) {
      // TargetPlatform.android => "shield_base_basic",
      // TargetPlatform.android => "test.sub.1",
      // TargetPlatform.android => "base1",
      // TargetPlatform.android => "com.instancy.shieldbasebasic30days",
      // TargetPlatform.iOS => "sbb6monthstopup",
      // TargetPlatform.iOS => "com.instancy.signUpSub130Days",
      TargetPlatform.android => membershipPlanDetailsModel.GoogleSubscriptionID,
      TargetPlatform.iOS => membershipPlanDetailsModel.AppleSubscriptionID,
      _ => "",
    };
    MyPrint.printOnConsole("Product Ids:'$productId'", tag: tag);

    if (productId.isEmpty) {
      MyPrint.printOnConsole("Product Id not Available", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Store Details Not Available");
      return null;
    }

    Map<String, ProductDetails> map = await InAppPurchaseController().getProductDetails([productId]);
    MyPrint.printOnConsole("Product Details Map:$map", tag: tag);

    ProductDetails? productDetails = map[productId];

    if (productDetails == null) {
      MyPrint.printOnConsole("Product Details Not Available", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Product Details Not Available");
      return null;
    }

    PurchaseDetails? purchaseDetails = await InAppPurchaseController().launchInAppPurchase(
      productDetails,
      isConsumable: false,
      context: context,
      isShowConfirmationDialog: isShowConfirmationDialog,
    );
    MyPrint.printOnConsole("purchaseDetails.status:${purchaseDetails?.status}", tag: tag);

    if (purchaseDetails == null) {
      MyPrint.printOnConsole("Purchase Failed", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Purchase Failed");
      return null;
    } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      MyPrint.printOnConsole("Purchase Cancelled", tag: tag);
      if (context != null && context.mounted) MyToast.greyMsg(context: context, msg: "Purchase Cancelled");
      return null;
    } else if (purchaseDetails.status == PurchaseStatus.pending) {
      MyPrint.printOnConsole("Purchase Pending", tag: tag);
      if (context != null && context.mounted) MyToast.greyMsg(context: context, msg: "Purchase Pending");
      return null;
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      IAPError? error = purchaseDetails.error;
      MyPrint.printOnConsole("Error in Store Purchase:$error", tag: tag);

      if (error != null) {
        if (context != null && context.mounted) MyToast.showError(context: context, msg: "Error in Buying Content : '${error.message}'");
      } else {
        if (context != null && context.mounted) MyToast.showError(context: context, msg: "Error in Buying Content");
      }

      return null;
    } else if (purchaseDetails.status == PurchaseStatus.restored) {
      MyPrint.printOnConsole("Purchase Restored", tag: tag);

      return null;
    }

    MyPrint.printOnConsole("Purchase Successful", tag: tag);
    return purchaseDetails;
  }
}

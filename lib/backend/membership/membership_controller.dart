import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/membership/request_model/cancel_user_membership_request_model.dart';
import 'package:flutter_instancy_2/models/membership/request_model/membership_plan_request_model.dart';
import 'package:flutter_instancy_2/models/membership/request_model/user_active_membership_request_model.dart';
import 'package:flutter_instancy_2/models/membership/response_model/user_active_membership_response_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/membership/components/confirm_cancel_membership_by_user_dialog.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../models/app_configuration_models/data_models/currency_model.dart';
import '../../models/in_app_purchase/request_model/ecommerce_process_payment_request_model.dart';
import '../../models/membership/data_model/member_ship_dto_model.dart';
import '../../models/membership/data_model/membership_plan_details_model.dart';
import '../../models/membership/data_model/user_active_membership_dto_model.dart';
import '../app/app_provider.dart';
import '../authentication/authentication_controller.dart';
import '../in_app_purchase/in_app_purchase_controller.dart';
import '../navigation/navigation.dart';
import 'membership_provider.dart';
import 'membership_repository.dart';

class MembershipController {
  late MembershipProvider _membershipProvider;
  late MembershipRepository _membershipRepository;

  MembershipController({required MembershipProvider? provider, MembershipRepository? repository, ApiController? apiController}) {
    _membershipProvider = provider ?? MembershipProvider();
    _membershipRepository = repository ?? MembershipRepository(apiController: apiController ?? ApiController());
  }

  MembershipProvider get membershipProvider => _membershipProvider;

  MembershipRepository get membershipRepository => _membershipRepository;

  Future<List<MemberShipDTOModel>> getAllMembershipPlansList({
    bool isRefresh = true,
    bool isUpdateMembership = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MembershipController().getAllMembershipPlansList() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    MembershipProvider provider = membershipProvider;

    List<MemberShipDTOModel> allPlansList = provider.allMembershipPlansList.getList();

    MyPrint.printOnConsole("allPlansList length:${allPlansList.length}", tag: tag);

    if (isRefresh || allPlansList.isEmpty) {
      provider.isAllMembershipPlansLoading.set(value: true, isNotify: isNotify);

      //region Make Api Call
      DateTime startTime = DateTime.now();

      DataResponseModel<List<MemberShipDTOModel>> response = isUpdateMembership
          ? await membershipRepository.GetUpdateMemberShipDetails(
              requestModel: MembershipPlanRequestModel(
                UserID: membershipRepository.apiController.apiDataProvider.getCurrentUserId(),
              ),
            )
          : await membershipRepository.GetMemberShipDetails(requestModel: MembershipPlanRequestModel());
      MyPrint.printOnConsole("All Membership Plans List Length:${response.data?.length ?? 0}", tag: tag);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("All Membership Plans List Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
      //endregion

      allPlansList = response.data ?? <MemberShipDTOModel>[];
      MyPrint.printOnConsole("All Membership Plans List Length got in Api:${allPlansList.length}", tag: tag);

      provider.allMembershipPlansList.setList(list: allPlansList, isClear: true, isNotify: false);
      provider.isAllMembershipPlansLoading.set(value: false, isNotify: true);
    }

    MyPrint.printOnConsole("Final All Membership Plans List Length:${allPlansList.length}", tag: tag);

    return allPlansList;
  }

  Future<List<UserActiveMembershipDTOModel>> getUserActiveMembershipData({
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MembershipController().getUserActiveMembershipData() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    MembershipProvider provider = membershipProvider;

    List<UserActiveMembershipDTOModel> activeMembershipList = provider.activeMembershipList.getList();

    if (isRefresh || activeMembershipList.isEmpty) {
      activeMembershipList.clear();

      provider.isActiveMembershipModelLoading.set(value: true, isNotify: isNotify);

      DataResponseModel<UserActiveMembershipResponseModel> response = await membershipRepository.GetUserActiveMembership(
        requestModel: UserActiveMembershipRequestModel(
          UserID: membershipRepository.apiController.apiDataProvider.getCurrentUserId(),
        ),
      );
      MyPrint.logOnConsole("GetUserActiveMembership response:$response", tag: tag);

      provider.isActiveMembershipModelLoading.set(value: false, isNotify: true);

      if (response.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from MembershipController().getUserActiveMembershipData() because GetUserActiveMembership had some error", tag: tag);
        return activeMembershipList;
      }

      if (response.data != null) activeMembershipList.addAll(response.data!.Table);
    }

    MyPrint.logOnConsole("final activeMembershipDTOModel:$activeMembershipList", tag: tag);
    provider.activeMembershipList.setList(list: activeMembershipList, isClear: true, isNotify: true);

    return activeMembershipList;
  }

  Future<bool> updateActiveMembership({
    required BuildContext context,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MembershipController().updateActiveMembership() called", tag: tag);

    dynamic value = await NavigationController.navigateToMembershipSelectionScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: MembershipSelectionScreenNavigationArguments(
        membershipProvider: MembershipProvider(),
        isUpdateMembership: true,
      ),
    );

    MyPrint.printOnConsole("value from MembershipSelectionScreen:$value");

    if (value is! MembershipPlanDetailsModel) {
      return false;
    }

    MembershipPlanDetailsModel? membershipPlanDetailsModel = value;

    PurchaseDetails? purchaseDetails = await AuthenticationController(provider: null).launchMembershipPlanInAppPurchase(
      membershipPlanDetailsModel: membershipPlanDetailsModel,
      isShowConfirmationDialog: true,
      context: context,
    );

    if (purchaseDetails == null) {
      MyPrint.printOnConsole("Couldn't complete payment", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Couldn't complete payment");
      return false;
    }

    CurrencyModel? currencyModel = context.mounted ? context.read<AppProvider>().currencyModel.get() : null;

    bool isPurchaseSaved = await InAppPurchaseController().purchaseProduct(
      requestModel: EcommerceProcessPaymentRequestModel(
        TotalPrice: membershipPlanDetailsModel.Amount,
        TransType: EcommerceTransactionType.membership,
        Rtype: "upgrade",
        RenewType: MembershipRenewType.auto,
        DurationID: membershipPlanDetailsModel.MemberShipDurationID.toString(),
        MembershipUpgradeUserID: membershipRepository.apiController.apiDataProvider.getCurrentUserId(),
        token: purchaseDetails.purchaseID ?? "",
        IsNativeApp: true,
        CurrencySign: currencyModel?.UserCurrency ?? "",
      ),
    );

    if (!isPurchaseSaved) {
      MyPrint.printOnConsole("Couldn't process payment", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Couldn't process payment");
      return false;
    }

    MyPrint.printOnConsole("Membership Upgraded Successfully", tag: tag);
    if (context.mounted) {
      MyToast.showSuccess(
        context: context,
        msg: "Congratulations! Your membership account has been created/updated/renewed. Account login details have been sent to your email address. "
            "Now you can access your new membership account.",
      );
    }

    return true;
  }

  Future<bool> cancelActiveMembership({
    required int UserId,
    required int MembershipID,
    UserActiveMembershipDTOModel? model,
    BuildContext? context,
    bool isAskConfirmation = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "MembershipController().cancelActiveMembership() called with UserId:$UserId, MembershipID:$MembershipID, model not null:${model != null}, context:$context, isAskConfirmation:$isAskConfirmation",
      tag: tag,
    );

    try {
      if (isAskConfirmation) {
        if (context == null) {
          MyPrint.printOnConsole("Returning from MembershipController().cancelActiveMembership() because isAskConfirmation is true but context is null", tag: tag);
          return false;
        }

        if (model == null) {
          MyPrint.printOnConsole("Returning from MembershipController().cancelActiveMembership() because isAskConfirmation is true but model is null", tag: tag);
          return false;
        }

        dynamic isConfirmCancelMembershipByUser = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmCancelMembershipByUserDialog(
              model: model,
              localStr: null,
            );
          },
        );
        MyPrint.printOnConsole("isConfirmCancelMembershipByUser:$isConfirmCancelMembershipByUser", tag: tag);

        if (isConfirmCancelMembershipByUser != true) {
          MyPrint.printOnConsole("Returning from MembershipController().cancelActiveMembership() because permission not granted by user", tag: tag);
          return false;
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Showing Confirmation dialog in MembershipController().cancelActiveMembership():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }

    DataResponseModel<String> responseModel = await membershipRepository.CancelUserMembership(
      requestModel: CancelUserMembershipRequestModel(
        UserMembershipID: UserId,
      ),
    );
    MyPrint.printOnConsole("responseModel Status:${responseModel.statusCode}", tag: tag);
    MyPrint.printOnConsole("responseModel data:'${responseModel.data}'", tag: tag);
    MyPrint.printOnConsole("responseModel Error:'${responseModel.appErrorModel}'", tag: tag);

    if (responseModel.statusCode != 200 || responseModel.appErrorModel != null || responseModel.data?.toString() != "true") {
      MyPrint.printOnConsole("Couldn't Cancel User Membership", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Couldn't Cancel User Membership'");
      return false;
    }

    MyPrint.printOnConsole("Membership Cancelled Successfully", tag: tag);
    if (context != null && context.mounted) MyToast.showSuccess(context: context, msg: "Membership Cancelled Successfully");
    return true;
  }
}

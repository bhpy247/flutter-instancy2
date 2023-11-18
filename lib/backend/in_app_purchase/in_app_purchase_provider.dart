import '../../models/in_app_purchase/response_model/ecommerce_order_response_model.dart';
import '../common/common_provider.dart';

class InAppPurchaseProvider extends CommonProvider {
  InAppPurchaseProvider() {
    isPurchaseHistoryOrdersLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    purchaseHistoryOrdersList = CommonProviderListParameter<EcommerceOrderResponseModel>(
      list: <EcommerceOrderResponseModel>[],
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isPurchaseHistoryOrdersLoading;
  late CommonProviderListParameter<EcommerceOrderResponseModel> purchaseHistoryOrdersList;

  void resetData() {
    isPurchaseHistoryOrdersLoading.set(value: false, isNotify: false);
    purchaseHistoryOrdersList.setList(list: [], isNotify: false);
  }
}

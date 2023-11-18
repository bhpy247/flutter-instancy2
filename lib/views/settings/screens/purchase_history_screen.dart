import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_controller.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/data_model/ecommerce_order_dto_model.dart';
import 'package:flutter_instancy_2/models/in_app_purchase/response_model/ecommerce_order_response_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/in_app_purchase/in_app_purchase_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_loader.dart';
import '../components/ecommerce_order_card.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  static const String routeName = "/PurchaseHistoryScreen";

  final PurchaseHistoryScreenNavigationArguments arguments;

  const PurchaseHistoryScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> with MySafeState {
  late InAppPurchaseProvider inAppPurchaseProvider;
  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    super.initState();

    inAppPurchaseProvider = widget.arguments.inAppPurchaseProvider ?? InAppPurchaseProvider();
    inAppPurchaseController = InAppPurchaseController(provider: inAppPurchaseProvider);

    if (inAppPurchaseProvider.purchaseHistoryOrdersList.length == 0) {
      inAppPurchaseController.getPurchaseHistoryData(
        isRefresh: true,
        isNotify: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InAppPurchaseProvider>.value(value: inAppPurchaseProvider),
      ],
      child: Consumer<InAppPurchaseProvider>(
        builder: (BuildContext context, InAppPurchaseProvider provider, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Purchase History"),
            ),
            body: getContentsListViewWidget(),
          );
        },
      ),
    );
  }

  Widget getContentsListViewWidget() {
    InAppPurchaseProvider provider = inAppPurchaseProvider;

    if (provider.isPurchaseHistoryOrdersLoading.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    } else if (provider.purchaseHistoryOrdersList.length == 0) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: () async {
              await inAppPurchaseController.getPurchaseHistoryData(
                isRefresh: true,
                isNotify: true,
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: constraints.maxHeight / 5),
                AppConfigurations.commonNoDataView(),
              ],
            ),
          );
        },
      );
    }

    List<EcommerceOrderResponseModel> list = provider.purchaseHistoryOrdersList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: () async {
        await inAppPurchaseController.getPurchaseHistoryData(
          isRefresh: true,
          isNotify: true,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          EcommerceOrderResponseModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.onBackground.withAlpha(20),
                  ),
                  child: Text(
                    model.monthString,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...model.Table.map((EcommerceOrderDTOModel model) {
                  return EcommerceOrderCard(
                    model: model,
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

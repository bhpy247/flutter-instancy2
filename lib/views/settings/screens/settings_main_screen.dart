import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../common/components/app_ui_components.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({super.key});

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> with MySafeState {
  late AppProvider appProvider;

  List<SettingOptionModel> options = <SettingOptionModel>[];

  void initializeOptions() {
    AppSystemConfigurationModel model = appProvider.appSystemConfigurationModel;

    if (model.enableMembership || model.enableInAppPurchase) {
      options.addAll([
        SettingOptionModel(
          title: "Purchase History",
          subTitle: "Checkout the Purchase History",
          iconData: Icons.payment,
          onTap: () {
            NavigationController.navigateToPurchaseHistoryScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              arguments: PurchaseHistoryScreenNavigationArguments(inAppPurchaseProvider: context.read<InAppPurchaseProvider>()),
            );
          },
        ),
      ]);
    }

    if (model.enableMembership) {
      options.addAll([
        SettingOptionModel(
          title: "Membership",
          subTitle: "Checkout the Current Membership Details",
          iconData: Icons.card_membership,
          onTap: () {
            NavigationController.navigateToUserMembershipDetailsScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              arguments: UserMembershipDetailsScreenNavigationArguments(membershipProvider: context.read<MembershipProvider>()),
            );
          },
        ),
      ]);
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    initializeOptions();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      body: AppUIComponents.getBackGroundBordersRounded(
        child: getOptionsListViewWidget(),
        context: context,
      ),
    );
  }

  Widget getOptionsListViewWidget() {
    if (options.isEmpty) {
      return Center(
        child: Text(
          "No Options Available",
          style: themeData.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return getSettingOptionWidget(model: options[index]);
      },
    );
  }

  Widget getSettingOptionWidget({required SettingOptionModel model}) {
    return InkWell(
      onTap: model.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: themeData.colorScheme.onBackground.withAlpha(50)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              model.iconData,
              size: model.iconSize,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    model.subTitle,
                    style: themeData.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.textTheme.labelMedium!.color?.withAlpha(100),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingOptionModel {
  final String title;
  final String subTitle;
  final IconData iconData;
  final double iconSize;
  final void Function()? onTap;

  const SettingOptionModel({
    this.title = "",
    this.subTitle = "",
    required this.iconData,
    this.iconSize = 30,
    this.onTap,
  });
}

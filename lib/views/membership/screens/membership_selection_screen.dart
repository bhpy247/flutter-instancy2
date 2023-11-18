import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_controller.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/models/membership/data_model/member_ship_dto_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/membership_plan_details_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_configurations.dart';
import '../../authentication/components/membership_selection_card.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';

class MembershipSelectionScreen extends StatefulWidget {
  static const String routeName = "/MembershipSelectionScreen";

  final MembershipSelectionScreenNavigationArguments arguments;

  const MembershipSelectionScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<MembershipSelectionScreen> createState() => _MembershipSelectionScreenState();
}

class _MembershipSelectionScreenState extends State<MembershipSelectionScreen> with MySafeState {
  late AppProvider appProvider;
  late MembershipProvider membershipProvider;
  late MembershipController membershipController;
  bool isUpdateMembership = false;

  Future<void> onRefresh() async {
    await membershipController.getAllMembershipPlansList(
      isRefresh: true,
      isUpdateMembership: isUpdateMembership,
      isNotify: true,
    );
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    membershipProvider = widget.arguments.membershipProvider ?? MembershipProvider();
    membershipController = MembershipController(provider: membershipProvider);
    isUpdateMembership = widget.arguments.isUpdateMembership;

    membershipController.getAllMembershipPlansList(
      isRefresh: false,
      isUpdateMembership: isUpdateMembership,
      isNotify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MembershipProvider>.value(value: membershipProvider),
      ],
      child: Consumer<MembershipProvider>(builder: (BuildContext context, MembershipProvider membershipProvider, Widget? child) {
        return AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Membership"),
            ),
            body: getMembershipListviewWidget(),
          ),
        );
      }),
    );
  }

  Widget getMembershipListviewWidget() {
    if (membershipProvider.isAllMembershipPlansLoading.get()) {
      return const Center(
        child: CommonLoader(),
      );
    }

    if (membershipProvider.allMembershipPlansList.length == 0) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Center(
          child: AppConfigurations.commonNoDataView(),
        ),
      );
    }

    List<MemberShipDTOModel> list = membershipProvider.allMembershipPlansList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          MemberShipDTOModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: MembershipSelectionCard(
              memberShipDTOModel: model,
              onMembershipPlanSelected: ({required MembershipPlanDetailsModel membershipPlanDetailsModel}) {
                Navigator.pop(context, membershipPlanDetailsModel);
              },
            ),
          );
        },
      ),
    );
  }
}

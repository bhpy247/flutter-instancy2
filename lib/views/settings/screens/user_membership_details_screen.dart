import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/membership/membership_controller.dart';
import 'package:flutter_instancy_2/models/membership/data_model/user_active_membership_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../backend/membership/membership_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_loader.dart';
import '../components/user_active_membership_card.dart';

class UserMembershipDetailsScreen extends StatefulWidget {
  static const String routeName = "/UserMembershipDetailsScreen";

  final UserMembershipDetailsScreenNavigationArguments arguments;

  const UserMembershipDetailsScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<UserMembershipDetailsScreen> createState() => _UserMembershipDetailsScreenState();
}

class _UserMembershipDetailsScreenState extends State<UserMembershipDetailsScreen> with MySafeState {
  late MembershipProvider membershipProvider;
  late MembershipController membershipController;

  bool isLoading = false;

  Future<void> updateMembership({required UserActiveMembershipDTOModel model}) async {
    isLoading = true;
    mySetState();

    bool isSuccess = await membershipController.updateActiveMembership(
      context: context,
    );

    isLoading = false;
    mySetState();

    if (isSuccess) {
      membershipController.getUserActiveMembershipData(
        isRefresh: true,
        isNotify: true,
      );
    }
  }

  Future<void> cancelMembership({required UserActiveMembershipDTOModel model}) async {
    isLoading = true;
    mySetState();

    bool isSuccess = await membershipController.cancelActiveMembership(
      UserId: membershipController.membershipRepository.apiController.apiDataProvider.getCurrentUserId(),
      MembershipID: model.MembershipID,
      model: model,
      isAskConfirmation: true,
      context: context,
    );

    isLoading = false;
    mySetState();

    if (isSuccess) {
      membershipController.getUserActiveMembershipData(
        isRefresh: true,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    membershipProvider = widget.arguments.membershipProvider ?? MembershipProvider();
    membershipController = MembershipController(provider: membershipProvider);

    if (membershipProvider.activeMembershipList.length == 0) {
      membershipController.getUserActiveMembershipData(
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
        ChangeNotifierProvider<MembershipProvider>.value(value: membershipProvider),
      ],
      child: Consumer<MembershipProvider>(
        builder: (BuildContext context, MembershipProvider provider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Membership"),
              ),
              body: getContentsListViewWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget getContentsListViewWidget() {
    MembershipProvider provider = membershipProvider;

    if (provider.isActiveMembershipModelLoading.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    } else if (provider.activeMembershipList.length == 0) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: () async {
              await membershipController.getUserActiveMembershipData(
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

    List<UserActiveMembershipDTOModel> list = provider.activeMembershipList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: () async {
        await membershipController.getUserActiveMembershipData(
          isRefresh: true,
          isNotify: true,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          UserActiveMembershipDTOModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: UserActiveMembershipCard(
              model: model,
              updateMembership: updateMembership,
              cancelMembership: cancelMembership,
            ),
          );
        },
      ),
    );
  }
}

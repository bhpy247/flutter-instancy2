import 'package:flutter_instancy_2/models/membership/data_model/member_ship_dto_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/user_active_membership_dto_model.dart';

import '../common/common_provider.dart';

class MembershipProvider extends CommonProvider {
  MembershipProvider() {
    isAllMembershipPlansLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    allMembershipPlansList = CommonProviderListParameter<MemberShipDTOModel>(
      list: <MemberShipDTOModel>[],
      notify: notify,
    );
    isActiveMembershipModelLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    activeMembershipList = CommonProviderListParameter<UserActiveMembershipDTOModel>(
      list: [],
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isAllMembershipPlansLoading;
  late CommonProviderListParameter<MemberShipDTOModel> allMembershipPlansList;

  late CommonProviderPrimitiveParameter<bool> isActiveMembershipModelLoading;
  late CommonProviderListParameter<UserActiveMembershipDTOModel> activeMembershipList;

  void resetData() {
    isAllMembershipPlansLoading.set(value: false, isNotify: false);
    allMembershipPlansList.setList(list: [], isNotify: false);
    isActiveMembershipModelLoading.set(value: false, isNotify: false);
    activeMembershipList.setList(list: [], isNotify: false);
  }
}

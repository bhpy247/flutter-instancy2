import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';

class MainScreenAppBarActions {
  final Color iconColor;

  MainScreenAppBarActions({
    required this.iconColor,
  });

  Widget getWaitlistButton({
    required BuildContext context,
    required int componentInstanceId,
    required int componentId,
    NativeMenuComponentModel? componentModel,
    MyLearningProvider? myLearningProvider,
  }) {
    return _getButton(
      onTap: () {
        NavigationController.navigateToMyLearningWaitlistScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: MyLearningWaitlistScreenNavigationArguments(
            componentId: componentId,
            componentInstanceId: componentInstanceId,
            componentModel: componentModel,
            myLearningProvider: myLearningProvider,
          ),
        );
      },
      iconData: Icons.featured_play_list,
    );
  }

  Widget getTempButton({
    required BuildContext context,
    required GestureTapCallback onTap,
  }) {
    return _getButton(
      onTap: onTap,
      iconData: Icons.library_add,
    );
  }

  Widget _getButton({
    required IconData iconData,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          // color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    );
  }
}
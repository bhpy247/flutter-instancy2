import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';

import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_border_dropdown.dart';

class CreateManuallyVideoScreen extends StatefulWidget {
  static const String routeName = "/createManuallyVideoScreen";

  const CreateManuallyVideoScreen({super.key});

  @override
  State<CreateManuallyVideoScreen> createState() => _CreateManuallyVideoScreenState();
}

class _CreateManuallyVideoScreenState extends State<CreateManuallyVideoScreen> with MySafeState {
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: AppStrings.generateWithAI,
      ),
      body: AppUIComponents.getBackGroundBordersRounded(context: context, child: getMainBody()),
    );
  }

  Widget getMainBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getAvatarDropdown(),
                SizedBox(
                  height: 20,
                ),
                getVideoBackgroundDropdown(),
                SizedBox(
                  height: 20,
                ),
                getAvatarSpeechDropdown(),
                SizedBox(
                  height: 20,
                ),
                getAvatarTypeDropdown(),
                SizedBox(
                  height: 20,
                ),
                getAvatarPosition(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          CommonButton(
            minWidth: double.infinity,
            onPressed: () {
              NavigationController.navigateToGenerateWithAiVideoScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                  argument: AddEditVideoScreenArgument());
            },
            text: AppStrings.generateWithAI,
            fontColor: themeData.colorScheme.onPrimary,
          )
        ],
      ),
    );
  }

  List<String> avatarList = ["Select Avatar", "Alex", "Bridget", "Christina", "Jack"],
      videoBackground = ["off_white", "warm_white", "light_pink", "soft_pink", "light_blue"],
      avatarSpeech = ["Afrikaans", "Amharic", "Amharic", "Arabic (AE)", "English"],
      avatarType = ["FullBody", "Circle"],
      avatarPosition = ["Left", "Center", "Right"];

  String? selectedAvatar, selectedVideoBackground, selectedAvatarSpeech, selectedAvatarType, selectedAvatarPosition;

  Widget getAvatarDropdown() {
    return getCommonDropDown(
      list: avatarList,
      value: selectedAvatar,
      hintText: "Select Avatar",
      onChanged: (val) {
        if (val == "Select Avatar") {
          selectedAvatar = null;
        } else {
          selectedAvatar = val;
        }
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getVideoBackgroundDropdown() {
    return getCommonDropDown(
      list: videoBackground,
      value: selectedVideoBackground,
      hintText: "Video Background",
      onChanged: (val) {
        selectedVideoBackground = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getAvatarSpeechDropdown() {
    return getCommonDropDown(
      list: avatarSpeech,
      value: selectedAvatarSpeech,
      hintText: "Avatar Speech",
      onChanged: (val) {
        selectedAvatarSpeech = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getAvatarTypeDropdown() {
    return getCommonDropDown(
      list: avatarType,
      value: selectedAvatarType,
      hintText: "Avatar Type",
      onChanged: (val) {
        selectedAvatarType = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getAvatarPosition() {
    return getCommonDropDown(
      list: avatarPosition,
      value: selectedAvatarPosition,
      hintText: "Avatar Position",
      onChanged: (val) {
        selectedAvatarPosition = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getCommonDropDown({
    required String? value,
    required List<String> list,
    required ValueChanged<String?> onChanged,
    required String hintText,
    double iconHeight = 15,
    double iconWidth = 15,
    String iconUrl = "",
  }) {
    return CommonBorderDropdown<String>(
      isExpanded: true,
      isDense: true,
      items: list,
      value: value,
      hintText: hintText,
      onChanged: onChanged,
    );
  }
}

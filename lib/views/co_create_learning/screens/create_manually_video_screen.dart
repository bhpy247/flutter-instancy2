import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';

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
        title: "Create Manually",
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
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border.all(color: Styles.borderColor), borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: getPopUp(),
                body: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Container(
                        height: 200,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      const Text(
                        '''A significant part of having productive meetings is taking thorough, accurate, and clear notes.
                  This is where you’ll keep track of decisions that were made, who was assigned which action items, and what questions the group discussed. What if you had a tool that could do all this for you so you could instead focus on contributing to the conversation?
                  Now you can, with artificial intelligence (AI) note-taking tools.''',
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          CommonButton(
            minWidth: double.infinity,
            onPressed: () {
              NavigationController.navigateToVideoScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
              );
            },
            text: "Generate With AI",
            fontColor: themeData.colorScheme.onPrimary,
          )
        ],
      ),
    );
  }

  Widget getPopUp() {
    return SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        overlayColor: Colors.black,
        overlayOpacity: .6,
        mini: false,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 2,
        buttonSize: const Size(56.0, 56.0),
        // it's the SpeedDial size which defaults to 56 itself
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: const Size(50, 50),
        visible: true,
        direction: SpeedDialDirection.up,
        switchLabelPosition: false,

        /// If true user is forced to close dial manually
        closeManually: true,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: true,
        // onOpen: () {
        //   debugPrint('OPENING DIAL');
        //   // setState(() {});
        // },
        // onClose: () {
        //   debugPrint('DIAL CLOSED');
        //   // isDialOpen.value = false;
        // },
        useRotationAnimation: true,
        tooltip: 'Open Speed Dial',
        elevation: 1.0,
        // animationDuration: Duration(seconds: 0),
        animationCurve: Curves.easeIn,
        isOpenOnStart: false,
        children: [
          getSpeedDialChild(text: "Avatar", image: "assets/cocreate/Avatar.png"),
          getSpeedDialChild(text: "Text", image: "assets/cocreate/text.png"),
          getSpeedDialChild(text: "Image/Video", image: "assets/cocreate/video_image.png"),
          getSpeedDialChild(text: "Background Music", image: "assets/cocreate/backGroundMusic.png"),
        ]);
  }

  SpeedDialChild getSpeedDialChild({required String image, required String text}) {
    return SpeedDialChild(
      label: text,
      labelStyle: TextStyle(color: themeData.colorScheme.onPrimary),
      labelBackgroundColor: themeData.primaryColor,
      backgroundColor: themeData.colorScheme.onPrimary,
      elevation: 0,
      labelShadow: [],
      child: Image.asset(
        image,
        height: 20,
        width: 20,
        color: themeData.primaryColor,
      ),
    );
  }
}

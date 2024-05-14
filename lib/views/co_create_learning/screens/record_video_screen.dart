import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';

class RecordVideoScreen extends StatefulWidget {
  static const String routeName = "/recordVideoScreen";
  final AddEditVideoScreenArgument argument;

  const RecordVideoScreen({super.key, required this.argument});

  @override
  State<RecordVideoScreen> createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> with MySafeState {
  Uint8List? fileBytes;

  String thumbNailName = "";
  Uint8List? thumbNailBytes;

  Future<String> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;
      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileBytes = file.bytes;
      thumbNailBytes = fileBytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.argument.isUploadScreen ? "Upload Video" : "Record Video",
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              widget.argument.isUploadScreen ? getUploadVideoScreen() : getRecordVideoWidget(),
              const Spacer(),
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
                text: "Save",
                fontColor: theme.colorScheme.onPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getRecordVideoWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        border: Border.all(color: Styles.borderColor),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: themeData.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Record Video...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget getUploadVideoScreen() {
    if (thumbNailName.checkNotEmpty) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60),
            decoration: BoxDecoration(
              border: Border.all(color: Styles.borderColor),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.arrowUpFromBracket,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  thumbNailName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonButton(
                onPressed: () {
                  thumbNailName = "";
                  fileBytes = null;
                  thumbNailBytes = null;
                  mySetState();
                },
                text: "Clear",
                backGroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 20,
              ),
              CommonButton(
                onPressed: () async {
                  thumbNailName = await openFileExplorer(FileType.audio, false);
                  mySetState();
                },
                text: "ReTake",
                backGroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      );
    }
    return InkWell(
      onTap: () async {
        thumbNailName = await openFileExplorer(FileType.video, false);
        mySetState();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: BoxDecoration(
          border: Border.all(color: Styles.borderColor),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeData.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.arrowUpFromBracket,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Browse File...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

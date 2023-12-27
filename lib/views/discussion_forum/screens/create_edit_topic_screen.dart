import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_controller.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_add_topic_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/discussion/discussion_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';

class CreateEditTopicScreen extends StatefulWidget {
  final CreateEditTopicScreenNavigationArguments arguments;
  static const String routeName = "/CreateEditTopicScreen";

  const CreateEditTopicScreen({super.key, required this.arguments});

  @override
  State<CreateEditTopicScreen> createState() => _CreateEditTopicScreenState();
}

class _CreateEditTopicScreenState extends State<CreateEditTopicScreen> with MySafeState {
  late DiscussionController discussionController;
  late DiscussionProvider discussionProvider;
  late AppProvider appProvider;

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController uploadFileTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isUrl = true, isLoading = false;
  FileType? fileType;

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;

  Future<String> openFileExplorer(FileType pickingType, bool multiPick) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );
    try {
      if (paths.isNotEmpty) {
        PlatformFile file = paths.first;
        if (!kIsWeb) {
          MyPrint.printOnConsole("File Path:${file.path}");
        }
        File fileNew = File(file.path!);
        if (fileNew.lengthSync() > 5 * 1024 * 1024) {
          // 5 MB in bytes
          if (context.mounted) {
            MyToast.showError(context: context, msg: "Maximum allowed file size : 5Mb");
          }
          return "";
        }
        MyPrint.printOnConsole("Got file Name:${file.name}");
        MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
        fileName = file.name;
        fileBytes = file.bytes;
        mySetState();
      } else {
        fileName = "";
        fileBytes = null;
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in selecting the file: $e");
      MyPrint.printOnConsole(s);
    }
    return fileName;
  }

  Future<void> createTopic() async {
    isLoading = true;
    mySetState();
    ForumModel forumModel = widget.arguments.forumModel;

    AddTopicRequestModel addTopicRequestModel = AddTopicRequestModel(
      title: titleTextEditingController.text.trim(),
      description: descriptionTextEditingController.text.trim(),
      forumID: forumModel.ForumID,
      forumName: forumModel.Name,
      strAttachFile: fileName,
      strContentID: widget.arguments.topicModel?.ContentID ?? "",
      strAttachFileBytes: fileBytes,
    );

    bool isSuccess = widget.arguments.isEdit
        ? await discussionController.editTopic(
        requestModel: addTopicRequestModel,
        componentId: widget.arguments.componentId,
        componentInstanceId: widget.arguments.componentInsId,
        contentId: widget.arguments.topicModel?.ContentID ?? "")
        : await discussionController.addTopic(
      requestModel: addTopicRequestModel,
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInsId,
    );
    MyPrint.printOnConsole("isSuccess: $isSuccess");

    isLoading = false;
    mySetState();

    MyPrint.printOnConsole("context.mounted:${context.mounted}");
    if (isSuccess && context.mounted) {
      MyToast.showSuccess(msg: widget.arguments.isEdit ? "Topic Edited SuccessFully" : "Topic Created SuccessFully", context: context);
      Navigator.pop(context, isSuccess);
    }
  }

  void setEditData() {
    TopicModel? topicModel = widget.arguments.topicModel;

    if (topicModel == null) return;
    titleTextEditingController.text = topicModel.Name;
    descriptionTextEditingController.text = topicModel.LongDescription;
    uploadFileTextEditingController.text = topicModel.UploadedImageName;
    fileName = topicModel.UploadedImageName;
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    discussionProvider = context.read<DiscussionProvider>();
    discussionController = DiscussionController(discussionProvider: discussionProvider);
    setEditData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: appBar(),
          body: AppUIComponents.getBackGroundBordersRounded(
            context: context,
            child: mainWidget(),
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            getCommonTextFormField(
              hintext: "Title",
              inputFormatter: [
                LengthLimitingTextInputFormatter(200),
              ],
              maxLines: 3,
              minLines: 1,
              isStarVisible: true,
              prefixIconData: FontAwesomeIcons.fileLines,
              textEditingController: titleTextEditingController,
              validator: (String? val) {
                if (val == null || val.trim().checkEmpty) {
                  return "Please enter the title";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            getCommonTextFormField(
              hintext: "Description",
              prefixIconData: FontAwesomeIcons.fileLines,
              textEditingController: descriptionTextEditingController,
              maxLines: 4,
              minLines: 1,
            ),
            if (widget.arguments.forumModel.AttachFileEditValue)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () async {
                    fileName = await openFileExplorer(FileType.any, false);
                    uploadFileTextEditingController.text = fileName;
                    mySetState();
                  },
                  child: getCommonTextFormField(
                    enable: false,
                    hintext: "Upload file",
                    prefixIconData: FontAwesomeIcons.arrowUpFromBracket,
                    suffix: Icons.add,
                    textEditingController: uploadFileTextEditingController,
                  ),
                ),
              ),
            const SizedBox(height: 40),
            getCreateTopicButton(),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        widget.arguments.isEdit ? "Edit Topic" : "Create Topic",
      ),
    );
  }

  Widget getCreateTopicButton() {
    return CommonButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (formKey.currentState?.validate() ?? false) {
          String vali = "success#\$#a5ee845c-7147-4a5e-aba3-980e74117e96#\$#";
          List<String> splitResponse = vali.split("#\$#");
          String topicIc = splitResponse[1].checkNotEmpty ? splitResponse[1] : "";
          MyPrint.printOnConsole(topicIc);
          createTopic();
        }
      },
      text: widget.arguments.isEdit ? "Edit Topic" : "Create Topic",
      fontColor: Colors.white,
      fontSize: 16,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  Widget getCommonTextFormField({
    String hintext = "",
    IconData? prefixIconData,
    IconData? suffix,
    bool enable = true,
    bool isStarVisible = false,
    required TextEditingController textEditingController,
    final String? Function(String?)? validator,
    int? maxLines,
    int? minLines,
    List<TextInputFormatter> inputFormatter = const [],
  }) {
    return CommonTextFormField(
      isOutlineInputBorder: true,
      borderRadius: 5,
      borderColor: Colors.grey,
      controller: textEditingController,
      enabled: enable,
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: inputFormatter,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // hintText: hintext,
      label: RichText(
        text: TextSpan(
          text: "$hintext ",
          style: const TextStyle(color: Colors.black),
          children: [
            if (isStarVisible)
              const TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      validator: validator,
      prefixWidget: prefixIconData == null
          ? const SizedBox()
          : Icon(
        prefixIconData,
        size: 15,
        color: Colors.grey,
      ),
      suffixWidget: suffix == null
          ? null
          : Icon(
        suffix,
        color: Colors.grey,
      ),
    );
  }
}

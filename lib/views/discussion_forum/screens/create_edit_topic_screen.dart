import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
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
import '../../../models/common/Instancy_multipart_file_upload_model.dart';
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
    } else {
      fileName = "";
      fileBytes = null;
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
    );

    String response = widget.arguments.isEdit
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
    MyPrint.printOnConsole("Successss: $response");

    bool isSuccess = false;

    List<String> splitResponse = response.split("#\$#");
    if (splitResponse.checkNotEmpty) {
      isSuccess = ParsingHelper.parseBoolMethod(splitResponse.firstOrNull == "success");
      String topicId = splitResponse.elementAtOrNull(1).checkNotEmpty ? splitResponse[1] : "";
      MyPrint.printOnConsole("topicId: $topicId, isSuccess $isSuccess");

      if (isSuccess) {
        UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
          topicId: topicId,
          isTopic: true,
          fileUploads: [
            InstancyMultipartFileUploadModel(
              fieldName: "Image",
              fileName: fileName,
              bytes: fileBytes,
            )
          ],
        );
        bool isSuccessUpload = await discussionController.uploadForumAttachment(requestModel: uploadForumAttachmentModel);
        MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload");
      }
    }

    isLoading = false;
    mySetState();

    if (isSuccess && context.mounted) {
      MyToast.showSuccess(msg: "Topic Created SuccessFully", context: context);
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
              hintext: "Title*",
              prefixIconData: FontAwesomeIcons.fileLines,
              textEditingController: titleTextEditingController,
              validator: (String? val) {
                if (val == null || val.checkEmpty) {
                  return "Please enter the title";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            getCommonTextFormField(hintext: "Description", prefixIconData: FontAwesomeIcons.fileLines, textEditingController: descriptionTextEditingController),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                fileName = await openFileExplorer(FileType.image, false);
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
    required TextEditingController textEditingController,
    final String? Function(String?)? validator,
  }) {
    return CommonTextFormField(
      isOutlineInputBorder: true,
      borderRadius: 5,
      borderColor: Colors.grey,
      controller: textEditingController,
      enabled: enable,
      contentPadding: EdgeInsets.zero,
      hintText: hintext,
      validator: validator,
      prefixWidget: prefixIconData == null
          ? const SizedBox()
          : Icon(
              prefixIconData,
              size: 15,
              color: Colors.grey,
            ),
      suffixWidget: suffix == null
          ? const SizedBox()
          : Icon(
              suffix,
              color: Colors.grey,
            ),
    );
  }
}

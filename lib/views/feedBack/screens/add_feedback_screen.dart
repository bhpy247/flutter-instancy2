import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_controller.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:flutter_instancy_2/models/feedback/request_model/update_feedback_request_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddFeedbackScreen extends StatefulWidget {
  static const String routeName = "/AddFeedbackScreen";

  const AddFeedbackScreen({super.key});

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> with MySafeState {
  late FeedbackController feedbackController;
  late FeedbackProvider feedbackProvider;
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
    List<InstancyMultipartFileUploadModel>? list;
    if (fileBytes != null) {
      list = [
        InstancyMultipartFileUploadModel(
          fieldName: "image",
          fileName: fileName,
          bytes: fileBytes,
        ),
      ];
    }
    MyPrint.printOnConsole("Date Time : ${DatePresentation.mmmmDDYYYYHHMMAFormatter(Timestamp.now())}");

    UpdateFeedbackRequestModel updateFeedbackRequestModel = UpdateFeedbackRequestModel(
      feedbackTitle: titleTextEditingController.text.trim(),
      feedbackdesc: descriptionTextEditingController.text.trim(),
      fileUploads: list,
      imageFileName: fileName,
      // date2: DatePresentation.mmmmDDYYYYHHMMAFormatter(Timestamp.now()),
      date2: DateTime.now().toIso8601String(),
      strAttachFileBytes: fileBytes,
    );

    bool isSuccess = await feedbackController.updateFeedback(
      requestModel: updateFeedbackRequestModel,
    );
    MyPrint.printOnConsole("isSuccess: $isSuccess");

    isLoading = false;
    mySetState();

    MyPrint.printOnConsole("context.mounted:${context.mounted}");
    if (isSuccess && context.mounted) {
      MyToast.showSuccess(msg: "Feedback added successfully", context: context);
      Navigator.pop(context, isSuccess);
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    feedbackProvider = context.read<FeedbackProvider>();
    feedbackController = FeedbackController(feedbackProvider: feedbackProvider);
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
              hintext: "Feedback",
              isStarVisible: true,
              validator: (String? val) {
                if (val == null || val.trim().checkEmpty) {
                  return "Please enter the Feedback";
                }
                return null;
              },
              prefixIconData: FontAwesomeIcons.solidComment,
              textEditingController: descriptionTextEditingController,
              maxLines: 4,
              minLines: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InkWell(
                onTap: () async {
                  fileName = await openFileExplorer(FileType.image, false);
                  uploadFileTextEditingController.text = fileName;
                  mySetState();
                },
                child: getCommonTextFormField(
                  enable: false,
                  hintext: "Choose image",
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
        "Enter New Feedback",
      ),
    );
  }

  Widget getCreateTopicButton() {
    return CommonButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (formKey.currentState?.validate() ?? false) {
          createTopic();
        }
      },
      text: "Add Feedback",
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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_answer_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditAnswerScreen extends StatefulWidget {
  static const String routeName = "/addEditAnswerScreen";
  final AddEditAnswerScreenNavigationArguments arguments;

  const AddEditAnswerScreen({super.key, required this.arguments});

  @override
  State<AddEditAnswerScreen> createState() => _AddEditAnswerScreenState();
}

class _AddEditAnswerScreenState extends State<AddEditAnswerScreen> with MySafeState {
  late AskTheExpertController askTheExpertController;
  late AskTheExpertProvider askTheExpertProvider;
  late AppProvider appProvider;

  TextEditingController titleTextEditingController = TextEditingController();
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

  Future<void> createAnswer() async {
    isLoading = true;
    mySetState();
    // ForumModel forumModel = widget.arguments.forumModel;
    UserQuestionListDto userQuestionListDto = widget.arguments.userQuestionListDto ?? UserQuestionListDto();

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
    AddAnswerRequestModel answerRequestModel = AddAnswerRequestModel();
    if (widget.arguments.isEdit) {
      QuestionAnswerResponse answerResponse = widget.arguments.questionAnswerResponse ?? QuestionAnswerResponse();
      answerRequestModel.Response = titleTextEditingController.text.trim();
      answerRequestModel.QuestionID = answerResponse.questionID;
      answerRequestModel.IsRemoveEditimage = false;
      answerRequestModel.ResponseID = answerResponse.responseID;
      answerRequestModel.UserResponseImageName = answerResponse.userResponseImage.checkNotEmpty ? answerResponse.userResponseImage : fileName;
      answerRequestModel.strAttachFileBytes = fileBytes;
      answerRequestModel.fileUploads = list;
    } else {
      answerRequestModel.Response = titleTextEditingController.text.trim();
      answerRequestModel.QuestionID = userQuestionListDto.questionID;
      answerRequestModel.IsRemoveEditimage = false;
      answerRequestModel.ResponseID = -1;
      answerRequestModel.UserResponseImageName = fileName;
      answerRequestModel.strAttachFileBytes = fileBytes;
      answerRequestModel.fileUploads = list;
    }

    bool isSuccess = await askTheExpertController.addAnswer(requestModel: answerRequestModel);
    MyPrint.printOnConsole("isSuccess: $isSuccess");

    isLoading = false;
    mySetState();

    MyPrint.printOnConsole("context.mounted:${context.mounted}");
    if (isSuccess && context.mounted) {
      MyToast.showSuccess(msg: widget.arguments.isEdit ? "Answer edited SuccessFully" : "Answer added SuccessFully", context: context);

      Navigator.pop(context, isSuccess);
    } else {
      if (context.mounted) {
        MyToast.showError(msg: "Answer addition failed", context: context);
      }
    }
  }

  void setEditData() {
    QuestionAnswerResponse? answerResponse = widget.arguments.questionAnswerResponse;

    if (answerResponse == null) return;
    titleTextEditingController.text = answerResponse.response;
    uploadFileTextEditingController.text = answerResponse.responseImageUploadName;
    fileName = answerResponse.responseImageUploadName;
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider);
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
              hintext: "Add Answer",
              // inputFormatter: [
              //   LengthLimitingTextInputFormatter(200),
              // ],
              maxLines: 3,
              minLines: 1,
              isStarVisible: true,
              prefixIconData: FontAwesomeIcons.fileLines,
              textEditingController: titleTextEditingController,
              validator: (String? val) {
                if (val == null || val.trim().checkEmpty) {
                  return "Please enter answer";
                }
                return null;
              },
            ),
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
        widget.arguments.isEdit ? "Edit Answer" : "Add Answer",
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
          createAnswer();
        }
      },
      text: widget.arguments.isEdit ? "Edit Answer" : "Add Answer",
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

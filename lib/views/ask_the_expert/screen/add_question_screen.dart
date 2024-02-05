import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_question_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/filter_user_skills_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class CreateEditQuestionScreen extends StatefulWidget {
  static const String routeName = "/addQuestionScreen";
  final CreateEditQuestionNavigationArguments arguments;

  const CreateEditQuestionScreen({super.key, required this.arguments});

  @override
  State<CreateEditQuestionScreen> createState() => _CreateEditQuestionScreenState();
}

class _CreateEditQuestionScreenState extends State<CreateEditQuestionScreen> with MySafeState {
  late AskTheExpertController askTheExpertController;
  late AskTheExpertProvider askTheExpertProvider;
  late AppProvider appProvider;

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController uploadFileTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCategoriesString = "";
  List<UserFilterSkills> skillsList = [];
  List<UserFilterSkills> selectedSkillsList = [];
  final GlobalKey expansionTile = GlobalKey();

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

  Future<void> createQuestion() async {
    List<int> skillIds = selectedSkillsList.map((model) => model.PreferrenceID).toList();
    List<String> skillName = selectedSkillsList.map((model) => model.preferrenceTitle).toList();
    if (skillIds.isEmpty) {
      MyToast.showError(context: context, msg: "Please Select at least one skill");
      return;
    }

    isLoading = true;
    mySetState();

    String commaSeparatedCategoriesIds = skillIds.join(', ');
    String commaSeparatedCategoriesName = skillName.join(', ');

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

    AddQuestionRequestModel requestModel = AddQuestionRequestModel(
        UserQuestion: titleTextEditingController.text.trim(),
        UserQuestionDesc: descriptionTextEditingController.text.trim(),
        QuestionTypeID: 1,
        UseruploadedImageName: fileName,
        strAttachFileBytes: fileBytes,
        fileUploads: list,
        EditQueID: -1,
        skills: commaSeparatedCategoriesName,
        SeletedSkillIds: commaSeparatedCategoriesIds);

    if (widget.arguments.isEdit) {
      requestModel.QuestionTypeID = widget.arguments.userQuestionListDto?.questionID ?? 0;
      // requestModel.ParentForumID = widget.arguments.forumModel?.ParentForumID ?? 0;
      // requestModel.CategoryIDs = widget.arguments.forumModel?.CategoryIDs ?? "";
      // requestModel.RequiresSubscription = widget.arguments.forumModel?.RequiresSubscription ?? false;
    }

    MyPrint.logOnConsole("Request Model Discussion Forum ${requestModel.toJson()}");

    bool isCreated = await askTheExpertController.addQuestion(
      requestModel: requestModel,
    );

    isLoading = false;
    mySetState();

    if (isCreated && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void setEditData() {
    UserQuestionListDto? topicModel = widget.arguments.userQuestionListDto;

    if (topicModel == null) return;
    titleTextEditingController.text = topicModel.userQuestion;
    descriptionTextEditingController.text = topicModel.userQuestionDescription;
    uploadFileTextEditingController.text = topicModel.userQuestionImage;
    fileName = topicModel.userQuestionImage;
    List<String> categoriesidsFromString = topicModel.questionCategories.split(",").toList();
    selectedSkillsList = skillsList.where((element) => categoriesidsFromString.contains(element.preferrenceTitle.toString())).toList();
    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedSkillsList.map((e) => e.preferrenceTitle).toList(),
      separator: ", ",
    );
    if (selectedCategoriesString.checkNotEmpty) {
      isExpanded = true;
    }
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider);
    askTheExpertController.getFilterSkills(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
    askTheExpertController.getUserFilterSkills(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
    skillsList = askTheExpertProvider.userFilterSkillsList.getList();
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
      child: SingleChildScrollView(
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

              // if (widget.arguments.forumModel.AttachFileEditValue)
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
              const SizedBox(height: 20),
              getSkillExpansionTile(),

              const SizedBox(height: 40),
              getCreateTopicButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        widget.arguments.isEdit ? "Edit a Question" : "Add Question",
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
          createQuestion();
        }
      },
      text: "Submit Question",
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
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
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

  Widget getSkillExpansionTile() {
    return Consumer<AskTheExpertProvider>(
      builder: (BuildContext context, AskTheExpertProvider provider, _) {
        return Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
          child: Theme(
            data: themeData.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: expansionTile,
              backgroundColor: const Color(0xffF8F8F8),
              initiallyExpanded: isExpanded,
              leading: const Icon(
                Icons.dashboard,
                size: 20,
                color: Colors.grey,
              ),

              // tilePadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
              title: Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: selectedCategoriesString.isEmpty
                        ? const TextSpan(
                            text: "Skills ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : TextSpan(
                            text: "$selectedCategoriesString ",
                            style: const TextStyle(color: Colors.black),
                          ),
                  )

                      // Text(
                      //   selectedCategoriesString.isEmpty ? "Skills" : selectedCategoriesString,
                      //   // style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
                      // ),
                      ),
                ],
              ),
              onExpansionChanged: (bool? newVal) {
                FocusScope.of(context).unfocus();
              },
              children: List.generate(skillsList.length, (index) {
                return Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      bool isChecked = !selectedSkillsList.where((element) => element.PreferrenceID == skillsList[index].PreferrenceID).checkNotEmpty;
                      MyPrint.printOnConsole("isChecked : $isChecked");
                      if (isChecked) {
                        selectedSkillsList.add(skillsList[index]);
                      } else {
                        selectedSkillsList.removeAt(index);
                      }

                      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                        list: selectedSkillsList.map((e) => e.preferrenceTitle).toList(),
                        separator: ", ",
                      );
                      setState(() {});

                      // if (isChecked) {
                      //   // selectedCategory = e.name;
                      //   selectedSkillsList.add(e);
                      //   setState(() {});
                      //
                      // } else {
                      //   // selectedCategory = "";
                      //   selectedSkillsList.remove(e);
                      // }
                      // print(isChecked);
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: themeData.primaryColor,
                          value: selectedSkillsList.where((element) => element.PreferrenceID == skillsList[index].PreferrenceID).checkNotEmpty,
                          onChanged: (bool? value) {
                            bool isChecked = value ?? false;
                            MyPrint.printOnConsole("selectedSkillsList : ${value}}");

                            if (isChecked) {
                              selectedSkillsList.add(skillsList[index]);
                            } else {
                              selectedSkillsList.removeWhere((element) => element.PreferrenceID == skillsList[index].PreferrenceID);
                            }

                            selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                              list: selectedSkillsList.map((e) => e.preferrenceTitle).toList(),
                              separator: ",",
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(skillsList[index].preferrenceTitle),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // children: provider.skillsList.getList().map((e) {
              //   return Container(
              //     color: Colors.white,
              //     child: InkWell(
              //       onTap: () {
              //         bool isChecked = !selectedSkillsList.contains(e);
              //         if (isChecked) {
              //           selectedSkillsList.add(e);
              //         } else {
              //           selectedSkillsList.remove(e);
              //         }
              //
              //         selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              //           list: selectedSkillsList.map((e) => e.CategoryName).toList(),
              //           separator: ", ",
              //         );
              //         setState(() {});
              //
              //         // if (isChecked) {
              //         //   // selectedCategory = e.name;
              //         //   selectedSkillsList.add(e);
              //         //   setState(() {});
              //         //
              //         // } else {
              //         //   // selectedCategory = "";
              //         //   selectedSkillsList.remove(e);
              //         // }
              //         // print(isChecked);
              //       },
              //       child: Row(
              //         children: [
              //           Checkbox(
              //             activeColor: themeData.primaryColor,
              //             value: selectedSkillsList.where((element) => element.id == e.id).checkNotEmpty,
              //             onChanged: (bool? value) {
              //               bool isChecked = value ?? false;
              //               if (isChecked) {
              //                 selectedSkillsList.add(e);
              //               } else {
              //                 selectedSkillsList.remove(e);
              //               }
              //
              //               selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              //                 list: selectedSkillsList.map((e) => e.CategoryName).toList(),
              //                 separator: ",",
              //               );
              //               setState(() {});
              //             },
              //           ),
              //           const SizedBox(width: 10),
              //           Expanded(
              //             child: Text(e.CategoryName),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }).toList(),
            ),
          ),
        );
      },
    );
  }
}

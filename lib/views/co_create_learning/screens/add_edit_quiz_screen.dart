import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/quiz_screen.dart';
import 'package:flutter_instancy_2/views/common/components/common_border_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/common_save_exit_button_row.dart';

class AddEditQuizScreen extends StatefulWidget {
  static const String routeName = "/AddEditQuizScreen";
  final AddEditQuizScreenArgument arguments;

  const AddEditQuizScreen({super.key, required this.arguments});

  @override
  State<AddEditQuizScreen> createState() => _AddEditQuizScreenState();
}

class _AddEditQuizScreenState extends State<AddEditQuizScreen> with MySafeState {
  bool isLoading = false;
  String? selectedQuestionType, selectedDifficultyLevel;

  TextEditingController countController = TextEditingController();
  TextEditingController promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  NavigationController.navigateToGeneratedQuizScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      argument: const GeneratedQuizScreenNavigationArgument());
                },
                text: AppStrings.generateWithAI,
                fontColor: theme.colorScheme.onPrimary,
              ),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: widget.arguments.courseDtoModel != null ? "Edit Quiz" : "Generate Quiz",
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 17,
                    ),
                    // getPromptTextFormField(),
                    // const SizedBox(
                    //   height: 17,
                    // ),
                    getCardCountTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getQuestionTypeDropDown(),
                    const SizedBox(
                      height: 17,
                    ),
                    getDifficultyLevelDropDown(),
                    const SizedBox(
                      height: 17,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  Widget getCardCountTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: countController,
      labelText: "Question Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getPromptTextFormField() {
    return getTexFormField(
        isMandatory: false,
        showPrefixIcon: false,
        controller: promptController,
        labelText: "Write Prompt...",
        keyBoardType: TextInputType.text,
        iconUrl: "assets/catalog/imageDescription.png",
        maxLines: 7,
        minLines: 7);
  }

  Widget getQuestionTypeDropDown() {
    return CommonBorderDropdown(
      isExpanded: true,
      items: const ["Multiple Choice", "True/False", "Both"],
      value: selectedQuestionType,
      hintText: "Question Type",
      onChanged: (val) {
        selectedQuestionType = val;
        mySetState();
      },
    );
  }

  Widget getDifficultyLevelDropDown() {
    return CommonBorderDropdown(
      isExpanded: true,
      items: const ["Hard", "Medium", "Easy"],
      value: selectedDifficultyLevel,
      hintText: "Difficulty Level",
      onChanged: (val) {
        selectedDifficultyLevel = val;
        mySetState();
      },
    );
  }

  //region textFieldView
  Widget getTexFormField(
      {TextEditingController? controller,
      String iconUrl = "",
      String? Function(String?)? validator,
      String labelText = "Label",
      Widget? suffixWidget,
      required bool isMandatory,
      int? minLines,
      int? maxLines,
      bool showPrefixIcon = false,
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.textFieldBorderColor,
      enabledBorderColor: Styles.textFieldBorderColor,
      borderWidth: 1,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      prefixWidget: showPrefixIcon
          ? iconUrl.isNotEmpty
              ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
              : const Icon(
                  FontAwesomeIcons.globe,
                  size: 15,
                  color: Colors.grey,
                )
          : null,
      suffixWidget: suffixWidget,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

//endregion
}

class GeneratedQuizScreen extends StatefulWidget {
  static const String routeName = "/GeneratedQuizScreen";
  final GeneratedQuizScreenNavigationArgument arguments;

  const GeneratedQuizScreen({super.key, required this.arguments});

  @override
  State<GeneratedQuizScreen> createState() => _GeneratedQuizScreenState();
}

class _GeneratedQuizScreenState extends State<GeneratedQuizScreen> with MySafeState {
  TextEditingController correctFeedbackController = TextEditingController();
  TextEditingController incorrectFeedbackController = TextEditingController();

  late PageController pageController;
  String selectedAnswer = "";
  bool onSaveTap = false;
  bool isSummaryWidget = false;

  List<QuizModel> quizModelList = [
    QuizModel(
      question: "What is the primary goal of office ergonomics?",
      isEditModeEnable: [
        false,
        false,
        false,
        false,
      ],
      optionList: [
        "A. Promote proper posture and reduce strain on the body",
        "B. Increase workload for employees",
        "C. Encourage standing desks only",
        "D. Focus on aesthetics over functionality",
      ],
      correctAnswer: "B. Increase workload for employees",
    ),
    QuizModel(
      question: "What is one of the risks associated with poor ergonomic setup?",
      isEditModeEnable: [
        false,
        false,
        false,
        false,
      ],
      optionList: [
        "A. Musculoskeletal disorders",
        "B. Enhanced productivity",
        "C. Improved posture",
        "D. Reduced fatigue",
      ],
      correctAnswer: "A. Musculoskeletal disorders",
    ),
    QuizModel(
      question: "Why is a good office chair important in office ergonomics?",
      isEditModeEnable: [
        false,
        false,
        false,
        false,
      ],
      optionList: [
        "A. To increase back pain",
        "B. To encourage slouching",
        "C. To maintain proper posture and support the spine",
        "D. To promote discomfort",
      ],
      correctAnswer: "C. To maintain proper posture and support the spine",
    ),
  ];

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Regenerate Quiz",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () {
            Navigator.pop(context);
          },
          iconData: InstancyIcons.reEnroll,
        ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.delete,
      ),
      InstancyUIActionModel(
        text: "Save & Exit",
        actionsEnum: InstancyContentActionsEnum.Save,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.save,
      ),
    ];

    return actions;
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0}) async {
    List<InstancyUIActionModel> actions = getActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(title: "Office Ergonomics", actions: [InkWell(onTap: () {}, child: const Icon(Icons.more_vert))]);
  }

  Widget getMainBody() {
    return PageView.builder(
      allowImplicitScrolling: false,
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (int index) {
        selectedAnswer = "";
        mySetState();
      },
      itemCount: quizModelList.length,
      itemBuilder: (BuildContext context, int index) {
        QuizModel model = quizModelList[index];
        return getSingleItemWidget(model, index);
      },
    );
  }

  Widget getSingleItemWidget(QuizModel model, int index) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "${index + 1}/${quizModelList.length}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // const Icon(Icons.more_vert)
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  getQuestionWidget(model: model, index: index),
                  const SizedBox(
                    height: 10,
                  ),
                  getAnswerList(model.optionList, model, index),
                  const SizedBox(
                    height: 20,
                  ),
                  getCorrectAnswerWidget(optionList: model.optionList, answer: model.correctAnswer, model: model),
                  const SizedBox(
                    height: 10,
                  ),
                  getCorrectFeedback(),
                  const SizedBox(
                    height: 10,
                  ),
                  getInCorrectFeedback(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          getBottomButton(index),
        ],
      ),
    );
  }

  Widget getQuestionWidget({required QuizModel model, int index = 0}) {
    return InkWell(
      onLongPress: () {
        model.isQuestionEditable = true;
        mySetState();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: model.isQuestionEditable
            ? getEditableTextField(
                controller: TextEditingController(text: "${model.question}"),
                onSubmitted: (String? val) {
                  if (val == null) return null;
                  model.question = val;
                  model.isQuestionEditable = false;
                  mySetState();
                  return "";
                },
              )
            : Text(
                "${index + 1}. ${model.question}",
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget getCorrectAnswerWidget({required QuizModel model, required List<String> optionList, required String? answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Correct Answer",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        getCommonDropDown(
          list: optionList,
          value: answer,
          hintText: "Correct Answer",
          onChanged: (val) {
            answer = val;
            model.correctAnswer = val ?? "";
            mySetState();
          },
          iconUrl: "assets/cocreate/commonText.png",
        ),
      ],
    );
  }

  Widget getBottomButton(int index) {
    if ((index + 1) == quizModelList.length) {
      return const CommonSaveExitButtonRow();
    }
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            onPressed: () {
              if (index != 0) {
                pageController.jumpToPage(index - 1);
              }
            },
            text: "Previous",
            fontColor: themeData.primaryColor,
            backGroundColor: themeData.colorScheme.onPrimary,
            borderColor: themeData.primaryColor,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CommonButton(
            onPressed: () {
              pageController.jumpToPage(index + 1);
            },
            text: "Next",
            fontColor: Colors.white,
          ),
        ),
      ],
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
      isDense: false,
      items: list,
      value: value,
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget getCorrectAndIncorrectAnswerWidget(
    QuizModel model,
  ) {
    if (!model.isAnswerGiven) return const SizedBox();
    if (!onSaveTap) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.selectedAnswer != model.correctAnswer)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Incorrect Answer",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Correct Answer${model.selectedAnswer != model.correctAnswer ? ":" : ""}",
            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        if (model.selectedAnswer != model.correctAnswer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              model.correctAnswer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget getAnswerList(List<String> answerList, QuizModel model, int quizListIndex) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: answerList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: model.isAnswerGiven
              ? null
              : () {
                  onSaveTap = false;
                  model.selectedAnswer = answerList[index];
                  mySetState();
                },
          onLongPress: () {
            model.isEditModeEnable[index] = true;
            mySetState();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(
              //   color: isSelected ? themeData.primaryColor : const Color(0xffDCDCDC),
              // ),
            ),
            child: model.isEditModeEnable[index]
                ? getEditableTextField(
                    controller: TextEditingController(text: answerList[index]),
                    onSubmitted: (String? val) {
                      if (answerList[index] == model.correctAnswer) {
                        quizModelList[quizListIndex].correctAnswer = val ?? "";
                      }
                      answerList[index] = val ?? "";
                      quizModelList[quizListIndex].optionList[index] = val ?? "";
                      MyPrint.printOnConsole("quizModelList[quizListIndex].optionList[index] : ${quizModelList[quizListIndex].optionList[index]}");
                      model.isEditModeEnable[index] = false;
                      mySetState();
                      return "";
                    },
                  )
                : Text(
                    answerList[index],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget getEditableTextField({
    required TextEditingController controller,
    required String? Function(String?)? onSubmitted,
  }) {
    return getTexFormField(
        isMandatory: false,
        showPrefixIcon: false,
        isHintText: true,
        controller: controller,
        labelText: "Correct Feedback",
        keyBoardType: TextInputType.text,
        iconUrl: "assets/cocreate/commonText.png",
        minLines: 1,
        maxLines: 1,
        onSubmitted: onSubmitted);
  }

  Widget getCorrectFeedback() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: correctFeedbackController,
      labelText: "Correct Feedback",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
      minLines: 3,
      maxLines: 3,
    );
  }

  Widget getInCorrectFeedback() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: incorrectFeedbackController,
      labelText: "Incorrect Feedback",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
      minLines: 3,
      maxLines: 3,
    );
  }

  //region textFieldView
  Widget getTexFormField({
    TextEditingController? controller,
    String iconUrl = "",
    String? Function(String?)? validator,
    String? Function(String?)? onSubmitted,
    String labelText = "Label",
    Widget? suffixWidget,
    required bool isMandatory,
    int? minLines,
    int? maxLines,
    bool showPrefixIcon = false,
    bool isHintText = false,
    TextInputType? keyBoardType,
    double iconHeight = 15,
    double iconWidth = 15,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      label: isMandatory ? labelWithStar(labelText) : null,
      isHintText: isHintText,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.borderColor,
      enabledBorderColor: Styles.borderColor,
      focusColor: Styles.borderColor,
      borderWidth: 1,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      onSubmitted: onSubmitted,
      // prefixWidget: showPrefixIcon
      //     ? iconUrl.isNotEmpty
      //     ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
      //     : const Icon(
      //   FontAwesomeIcons.globe,
      //   size: 15,
      //   color: Colors.grey,
      // )
      //     : null,
      suffixWidget: suffixWidget,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
              ))
        ],
      ),
    );
  }
//endregion
}

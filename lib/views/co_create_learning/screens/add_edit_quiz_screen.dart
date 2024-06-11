import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/assessment_generate_request_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_border_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  String? selectedQuestionType, selectedDifficultyLevel;

  TextEditingController countController = TextEditingController();

  void initialize() {
    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    QuizContentModel? quizContentModel = coCreateContentAuthoringModel.quizContentModel;
    MyPrint.printOnConsole("quizContentModel:$quizContentModel");
    if (quizContentModel != null) {
      countController.text = quizContentModel.questionCount.toString();
      selectedQuestionType = quizContentModel.questionType.isEmpty ? null : quizContentModel.questionType;
      selectedDifficultyLevel = quizContentModel.difficultyLevel.isEmpty ? null : quizContentModel.difficultyLevel;
    }

    if (!coCreateContentAuthoringModel.isEdit) initializeDataForNewContent();
  }

  void initializeDataForNewContent() {
    countController.text = "3";
    selectedQuestionType = "Multiple Choice";
    selectedDifficultyLevel = "Medium";
  }

  Future<void> onGenerateTap() async {
    QuizContentModel quizContentModel = coCreateContentAuthoringModel.quizContentModel ?? QuizContentModel();
    quizContentModel.questionCount = int.tryParse(countController.text) ?? 0;
    quizContentModel.questionType = (selectedQuestionType == QuizQuestionType.mcqString
            ? QuizQuestionType.mcq
            : selectedQuestionType == QuizQuestionType.twoChoiceString
                ? QuizQuestionType.twoChoice
                : QuizQuestionType.both)
        .toString();
    quizContentModel.difficultyLevel = selectedDifficultyLevel ?? "";

    coCreateContentAuthoringModel.quizContentModel = quizContentModel;

    NavigationController.navigateToGeneratedQuizScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: GeneratedQuizScreenNavigationArgument(
        coCreateContentAuthoringModel: coCreateContentAuthoringModel,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
    initialize();
  }

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
                  onGenerateTap();
                },
                text: AppStrings.generateWithAI,
                fontColor: theme.colorScheme.onPrimary,
              ),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: widget.arguments.coCreateContentAuthoringModel.isEdit ? "Edit Quiz" : "Generate Quiz",
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
      labelText: "Questions Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getQuestionTypeDropDown() {
    return CommonBorderDropdown(
      isExpanded: true,
      items: const [QuizQuestionType.mcqString, QuizQuestionType.twoChoiceString, QuizQuestionType.bothString],
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
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late PageController pageController;
  late Future future;
  // List<QuizQuestionModel> quizModelList = [
  //   QuizQuestionModel(
  //     question: "What is the primary goal of office ergonomics?",
  //     isEditModeEnable: [
  //       false,
  //       false,
  //       false,
  //       false,
  //     ],
  //     optionList: [
  //       "A. Promote proper posture and reduce strain on the body",
  //       "B. Increase workload for employees",
  //       "C. Encourage standing desks only",
  //       "D. Focus on aesthetics over functionality",
  //     ],
  //     correctAnswer: "B. Increase workload for employees",
  //     correctFeedback: "True",
  //     inCorrectFeedback: "False",
  //   ),
  //   QuizQuestionModel(
  //     question: "What is one of the risks associated with poor ergonomic setup?",
  //     isEditModeEnable: [
  //       false,
  //       false,
  //       false,
  //       false,
  //     ],
  //     optionList: [
  //       "A. Musculoskeletal disorders",
  //       "B. Enhanced productivity",
  //       "C. Improved posture",
  //       "D. Reduced fatigue",
  //     ],
  //     correctAnswer: "A. Musculoskeletal disorders",
  //     correctFeedback: "True",
  //     inCorrectFeedback: "False",
  //   ),
  //   QuizQuestionModel(
  //     question: "Why is a good office chair important in office ergonomics?",
  //     isEditModeEnable: [
  //       false,
  //       false,
  //       false,
  //       false,
  //     ],
  //     optionList: [
  //       "A. To increase back pain",
  //       "B. To encourage slouching",
  //       "C. To maintain proper posture and support the spine",
  //       "D. To promote discomfort",
  //     ],
  //     correctAnswer: "C. To maintain proper posture and support the spine",
  //     correctFeedback: "True",
  //     inCorrectFeedback: "False",
  //   ),
  // ];

  List<QuizQuestionModel> quizModelList = [];

  void initializeData() {
    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    QuizContentModel? quizContentModel = coCreateContentAuthoringModel.quizContentModel;
    if (quizContentModel != null) {
      if (quizContentModel.questions.isNotEmpty) {
        quizModelList = quizContentModel.questions.toList();
      }

      if (quizModelList.length > quizContentModel.questionCount) {
        quizModelList = quizModelList.sublist(0, quizContentModel.questionCount);
      }
    }

    future = getData();
  }

  Future<void> getData() async {
    if (coCreateContentAuthoringModel.quizContentModel == null) return;

    QuizContentModel quizContentModel = coCreateContentAuthoringModel.quizContentModel!;
    AssessmentGenerateRequestModel requestModel = AssessmentGenerateRequestModel(
        prompt:
            "Generate meta-data fields below in 'English' language \nTag line, \nShort description (less than 25 words), Long description (less than 120 words), keywords, Table of content and Learning objectives.\n for this eLearning Course Title: 'Heart Attack'.\n Provide them in JSON format with the following keys:\n  short_description,learning_objectives as string.",
        difficultyLevel: quizContentModel.difficultyLevel,
        numberOfQuestions: quizContentModel.questionCount.toString(),
        type: quizContentModel.questionType);

    QuizResponseModel? quizResponseModel = await coCreateKnowledgeController.generateQuiz(requestModel: requestModel);
    if (quizResponseModel != null) {
      quizModelList = quizResponseModel.assessment;
    }
  }

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

  Future<CourseDTOModel?> saveQuiz() async {
    QuizContentModel quizContentModel = coCreateContentAuthoringModel.quizContentModel ?? QuizContentModel();
    quizContentModel.questions = quizModelList.toList();
    coCreateContentAuthoringModel.quizContentModel = quizContentModel;

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    if (courseDTOModel != null) {
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;

      courseDTOModel.Skills = coCreateContentAuthoringModel.skills;

      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      courseDTOModel.quizContentModel = quizContentModel;

      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveQuiz();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveQuiz();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    NavigationController.navigateToQuizScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: QuizScreenNavigationArguments(
        courseDTOModel: courseDTOModel,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // quizModelList = AppConstants().quizModelList;
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              if (snapShot.connectionState == ConnectionState.done) {
                return getMainBody();
              }
              return CommonLoader();
            }),
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
        mySetState();
      },
      itemCount: quizModelList.length,
      itemBuilder: (BuildContext context, int index) {
        QuizQuestionModel model = quizModelList[index];

        return QuizQuestionEditingWidget(
          questionModel: model,
          index: index,
          allQuestionsCount: quizModelList.length,
          onPreviousClick: () {
            if (index != 0) {
              pageController.jumpToPage(index - 1);
            }
          },
          onNextClick: () {
            pageController.jumpToPage(index + 1);
          },
          onSaveAndExitPressed: onSaveAndExitTap,
          onSaveAndViewPressed: onSaveAndViewTap,
        );
      },
    );
  }
}

class QuizQuestionEditingWidget extends StatefulWidget {
  final QuizQuestionModel questionModel;
  final int index;
  final int allQuestionsCount;
  final void Function()? onPreviousClick;
  final void Function()? onNextClick;
  final void Function()? onSaveAndExitPressed;
  final void Function()? onSaveAndViewPressed;

  const QuizQuestionEditingWidget({
    super.key,
    required this.questionModel,
    required this.index,
    required this.allQuestionsCount,
    this.onPreviousClick,
    this.onNextClick,
    this.onSaveAndExitPressed,
    this.onSaveAndViewPressed,
  });

  @override
  State<QuizQuestionEditingWidget> createState() => _QuizQuestionEditingWidgetState();
}

class _QuizQuestionEditingWidgetState extends State<QuizQuestionEditingWidget> with MySafeState {
  late QuizQuestionModel questionModel;
  late int index;

  TextEditingController correctFeedbackController = TextEditingController();
  TextEditingController incorrectFeedbackController = TextEditingController();

  void save() {
    questionModel.correctFeedback = correctFeedbackController.text;
    questionModel.inCorrectFeedback = incorrectFeedbackController.text;
  }

  void onNextPressed() {
    save();
    widget.onNextClick?.call();
  }

  void onPreviousPressed() {
    save();
    widget.onPreviousClick?.call();
  }

  void onSaveAndExitPressed() {
    save();
    widget.onSaveAndExitPressed?.call();
  }

  void onSaveAndViewPressed() {
    save();
    widget.onSaveAndViewPressed?.call();
  }

  String _getAlphabeticLabel(int index) {
    return String.fromCharCode(65 + index); // 65 is the ASCII code for 'A'
  }

  @override
  void initState() {
    super.initState();

    questionModel = widget.questionModel;
    index = widget.index;

    correctFeedbackController.text = questionModel.correctFeedback;
    incorrectFeedbackController.text = questionModel.inCorrectFeedback;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

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
                            "Question ${widget.index + 1} of ${widget.allQuestionsCount}",
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
                  getQuestionWidget(questionModel: questionModel, index: index),
                  const SizedBox(
                    height: 10,
                  ),
                  getAnswerList(questionModel.choices, questionModel, index),
                  const SizedBox(
                    height: 20,
                  ),
                  getCorrectAnswerWidget(optionList: questionModel.choices, answer: questionModel.correctChoice, questionModel: questionModel),
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

  Widget getQuestionWidget({required QuizQuestionModel questionModel, int index = 0}) {
    return InkWell(
      onLongPress: () {
        questionModel.isQuestionEditable = true;
        mySetState();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: questionModel.isQuestionEditable
            ? getEditableTextField(
                controller: TextEditingController(text: "${questionModel.question}"),
                onSubmitted: (String? val) {
                  if (val == null) return null;
                  questionModel.question = val;
                  questionModel.isQuestionEditable = false;
                  mySetState();
                  return "";
                },
              )
            : Text(
                "${index + 1}. ${questionModel.question}",
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget getCorrectAnswerWidget({required QuizQuestionModel questionModel, required List<String> optionList, required String? answer}) {
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
            questionModel.correctChoice = val ?? "";
            mySetState();
          },
          iconUrl: "assets/cocreate/commonText.png",
        ),
      ],
    );
  }

  Widget getBottomButton(int index) {
    if ((index + 1) == widget.allQuestionsCount) {
      return CommonSaveExitButtonRow(
        onSaveAndExitPressed: onSaveAndExitPressed,
        onSaveAndViewPressed: onSaveAndViewPressed,
      );
    }
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            onPressed: () {
              onPreviousPressed();
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
              onNextPressed();
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
    QuizQuestionModel questionModel,
  ) {
    if (!questionModel.isAnswerGiven) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (questionModel.selectedAnswer != questionModel.correctChoice)
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
            "Correct Answer${questionModel.selectedAnswer != questionModel.correctChoice ? ":" : ""}",
            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        if (questionModel.selectedAnswer != questionModel.correctChoice)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              questionModel.correctChoice,
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget getAnswerList(List<String> answerList, QuizQuestionModel questionModel, int quizListIndex) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: answerList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: questionModel.isAnswerGiven
              ? null
              : () {
                  questionModel.selectedAnswer = answerList[index];
                  mySetState();
                },
          onLongPress: () {
            questionModel.isEditModeEnable = [false, false, false, false];
            questionModel.isEditModeEnable[index] = true;
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
            child: questionModel.isEditModeEnable[index]
                ? getEditableTextField(
                    controller: TextEditingController(text: answerList[index]),
                    onSubmitted: (String? val) {
                      if (answerList[index] == questionModel.correctChoice) {
                        questionModel.correctChoice = val ?? "";
                      }
                      answerList[index] = val ?? "";
                      questionModel.choices[index] = val ?? "";
                      MyPrint.printOnConsole("questionModel.optionList[index] : ${questionModel.choices[index]}");
                      questionModel.isEditModeEnable[index] = false;
                      mySetState();
                      return "";
                    },
                  )
                : Text(
                    "${_getAlphabeticLabel(index)}. ${answerList[index]}",
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

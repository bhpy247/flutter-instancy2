import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/flash_card_screen.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_constants.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../packages/flipcard/flip_card.dart';
import '../../../packages/flipcard/flip_card_controller.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  static const String routeName = "/AddEditFlashcardScreen";

  final AddEditFlashcardScreenNavigationArguments arguments;

  const AddEditFlashcardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> with MySafeState {
  bool isLoading = false;

  int cardCount = 0;
  Color? selectedColor;

  TextEditingController countController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController promptController = TextEditingController();
  List<String> skills = <String>[];
  String thumbnailImageUrl = "";

  List<QuestionAnswerModel> questionList = [];

  // Future<>
  static const Color guidePrimary = Color(0xFF6200EE);
  final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
  };

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: Colors.green,
      onColorChanged: (Color color) => setState(() => selectedColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        // ColorPickerType.both: false,
        // ColorPickerType.primary: true,
        // ColorPickerType.accent: true,
        // ColorPickerType.bw: false,
        // ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  void showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ColorPicker(
            // Use the screenPickerColor as start color.
            color: Colors.green,

            // Update the screenPickerColor using the callback.
            onColorChanged: (Color color) => setState(() => selectedColor = color),
            width: 44,
            height: 44,
            borderRadius: 22,
            heading: Text(
              'Select color',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subheading: Text(
              'Select color shade',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  NavigationController.navigateToGenerateWithAiFlashCardScreen(
                    navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                  );
                },
                text: AppStrings.generateWithAI,
                fontColor: themeData.colorScheme.onPrimary,
              ),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: widget.arguments.courseDTOModel != null ? "Edit Flashcard" : "Create Flashcard",
            ),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            getCardCountTextFormField(),
                            const SizedBox(
                              height: 17,
                            ),
                            getDropDownViewTypeTile(text: selectedColor == null ? "Background Color" : "$selectedColor"),
                            const SizedBox(
                              height: 17,
                            ),
                            getUrlTextFormField(),
                            const SizedBox(
                              height: 17,
                            ),
                          ],
                        ),
                      ),
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

  Widget getDropDownViewTypeTile({
    required String text,
    void Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
      child: Theme(
        data: themeData.copyWith(dividerColor: Colors.transparent),
        child: ListTile(
          onTap: () {
            colorPickerDialog();
          },
          // key: expansionTile,
          // backgroundColor: const Color(0xffF8F8F8),
          // initiallyExpanded: isExpanded,
          // tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          title: Row(
            children: [
              getImageView(url: "assets/catalog/categories.png", height: 15, width: 15),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  text,
                  style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
                ),
              ),
            ],
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
      controller: countController,
      labelText: "Card Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getUrlTextFormField() {
    return getTexFormField(
      isMandatory: false,
      controller: urlController,
      labelText: "Enter URL",
    );
  }

  Widget getPromptTextFormField() {
    return getTexFormField(
      isMandatory: false,
      controller: promptController,
      labelText: "Write a prompt",
      minLines: 1,
      maxLines: 5,
      iconUrl: "assets/catalog/imageDescription.png",
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
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      prefixWidget: iconUrl.isNotEmpty
          ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
          : const Icon(
              FontAwesomeIcons.globe,
              size: 15,
              color: Colors.grey,
            ),
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

class GenerateWithAiFlashCardScreen extends StatefulWidget {
  static const String routeName = "/GenerateWithAiFlashCardScreen";

  const GenerateWithAiFlashCardScreen({super.key});

  @override
  State<GenerateWithAiFlashCardScreen> createState() => _GenerateWithAiFlashCardScreenState();
}

class _GenerateWithAiFlashCardScreenState extends State<GenerateWithAiFlashCardScreen> with MySafeState {
  late FlipCardController _controller;
  late PageController pageController;

  List<QuestionAnswerModel> questionList = [
    QuestionAnswerModel(
        controller: FlipCardController(),
        answer: "Artificial intelligence (AI) is made up of units similar to the human brain's neuron called perceptrons, which are the processing power behind AI. ",
        question: "What is artificial intelligence (AI) ?",
        imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(
        controller: FlipCardController(),
        answer:
            "Neural networks are a class of machine learning algorithms inspired by the structure and functioning of the human brain. They are composed of interconnected processing units, called neurons or nodes, organized in layers.",
        question: "What is Neural Networks ?",
        imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(controller: FlipCardController(), answer: "What are the two main types of AI", question: "Narrow AI and General AI", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(controller: FlipCardController(), answer: "AI for specific tasks like facial recognition.", question: "What is Narrow AI ?", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(controller: FlipCardController(), answer: "AI with broad human-like abilities.", question: "What is General AI ?", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(
        controller: FlipCardController(), answer: "Virtual assistants, recommendation systems.", question: "What are some examples of Narrow AI ?", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(
        controller: FlipCardController(), answer: "Safety, job displacement, misuse concerns.", question: "What are some challenges of General AI ?", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(controller: FlipCardController(), answer: "Teaching computers to learn from data.", question: "What is machine learning ?", imageAsset: "assets/cocreate/Card.png"),
    QuestionAnswerModel(
        controller: FlipCardController(), answer: "Supervised, unsupervised, reinforcement.", question: "What are the three main types of machine learning ?", imageAsset: "assets/cocreate/Card.png"),
  ];

  List<InstancyUIActionModel> getActionsListOfMainWidget({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Regenerate All Flashcards",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () {
            Navigator.pop(context);
          },
          iconData: InstancyIcons.reEnroll,
        ),
      InstancyUIActionModel(
        text: "Delete All Flashcards",
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

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0, bool isOfMainWidget = true, String frontString = "", String backString = ""}) async {
    List<InstancyUIActionModel> actions =
        isOfMainWidget ? getActionsListOfMainWidget(model: model, index: index) : getActionsListOfIndividualFlashCard(model: model, index: index, backString: backString, frontString: frontString);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  List<InstancyUIActionModel> getActionsListOfIndividualFlashCard({required CourseDTOModel model, int index = 0, required String frontString, required String backString}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Edit this Flashcard",
          actionsEnum: InstancyContentActionsEnum.Save,
          onTap: () {
            Navigator.pop(context);
            NavigationController.navigateToEditFlashcardScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              argument: EditFlashcardScreenNavigationArgument(back: backString, front: frontString),
            );
          },
          iconData: InstancyIcons.edit,
        ),
      InstancyUIActionModel(
        text: "Regenerate this Flashcard",
        actionsEnum: InstancyContentActionsEnum.View,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.reEnroll,
      ),
      InstancyUIActionModel(
        text: "Delete this Flashcard",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(title: "Unveiling the Neurons of AIsss", actions: [
      InkWell(
          onTap: () {
            showMoreActions(model: CourseDTOModel());
          },
          child: const Icon(
            Icons.more_vert,
            size: 22,
          ))
    ]);
  }

  Widget getMainBody() {
    int length = questionList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Expanded(
                    child: getSingleWidget(
                      model: questionList[index],
                      index: index,
                      total: length,
                    ),
                  ),
                  getBottomButton(index)

                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     if (index > 0)
                  //       Container(
                  //         margin: const EdgeInsets.only(top: 110),
                  //         child: InkWell(
                  //           onTap: () {
                  //             pageController.animateToPage(index - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  //           },
                  //           child: const Icon(
                  //             Icons.keyboard_arrow_left_outlined,
                  //           ),
                  //         ),
                  //       )
                  //     else
                  //       const SizedBox(width: 20),
                  //     Expanded(
                  //       child:
                  //     ),
                  //     if (index < length - 1)
                  //       Container(
                  //         margin: const EdgeInsets.only(top: 110),
                  //         child: InkWell(
                  //           onTap: () {
                  //             pageController.animateToPage(index + 1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  //           },
                  //           child: const Icon(
                  //             Icons.keyboard_arrow_right_outlined,
                  //           ),
                  //         ),
                  //       )
                  //     else
                  //       const SizedBox(width: 20),
                  //   ],
                  // ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getSingleWidget({required QuestionAnswerModel model, required int index, required int total}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Flashcard ${index + 1} of $total",
                  style: themeData.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  showMoreActions(model: CourseDTOModel(), isOfMainWidget: false, frontString: model.question, backString: model.answer);
                },
                child: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: FlipCard(
            alignment: Alignment.topCenter,
            controller: model.controller,
            flipOnTouch: true,
            front: getCommonFrontAndBackWidget(text: model.question, onTap: () => model.controller.flip()),
            back: getCommonFrontAndBackWidget(text: model.answer, onTap: () => model.controller.flip()),
          ),
        ),
      ],
    );
  }

  Widget getCommonFrontAndBackWidget({String text = "", Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/cocreate/flashCard.png",
              width: double.maxFinite,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget getBottomButton(int index) {
    if ((index + 1) == questionList.length) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonSaveExitButtonRow(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
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
      ),
    );
  }
}

class EditFlashCardScreen extends StatefulWidget {
  static const String routeName = "/EditFlashCardScreen";

  const EditFlashCardScreen({super.key, required this.arguments});

  final EditFlashcardScreenNavigationArgument arguments;

  @override
  State<EditFlashCardScreen> createState() => _EditFlashCardScreenState();
}

class _EditFlashCardScreenState extends State<EditFlashCardScreen> with MySafeState {
  TextEditingController frontController = TextEditingController();
  TextEditingController backController = TextEditingController();

  @override
  void initState() {
    super.initState();
    frontController.text = widget.arguments.front;
    backController.text = widget.arguments.back;
    MyPrint.printOnConsole("Text: ${widget.arguments.front}");
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeData.colorScheme.onPrimary,
      appBar: getAppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: CommonSaveExitButtonRow(),
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Edit",
    );
  }

  Widget getMainBody() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    getFrontTextField(),
                    SizedBox(
                      height: 30,
                    ),
                    getBackTextField(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFrontTextField() {
    return Column(
      children: [
        Text(
          "Front",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 10,
        ),
        getTexFormField(
          isMandatory: false,
          controller: frontController,
          labelText: "Front",
          keyBoardType: TextInputType.number,
          iconUrl: "",
          minLines: 6,
          maxLines: 6,
        ),
      ],
    );
  }

  Widget getBackTextField() {
    return Column(
      children: [
        Text(
          "Back",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 10,
        ),
        getTexFormField(
          isMandatory: false,
          controller: backController,
          labelText: "Back",
          keyBoardType: TextInputType.number,
          iconUrl: "",
          minLines: 6,
          maxLines: 6,
        ),
      ],
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
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      isHintText: true,
      textAlign: TextAlign.center,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
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

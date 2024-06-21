import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/request_model/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_constants.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../packages/flipcard/flip_card.dart';
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

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  Color? selectedColor;

  TextEditingController countController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  static const Color guidePrimary = Color(0xFF6200EE);
  final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
  };

  void initialize() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    FlashcardContentModel? flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel;
    if (flashcardContentModel != null) {
      countController.text = flashcardContentModel.cardCount.toString();
      urlController.text = flashcardContentModel.queryUrl.toString();
      selectedColor = flashcardContentModel.backgroundColor.toColorMaybeNull;
    }

    if (!coCreateContentAuthoringModel.isEdit) initializeDataForNewContent();
  }

  void initializeDataForNewContent() {
    countController.text = "3";
    urlController.text = "https://www.unvielingtheneuronsofAI.com";
    selectedColor = const Color(0xff2ba700);
  }

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

  Future<void> onGenerateTap() async {
    FlashcardContentModel flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel ?? FlashcardContentModel();
    flashcardContentModel.cardCount = int.tryParse(countController.text) ?? 0;
    flashcardContentModel.queryUrl = urlController.text;
    flashcardContentModel.backgroundColor = selectedColor?.toHex() ?? "";

    coCreateContentAuthoringModel.flashcardContentModel = flashcardContentModel;

    dynamic value = await NavigationController.navigateToGenerateWithAiFlashCardScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: GenerateWithAiFlashCardScreenNavigationArguments(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
    );

    if (value == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();

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
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  onGenerateTap();
                },
                text: AppStrings.generateWithAI,
                fontColor: themeData.colorScheme.onPrimary,
              ),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: coCreateContentAuthoringModel.isEdit ? "Edit Flashcard" : "Generate Flashcard",
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

  final GenerateWithAiFlashCardScreenNavigationArguments arguments;

  const GenerateWithAiFlashCardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<GenerateWithAiFlashCardScreen> createState() => _GenerateWithAiFlashCardScreenState();
}

class _GenerateWithAiFlashCardScreenState extends State<GenerateWithAiFlashCardScreen> with MySafeState {
  bool isLoading = false;

  late PageController pageController;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  List<FlashcardModel> questionList = [
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "Artificial intelligence (AI) is made up of units similar to the human brain's neuron called perceptrons, which are the processing power behind AI. ",
    //   flashcardFront: "What is artificial intelligence (AI) ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack:
    //       "Neural networks are a class of machine learning algorithms inspired by the structure and functioning of the human brain. They are composed of interconnected processing units, called neurons or nodes, organized in layers.",
    //   flashcardFront: "What is Neural Networks ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "What are the two main types of AI",
    //   flashcardFront: "Narrow AI and General AI",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "AI for specific tasks like facial recognition.",
    //   flashcardFront: "What is Narrow AI ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "AI with broad human-like abilities.",
    //   flashcardFront: "What is General AI ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "Virtual assistants, recommendation systems.",
    //   flashcardFront: "What are some examples of Narrow AI ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "Safety, job displacement, misuse concerns.",
    //   flashcardFront: "What are some challenges of General AI ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "Teaching computers to learn from data.",
    //   flashcardFront: "What is machine learning ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
    // FlashcardModel(
    //   controller: FlipCardController(),
    //   flashcardBack: "Supervised, unsupervised, reinforcement.",
    //   flashcardFront: "What are the three main types of machine learning ?",
    //   assetImagePath: "assets/cocreate/Card.png",
    // ),
  ];
  Future? future;

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    FlashcardContentModel? flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel;
    if (flashcardContentModel == null || flashcardContentModel.flashcards.isEmpty) {
      future = getData();
    } else {
      questionList = flashcardContentModel.flashcards.toList();

      if (questionList.length > flashcardContentModel.cardCount) {
        questionList = questionList.sublist(0, flashcardContentModel.cardCount);
      }
    }

    mySetState();
  }

  Future<void> getData() async {
    try {
      FlashcardRequestModel requestModel = FlashcardRequestModel(
        difficultyLevel: "Hard",
        topicName: coCreateContentAuthoringModel.title,
        // description: coCreateContentAuthoringModel.description,
        flashcardCount: coCreateContentAuthoringModel.flashcardContentModel?.cardCount ?? 1,
        flashcards: questionList,
        // regenerateCards: singleFlashcardToRegenerate == null ? [] : [singleFlashcardToRegenerate],
      );

      GeneratedFlashcardResponseModel? flashcardResponseModel = await coCreateKnowledgeController.generateFlashcard(requestModel: requestModel);

      if (flashcardResponseModel == null) return;

      questionList = flashcardResponseModel.flashcards;
      MyPrint.printOnConsole("requestModel : ${questionList.length}");
    } catch (e, s) {
      MyPrint.printOnConsole("Error in getData : $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> regenerateData({FlashcardModel? singleFlashcardToRegenerate, int index = 0}) async {
    isLoading = true;
    mySetState();
    try {
      FlashcardRequestModel requestModel = FlashcardRequestModel(
        difficultyLevel: "Hard",
        topicName: coCreateContentAuthoringModel.title,
        // description: coCreateContentAuthoringModel.description,
        flashcardCount: coCreateContentAuthoringModel.flashcardContentModel?.cardCount ?? 1,
        flashcards: questionList,
        regenerateCards: singleFlashcardToRegenerate == null ? [] : [singleFlashcardToRegenerate],
      );

      GeneratedFlashcardResponseModel? flashcardResponseModel = await coCreateKnowledgeController.generateFlashcard(requestModel: requestModel);

      if (flashcardResponseModel == null) return;
      questionList.removeAt(index);
      questionList.insert(index, flashcardResponseModel.flashcards.first);
      MyPrint.printOnConsole("requestModel : ${questionList.length}");

      isLoading = false;
      mySetState();
    } catch (e, s) {
      MyPrint.printOnConsole("Error in getData : $e");
      MyPrint.printOnConsole(s);
    }
  }

  List<InstancyUIActionModel> getActionsListOfMainWidget({required CourseDTOModel model}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Regenerate All Flashcards",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () {
            Navigator.pop(context);
            future = getData();
            mySetState();
          },
          iconData: InstancyIcons.reEnroll,
        ),
      InstancyUIActionModel(
        text: "Delete All Flashcards",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
          questionList.clear();
          mySetState();
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

  Future<void> showMoreActionsForMainContent({required CourseDTOModel model}) async {
    List<InstancyUIActionModel> actions = getActionsListOfMainWidget(model: model);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  Future<void> showMoreActionsForFlashcard({required FlashcardModel model, required int index}) async {
    List<InstancyUIActionModel> actions = getActionsListOfIndividualFlashCard(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  List<InstancyUIActionModel> getActionsListOfIndividualFlashCard({required FlashcardModel model, required int index}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Edit this Flashcard",
        actionsEnum: InstancyContentActionsEnum.Save,
        onTap: () async {
          Navigator.pop(context);

          dynamic value = await NavigationController.navigateToEditFlashcardScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            argument: EditFlashcardScreenNavigationArgument(model: model),
          );

          if (value == true) {
            mySetState();
          }
        },
        iconData: InstancyIcons.edit,
      ),
      InstancyUIActionModel(
        text: "Regenerate this Flashcard",
        actionsEnum: InstancyContentActionsEnum.View,
        onTap: () async {
          Navigator.pop(context);
          await regenerateData(singleFlashcardToRegenerate: model, index: index);
          mySetState();
        },
        iconData: InstancyIcons.reEnroll,
      ),
      InstancyUIActionModel(
        text: "Delete this Flashcard",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
          questionList.removeAt(index);
          mySetState();
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  Future<CourseDTOModel?> saveFlashcard() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GenerateWithAiFlashCardScreen().saveFlashcard() called", tag: tag);

    isLoading = true;
    mySetState();

    FlashcardContentModel flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel ?? FlashcardContentModel();
    flashcardContentModel.flashcards = questionList.toList();
    coCreateContentAuthoringModel.flashcardContentModel = flashcardContentModel;

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from AddEditEventScreen().saveEvent() because contentId is null or empty", tag: tag);
      MyToast.showError(context: context, msg: coCreateContentAuthoringModel.isEdit ? "Couldn't Update Content" : "Couldn't Create Content");
      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    await NavigationController.navigateToFlashCardScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FlashCardScreenNavigationArguments(
        courseDTOModel: courseDTOModel,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: getAppBar(),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: future != null
              ? FutureBuilder(
                  future: future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return getMainBody();
                    }
                    return const CommonLoader();
                  },
                )
              : getMainBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: coCreateContentAuthoringModel.title,
      actions: [
        InkWell(
          onTap: () {
            showMoreActionsForMainContent(model: CourseDTOModel());
          },
          child: const Icon(
            Icons.more_vert,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget getMainBody() {
    int length = questionList.length;

    if (length == 0) {
      return const Center(
        child: Text("No Flashcard Available"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
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

  Widget getSingleWidget({required FlashcardModel model, required int index, required int total}) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CommonLoader(),
      child: Column(
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
                    showMoreActionsForFlashcard(model: model, index: index);
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
              front: getCommonFrontAndBackWidget(text: model.flashcard_front, onTap: () => model.controller.flip()),
              back: getCommonFrontAndBackWidget(text: model.flashcard_back, onTap: () => model.controller.flip()),
            ),
          ),
        ],
      ),
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
            // Image.asset(
            //   "assets/cocreate/flashCard.png",
            //   width: double.maxFinite,
            // ),
            // const SizedBox(height: 20),
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
        child: CommonSaveExitButtonRow(
          onSaveAndExitPressed: onSaveAndExitTap,
          onSaveAndViewPressed: onSaveAndViewTap,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          if (index != 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
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

  void onSaveTap() {
    widget.arguments.model.flashcard_back = frontController.text.trim();
    widget.arguments.model.flashcard_front = backController.text.trim();
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    frontController.text = widget.arguments.model.flashcard_front;
    backController.text = widget.arguments.model.flashcard_back;
    MyPrint.printOnConsole("Text: ${widget.arguments.model.flashcard_back}");
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeData.colorScheme.onPrimary,
      appBar: getAppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CommonButton(
          minWidth: double.infinity,
          onPressed: () {
            onSaveTap();
          },
          text: "Edit",
          fontColor: themeData.colorScheme.onPrimary,
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  getFrontTextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  getBackTextField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFrontTextField() {
    return Column(
      children: [
        const Text(
          "Front",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 10,
        ),
        getTexFormField(
          isMandatory: false,
          controller: frontController,
          labelText: "Front",
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
        const Text(
          "Back",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 10,
        ),
        getTexFormField(
          isMandatory: false,
          controller: backController,
          labelText: "Back",
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

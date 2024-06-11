import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/flashcard_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';

import '../../../configs/app_configurations.dart';
import '../../../packages/flipcard/flip_card.dart';
import '../../../packages/flipcard/flip_card_controller.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';

class FlashCardScreen extends StatefulWidget {
  static const String routeName = "/FlashCardScreen";

  final FlashCardScreenNavigationArguments arguments;

  const FlashCardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> with MySafeState {
  late PageController pageController;

  String title = "";
  List<FlashcardModel> flashcards = [
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "Artificial intelligence (AI) is made up of units similar to the human brain's neuron called perceptrons, which are the processing power behind AI. ",
      flashcardFront: "What is artificial intelligence (AI) ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack:
          "Neural networks are a class of machine learning algorithms inspired by the structure and functioning of the human brain. They are composed of interconnected processing units, called neurons or nodes, organized in layers.",
      flashcardFront: "What is Neural Networks ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "What are the two main types of AI",
      flashcardFront: "Narrow AI and General AI",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "AI for specific tasks like facial recognition.",
      flashcardFront: "What is Narrow AI ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "AI with broad human-like abilities.",
      flashcardFront: "What is General AI ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "Virtual assistants, recommendation systems.",
      flashcardFront: "What are some examples of Narrow AI ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "Safety, job displacement, misuse concerns.",
      flashcardFront: "What are some challenges of General AI ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "Teaching computers to learn from data.",
      flashcardFront: "What is machine learning ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
    FlashcardModel(
      controller: FlipCardController(),
      flashcardBack: "Supervised, unsupervised, reinforcement.",
      flashcardFront: "What are the three main types of machine learning ?",
      assetImagePath: "assets/cocreate/Card.png",
    ),
  ];

  void initializeData() {
    title = widget.arguments.courseDTOModel.ContentName;
    if (title.isEmpty) title = "Unveiling the Neurons of AI";
    FlashcardContentModel? flashcardContentModel = widget.arguments.courseDTOModel.flashcardContentModel;

    if ((flashcardContentModel?.flashcards).checkNotEmpty) {
      flashcards = flashcardContentModel!.flashcards;
    }
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
    return AppConfigurations().commonAppBar(
      title: title,
    );
  }

  Widget getMainBody() {
    int length = flashcards.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return getSingleWidget(
                model: flashcards[index],
                index: index,
                total: length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getSingleWidget({required FlashcardModel model, required int index, required int total}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Flashcard ${index + 1} of $total",
            style: themeData.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: FlipCard(
            alignment: Alignment.topCenter,
            controller: model.controller,
            flipOnTouch: true,
            front: getCommonFrontAndBackWidget(text: model.flashcardFront, onTap: () => model.controller.flip()),
            back: getCommonFrontAndBackWidget(text: model.flashcardBack, onTap: () => model.controller.flip()),
          ),
        ),
        Spacer(),
        getBottomButton(index)
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
    // if ((index + 1) == flashcards.length) {
    //   return Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: CommonSaveExitButtonRow(
    //       onSaveAndExitPressed: onSaveAndExitTap,
    //       onSaveAndViewPressed: onSaveAndViewTap,
    //     ),
    //   );
    // }

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
          const SizedBox(width: 20),
          Expanded(
            child: CommonButton(
              onPressed: () {
                if ((index + 1) == flashcards.length) {
                  Navigator.pop(context);
                  return;
                }
                pageController.jumpToPage(index + 1);
              },
              text: (index + 1) == flashcards.length ? "End" : "Next",
              fontColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

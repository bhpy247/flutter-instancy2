import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';

import '../../../configs/app_configurations.dart';
import '../../../packages/flipcard/flip_card.dart';
import '../../../packages/flipcard/flip_card_controller.dart';
import '../../common/components/app_ui_components.dart';

class FlashCardScreen extends StatefulWidget {
  static const String routeName = "/FlashCardScreen";

  const FlashCardScreen({super.key});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> with MySafeState {
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
    return AppConfigurations().commonAppBar(
      title: "Unveiling the Neurons of AI",
    );
  }

  Widget getMainBody() {
    int length = questionList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 110),
                          child: InkWell(
                            onTap: () {
                              pageController.animateToPage(index - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_left_outlined,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 20),
                      Expanded(
                        child: getSingleWidget(
                          model: questionList[index],
                          index: index,
                          total: length,
                        ),
                      ),
                      if (index < length - 1)
                        Container(
                          margin: const EdgeInsets.only(top: 110),
                          child: InkWell(
                            onTap: () {
                              pageController.animateToPage(index + 1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_right_outlined,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 20),
                    ],
                  ),
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "${index + 1}/$total",
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
}

class QuestionAnswerModel {
  String question;
  String imageAsset;
  String answer;
  FlipCardController controller;

  QuestionAnswerModel({this.answer = "", this.question = "", this.imageAsset = "", required this.controller});
}

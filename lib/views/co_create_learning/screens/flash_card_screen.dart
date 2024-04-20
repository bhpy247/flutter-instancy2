import 'package:flutter/material.dart';

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

class _FlashCardScreenState extends State<FlashCardScreen> {
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
    return PageView.builder(
      controller: pageController,
      itemCount: questionList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ),
                Expanded(
                  child: getSingleWidget(
                    model: questionList[index],
                  ),
                ),
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
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getSingleWidget({required QuestionAnswerModel model}) {
    return FlipCard(
      alignment: Alignment.topCenter,
      controller: model.controller,
      flipOnTouch: true,
      front: getCommonFrontAndBackWidget(text: model.question, onTap: () => model.controller.flip()),
      back: getCommonFrontAndBackWidget(text: model.answer, onTap: () => model.controller.flip()),
    );
  }

  Widget getCommonFrontAndBackWidget({String text = "", Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/cocreate/flashCard.png",
              height: 100,
              width: 100,
            ),
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

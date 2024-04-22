import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/quiz_summary_widget.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';

import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';

class QuizScreen extends StatefulWidget {
  static const String routeName = "/QuizScreen";

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with MySafeState {
  late PageController pageController;

  List<QuizModel> quizModelList = [
    QuizModel(
      question: "What is the primary goal of office ergonomics?",
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
      optionList: [
        "A. To increase back pain",
        "B. To encourage slouching",
        "C. To maintain proper posture and support the spine",
        "D. To promote discomfort",
      ],
      correctAnswer: "C. To maintain proper posture and support the spine",
    ),
  ];

  String selectedAnswer = "";
  bool onSaveTap = false;
  bool isSummaryWidget = false;

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
        child: !isSummaryWidget ? getMainBody() : getSummaryWidget(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Office Ergonomics",
    );
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
    bool isForwardNavigationEnabled = model.isAnswerGiven;

    return Container(
      margin: const EdgeInsets.all(10),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "${index + 1}. ${model.question}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          getAnswerList(model.optionList, model),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: ((index - 1) != -1),
                  child: InkWell(
                    onTap: () {
                      if ((index - 1) != -1) {
                        pageController.jumpToPage(index - 1);
                      }
                    },
                    child: const Text("Previous"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!isForwardNavigationEnabled) {
                      MyToast.showError(context: context, msg: "Please submit answer");
                      return;
                    }

                    if (quizModelList.length != index + 1) {
                      pageController.jumpToPage(index + 1);
                    } else {
                      isSummaryWidget = true;
                      mySetState();
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: isForwardNavigationEnabled ? null : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonButton(
                onPressed: model.selectedAnswer.checkNotEmpty
                    ? () {
                        model.isAnswerGiven = true;
                        onSaveTap = true;
                        model.isCorrectAnswerGiven = model.selectedAnswer == model.correctAnswer;
                        mySetState();
                      }
                    : null,
                text: "Submit",
                fontColor: Colors.white,
                backGroundColor: model.selectedAnswer.checkNotEmpty ? null : Colors.grey[400],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
            ],
          ),
          getCorrectAndIncorrectAnswerWidget(model)
        ],
      ),
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

  Widget getAnswerList(List<String> answerList, QuizModel model) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: answerList.length,
      itemBuilder: (BuildContext context, int index) {
        bool isSelected = model.selectedAnswer == answerList[index];

        return InkWell(
          onTap: model.isAnswerGiven
              ? null
              : () {
                  onSaveTap = false;
                  model.selectedAnswer = answerList[index];
                  mySetState();
                },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected ? themeData.primaryColor : const Color(0xffDCDCDC),
              ),
            ),
            child: Text(
              answerList[index],
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? themeData.primaryColor : Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getSummaryWidget() {
    return QuizSummaryWidget(quizModelList: quizModelList);
  }
}

class QuizModel {
  String question = "";
  List<String> optionList = [];
  String correctAnswer = "";
  String selectedAnswer = "";
  bool isAnswerGiven = false, isCorrectAnswerGiven = false;

  QuizModel({
    this.question = "",
    this.correctAnswer = "",
    this.optionList = const [],
    this.isAnswerGiven = false,
    this.isCorrectAnswerGiven = false,
  });
}

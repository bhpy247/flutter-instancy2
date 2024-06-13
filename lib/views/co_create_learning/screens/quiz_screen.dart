import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/quiz_summary_widget.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../utils/my_toast.dart';
import '../../common/components/app_ui_components.dart';

class QuizScreen extends StatefulWidget {
  static const String routeName = "/QuizScreen";

  final QuizScreenNavigationArguments arguments;

  const QuizScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with MySafeState {
  late PageController pageController;

  String title = "";
  List<QuizQuestionModel> quizModelList = [
    QuizQuestionModel(
      question: "What is the primary goal of office ergonomics?",
      choices: [
        "A. Promote proper posture and reduce strain on the body",
        "B. Increase workload for employees",
        "C. Encourage standing desks only",
        "D. Focus on aesthetics over functionality",
      ],
      correct_choice: "A. Promote proper posture and reduce strain on the body",
      correctFeedback:
          "That's right! The main goal is to create a workspace that supports good posture and reduces physical stress. By adjusting the workspace to fit the individual needs of workers, office ergonomics promotes better health and productivity.",
      inCorrectFeedback:
          "Incorrect. Office ergonomics is about optimizing the physical setup of the workspace to reduce strain and prevent injuries, thereby improving employee comfort and performance.",
      isEditModeEnable: [false, false, false, false],
    ),
    QuizQuestionModel(
      question: "What is one of the risks associated with poor ergonomic setup?",
      choices: [
        "A. Musculoskeletal disorders",
        "B. Enhanced productivity",
        "C. Improved posture",
        "D. Reduced fatigue",
      ],
      correct_choice: "A. Musculoskeletal disorders",
      correctFeedback: "Correct! Poor ergonomic setup can lead to various musculoskeletal disorders such as carpal tunnel syndrome, tendonitis, and lower back pain.",
      inCorrectFeedback:
          "Incorrect. Poor ergonomics can indeed increase the risk of injuries, but it's not just due to slips, trips, and falls. The primary risk is from strains and repetitive motion injuries.",
      isEditModeEnable: [false, false, false, false],
    ),
    QuizQuestionModel(
      question: "Why is a good office chair important in office ergonomics?",
      choices: [
        "A. To increase back pain",
        "B. To encourage slouching",
        "C. To maintain proper posture and support the spine",
        "D. To promote discomfort",
      ],
      correct_choice: "C. To maintain proper posture and support the spine",
      correctFeedback:
          "Correct! A good office chair provides adequate lumbar support to maintain the natural curve of the spine. This helps prevent lower back pain and spinal issues that can arise from prolonged sitting.",
      inCorrectFeedback:
          "Incorrect. A good office chair provides adequate lumbar support to maintain the natural curve of the spine. This helps prevent lower back pain and spinal issues that can arise from prolonged sitting.",
      isEditModeEnable: [false, false, false, false],
    ),
  ];

  String selectedAnswer = "";
  bool onSaveTap = false;
  bool isSummaryWidget = false;

  void initializeData() {
    title = widget.arguments.courseDTOModel.ContentName;
    if (title.isEmpty) title = "Office Ergonomics";

    quizModelList = AppConstants().quizModelList;

    QuizContentModel? quizContentModel = widget.arguments.courseDTOModel.quizContentModel;
    if ((quizContentModel?.questions).checkNotEmpty) {
      quizModelList = quizContentModel!.questions;
    }

    for (var value in quizModelList) {
      value.isAnswerGiven = false;
      value.isAnswerSelectedForSubmit = false;
      value.isEditModeEnable = List.generate(value.choices.length, (index) => false);
      value.isQuestionEditable = false;
      value.isCorrectAnswerGiven = false;
      value.selectedAnswer = "";
    }
  }

  void onSubmitTap({required QuizQuestionModel model}) {
    model.isAnswerGiven = true;
    onSaveTap = true;
    model.isCorrectAnswerGiven = model.selectedAnswer == model.correct_choice;
    model.isAnswerSelectedForSubmit = false;
    mySetState();
  }

  Color getTrueFalseColor({required List<String> answerList, required QuizQuestionModel model, int index = 0, bool isText = false}) {
    if (answerList[index] == model.correct_choice) {
      return Colors.green;
    } else if (answerList[index] == model.selectedAnswer) {
      return Colors.red;
    } else {
      return isText ? Colors.black54 : const Color(0xffDCDCDC);
    }
  }

  int getIntForTheText({required List<String> answerList, required QuizQuestionModel model, int index = 0, bool isText = false}) {
    if (answerList[index] == model.correct_choice) {
      return 1;
    } else if (answerList[index] == model.selectedAnswer) {
      return 2;
    } else {
      return 0;
    }
  }

  void onNextPressed(int index) {
    if (quizModelList.length != index + 1) {
      pageController.jumpToPage(index + 1);
    } else {
      isSummaryWidget = true;
      mySetState();
    }
  }

  void onPreviousPressed(int index) {
    if ((index - 1) != -1) {
      pageController.jumpToPage(index - 1);
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
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: !isSummaryWidget ? getMainBody() : getSummaryWidget(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: title,
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
        QuizQuestionModel model = quizModelList[index];
        return getSingleItemWidget(model, index);
      },
    );
  }

  Widget getSingleItemWidget(QuizQuestionModel model, int index) {

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
                    "Question ${index + 1} of ${quizModelList.length}",
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
          getAnswerList(model.choices, model),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Visibility(
          //         visible: ((index - 1) != -1),
          //         child: InkWell(
          //           onTap: () {
          //             if ((index - 1) != -1) {
          //               pageController.jumpToPage(index - 1);
          //             }
          //           },
          //           child: const Text("Previous"),
          //         ),
          //       ),
          //       InkWell(
          //         onTap: () {
          //           if (!isForwardNavigationEnabled) {
          //             MyToast.showError(context: context, msg: "Please submit answer");
          //             return;
          //           }
          //
          //           if (quizModelList.length != index + 1) {
          //             pageController.jumpToPage(index + 1);
          //           } else {
          //             isSummaryWidget = true;
          //             mySetState();
          //           }
          //         },
          //         child: Text(
          //           "Next",
          //           style: TextStyle(
          //             color: isForwardNavigationEnabled ? null : Colors.grey,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (model.isAnswerSelectedForSubmit)
                CommonButton(
                  onPressed: model.isAnswerSelectedForSubmit
                      ? () {
                          onSubmitTap(model: model);
                          // model.isAnswerGiven = true;
                          // onSaveTap = true;
                          // model.isCorrectAnswerGiven = model.selectedAnswer == model.correctAnswer;
                          // mySetState();
                        }
                      : null,
                  text: "Submit",
                  fontColor: Colors.white,
                  backGroundColor: model.selectedAnswer.checkNotEmpty ? null : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
            ],
          ),
          getCorrectAndIncorrectAnswerWidget(model),
          const Spacer(),
          getBottomButton(index, model.isAnswerGiven)
        ],
      ),
    );
  }

  Widget getCorrectAndIncorrectAnswerWidget(
    QuizQuestionModel model,
  ) {
    if (!model.isAnswerGiven) return const SizedBox();
    if (!onSaveTap) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Feedback",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          model.isCorrectAnswerGiven ? Text(model.correctFeedback) : Text(model.inCorrectFeedback)

          // if (model.selectedAnswer != model.correctAnswer)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //     child: Text(
          //       model.inCorrectFeedback.isNotEmpty ? model.inCorrectFeedback : "Incorrect Answer",
          //       style: const TextStyle(fontSize: 14, color: Colors.red),
          //     ),
          //   ),
          // const SizedBox(
          //   height: 6,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: Text(
          //     model.correctFeedback.isNotEmpty ? model.correctFeedback : "Correct Answer",
          //     style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // const SizedBox(
          //   height: 6,
          // ),
          // if (model.selectedAnswer != model.correctAnswer)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //     child: Text(
          //       model.correctAnswer,
          //       style: const TextStyle(fontSize: 14),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget getBottomButton(int index, bool isAnswerGiven) {
    return Row(
      children: [
        if (((index - 1) != -1))
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CommonButton(
                onPressed: () {
                  onPreviousPressed(index);
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
              if (!isAnswerGiven) {
                MyToast.showError(context: context, msg: "Please submit answer");
                return;
              }
              onNextPressed(index);
              mySetState();
            },
            text: quizModelList.length == index + 1 ? "End" : "Next",
            fontColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getAnswerList(List<String> answerList, QuizQuestionModel model) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: answerList.length,
      itemBuilder: (BuildContext context, int index) {

        return InkWell(
          onTap: model.isAnswerGiven
              ? null
              : () {
                  model.isEditModeEnable[index] = true;
                  onSaveTap = false;
                  model.isAnswerSelectedForSubmit = true;
                  model.selectedAnswer = answerList[index];
                  // onSubmitTap(model: model);
                  mySetState();
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: model.isAnswerGiven
                          ? getTrueFalseColor(
                              answerList: answerList,
                              model: model,
                              index: index,
                            )
                          : model.selectedAnswer == answerList[index]
                              ? Colors.green
                              : const Color(0xffDCDCDC)
                      // color: model.selectedAnswer == model.correctAnswer ? Colors.green : const Color(0xffDCDCDC)
                      ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        answerList[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: !model.isAnswerGiven
                              ? model.selectedAnswer == answerList[index]
                                  ? Colors.green
                                  : Colors.black54
                              : getTrueFalseColor(
                                  answerList: answerList,
                                  model: model,
                                  index: index,
                                  isText: true,
                                ),
                        ),
                      ),
                    ),
                    if (model.isAnswerGiven)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: getWriteWrongAnswerWidget(
                              answerList: answerList,
                              model: model,
                              index: index,
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getWriteWrongAnswerWidget({required List<String> answerList, required QuizQuestionModel model, int index = 0, bool isText = false}) {
    if (getIntForTheText(answerList: answerList, model: model, index: index) == 1) {
      return const Row(
        children: [
          Icon(
            FontAwesomeIcons.solidCircleCheck,
            color: Colors.green,
            size: 13,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Correct Answer!",
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    } else if (getIntForTheText(
          answerList: answerList,
          model: model,
          index: index,
        ) ==
        2) {
      return const Row(
        children: [
          Icon(
            FontAwesomeIcons.solidCircleXmark,
            color: Colors.red,
            size: 13,
          ),
          SizedBox(
            width: 5,
          ),
          Text("Your Answer!", style: TextStyle(fontSize: 12))
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getSummaryWidget() {
    return QuizSummaryWidget(quizModelList: quizModelList);
  }
}

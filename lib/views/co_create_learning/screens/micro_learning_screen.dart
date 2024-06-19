import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_page_element_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_controller.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';

class MicroLearningScreen extends StatefulWidget {
  static const String routeName = "/MicroLearningScreen";
  final MicroLearningScreenNavigationArgument arguments;

  const MicroLearningScreen({super.key, required this.arguments});

  @override
  State<MicroLearningScreen> createState() => _MicroLearningScreenState();
}

class _MicroLearningScreenState extends State<MicroLearningScreen> with MySafeState {
  String title = "";
  late AppProvider appProvider;
  int selectedIndex = 0;
  PageController pageViewController = PageController();

  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  bool onSaveTap = false;

  List<String> contentList = [];
  List<MicroLearningPageElementModel> microLearningList = <MicroLearningPageElementModel>[];

  /*List<MicroLearningPageElementModel> microLearningList = <MicroLearningPageElementModel>[
    MicroLearningPageElementModel(
      title: "Technology in Sustainable Urban Planning",
      htmlContentCode:
          "Sustainable urban planning focuses on creating cities and communities that are environmentally friendly, economically viable, and socially equitable. Technology plays a crucial role in this effort by providing tools and solutions that enhance the efficiency and effectiveness of urban development. Key technological advancements include smart grids, green buildings, intelligent transportation systems, and data analytics for urban management.",
      elementType: MicroLearningElementType.Text,
      imageUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FtemoImageForMicrolearning.png?alt=media&token=02104ae0-a27b-4b99-9a28-cfff84ddffd9",
    ),
    MicroLearningPageElementModel(
      quizQuestionModel: QuizQuestionModel(
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
      title: "",
      elementType: MicroLearningElementType.Quiz,
    ),
    MicroLearningPageElementModel(
      title: "Conclusion",
      htmlContentCode:
          "Technology is integral to achieving sustainable urban planning goals. By leveraging advancements such as smart grids, green buildings, intelligent transportation systems, and data analytics, cities can create more sustainable, livable, and resilient environments for their inhabitants.",
      elementType: MicroLearningElementType.Image,
      imageUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fconclusionimg.png?alt=media&token=0398ab8e-390e-4f38-a65b-d861cae4d701",
    ),
  ];*/

  void initializeData() {
    appProvider = context.read<AppProvider>();
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    title = widget.arguments.model.ContentName;
    if (title.isEmpty) title = "Technology in sustainable urban planning";
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

  void onSubmitTap({required QuizQuestionModel model}) {
    model.isAnswerGiven = true;
    onSaveTap = true;
    model.isCorrectAnswerGiven = model.selectedAnswer == model.correct_choice;
    model.isAnswerSelectedForSubmit = false;
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: getAppBar(),
      bottomNavigationBar: getBottomButtons(),
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
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 10),
          child: Row(
            children: List.generate(
              microLearningList.length,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == selectedIndex ? themeData.primaryColor : Styles.textFieldBorderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: getContentPageView(),
        )
      ],
    );
  }

  Widget getContentPageView() {
    return PageView.builder(
      controller: pageViewController,
      onPageChanged: (int index) {
        selectedIndex = index;
        mySetState();
      },
      itemCount: microLearningList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: getContentWidget(model: microLearningList[index]),
        );
      },
    );
  }

  Widget getContentWidget({required MicroLearningPageElementModel model}) {
    Widget? child;
    if (model.elementType == MicroLearningElementType.Text) {
      child = getTypeTextWidget(model: model);
    } else if (model.elementType == MicroLearningElementType.Quiz) {
      child = getQuestionWidget(model: model.quizQuestionModels.firstElement ?? QuizQuestionModel(), index: 0);
    } else if (model.elementType == MicroLearningElementType.Image) {
      child = getTypeImageWidget(model: model);
    }
    return child ?? const SizedBox();
  }

  Widget getTypeTextWidget({required MicroLearningPageElementModel model}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          /*Text(
            model.title,
            style: TextStyle(
              color: themeData.primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),*/
          getTextWidget(text: model.htmlContentCode),
          const SizedBox(
            height: 20,
          ),
          getImageWidget(url: model.imageUrl),
        ],
      ),
    );
  }

  Widget getTypeImageWidget({required MicroLearningPageElementModel model}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          /*Text(
            model.title,
            style: TextStyle(
              color: themeData.primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),*/
          getImageWidget(url: model.imageUrl),
          const SizedBox(
            height: 20,
          ),
          getTextWidget(text: model.htmlContentCode, textAlign: TextAlign.center),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getTextWidget({required String text, TextAlign textAlign = TextAlign.start}) {
    return Text(
      text,
      textAlign: textAlign,
    );
  }

  Widget getImageWidget({required String url}) {
    if (url.checkEmpty) return const SizedBox();
    return CommonCachedNetworkImage(
      imageUrl: url,
      // imageUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FtemoImageForMicrolearning.png?alt=media&token=02104ae0-a27b-4b99-9a28-cfff84ddffd9",
    );
  }

  Widget getBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        children: [
          if (selectedIndex != 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CommonButton(
                  onPressed: () {
                    if (selectedIndex != 0) {
                      pageViewController.jumpToPage(selectedIndex - 1);
                    }
                  },
                  text: "Previous",
                  fontColor: themeData.colorScheme.onPrimary,
                ),
              ),
            ),
          Expanded(
            child: CommonButton(
              onPressed: () {
                if ((selectedIndex + 1) != (microLearningList.length)) {
                  pageViewController.jumpToPage(selectedIndex + 1);
                } else {
                  Navigator.pop(context);
                }
              },
              text: (selectedIndex + 1) == (microLearningList.length) ? "End" : "Next",
              fontColor: themeData.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget getQuestionWidget({required QuizQuestionModel model, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            model.question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
        // getBottomButton(index, model.isAnswerGiven)
      ],
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

// Widget getMainBody() {
//   String htmlCode = contentList.firstElement ?? "";
//
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     decoration: BoxDecoration(
//       border: Border.all(width: 1, color: Colors.grey.shade400),
//       borderRadius: BorderRadius.circular(5),
//     ),
//     child: htmlCode.isNotEmpty ? getWebviewWidget(htmlCode: htmlCode) : getDummyArticleWidget(),
//   );
// }

// Widget getWebviewWidget({required String htmlCode}) {
//   return InAppWebView(
//     initialData: InAppWebViewInitialData(
//       data: htmlCode,
//     ),
//     onWebViewCreated: (InAppWebViewController webViewController) {
//       MyPrint.printOnConsole("onWebViewCreated called with webViewController:$webViewController");
//
//       // this.webViewController = webViewController;
//     },
//     onLoadStart: (InAppWebViewController webViewController, WebUri? webUri) {
//       MyPrint.printOnConsole("onLoadStart called with webViewController:$webViewController, webUri:$webUri");
//       // this.webViewController = webViewController;
//     },
//     onProgressChanged: (InAppWebViewController webViewController, int progress) {
//       MyPrint.printOnConsole("onProgressChanged called with webViewController:$webViewController, progress:$progress");
//       // this.webViewController = webViewController;
//
//       /*if(!isPageLoaded && progress == 100) {
//             isPageLoaded = true;
//             setState(() {});
//           }*/
//     },
//     onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
//       MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
//       // this.webViewController = webViewController;
//     },
//   );
// }
//
// Widget getDummyArticleWidget() {
//   return const SizedBox();
// }
}

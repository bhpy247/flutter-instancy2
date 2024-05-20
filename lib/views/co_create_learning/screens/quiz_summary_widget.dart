import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';

class QuizSummaryWidget extends StatefulWidget {
  final List<QuizQuestionModel> quizModelList;

  const QuizSummaryWidget({super.key, required this.quizModelList});

  @override
  State<QuizSummaryWidget> createState() => _QuizSummaryWidgetState();
}

class _QuizSummaryWidgetState extends State<QuizSummaryWidget> {
  int correctAnswer = 0;
  int inCorrectAnswer = 0;
  Color borderColor = const Color(0xffDCDCDC);

  @override
  void initState() {
    super.initState();
    correctAnswer = widget.quizModelList.where((element) => element.isCorrectAnswerGiven).toList().length;
    inCorrectAnswer = widget.quizModelList.where((element) => !element.isCorrectAnswerGiven).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    return getMainSummaryWidget();
  }

  Widget getMainSummaryWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  "Summary",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // Icon(Icons.more_vert)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          getQuestionCountAndSummary(),
          const SizedBox(
            height: 20,
          ),
          getQuestionAnswerList()
        ],
      ),
    );
  }

  Widget getQuestionCountAndSummary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: getColumn(title: "${widget.quizModelList.length}", subTitle: 'Total Question')),
            VerticalDivider(
              color: borderColor,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getColumn(
                      title: "$correctAnswer",
                      subTitle: 'Correct',
                      titleFontSize: 17,
                      subTitleFontSize: 13,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getColumn(
                      title: "$inCorrectAnswer",
                      subTitle: 'Incorrect',
                      titleFontSize: 17,
                      subTitleFontSize: 13,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getColumn({
    required String title,
    required String subTitle,
    double titleFontSize = 36,
    double subTitleFontSize = 16,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
        Text(
          subTitle,
          style: TextStyle(fontSize: subTitleFontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget getQuestionAnswerList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: widget.quizModelList.length,
        itemBuilder: (BuildContext context, int index) {
          return getSingleQuestionItem(widget.quizModelList[index], index);
        },
      ),
    );
  }

  Widget getSingleQuestionItem(QuizQuestionModel model, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ",
            style: const TextStyle(fontSize: 15),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.question,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model.selectedAnswer,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Text(model.question),
                Text(
                  model.isCorrectAnswerGiven
                      ? (model.correctFeedback.isNotEmpty ? model.correctFeedback : "Correct Answer")
                      : model.inCorrectFeedback.isNotEmpty
                          ? model.inCorrectFeedback
                          : "Incorrect Answer",
                  style: TextStyle(color: model.isCorrectAnswerGiven ? Colors.green : Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

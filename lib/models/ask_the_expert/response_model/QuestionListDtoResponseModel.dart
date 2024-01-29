import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';

class QuestionListDtoResponseModel {
  List<UserQuestionListDto> questionList = [];
  int rowcount = 0;

  QuestionListDtoResponseModel({this.questionList = const [], this.rowcount = 0});

  QuestionListDtoResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['QuestionList'] != null) {
      questionList = <UserQuestionListDto>[];
      json['QuestionList'].forEach((v) {
        questionList.add(UserQuestionListDto.fromJson(v));
      });
    }
    rowcount = json['rowcount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QuestionList'] = questionList.map((v) => v.toJson()).toList();
    data['rowcount'] = rowcount;
    return data;
  }
}

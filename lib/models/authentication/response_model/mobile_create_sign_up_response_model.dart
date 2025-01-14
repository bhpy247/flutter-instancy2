import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../data_model/user_sign_up_details_model.dart';

class MobileCreateSignUpResponseModel {
  List<UserSignUpDetailsModel> userSignUpDetails = [];

  MobileCreateSignUpResponseModel({
    required this.userSignUpDetails,
  });

  MobileCreateSignUpResponseModel.fromJson(Map<String, dynamic> json) {
    userSignUpDetails = ParsingHelper.parseMapsListMethod<String, dynamic>((json["usersignupdetails"])).map((x) => UserSignUpDetailsModel.fromMap(x)).toList();
  }

  Map<String, dynamic> toJson({bool toJson = true}) {
    return {
      "usersignupdetails": userSignUpDetails.map((x) => x.toMap(toJson: toJson)).toList(),
    };
  }
}


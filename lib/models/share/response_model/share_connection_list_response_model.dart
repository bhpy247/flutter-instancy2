import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../utils/parsing_helper.dart';
import '../data_model/share_connection_user_model.dart';

class ShareConnectionListResponseModel {
  List<ShareConnectionUserModel> connectionsList = [];

  ShareConnectionListResponseModel({
    this.connectionsList = const [],
  });

  ShareConnectionListResponseModel.fromJson(Map<String, dynamic> json) {
    connectionsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]).map((x) => ShareConnectionUserModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
    "Table": connectionsList.map((x) => x.toJson()).toList()};
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

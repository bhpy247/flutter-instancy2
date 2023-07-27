import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AddToWishlistRequestModel {
  String addedDate = "";
  String componentID = "";
  int componentInstanceID = 0;
  String contentID = "";
  String userID = "";

  AddToWishlistRequestModel(
      {this.addedDate = "",
        this.componentID = "",
        this.componentInstanceID = 0,
        this.contentID = "",
        this.userID = ""});

  AddToWishlistRequestModel.fromMap(Map<String, dynamic> json) {
    addedDate = ParsingHelper.parseStringMethod(json['AddedDate']);
    componentID = ParsingHelper.parseStringMethod(json['ComponentID']);
    componentInstanceID = ParsingHelper.parseIntMethod(json['ComponentInstanceID']);
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    userID = ParsingHelper.parseStringMethod(json['UserID']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AddedDate'] = addedDate;
    data['ComponentID'] = componentID;
    data['ComponentInstanceID'] = componentInstanceID;
    data['ContentID'] = contentID;
    data['UserID'] = userID;
    return data;
  }
}

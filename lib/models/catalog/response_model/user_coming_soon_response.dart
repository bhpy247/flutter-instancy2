import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserComingSoonResponse {
  List<ComingSoonResponseTable> table = [];

  UserComingSoonResponse({this.table = const []});

  UserComingSoonResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <ComingSoonResponseTable>[];
      json['Table'].forEach((v) {
        table.add(ComingSoonResponseTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = table.map((v) => v.toJson()).toList();
    return data;
  }
}

class ComingSoonResponseTable {
  int userID = 0;
  String contentID = "";
  String comingSoonResponse = "";
  String createdDateTime = "";

  ComingSoonResponseTable({this.userID = 0, this.contentID = "", this.comingSoonResponse = "", this.createdDateTime = ""});

  ComingSoonResponseTable.fromJson(Map<String, dynamic> json) {
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    comingSoonResponse = ParsingHelper.parseStringMethod(json['ComingSoonResponse']);
    createdDateTime = ParsingHelper.parseStringMethod(json['CreatedDateTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['ContentID'] = contentID;
    data['ComingSoonResponse'] = comingSoonResponse;
    data['CreatedDateTime'] = createdDateTime;
    return data;
  }
}

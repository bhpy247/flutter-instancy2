import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AddQuestionResponseModel {
  List<Table>? table;

  AddQuestionResponseModel({this.table});

  AddQuestionResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <Table>[];
      json['Table'].forEach((v) {
        table!.add(Table.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (table != null) {
      data['Table'] = table!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  int column1 = 0;
  String notifyMessage = "";

  Table({this.column1 = 0, this.notifyMessage = ""});

  Table.fromJson(Map<String, dynamic> json) {
    column1 = ParsingHelper.parseIntMethod(json['Column1']);
    notifyMessage = ParsingHelper.parseStringMethod(json['NotifyMessage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Column1'] = column1;
    data['NotifyMessage'] = notifyMessage;
    return data;
  }
}

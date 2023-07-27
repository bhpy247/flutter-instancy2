import '../../../utils/parsing_helper.dart';

class StaticWebPageModel {
  String webpageHTML = "";
  String folderPth = "";
  String notifyMessage = "";

  StaticWebPageModel({this.webpageHTML = "", this.folderPth = "", this.notifyMessage = ""});

  StaticWebPageModel.fromJson(Map<String, dynamic> json) {
    webpageHTML = ParsingHelper.parseStringMethod(json['webpageHTML'] ?? "");
    folderPth = ParsingHelper.parseStringMethod(json['folderPth'] ?? "");
    notifyMessage = ParsingHelper.parseStringMethod(json['notifyMessage'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['webpageHTML'] = webpageHTML;
    data['folderPth'] = folderPth;
    data['notifyMessage'] = notifyMessage;
    return data;
  }
}

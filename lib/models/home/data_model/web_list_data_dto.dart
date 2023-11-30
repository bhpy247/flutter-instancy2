import '../response_model/banner_web_list_model.dart';

class WebListDataDTO {
  List<WebListDTO>? webList;

  WebListDataDTO({this.webList});

  WebListDataDTO.fromJson(Map<String, dynamic> json) {
    if (json['WebList'] != null) {
      webList = <WebListDTO>[];
      json['WebList'].forEach((v) {
        webList!.add(WebListDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (webList != null) {
      data['WebList'] = webList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

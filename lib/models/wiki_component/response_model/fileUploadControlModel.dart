import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class FileUploadControlsModel {
  int objectTypeID = 0, mediaTypeID = 0;
  String mediaTypeIdisplayName = "", displayIcon = "";
  bool status = false;

  FileUploadControlsModel(
      {this.objectTypeID = 0,
        this.mediaTypeID = 0,
        this.mediaTypeIdisplayName = "",
        this.displayIcon = "",
        this.status = false});

  FileUploadControlsModel.fromMap(Map<String, dynamic> json) {
    objectTypeID = ParsingHelper.parseIntMethod(json['ObjectTypeID']);
    mediaTypeID = ParsingHelper.parseIntMethod(json['MediaTypeID']);
    mediaTypeIdisplayName = ParsingHelper.parseStringMethod(json['MediaTypeIdisplayName']);
    displayIcon = ParsingHelper.parseStringMethod(json['DisplayIcon']);
    status = ParsingHelper.parseBoolMethod(json['Status']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ObjectTypeID'] = objectTypeID;
    data['MediaTypeID'] = mediaTypeID;
    data['MediaTypeIdisplayName'] = mediaTypeIdisplayName;
    data['DisplayIcon'] = displayIcon;
    data['Status'] = status;
    return data;
  }
}

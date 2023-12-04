import '../../../utils/parsing_helper.dart';

class StatusCountDTO {
  String status = "";
  int ContentCount = 0;

  StatusCountDTO({
    this.status = "",
    this.ContentCount = 0,
  });

  StatusCountDTO.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    status = ParsingHelper.parseStringMethod(json["status"]);
    ContentCount = ParsingHelper.parseIntMethod(json["ContentCount"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "ContentCount": ContentCount,
    };
  }
}

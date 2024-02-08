import 'package:flutter_instancy_2/utils/my_utils.dart';

class CourseOfflineLaunchRequestModel {
  int UserId = 0;
  int SiteId = 0;
  int ScoId = 0;
  int ContentTypeId = 0;
  int MediaTypeId = 0;
  int ParentContentTypeId = 0;
  int ParentContentScoId = 0;
  String ContentId = "";
  String ParentContentId = "";
  String UserName = "";

  CourseOfflineLaunchRequestModel({
    this.UserId = 0,
    this.SiteId = 0,
    this.ScoId = 0,
    this.ContentTypeId = 0,
    this.MediaTypeId = 0,
    this.ParentContentTypeId = 0,
    this.ParentContentScoId = 0,
    this.ContentId = "",
    this.ParentContentId = "",
    this.UserName = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "UserId": UserId,
      "SiteId": SiteId,
      "ScoId": ScoId,
      "ContentTypeId": ContentTypeId,
      "MediaTypeId": MediaTypeId,
      "ParentContentTypeId": ParentContentTypeId,
      "ParentContentScoId": ParentContentScoId,
      "ContentId": ContentId,
      "ParentContentId": ParentContentId,
      "UserName": UserName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

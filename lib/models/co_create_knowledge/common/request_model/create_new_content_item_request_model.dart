import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_formdata_model.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class CreateNewContentItemRequestModel {
  String topic = "";
  String size = "";
  String Language = AppConstants.defaultLocale;
  String kbId = "";
  String authorName = "";
  String JWVideoDetails = "";
  String JWfileName = "";
  String fileName = "";
  String additionalData = "";
  String FolderID = "";
  String CMSGroupID = "";
  int ObjectTypeID = 0;
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int MediaTypeID = 0;
  CreateNewContentItemFormDataModel formData = CreateNewContentItemFormDataModel();
  List<InstancyMultipartFileUploadModel>? Files;

  CreateNewContentItemRequestModel({
    this.topic = "",
    this.size = "",
    this.Language = AppConstants.defaultLocale,
    this.kbId = "",
    this.authorName = "",
    this.JWVideoDetails = "",
    this.JWfileName = "",
    this.fileName = "",
    this.additionalData = "",
    this.FolderID = "",
    this.CMSGroupID = "",
    this.ObjectTypeID = 0,
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.MediaTypeID = 0,
    required this.formData,
    this.Files,
  });

  Map<String, String> toMap() {
    return {
      "formData": MyUtils.encodeJson(formData.toMap()),
      "ObjectTypeID": ObjectTypeID.toString(),
      "FolderID": FolderID,
      "SiteID": SiteID.toString(),
      "MediaTypeID": MediaTypeID.toString(),
      "CMSGroupID": CMSGroupID,
      "Language": Language,
      "kbId": kbId,
      "authorName": authorName,
      "JWVideoDetails": JWVideoDetails,
      "JWfileName": JWfileName,
      "fileName": fileName,
      "additionalData": additionalData,
      "UserID": UserID.toString(),
      "topic": topic,
      "size": size,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

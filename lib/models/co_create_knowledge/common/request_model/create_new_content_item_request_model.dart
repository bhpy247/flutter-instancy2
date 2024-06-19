import 'dart:typed_data';

import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_formdata_model.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class CreateNewContentItemRequestModel {
  String ContentID = "";
  String FolderPath = "";
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
  String ActionType = CreateNewContentItemActionType.create;
  String ThumbnailImageName = "";
  String CategoryType = "";
  int ObjectTypeID = 0;
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int MediaTypeID = 0;
  bool isContentShared = false;
  CreateNewContentItemFormDataModel formData = CreateNewContentItemFormDataModel();
  Uint8List? ThumbnailImage;
  List<String> Categories = <String>[];
  List<String> UnAssignCategories = <String>[];
  List<InstancyMultipartFileUploadModel>? Files;

  CreateNewContentItemRequestModel({
    this.ContentID = "",
    this.FolderPath = "",
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
    this.ActionType = CreateNewContentItemActionType.create,
    this.ThumbnailImageName = "",
    this.CategoryType = "",
    this.ObjectTypeID = 0,
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.MediaTypeID = 0,
    this.isContentShared = false,
    required this.formData,
    this.ThumbnailImage,
    List<String>? Categories,
    List<String>? UnAssignCategories,
    this.Files,
  }) {
    this.Categories = Categories ?? <String>[];
    this.UnAssignCategories = UnAssignCategories ?? <String>[];
  }

  Map<String, String> toMap() {
    return {
      "ContentID": ContentID,
      "topic": topic,
      "size": size,
      "Language": Language,
      "kbId": kbId,
      "authorName": authorName,
      "JWVideoDetails": JWVideoDetails,
      "JWfileName": JWfileName,
      "fileName": fileName,
      "additionalData": additionalData,
      "FolderID": FolderID,
      "CMSGroupID": CMSGroupID,
      "ActionType": ActionType,
      "ThumbnailImageName": ThumbnailImageName,
      "CategoryType": CategoryType,
      "ObjectTypeID": ObjectTypeID.toString(),
      "UserID": UserID.toString(),
      "SiteID": SiteID.toString(),
      "MediaTypeID": MediaTypeID.toString(),
      "isContentShared": isContentShared.toString(),
      "formData": MyUtils.encodeJson(formData.toMap()),
      "ThumbnailImage": ThumbnailImage == null
          ? ""
          : MyUtils.convertBytesToBase64(
              bytes: ThumbnailImage!,
              fileName: ThumbnailImageName,
              defaultMimeType: "image/jpeg",
            ),
      "Categories": AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: Categories),
      "UnAssignCategories": AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: UnAssignCategories),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

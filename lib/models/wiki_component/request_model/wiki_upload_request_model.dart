import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';

class WikiUploadRequestModel {
  bool isUrl;
  List<InstancyMultipartFileUploadModel>? fileUploads;
  String url, title, shortDesc, keywords, eventCategoryID, locale;
  int mediaTypeID, objectTypeID, userID, siteID, componentID, cMSGroupId;
  List<String> categories;

  WikiUploadRequestModel({
    this.isUrl = false,
    this.fileUploads,
    this.url = "",
    this.title = "",
    this.shortDesc = "",
    this.keywords = "",
    this.eventCategoryID = "",
    this.locale = "",
    this.mediaTypeID = 0,
    this.objectTypeID = 0,
    this.userID = 0,
    this.siteID = 0,
    this.componentID = 0,
    this.cMSGroupId = 0,
    this.categories = const [],
  });

  Map<String, String> toMap() {
    Map<String, String> map = <String, String>{
      "MediaTypeID": mediaTypeID.toString(),
      "ObjectTypeID": objectTypeID.toString(),
      "Title": title,
      "ShortDesc": shortDesc,
      "UserID": userID.toString(),
      "SiteID": siteID.toString(),
      "ComponentID": componentID.toString(),
      "LocaleID": locale,
      "CMSGroupId": cMSGroupId.toString(),
      "Keywords": keywords,
      "OrgUnitID": siteID.toString(),
      "EventContentid": eventCategoryID,
      "EventCategoryID" : eventCategoryID,
      "CategoryIds": AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: categories, separator: ","),
      'locale': locale,
    };

    if(isUrl) {
      map['WebSiteURL'] = url;
    }

    return map;
  }
}
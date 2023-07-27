import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class MyLearningDataRequestModel {
  int pageIndex = 0, pageSize = 0, source = 0, type = 0, isArchived = 0, isWaitList = 0, isWishListContent = 0, componentId = 0, componentInsId = 0,
      userId = -1, siteId = AppConstants.defaultSiteId, orgUnitId = AppConstants.defaultSiteId;
  String searchText = "", sortBy = "", hideComplete = "", locale = "", groupBy = "", categories = "", objectTypes = "", skillCats = "", skills = "",
      jobRoles = "", solutions = "", ratings = "", keywords = "", priceRange = "", duration = "", instructors = "", filterCredits = "",
      multiLocation = "", contentID = "", contentStatus = '', Datefilter = "";

  MyLearningDataRequestModel({
    this.pageIndex = 0,
    this.pageSize = 0,
    this.source = 0,
    this.type = 0,
    this.isArchived = 0,
    this.isWaitList = 0,
    this.isWishListContent = 0,
    this.componentId = 0,
    this.componentInsId = 0,
    this.userId = -1,
    this.siteId = AppConstants.defaultSiteId,
    this.orgUnitId = AppConstants.defaultSiteId,
    this.searchText = "",
    this.sortBy = "",
    this.hideComplete = "",
    this.locale = "",
    this.groupBy = "",
    this.categories = "",
    this.objectTypes = "",
    this.skillCats = "",
    this.skills = "",
    this.jobRoles = "",
    this.solutions = "",
    this.ratings = "",
    this.keywords = "",
    this.priceRange = "",
    this.duration = "",
    this.instructors = "",
    this.filterCredits = "",
    this.multiLocation = "",
    this.contentID = "",
    this.contentStatus = "",
    this.Datefilter = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "pageIndex": pageIndex,
      "pageSize": pageSize,
      "source": source,
      "type": type,
      "IsArchived": isArchived,
      "IsWaitlist": isWaitList,
      "iswishlistcontent": isWishListContent,
      "ComponentID": componentId,
      "ComponentInsID": componentInsId,
      "UserID": userId,
      "SiteID": siteId,
      "OrgUnitID": orgUnitId,
      "SearchText": searchText,
      "sortBy": sortBy,
      "HideComplete": hideComplete,
      "Locale": locale,
      "groupBy": groupBy,
      "categories": categories,
      "objecttypes": objectTypes,
      "skillcats": skillCats,
      "skills": skills,
      "jobroles": jobRoles,
      "solutions": solutions,
      "ratings": ratings,
      "keywords": keywords,
      "pricerange": priceRange,
      "duration": duration,
      "instructors": instructors,
      "filtercredits": filterCredits,
      "multiLocation": multiLocation,
      "ContentID": contentID,
      "ContentStatus": contentStatus,
      "Datefilter": Datefilter,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
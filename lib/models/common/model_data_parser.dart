import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/forgot_password_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/signup_field_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/associated_content_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/catalog_dto_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/user_coming_soon_response.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/home/response_model/categorywise_course_dto_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/page_notes_response_model.dart';
import 'package:flutter_instancy_2/models/waitlist/response_model/add_to_waitList_response_model.dart';
import 'package:flutter_instancy_2/models/wiki_component/response_model/fileUploadControlModel.dart';
import 'package:flutter_instancy_2/models/wiki_component/response_model/wikiCategoriesModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../app_configuration_models/data_models/local_str.dart';
import '../app_configuration_models/data_models/tincan_data_model.dart';
import '../app_configuration_models/response_model/mobile_api_auth_response_model.dart';
import '../app_configuration_models/response_model/mobile_get_learning_portal_info_response_model.dart';
import '../authentication/data_model/successful_user_login_model.dart';
import '../authentication/response_model/country_response_model.dart';
import '../authentication/response_model/email_login_response_model.dart';
import '../authentication/response_model/sign_up_response_model.dart';
import '../catalog/catalogCategoriesForBrowseModel.dart';
import '../catalog/response_model/add_associated_content_to_mylearning_response_model.dart';
import '../catalog/response_model/prerequisiteDetailsResponseModel.dart';
import '../catalog/response_model/removeFromWishlistModel.dart';
import '../content_details/data_model/content_details_dto_model.dart';
import '../content_details/response_model/course_details_schedule_data_response_model.dart';
import '../content_review_ratings/response_model/content_user_ratings_data_response_model.dart';
import '../course/data_model/gloassary_model.dart';
import '../course_launch/response_model/content_status_response_model.dart';
import '../discussion/response_model/forum_listing_dto_response_model.dart';
import '../dto/response_dto_model.dart';
import '../event/response_model/event_session_data_response_model.dart';
import '../event_track/data_model/event_track_header_dto_model.dart';
import '../event_track/data_model/event_track_tab_dto_model.dart';
import '../event_track/response_model/event_related_content_data_response_model.dart';
import '../event_track/response_model/event_track_resourse_response_model.dart';
import '../event_track/response_model/track_content_data_response_model.dart';
import '../filter/data_model/content_filter_category_tree_model.dart';
import '../filter/response_model/component_sort_options_response_model.dart';
import '../filter/response_model/filter_duration_values_response_model.dart';
import '../filter/response_model/instructor_list_filter_response_model.dart';
import '../filter/response_model/learning_provider_filter_response_model.dart';
import '../home/data_model/new_course_list_dto.dart';
import '../home/response_model/banner_web_list_model.dart';
import '../home/response_model/static_web_page_podel.dart';
import '../my_connections/response_model/people_listing_dto_response_model.dart';
import '../my_learning/data_model/my_learning_content_model.dart';
import '../my_learning/response_model/my_learning_response_dto_model.dart';
import '../profile/data_model/user_profile_header_dto_model.dart';
import '../profile/response_model/education_title_response_model.dart';
import '../profile/response_model/profile_response_model.dart';
import '../progress_report/data_model/content_progress_summary_data_model.dart.dart';
import '../progress_report/response_model/content_progress_detail_data_response.dart';
import '../share/response_model/share_connection_list_response_model.dart';

typedef ModelDataParsingCallbackTypeDef<T> = T? Function({required dynamic decodedValue});

enum ModelDataParsingType {
  dynamic,
  string,
  bool,

  //region Splash Module
  mobileGetLearningPortalInfoResponseModel,
  mobileApiAuthResponseModel,
  localStr,
  tinCanDataModel,
  nativeMenuModelsList,
  nativeMenusComponentModelsList,
  //endregion

  //region Authentication Module
  emailLoginResponseModel,
  successfulUserLoginModel,
  signupResponseModel,
  //endregion

  //region Home Menu
  newLearningResourcesResponseModel,
  listCourseDTOModel,
  listWebListModel,
  staticWebPageModel,
  //endregion


  //region forgotPassword
  forgotPasswordResponseModel,
  //endregion

  //region signUpFieldResponseModel
  signupFieldResponseModel,
  //endregion

  //region Profile Menu
  profileResponseModel,
  countryResponseModel,
  educationTitleResponseModel,
  userProfileHeaderDTOModel,
  //endregion

  //region My Learning Menu
  myLearningContentModel,
  myLearningContentDataResponseModel,
  contentUserRatingsDataResponseModel,
  myLearningResponseDTOModel,
  pageNoteResponseModel,
  //endregion

  //region Wiki Component
  fileUploadControlModel,
  wikiCategoriesModel,
  //endregion

  //region CatalogCategoriesForBrowseModel
  catalogCategoriesForBrowseModel,
  //endregion

  //region CatalogContentFromCategories
  catalogResponseDTOModel,
  //endregion

  //region Filter
  contentFilterCategoryTreeModelList,
  LearningProviderFilterResponseModel,
  InstructorListFilterResponseModel,
  FilterDurationValuesResponseModel,
  ComponentSortResponseModel,
  //endregion

  //region wishList
  removeFromWishlist,
  //endregion

  // region Share Module
  shareConnectionListResponseModel,
  //endregion

  // region Progress Report Module
  progressDetailDataResponseModel,
  contentProgressSummaryDataModelList,
  //endregion

  //region PreRequisite
  prerequisiteResponseModel,
  associatedContent,
  //endregion

  // region Event
  eventSessionDataResponseModel,
  //endregion

  // region Content Details Module
  contentDetailsDTOModel,
  courseDetailsScheduleDataResponseModel,
  //endregion

  responseDTOModel,

  //region Course Launch
  ContentStatusResponseModel,
  //endregion

  //region Catalog Module
  addAssociatedContentToMyLearningResponseModel,
  //endregion

  //region Event Track
  eventTrackHeaderDTOModel,
  eventTrackTabDTOModelList,
  eventTrackDTOModelList,
  glossaryModelList,
  eventTrackResourceResponseModel,
  trackContentDataResponseModel,
  eventRelatedContentDataResponseModel,
  //endregion

  // region Discussion
  forumListingDTOResponseModel,
  //endregion

  // region MyConnection
  peopleListingDTOResponseModel,
  //endregion

  //region UserComingSoon
  userComingSoonResponseModel,
  //endregion

  //region waitList
  addToWaitListResponseModel,
  //endregion

  //region Instabot
  botDetailsModel
  //endregion
}

class ModelDataParser {
  static Map<ModelDataParsingType, ModelDataParsingCallbackTypeDef> callsMap = <ModelDataParsingType, ModelDataParsingCallbackTypeDef>{
    ModelDataParsingType.dynamic : parseDynamic,
    ModelDataParsingType.string : parseString,
    ModelDataParsingType.bool : parseBool,

    //region Splash Module
    ModelDataParsingType.mobileGetLearningPortalInfoResponseModel : parseLearningPortalInfo,
    ModelDataParsingType.mobileApiAuthResponseModel : parseMobileApiAuthResponseModel,
    ModelDataParsingType.localStr : parseLocalStr,
    ModelDataParsingType.tinCanDataModel : parseTinCanDataModel,
    ModelDataParsingType.nativeMenuModelsList : parseNativeMenuModelsList,
    ModelDataParsingType.nativeMenusComponentModelsList : parseNativeMenuComponentModelsList,
    //endregion

    //region Authentication Module
    ModelDataParsingType.emailLoginResponseModel : parseEmailLoginResponseModel,
    ModelDataParsingType.successfulUserLoginModel : parseSuccessfulUserLoginModel,
    ModelDataParsingType.signupResponseModel : parseSignupResponseModel,
    //endregion

    //region Home Menu
    ModelDataParsingType.newLearningResourcesResponseModel : parseNewLearningResourcesResponseModel,
    ModelDataParsingType.listCourseDTOModel : parseCourseDTOList,
    ModelDataParsingType.listWebListModel : parseWebListList,
    ModelDataParsingType.staticWebPageModel : parseStaticWebPageModel,
    //endregion


    //region signUpFieldResponseModel
    ModelDataParsingType.signupFieldResponseModel:parseSignupFieldResponseModel,
    //endregion

    //region forgotPassword
    ModelDataParsingType.forgotPasswordResponseModel : parseForgotPasswordResponseModel,
    //endregion

    //region Profile Menu
    ModelDataParsingType.profileResponseModel : parseProfileResponseModel,
    ModelDataParsingType.countryResponseModel : parseCountryResponseModel,
    ModelDataParsingType.educationTitleResponseModel : parseEducationTitleResponseModel,
    ModelDataParsingType.userProfileHeaderDTOModel : parseUserProfileHeaderDTOModel,
    //endregion

    //region My Learning Menu
    ModelDataParsingType.myLearningContentModel : parseMyLearningContentModel,
    ModelDataParsingType.contentUserRatingsDataResponseModel : parseContentUserRatingsDataResponseModel,
    ModelDataParsingType.myLearningResponseDTOModel : parseMyLearningResponseDTOModel,
    ModelDataParsingType.pageNoteResponseModel : parsePageNoteResponseModel,
    //endregion

    //region Wiki Component
    ModelDataParsingType.fileUploadControlModel : parseListFileUploadControlsModel,
    ModelDataParsingType.wikiCategoriesModel : parseWikiCategoriesModel,
    //endregion

    //region catalogCategoriesForBrowseModel
    ModelDataParsingType.catalogCategoriesForBrowseModel : parseListCatalogCategoriesForBrowseModel,
    //endregion

    //region CatalogContentFromCategoriesModel
    ModelDataParsingType.catalogResponseDTOModel : parseCatalogResponseDTOModel,
    //endregion

    //region Filter
    ModelDataParsingType.contentFilterCategoryTreeModelList: parseContentFilterCategoryTreeModelList,
    ModelDataParsingType.LearningProviderFilterResponseModel: parseLearningProviderFilterResponseModel,
    ModelDataParsingType.InstructorListFilterResponseModel: parseInstructorListFilterResponseModel,
    ModelDataParsingType.FilterDurationValuesResponseModel: parseFilterDurationValuesResponseModel,
    ModelDataParsingType.ComponentSortResponseModel: parseComponentSortResponseModel,
    //endregion

    //region
    ModelDataParsingType.removeFromWishlist : parseRemoveFromWishlistResponseModel,
    //endregion


    // region Share Module
    ModelDataParsingType.shareConnectionListResponseModel: parseShareConnectionListResponseModel,
    //endregion

    // region Progress Report Module
    ModelDataParsingType.progressDetailDataResponseModel: parseProgressDetailDataResponseModel,
    ModelDataParsingType.contentProgressSummaryDataModelList: parseContentProgressSummaryDataModelList,
    //endregion

    //region prerequisiteResponseModel
    ModelDataParsingType.prerequisiteResponseModel : parsePrerequisiteDetailDataResponseModel,
    ModelDataParsingType.associatedContent : parseAssociatedContentDataResponseModel,
    //endregion

    // region Event
    ModelDataParsingType.eventSessionDataResponseModel : parseEventSessionDataResponseModel,
    //endregion

    // region Content Details Module
    ModelDataParsingType.contentDetailsDTOModel: parseContentDetailsDTOModel,
    ModelDataParsingType.courseDetailsScheduleDataResponseModel: parseCourseDetailsScheduleDataResponseModel,
    //endregion

    ModelDataParsingType.responseDTOModel: parseResponseDTOModel,

    //region Course Launch
    ModelDataParsingType.ContentStatusResponseModel: parseContentStatusResponseModel,
    //endregion

    //region Catalog Module
    ModelDataParsingType.addAssociatedContentToMyLearningResponseModel: parseAddAssociatedContentToMyLearningResponseModel,
    //endregion

    //region Event Track
    ModelDataParsingType.eventTrackHeaderDTOModel : parseEventTrackHeaderDTOModel,
    ModelDataParsingType.eventTrackTabDTOModelList : parseEventTrackTabDTOModelList,
    ModelDataParsingType.eventTrackDTOModelList : parseEventTrackDTOModelList,
    ModelDataParsingType.glossaryModelList : parseGlossaryModelList,
    ModelDataParsingType.eventTrackResourceResponseModel : parseEventTrackResourceResponseModel,
    ModelDataParsingType.trackContentDataResponseModel : parseTrackContentDataResponseModel,
    ModelDataParsingType.eventRelatedContentDataResponseModel : parseEventRelatedContentDataResponseModel,
    //endregion

    // region Discussion
    ModelDataParsingType.forumListingDTOResponseModel : parseForumListingDTOResponseModel,
    //endregion

    // region MyConnection
    ModelDataParsingType.peopleListingDTOResponseModel : parsePeopleListingDTOResponseModel,
    //endregion

    //region userComingSoonResponse
    ModelDataParsingType.userComingSoonResponseModel : parseUserComingSoonResponseModel,
    //endregion

    //region waitListResponse
    ModelDataParsingType.addToWaitListResponseModel : parseAddWaitListResponseModel,
    //endregion

    //region instabotResponse
    ModelDataParsingType.botDetailsModel: parseBotDetailsModel
    //endregion
  };

  //region Splash Module
  static T? parseDataFromDecodedValue<T>({required ModelDataParsingType parsingType, dynamic decodedValue}) {
    ModelDataParsingCallbackTypeDef? type = callsMap[parsingType];
    MyPrint.printOnConsole("Parsing Callback:$type");

    if(type is ModelDataParsingCallbackTypeDef<T>) {
      return type(decodedValue: decodedValue);
    }
    else {
      return null;
    }
  }

  static dynamic parseDynamic({required dynamic decodedValue}) {
    return decodedValue;
  }

  static String parseString({required dynamic decodedValue}) {
    return ParsingHelper.parseStringMethod(decodedValue);
  }

  static bool parseBool({required dynamic decodedValue}) {
    return ParsingHelper.parseBoolMethod(decodedValue);
  }

  static MobileGetLearningPortalInfoResponseModel? parseLearningPortalInfo({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return MobileGetLearningPortalInfoResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static MobileApiAuthResponseModel? parseMobileApiAuthResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return MobileApiAuthResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static LocalStr? parseLocalStr({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return LocalStr.fromJson(map);
    }
    else {
      return null;
    }
  }

  static TinCanDataModel? parseTinCanDataModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(MyUtils.decodeJson(decodedValue.toString().replaceAll("'", '"')));

    if(map.isNotEmpty) {
      return TinCanDataModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static List<NativeMenuModel> parseNativeMenuModelsList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => NativeMenuModel.fromJson(e)).toList();
  }

  static List<NativeMenuComponentModel> parseNativeMenuComponentModelsList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => NativeMenuComponentModel.fromJson(e)).toList();
  }
  //endregion

  //region Authentication Module
  static EmailLoginResponseModel? parseEmailLoginResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return EmailLoginResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static SuccessfulUserLoginModel? parseSuccessfulUserLoginModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return SuccessfulUserLoginModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static SignupResponseModel? parseSignupResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return SignupResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Home Menu
  static CategoryWiseCourseDTOResponseModel? parseNewLearningResourcesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return CategoryWiseCourseDTOResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static List<NewCourseListDTOModel> parseCourseDTOList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => NewCourseListDTOModel.fromJson(e)).toList();
  }

  static List<WebList> parseWebListList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => WebList.fromJson(e)).toList();
  }

  static StaticWebPageModel? parseStaticWebPageModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return StaticWebPageModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static ForgotPasswordResponseModel? parseForgotPasswordResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return ForgotPasswordResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static SignupFieldResponseModel? parseSignupFieldResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return SignupFieldResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Profile Menu
  static ProfileResponseModel? parseProfileResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return ProfileResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static CountryResponseModel? parseCountryResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return CountryResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static EducationTitleResponseModel? parseEducationTitleResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return EducationTitleResponseModel.fromJson(map);
    }
    else {
      return null;
    }
  }

  static UserProfileHeaderDTOModel? parseUserProfileHeaderDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return UserProfileHeaderDTOModel.fromJson(map);
    }
    else {
      return null;
    }
  }
  //endregion

  //region My Learning Menu
  static MyLearningContentModel? parseMyLearningContentModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return MyLearningContentModel.fromMap(map);
    }
    else {
      return null;
    }
  }

  static ContentUserRatingsDataResponseModel? parseContentUserRatingsDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(map.isNotEmpty) {
      return ContentUserRatingsDataResponseModel.fromMap(map);
    }
    else {
      return null;
    }
  }

  static MyLearningResponseDTOModel? parseMyLearningResponseDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(map.isNotEmpty) {
      return MyLearningResponseDTOModel.fromMap(map);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Wiki Component
  static List<FileUploadControlsModel> parseListFileUploadControlsModel({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => FileUploadControlsModel.fromMap(e)).toList();
  }

  static WikiCategoriesModel? parseWikiCategoriesModel({required dynamic decodedValue}) {
      Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

      if(map.isNotEmpty) {
        return WikiCategoriesModel.fromMap(map);
      }
      else {
        return null;
      }
    }
  //endregion

  // region Wiki Component
  static List<CatalogCategoriesForBrowseModel> parseListCatalogCategoriesForBrowseModel({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => CatalogCategoriesForBrowseModel.fromJson(e)).toList();
  }

  //endregion

  //region CatalogContentFromCategory
  static CatalogResponseDTOModel? parseCatalogResponseDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if(map.isNotEmpty) {
      return CatalogResponseDTOModel.fromMap(map);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Filter
  static List<ContentFilterCategoryTreeModel>? parseContentFilterCategoryTreeModelList({required dynamic decodedValue}) {
    List<dynamic> list = ParsingHelper.parseListMethod(decodedValue);
    List<Map<String, dynamic>> mapsList = list.map((e) {
      return ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(e);
    }).toList();
    mapsList.removeWhere((element) => element.isEmpty);

    if(mapsList.isNotEmpty) {
      return mapsList.map((Map<String, dynamic> map) {
        return ContentFilterCategoryTreeModel.fromJson(map);
      }).toList();
    }
    else {
      return null;
    }
  }

  static LearningProviderFilterResponseModel? parseLearningProviderFilterResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return LearningProviderFilterResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static InstructorListFilterResponseModel? parseInstructorListFilterResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return InstructorListFilterResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static FilterDurationValuesResponseModel? parseFilterDurationValuesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return FilterDurationValuesResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static ComponentSortResponseModel? parseComponentSortResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ComponentSortResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  //region
  static RemoveFromWishlistResponseModel? parseRemoveFromWishlistResponseModel({required dynamic decodedValue}){
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return RemoveFromWishlistResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Share Module
  static ShareConnectionListResponseModel? parseShareConnectionListResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ShareConnectionListResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  // region Progress Report Module
  static ContentProgressDetailDataResponseModel? parseProgressDetailDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ContentProgressDetailDataResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static List<ContentProgressSummaryDataModel>? parseContentProgressSummaryDataModelList({required dynamic decodedValue}) {
    List<dynamic> list = ParsingHelper.parseListMethod(decodedValue);
    List<Map<String, dynamic>> mapsList = list.map((e) {
      return ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(e);
    }).toList();
    mapsList.removeWhere((element) => element.isEmpty);

    if(mapsList.isNotEmpty) {
      return mapsList.map((Map<String, dynamic> map) {
        return ContentProgressSummaryDataModel.fromJson(map);
      }).toList();
    }
    else {
      return null;
    }
  }
  //endregion


  //region Prerequisite Model
  static PrerequisiteDetailResponseModel? parsePrerequisiteDetailDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return PrerequisiteDetailResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static AssociatedContentResponseModel? parseAssociatedContentDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return AssociatedContentResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  //endregion

  // region Event
  static EventSessionDataResponseModel? parseEventSessionDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return EventSessionDataResponseModel.fromMap(json);
    }
    else {
      return null;
    }
  }
  //endregion


  // region Content Details Module
  static ContentDetailsDTOModel? parseContentDetailsDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ContentDetailsDTOModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static CourseDetailsScheduleDataResponseModel? parseCourseDetailsScheduleDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return CourseDetailsScheduleDataResponseModel.fromMap(json);
    }
    else {
      return null;
    }
  }
  //endregion

  //region Event Track
  static EventTrackHeaderDTOModel? parseEventTrackHeaderDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return EventTrackHeaderDTOModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static List<EventTrackTabDTOModel>? parseEventTrackTabDTOModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    MyPrint.logOnConsole("decodedValue :  $mapsList");
    return mapsList.map((e) => EventTrackTabDTOModel.fromJson(e)).toList();
  }

  static List<EventTrackDTOModel>? parseEventTrackDTOModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    MyPrint.logOnConsole("decodedValue :  $mapsList");
    return mapsList.map((e) => EventTrackDTOModel.fromJson(e)).toList();
  }

  static List<GlossaryModel>? parseGlossaryModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    MyPrint.logOnConsole("decodedValue :  $mapsList");
    return mapsList.map((e) => GlossaryModel.fromJson(e)).toList();
  }

  static EventTrackResourceResponseModel? parseEventTrackResourceResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return EventTrackResourceResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static TrackContentDataResponseModel? parseTrackContentDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return TrackContentDataResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  static EventRelatedContentDataResponseModel? parseEventRelatedContentDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return EventRelatedContentDataResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  // region Discussion
  static ForumListingDTOResponseModel? parseForumListingDTOResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ForumListingDTOResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  // region MyConnection
  static PeopleListingDTOResponseModel? parsePeopleListingDTOResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return PeopleListingDTOResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion


  static UserComingSoonResponse? parseUserComingSoonResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return UserComingSoonResponse.fromJson(json);
    }
    else {
      return null;
    }
  }

  static AddToWaitListResponseModel? parseAddWaitListResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AddToWaitListResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static BotDetailsModel? parseBotDetailsModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return BotDetailsModel.fromMap(json);
    } else {
      return null;
    }
  }

  static ResponseDTOModel? parseResponseDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ResponseDTOModel.fromJson(json);
    }
    else {
      return null;
    }
  }

  //region Course Launch
  static ContentStatusResponseModel? parseContentStatusResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return ContentStatusResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion

  // region Catalog Module
  static AddAssociatedContentToMyLearningResponseModel? parseAddAssociatedContentToMyLearningResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return AddAssociatedContentToMyLearningResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion
  // region Catalog Module
  static PageNotesResponseModel? parsePageNoteResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if(json.isNotEmpty) {
      return PageNotesResponseModel.fromJson(json);
    }
    else {
      return null;
    }
  }
  //endregion
}
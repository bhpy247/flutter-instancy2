import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/response_model/currency_data_response_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/answer_comment_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/QuestionListDtoResponseModel.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/add_question_response_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/filter_user_skills_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/user_question_skills_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/forgot_password_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/save_social_network_users_response_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/signup_field_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/associated_content_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/catalog_dto_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/user_coming_soon_response.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/response_model/article_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_module_names_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_resources_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/speaking_style_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/assessment_generate_content_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/generate_assessment_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/response_model/video_detail_response_model.dart';
import 'package:flutter_instancy_2/models/common/response_model/common_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/get_course_tracking_data_response_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/category_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';
import 'package:flutter_instancy_2/models/dto/global_search_dto_model.dart';
import 'package:flutter_instancy_2/models/event/response_model/re_entrollment_history_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/resource_content_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_list_view_data_response_model.dart';
import 'package:flutter_instancy_2/models/feedback/data_model/feedback_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/games_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/content_game_activity_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
import 'package:flutter_instancy_2/models/home/data_model/web_list_data_dto.dart';
import 'package:flutter_instancy_2/models/home/response_model/categorywise_course_dto_model.dart';
import 'package:flutter_instancy_2/models/learning_communities/data_model/learning_communities_dto_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/check_contents_enrollment_status_response_model.dart';
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
import '../ar_vr_module/response_model/ar_content_model.dart';
import '../ask_the_expert/data_model/ask_the_expert_dto.dart';
import '../authentication/data_model/successful_user_login_model.dart';
import '../authentication/response_model/email_login_response_model.dart';
import '../authentication/response_model/mobile_create_sign_up_response_model.dart';
import '../authentication/response_model/mobile_get_user_details_response_model.dart';
import '../catalog/catalogCategoriesForBrowseModel.dart';
import '../catalog/response_model/add_associated_content_to_mylearning_response_model.dart';
import '../catalog/response_model/add_expired_event_to_mylearning_response_model.dart';
import '../catalog/response_model/enroll_waiting_list_event_response_model.dart';
import '../catalog/response_model/mobile_catalog_objects_data_response_model.dart';
import '../catalog/response_model/prerequisiteDetailsResponseModel.dart';
import '../catalog/response_model/removeFromWishlistModel.dart';
import '../co_create_knowledge/common/response_model/avatar_voice_model.dart';
import '../co_create_knowledge/common/response_model/avtar_response_model.dart';
import '../co_create_knowledge/common/response_model/background_response_model.dart';
import '../co_create_knowledge/podcast/response_model/language_response_model.dart';
import '../co_create_knowledge/podcast/response_model/language_voice_model.dart';
import '../content_details/response_model/course_details_schedule_data_response_model.dart';
import '../content_review_ratings/response_model/content_user_ratings_data_response_model.dart';
import '../course/data_model/CourseDTOModel.dart';
import '../course/data_model/gloassary_model.dart';
import '../course_launch/response_model/content_status_response_model.dart';
import '../discussion/response_model/discussion_topic_dto_response_model.dart';
import '../discussion/response_model/forum_listing_dto_response_model.dart';
import '../discussion/response_model/replies_dto_model.dart';
import '../dto/response_dto_model.dart';
import '../event/response_model/event_session_data_response_model.dart';
import '../event_track/data_model/event_track_header_dto_model.dart';
import '../event_track/data_model/event_track_tab_dto_model.dart';
import '../event_track/response_model/event_track_resourse_response_model.dart';
import '../filter/data_model/content_filter_category_tree_model.dart';
import '../filter/response_model/component_sort_options_response_model.dart';
import '../filter/response_model/filter_duration_values_response_model.dart';
import '../filter/response_model/instructor_list_filter_response_model.dart';
import '../filter/response_model/learning_provider_filter_response_model.dart';
import '../global_search/response_model/global_search_component_response_model.dart';
import '../home/data_model/new_course_list_dto.dart';
import '../home/response_model/static_web_page_podel.dart';
import '../in_app_purchase/response_model/ecommerce_order_response_model.dart';
import '../in_app_purchase/response_model/ecommerce_process_payment_response_model.dart';
import '../membership/data_model/member_ship_dto_model.dart';
import '../membership/response_model/user_active_membership_response_model.dart';
import '../message/response_model/chat_users_list_response_model.dart';
import '../my_connections/response_model/people_listing_dto_response_model.dart';
import '../my_learning/data_model/my_learning_content_model.dart';
import '../my_learning/response_model/my_learning_response_dto_model.dart';
import '../profile/data_model/user_profile_header_dto_model.dart';
import '../profile/response_model/education_title_response_model.dart';
import '../profile/response_model/profile_response_model.dart';
import '../profile/response_model/sign_up_response_model.dart';
import '../progress_report/data_model/consolidated_group_dto.dart';
import '../progress_report/data_model/content_progress_summary_data_model.dart.dart';
import '../progress_report/response_model/content_progress_detail_data_response.dart';
import '../share/response_model/share_connection_list_response_model.dart';

typedef ModelDataParsingCallbackTypeDef<T> = T? Function({required dynamic decodedValue});

enum ModelDataParsingType {
  dynamic,
  string,
  bool,
  int,
  List,
  StringList,
  Uint8List,

  //region App Module
  CurrencyDataResponseModel,
  DynamicTabsDTOModelList,
  //endregion

  // region Splash Module
  mobileGetLearningPortalInfoResponseModel,
  mobileApiAuthResponseModel,
  localStr,
  tinCanDataModel,
  nativeMenuModelsList,
  nativeMenusComponentModelsList,
  //endregion

  //region Authentication Module
  emailLoginResponseModel,
  NativeLoginDTOModel,
  SaveSocialNetworkUsersResponseDtoModel,
  successfulUserLoginModel,
  MobileCreateSignUpResponseModel,
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
  MobileGetUserDetailsResponseModel,
  educationTitleResponseModel,
  userProfileHeaderDTOModel,
  SignUpResponseModel,
  //endregion

  //region My Learning Menu
  myLearningContentModel,
  myLearningContentDataResponseModel,
  contentUserRatingsDataResponseModel,
  myLearningResponseDTOModel,
  CheckContentsEnrollmentStatusResponseModel,
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
  mobileCatalogObjectsDataResponseModel,
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
  reEnrollmentHistoryResponseModel,
  //endregion

  // region Content Details Module
  courseDTOModel,
  courseDetailsScheduleDataResponseModel,
  //endregion

  responseDTOModel,

  //region Course Launch
  ContentStatusResponseModel,
  //endregion

  //region Catalog Module
  addAssociatedContentToMyLearningResponseModel,
  enrollWaitingListEventResponseModel,
  addExpiredEventToMyLearningResponseModel,
  //endregion

  //region Event Track
  eventTrackHeaderDTOModel,
  eventTrackTabDTOModelList,
  eventTrackDTOModelList,
  glossaryModelList,
  eventTrackResourceResponseModel,
  TrackListViewDataResponseModel,
  ResourceContentDTOModel,
  //endregion

  // region Discussion
  forumListingDTOResponseModel,
  ForumUserInfoList,
  discussionTopicResponseModel,
  RepliesDTOModel,
  topicCommentResponseModel,
  userLikedList,
  forumResponseModel,
  categoriesDtoModel,
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
  botDetailsModel,
  //endregion

  //region messages screen
  chatUsersListResponseModel,
  //endregion

  // region ARModule
  arContentModel,
  parseDiscussionTopicResponseModel,
  // endregion

  //region InApp Purchase
  EcommerceProcessPaymentResponseModel,
  EcommerceOrderResponseModel,
  //endregion

  // region Membership
  MemberShipDTOModelList,
  UserActiveMembershipResponseModel,
  //endregion

  // region Gamification
  GamesDTOModelList,
  UserAchievementDTOModel,
  LeaderBoardDTOModel,
  ContentGameActivityResponseModel,
  //endregion

  //region MyProgressRepor
  ConsolidatedGroupDTO,
  //endregion

  //Feedback
  FeedbackDTOModel,
  //region

  //region CommonResponseModel
  CommonResponseModel,
  //endregion

  //region Ask the expert
  QuestionListDtoModel,
  AskTheExpertDtoModel,
  AnswerCommentDtoModel,
  AddQuestionResponseModel,
  FilterUserSkillsDtoResponseModel,
  UserQuestionSkillsResponseModel,
  //endregion

  //region learning Communities
  LearningCommunitiesDto,
  //endregion

  //region global search
  GlobalSearchComponentResponseDto,
  GlobalSearchResultDto,
  //endregion

  GetCourseTrackingDataResponseModel,

  //region co-createKnowledge
  GeneratedFlashcardResponseModel,
  AvtarResponseModel,
  BackgroundColorModelList,
  AvatarVoiceList,
  AssessmentGenerateContentResponseModel,
  GenerateAssessmentResponseModel,
  GenerateAssessmentResponseModelList,
  GetVideoDetailList,
  GetLanguageList,
  GetLanguageVoiceList,
  SpeakingStyleModel,
  CourseDtoModelList,
  ArticleResponseModel,

  CoCreateToCourseDtoModelList,
  NativeAuthoringGetResourcesResponseModel,
  NativeAuthoringGetModuleNamesResponseModel,
  //enregion
}

class ModelDataParser {
  static Map<ModelDataParsingType, ModelDataParsingCallbackTypeDef> callsMap = <ModelDataParsingType, ModelDataParsingCallbackTypeDef>{
    ModelDataParsingType.dynamic: parseDynamic,
    ModelDataParsingType.string: parseString,
    ModelDataParsingType.bool: parseBool,
    ModelDataParsingType.int: parseInt,
    ModelDataParsingType.List: parseList,
    ModelDataParsingType.StringList: parseStringList,

    //region App Module
    ModelDataParsingType.CurrencyDataResponseModel: parseCurrencyDataResponseModel,
    ModelDataParsingType.DynamicTabsDTOModelList: parseDynamicTabsDTOModelList,
    //endregion

    //region Splash Module
    ModelDataParsingType.mobileGetLearningPortalInfoResponseModel: parseLearningPortalInfo,
    ModelDataParsingType.mobileApiAuthResponseModel: parseMobileApiAuthResponseModel,
    ModelDataParsingType.localStr: parseLocalStr,
    ModelDataParsingType.tinCanDataModel: parseTinCanDataModel,
    ModelDataParsingType.nativeMenuModelsList: parseNativeMenuModelsList,
    ModelDataParsingType.nativeMenusComponentModelsList: parseNativeMenuComponentModelsList,
    //endregion

    //region Authentication Module
    ModelDataParsingType.emailLoginResponseModel: parseEmailLoginResponseModel,
    ModelDataParsingType.NativeLoginDTOModel: parseNativeLoginDTOModel,
    ModelDataParsingType.SaveSocialNetworkUsersResponseDtoModel: parseSaveSocialNetworkUsersResponseDtoModel,
    ModelDataParsingType.successfulUserLoginModel: parseSuccessfulUserLoginModel,
    ModelDataParsingType.MobileCreateSignUpResponseModel: parseMobileCreateSignUpResponseModel,
    //endregion

    //region Home Menu
    ModelDataParsingType.newLearningResourcesResponseModel: parseNewLearningResourcesResponseModel,
    ModelDataParsingType.listCourseDTOModel: parseCourseDTOList,
    ModelDataParsingType.listWebListModel: parseWebListList,
    ModelDataParsingType.staticWebPageModel: parseStaticWebPageModel,
    //endregion

    //region signUpFieldResponseModel
    ModelDataParsingType.signupFieldResponseModel: parseSignupFieldResponseModel,
    //endregion

    //region forgotPassword
    ModelDataParsingType.forgotPasswordResponseModel: parseForgotPasswordResponseModel,
    //endregion

    //region Profile Menu
    ModelDataParsingType.profileResponseModel: parseProfileResponseModel,
    ModelDataParsingType.MobileGetUserDetailsResponseModel: parseMobileGetUserDetailsResponseModel,
    ModelDataParsingType.educationTitleResponseModel: parseEducationTitleResponseModel,
    ModelDataParsingType.userProfileHeaderDTOModel: parseUserProfileHeaderDTOModel,
    ModelDataParsingType.SignUpResponseModel: parseSignUpResponseModel,
    //endregion

    //region My Learning Menu
    ModelDataParsingType.myLearningContentModel: parseMyLearningContentModel,
    ModelDataParsingType.contentUserRatingsDataResponseModel: parseContentUserRatingsDataResponseModel,
    ModelDataParsingType.myLearningResponseDTOModel: parseMyLearningResponseDTOModel,
    ModelDataParsingType.CheckContentsEnrollmentStatusResponseModel: parseCheckContentsEnrollmentStatusResponseModel,
    ModelDataParsingType.pageNoteResponseModel: parsePageNoteResponseModel,
    //endregion

    //region Wiki Component
    ModelDataParsingType.fileUploadControlModel: parseListFileUploadControlsModel,
    ModelDataParsingType.wikiCategoriesModel: parseWikiCategoriesModel,
    //endregion

    //region catalogCategoriesForBrowseModel
    ModelDataParsingType.catalogCategoriesForBrowseModel: parseListCatalogCategoriesForBrowseModel,
    //endregion

    //region CatalogContentFromCategoriesModel
    ModelDataParsingType.catalogResponseDTOModel: parseCatalogResponseDTOModel,
    ModelDataParsingType.mobileCatalogObjectsDataResponseModel: parseMobileCatalogObjectsDataResponseModel,
    //endregion

    //region Filter
    ModelDataParsingType.contentFilterCategoryTreeModelList: parseContentFilterCategoryTreeModelList,
    ModelDataParsingType.LearningProviderFilterResponseModel: parseLearningProviderFilterResponseModel,
    ModelDataParsingType.InstructorListFilterResponseModel: parseInstructorListFilterResponseModel,
    ModelDataParsingType.FilterDurationValuesResponseModel: parseFilterDurationValuesResponseModel,
    ModelDataParsingType.ComponentSortResponseModel: parseComponentSortResponseModel,
    //endregion

    //region
    ModelDataParsingType.removeFromWishlist: parseRemoveFromWishlistResponseModel,
    //endregion

    // region Share Module
    ModelDataParsingType.shareConnectionListResponseModel: parseShareConnectionListResponseModel,
    //endregion

    // region Progress Report Module
    ModelDataParsingType.progressDetailDataResponseModel: parseProgressDetailDataResponseModel,
    ModelDataParsingType.contentProgressSummaryDataModelList: parseContentProgressSummaryDataModelList,
    //endregion

    //region prerequisiteResponseModel
    ModelDataParsingType.prerequisiteResponseModel: parsePrerequisiteDetailDataResponseModel,
    ModelDataParsingType.associatedContent: parseAssociatedContentDataResponseModel,
    //endregion

    // region Event
    ModelDataParsingType.eventSessionDataResponseModel: parseEventSessionDataResponseModel,
    ModelDataParsingType.reEnrollmentHistoryResponseModel: parseReEnrollmentHistoryResponseModel,
    //endregion

    // region Content Details Module
    ModelDataParsingType.courseDTOModel: parseCourseDTOModel,
    ModelDataParsingType.courseDetailsScheduleDataResponseModel: parseCourseDetailsScheduleDataResponseModel,
    //endregion

    ModelDataParsingType.responseDTOModel: parseResponseDTOModel,

    //region Course Launch
    ModelDataParsingType.ContentStatusResponseModel: parseContentStatusResponseModel,
    //endregion

    //region Catalog Module
    ModelDataParsingType.addAssociatedContentToMyLearningResponseModel: parseAddAssociatedContentToMyLearningResponseModel,
    ModelDataParsingType.enrollWaitingListEventResponseModel: parseEnrollWaitingListEventResponseModel,
    ModelDataParsingType.addExpiredEventToMyLearningResponseModel: parseAddExpiredEventToMyLearningResponseModel,
    //endregion

    //region Event Track
    ModelDataParsingType.eventTrackHeaderDTOModel: parseEventTrackHeaderDTOModel,
    ModelDataParsingType.eventTrackTabDTOModelList: parseEventTrackTabDTOModelList,
    ModelDataParsingType.eventTrackDTOModelList: parseEventTrackDTOModelList,
    ModelDataParsingType.glossaryModelList: parseGlossaryModelList,
    ModelDataParsingType.eventTrackResourceResponseModel: parseEventTrackResourceResponseModel,
    ModelDataParsingType.TrackListViewDataResponseModel: parseTrackListViewDataResponseModel,
    ModelDataParsingType.ResourceContentDTOModel: parseResourceContentDTOModel,
    //endregion

    // region Discussion
    ModelDataParsingType.forumListingDTOResponseModel: parseForumListingDTOResponseModel,
    ModelDataParsingType.ForumUserInfoList: parseForumUserInfoList,
    ModelDataParsingType.discussionTopicResponseModel: parseDiscussionTopicResponseModel,
    ModelDataParsingType.RepliesDTOModel: parseRepliesDTOModel,
    ModelDataParsingType.topicCommentResponseModel: parseTopicCommentsResponseModel,
    ModelDataParsingType.userLikedList: parseUserLikedListResponseModel,
    ModelDataParsingType.forumResponseModel: parseForumResponseModel,
    ModelDataParsingType.categoriesDtoModel: parseCategoriesDtoResponseModel,
    //endregion

    // region MyConnection
    ModelDataParsingType.peopleListingDTOResponseModel: parsePeopleListingDTOResponseModel,
    //endregion

    //region userComingSoonResponse
    ModelDataParsingType.userComingSoonResponseModel: parseUserComingSoonResponseModel,
    //endregion

    //region waitListResponse
    ModelDataParsingType.addToWaitListResponseModel: parseAddWaitListResponseModel,
    //endregion

    //region instabotResponse
    ModelDataParsingType.botDetailsModel: parseBotDetailsModel,
    //endregion

    //region
    ModelDataParsingType.chatUsersListResponseModel: parseChatUsersListResponseModel,

    //endregion

    //region ARModule
    ModelDataParsingType.arContentModel: parseARContentModel,
    //endregion

    //region InApp Purchase
    ModelDataParsingType.EcommerceProcessPaymentResponseModel: parseEcommerceProcessPaymentResponseModel,
    ModelDataParsingType.EcommerceOrderResponseModel: parseEcommerceOrderResponseModel,
    //endregion

    // region MemberShip
    ModelDataParsingType.MemberShipDTOModelList: parseMemberShipDTOModelList,
    ModelDataParsingType.UserActiveMembershipResponseModel: parseUserActiveMembershipResponseModel,
    //endregion

    // region Gamification
    ModelDataParsingType.GamesDTOModelList: parseGamesDTOModelList,
    ModelDataParsingType.UserAchievementDTOModel: parseUserAchievementDTOModel,
    ModelDataParsingType.LeaderBoardDTOModel: parseLeaderBoardDTOModel,
    ModelDataParsingType.ContentGameActivityResponseModel: parseContentGameActivityResponseModel,
    //endregion

    //region My progress Report
    ModelDataParsingType.ConsolidatedGroupDTO: parseMyProgressReportDTOModel,
    //endregion

    //region Feedback
    ModelDataParsingType.FeedbackDTOModel: parseFeedbackDTOList,
    //endregion

    //region CommonResponseModel
    ModelDataParsingType.CommonResponseModel: parseCommonResponseModelList,
    //region

    // region AskTheExpertDtoModel
    ModelDataParsingType.AskTheExpertDtoModel: parseAskTheExpertDtoModel,
    ModelDataParsingType.AnswerCommentDtoModel: parseAnswerCommentDTOModel,
    ModelDataParsingType.QuestionListDtoModel: parseQuestionListDtoModel,
    ModelDataParsingType.AddQuestionResponseModel: parseAddQuestionResponseModel,
    ModelDataParsingType.FilterUserSkillsDtoResponseModel: parseFilterUserSkillsDtoResponseModel,
    ModelDataParsingType.UserQuestionSkillsResponseModel: parseUserQuestionSkillsResponseModel,
    //region

    //region LearningCommunitiesModel
    ModelDataParsingType.LearningCommunitiesDto: parseLearningCommunitiesDtoResponseModel,
    //endregion

    //region GlobalSearch
    ModelDataParsingType.GlobalSearchComponentResponseDto: parseGlobalSearchComponentResponseModel,
    ModelDataParsingType.GlobalSearchResultDto: parseGlobalSearchDtoResponseModel,

    //endregion

    ModelDataParsingType.GetCourseTrackingDataResponseModel: parseGetCourseTrackingDataResponseModel,
    ModelDataParsingType.GeneratedFlashcardResponseModel: parseGeneratedFlashcardResponseModel,
    ModelDataParsingType.AvtarResponseModel: parseAvatarResponseModel,
    ModelDataParsingType.BackgroundColorModelList: parseBackgroundColorList,
    ModelDataParsingType.AvatarVoiceList: parseAvatarVoiceList,
    ModelDataParsingType.AssessmentGenerateContentResponseModel: parseAssessmentGenerateContentResponseModel,
    ModelDataParsingType.GenerateAssessmentResponseModel: parseGenerateAssessmentResponseModel,
    ModelDataParsingType.GenerateAssessmentResponseModelList: parseGenerateAssessmentResponseModelList,
    ModelDataParsingType.GetVideoDetailList: parseVideoDetailList,
    ModelDataParsingType.CourseDtoModelList: parseCourseDtoModelList,
    ModelDataParsingType.GetLanguageList: parseLanguageList,
    ModelDataParsingType.GetLanguageVoiceList: parseLanguageVoiceList,
    ModelDataParsingType.SpeakingStyleModel: parseSpeakingStyle,
    ModelDataParsingType.ArticleResponseModel: parseArticleResponseModel,
    ModelDataParsingType.CoCreateToCourseDtoModelList: parseCoCreateToCourseDtoModelList,
    ModelDataParsingType.NativeAuthoringGetResourcesResponseModel: parseNativeAuthoringGetResourcesResponseModel,
    ModelDataParsingType.NativeAuthoringGetModuleNamesResponseModel: parseNativeAuthoringGetModuleNamesResponseModel,
  };

  static T? parseDataFromDecodedValue<T>({required ModelDataParsingType parsingType, dynamic decodedValue}) {
    ModelDataParsingCallbackTypeDef? type = callsMap[parsingType];
    MyPrint.printOnConsole("Parsing Callback:$type");

    if (type is ModelDataParsingCallbackTypeDef<T>) {
      MyPrint.printOnConsole("Parsing Callback Matched");
      return type(decodedValue: decodedValue);
    } else {
      MyPrint.printOnConsole("Parsing Callback Not Matched");
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

  static int parseInt({required dynamic decodedValue}) {
    return ParsingHelper.parseIntMethod(decodedValue);
  }

  static List parseList({required dynamic decodedValue}) {
    return ParsingHelper.parseListMethod(decodedValue);
  }

  static List<String> parseStringList({required dynamic decodedValue}) {
    return ParsingHelper.parseListMethod<dynamic, String>(decodedValue);
  }

  //region App Module
  static CurrencyDataResponseModel? parseCurrencyDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return CurrencyDataResponseModel.fromMap(map);
    } else {
      return null;
    }
  }

  static List<DynamicTabsDTOModel>? parseDynamicTabsDTOModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> list = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    if (list.isNotEmpty) {
      return list.map((e) => DynamicTabsDTOModel.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  //endregion

  //region Splash Module
  static MobileGetLearningPortalInfoResponseModel? parseLearningPortalInfo({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MobileGetLearningPortalInfoResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static MobileApiAuthResponseModel? parseMobileApiAuthResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MobileApiAuthResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static LocalStr? parseLocalStr({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return LocalStr.fromJson(map);
    } else {
      return null;
    }
  }

  static TinCanDataModel? parseTinCanDataModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(MyUtils.decodeJson(decodedValue.toString().replaceAll("'", '"')));

    if (map.isNotEmpty) {
      return TinCanDataModel.fromJson(map);
    } else {
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

    if (map.isNotEmpty) {
      return EmailLoginResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static NativeLoginDTOModel? parseNativeLoginDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return NativeLoginDTOModel.fromMap(map);
    } else {
      return null;
    }
  }

  static SaveSocialNetworkUsersResponseDtoModel? parseSaveSocialNetworkUsersResponseDtoModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return SaveSocialNetworkUsersResponseDtoModel.fromMap(map);
    } else {
      return null;
    }
  }

  static SuccessfulUserLoginModel? parseSuccessfulUserLoginModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return SuccessfulUserLoginModel.fromJson(map);
    } else {
      return null;
    }
  }

  static MobileCreateSignUpResponseModel? parseMobileCreateSignUpResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MobileCreateSignUpResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  //endregion

  //region Home Menu
  static CategoryWiseCourseDTOResponseModel? parseNewLearningResourcesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return CategoryWiseCourseDTOResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static List<NewCourseListDTOModel> parseCourseDTOList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    return mapsList.map((e) => NewCourseListDTOModel.fromJson(e)).toList();
  }

  // static List<WebListDTO> parseWebListList({required dynamic decodedValue}) {
  //   List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
  //
  //   return mapsList.map((e) => WebListDTO.fromJson(e)).toList();
  // }
  static WebListDataDTO? parseWebListList({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return WebListDataDTO.fromJson(map);
    } else {
      return null;
    }
  }

  static StaticWebPageModel? parseStaticWebPageModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return StaticWebPageModel.fromJson(map);
    } else {
      return null;
    }
  }

  static ForgotPasswordResponseModel? parseForgotPasswordResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return ForgotPasswordResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static SignupFieldResponseModel? parseSignupFieldResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return SignupFieldResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  //endregion

  //region Profile Menu
  static ProfileResponseModel? parseProfileResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return ProfileResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static MobileGetUserDetailsResponseModel? parseMobileGetUserDetailsResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MobileGetUserDetailsResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static EducationTitleResponseModel? parseEducationTitleResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return EducationTitleResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static UserProfileHeaderDTOModel? parseUserProfileHeaderDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return UserProfileHeaderDTOModel.fromJson(map);
    } else {
      return null;
    }
  }

  static SignUpResponseModel? parseSignUpResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return SignUpResponseModel.fromMap(map);
    } else {
      return null;
    }
  }

  //endregion

  //region My Learning Menu
  static MyLearningContentModel? parseMyLearningContentModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MyLearningContentModel.fromMap(map);
    } else {
      return null;
    }
  }

  static ContentUserRatingsDataResponseModel? parseContentUserRatingsDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (map.isNotEmpty) {
      return ContentUserRatingsDataResponseModel.fromMap(map);
    } else {
      return null;
    }
  }

  static MyLearningResponseDTOModel? parseMyLearningResponseDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (map.isNotEmpty) {
      return MyLearningResponseDTOModel.fromMap(map);
    } else {
      return null;
    }
  }

  static CheckContentsEnrollmentStatusResponseModel? parseCheckContentsEnrollmentStatusResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(MyUtils.decodeJson(decodedValue));

    if (map.isNotEmpty) {
      return CheckContentsEnrollmentStatusResponseModel.fromMap(map);
    } else {
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

    if (map.isNotEmpty) {
      return WikiCategoriesModel.fromMap(map);
    } else {
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

    if (map.isNotEmpty) {
      return CatalogResponseDTOModel.fromMap(map);
    } else {
      return null;
    }
  }

  static MobileCatalogObjectsDataResponseModel? parseMobileCatalogObjectsDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MobileCatalogObjectsDataResponseModel.fromMap(map);
    } else {
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

    if (mapsList.isNotEmpty) {
      return mapsList.map((Map<String, dynamic> map) {
        return ContentFilterCategoryTreeModel.fromJson(map);
      }).toList();
    } else {
      return null;
    }
  }

  static LearningProviderFilterResponseModel? parseLearningProviderFilterResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return LearningProviderFilterResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static InstructorListFilterResponseModel? parseInstructorListFilterResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return InstructorListFilterResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static FilterDurationValuesResponseModel? parseFilterDurationValuesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return FilterDurationValuesResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static ComponentSortResponseModel? parseComponentSortResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ComponentSortResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  //region
  static RemoveFromWishlistResponseModel? parseRemoveFromWishlistResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return RemoveFromWishlistResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  //region Share Module
  static ShareConnectionListResponseModel? parseShareConnectionListResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ShareConnectionListResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  // region Progress Report Module
  static ContentProgressDetailDataResponseModel? parseProgressDetailDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ContentProgressDetailDataResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static List<ContentProgressSummaryDataModel>? parseContentProgressSummaryDataModelList({required dynamic decodedValue}) {
    List<dynamic> list = ParsingHelper.parseListMethod(decodedValue);
    List<Map<String, dynamic>> mapsList = list.map((e) {
      return ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(e);
    }).toList();
    mapsList.removeWhere((element) => element.isEmpty);

    if (mapsList.isNotEmpty) {
      return mapsList.map((Map<String, dynamic> map) {
        return ContentProgressSummaryDataModel.fromJson(map);
      }).toList();
    } else {
      return null;
    }
  }

  //endregion

  //region Prerequisite Model
  static PrerequisiteDetailResponseModel? parsePrerequisiteDetailDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return PrerequisiteDetailResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static AssociatedContentResponseModel? parseAssociatedContentDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AssociatedContentResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  // region Event
  static EventSessionDataResponseModel? parseEventSessionDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return EventSessionDataResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static ReEnrollmentHistoryResponseModel? parseReEnrollmentHistoryResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ReEnrollmentHistoryResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  // region Content Details Module
  static CourseDTOModel? parseCourseDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return CourseDTOModel.fromMap(json);
    } else {
      return null;
    }
  }

  static CourseDetailsScheduleDataResponseModel? parseCourseDetailsScheduleDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return CourseDetailsScheduleDataResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  //endregion

  //region Event Track
  static EventTrackHeaderDTOModel? parseEventTrackHeaderDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return EventTrackHeaderDTOModel.fromJson(json);
    } else {
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

    if (json.isNotEmpty) {
      return EventTrackResourceResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static TrackListViewDataResponseModel? parseTrackListViewDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return TrackListViewDataResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static ResourceContentDTOModel? parseResourceContentDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ResourceContentDTOModel.fromMap(json);
    } else {
      return null;
    }
  }

  //endregion

  // region Discussion
  static ForumListingDTOResponseModel? parseForumListingDTOResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ForumListingDTOResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static List<ForumUserInfoModel>? parseForumUserInfoList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => ForumUserInfoModel.fromJson(e)).toList();
  }

  static DiscussionTopicDTOResponseModel? parseDiscussionTopicResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return DiscussionTopicDTOResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static RepliesDTOModel? parseRepliesDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return RepliesDTOModel.fromJson(json);
    } else {
      return null;
    }
  }

  static ForumModel? parseForumResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ForumModel.fromJson(json);
    } else {
      return null;
    }
  }

  static CategoriesDtoModel? parseCategoriesDtoResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return CategoriesDtoModel.fromMap(json);
    } else {
      return null;
    }
  }

  static List<TopicCommentModel>? parseTopicCommentsResponseModel({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    MyPrint.logOnConsole("decodedValue :  $mapsList");
    return mapsList.map((e) => TopicCommentModel.fromJson(e)).toList();
  }

  static List<ForumUserInfoModel>? parseUserLikedListResponseModel({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    MyPrint.logOnConsole("decodedValue :  $mapsList");
    return mapsList.map((e) => ForumUserInfoModel.fromJson(e)).toList();
  }

  //endregion

  // region MyConnection
  static PeopleListingDTOResponseModel? parsePeopleListingDTOResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return PeopleListingDTOResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  //region Messages
  static ChatUsersListResponseModel? parseChatUsersListResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ChatUsersListResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  static UserComingSoonResponse? parseUserComingSoonResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return UserComingSoonResponse.fromJson(json);
    } else {
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

    if (json.isNotEmpty) {
      return ResponseDTOModel.fromJson(json);
    } else {
      return null;
    }
  }

  //region Course Launch
  static ContentStatusResponseModel? parseContentStatusResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ContentStatusResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion

  // region Catalog Module
  static AddAssociatedContentToMyLearningResponseModel? parseAddAssociatedContentToMyLearningResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AddAssociatedContentToMyLearningResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static EnrollWaitingListEventResponseModel? parseEnrollWaitingListEventResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return EnrollWaitingListEventResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static AddExpiredEventToMyLearningResponseModel? parseAddExpiredEventToMyLearningResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AddExpiredEventToMyLearningResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  //endregion
  // region Catalog Module
  static PageNotesResponseModel? parsePageNoteResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return PageNotesResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

//endregion

// region ARModule
  static ARContentModel? parseARContentModel({required dynamic decodedValue}) {
    List<Map<String, dynamic>> json = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ARContentModel.fromJson(json);
    } else {
      return null;
    }
  }

// endregion

//region InApp Purchase
  static EcommerceProcessPaymentResponseModel? parseEcommerceProcessPaymentResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return EcommerceProcessPaymentResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static EcommerceOrderResponseModel? parseEcommerceOrderResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return EcommerceOrderResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

//endregion

// region Membership
  static List<MemberShipDTOModel> parseMemberShipDTOModelList({required dynamic decodedValue}) {
    return ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue).map((e) => MemberShipDTOModel.fromMap(e)).toList();
  }

  static UserActiveMembershipResponseModel? parseUserActiveMembershipResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return UserActiveMembershipResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

//endregion

// region Gamification
  static List<GamesDTOModel> parseGamesDTOModelList({required dynamic decodedValue}) {
    return ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue).map((e) => GamesDTOModel.fromMap(e)).toList();
  }

  static UserAchievementDTOModel? parseUserAchievementDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return UserAchievementDTOModel.fromMap(json);
    } else {
      return null;
    }
  }

  static LeaderBoardDTOModel? parseLeaderBoardDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return LeaderBoardDTOModel.fromMap(json);
    } else {
      return null;
    }
  }

  static ContentGameActivityResponseModel? parseContentGameActivityResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return ContentGameActivityResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

//endregion

  //region Feedback
  static List<FeedbackDtoModel>? parseFeedbackDTOList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => FeedbackDtoModel.fromJson(e)).toList();
  }

  //region

  //region CommonResponseModel
  static List<CommonResponseModel>? parseCommonResponseModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => CommonResponseModel.fromJson(e)).toList();
  }

  //region
  // region AskTheExpertDtoModel
  static AskTheExpertDto? parseAskTheExpertDtoModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AskTheExpertDto.fromJson(json);
    } else {
      return null;
    }
  }

  static AnswerCommentDTOModel? parseAnswerCommentDTOModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AnswerCommentDTOModel.fromJson(json);
    } else {
      return null;
    }
  }

  static QuestionListDtoResponseModel? parseQuestionListDtoModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return QuestionListDtoResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static AddQuestionResponseModel? parseAddQuestionResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AddQuestionResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static FilterUserSkillsDtoResponseModel? parseFilterUserSkillsDtoResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return FilterUserSkillsDtoResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static UserQuestionSkillsResponseModel? parseUserQuestionSkillsResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return UserQuestionSkillsResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  //region

//region
  static List<ConsolidatedGroupDTO>? parseMyProgressReportDTOModel({required dynamic decodedValue}) {
    return ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue).map((e) => ConsolidatedGroupDTO.fromJson(e)).toList();
  }

//endregion

//region LearningCommunitiesModel

  static LearningCommunitiesDtoModel? parseLearningCommunitiesDtoResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return LearningCommunitiesDtoModel.fromJson(json);
    } else {
      return null;
    }
  }

//endregion

//region Global Search
  static GlobalSearchComponentResponseModel? parseGlobalSearchComponentResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return GlobalSearchComponentResponseModel.fromJson(json);
    } else {
      return null;
    }
  }

  static GlobalSearchDTOModel? parseGlobalSearchDtoResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return GlobalSearchDTOModel.fromMap(json);
    } else {
      return null;
    }
  }
//endregion

  static GetCourseTrackingDataResponseModel? parseGetCourseTrackingDataResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return GetCourseTrackingDataResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static GeneratedFlashcardResponseModel? parseGeneratedFlashcardResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return GeneratedFlashcardResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static AvtarResponseModel? parseAvatarResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AvtarResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static List<AvtarVoiceModel>? parseAvatarVoiceList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => AvtarVoiceModel.fromJson(e)).toList();
  }

  static AssessmentGenerateContentResponseModel? parseAssessmentGenerateContentResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    if (json.isNotEmpty) {
      return AssessmentGenerateContentResponseModel.fromMap(json);
    } else {
      return null;
    }
  }

  static GenerateAssessmentResponseModel parseGenerateAssessmentResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    return GenerateAssessmentResponseModel.fromMap(json);
  }

  static List<GenerateAssessmentResponseModel>? parseGenerateAssessmentResponseModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);

    if (mapsList.isNotEmpty) {
      return mapsList.map((e) => GenerateAssessmentResponseModel.fromMap(e)).toList();
    } else {
      return null;
    }
  }

  static List<BackgroundColorModel>? parseBackgroundColorList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => BackgroundColorModel.fromJson(e)).toList();
  }

  static List<VideoDetails>? parseVideoDetailList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => VideoDetails.fromJson(e)).toList();
  }

  static List<LanguageModel>? parseLanguageList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => LanguageModel.fromJson(e)).toList();
  }

  static List<LanguageVoiceModel>? parseLanguageVoiceList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => LanguageVoiceModel.fromJson(e)).toList();
  }

  static SpeakingStyleModel parseSpeakingStyle({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    return SpeakingStyleModel.fromMap(json);
  }

  static List<CourseDTOModel> parseCourseDtoModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => CourseDTOModel.fromMap(e)).toList();
  }

  static List<CourseDTOModel> parseCoCreateToCourseDtoModelList({required dynamic decodedValue}) {
    List<Map<String, dynamic>> mapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(decodedValue);
    return mapsList.map((e) => CourseDTOModel.fromCoCreateModelMap(e)).toList();
  }

  static NativeAuthoringGetResourcesResponseModel parseNativeAuthoringGetResourcesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    return NativeAuthoringGetResourcesResponseModel.fromMap(json);
  }

  static NativeAuthoringGetModuleNamesResponseModel parseNativeAuthoringGetModuleNamesResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    return NativeAuthoringGetModuleNamesResponseModel.fromMap(json);
  }

  static ArticleResponseModel parseArticleResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> json = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(decodedValue);

    return ArticleResponseModel.fromMap(json);
  }
}

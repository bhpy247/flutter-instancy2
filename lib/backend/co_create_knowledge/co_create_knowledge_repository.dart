import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/request_model/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/assessment_generate_content_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/generate_assessment_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/assessment_generate_content_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/generate_assessment_response_model.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CoCreateKnowledgeRepository {
  final ApiController apiController;

  const CoCreateKnowledgeRepository({required this.apiController});

  Future<DataResponseModel<List<CourseDTOModel>>> getMyKnowledgeList({required int componentId, required int componentInstanceId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.fileUploadControlModel,
      url: apiEndpoints.apiGetFileUploadControl(
        componentInstanceId: ParsingHelper.parseStringMethod(componentInstanceId),
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        locale: apiUrlConfigurationProvider.getLocale(),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> aiAgentModel = {
      "Expired": "",
      "ContentStatus": " <span title='In Progress' class='statusInprogress'>In Progress</span>",
      "ReportLink": "",
      "DiscussionsLink": "",
      "CertificateLink": "",
      "NotesLink": "",
      "CancelEventLink": "",
      "DownLoadLink": "",
      "RepurchaseLink": "",
      "SetcompleteLink": "<a id='setcomplete_48cd7d6d-9edc-4451-93de-bd3fbc2d0319' title='Set Complete'\">Set Complete</a>",
      "ViewRecordingLink": "",
      "InstructorCommentsLink": "",
      "Required": 0,
      "DownloadCalender": "",
      "EventScheduleLink": "",
      "EventScheduleStatus": "",
      "EventScheduleConfirmLink": "",
      "EventScheduleCancelLink": "",
      "EventScheduleReserveTime": "",
      "EventScheduleReserveStatus": "",
      "ReScheduleEvent": "",
      "Addorremoveattendees": "",
      "CancelScheduleEvent": "",
      "Sharelink": "https://enterprisedemo.instancy.com/InviteURLID/contentId/48cd7d6d-9edc-4451-93de-bd3fbc2d0319/ComponentId/1",
      "SurveyLink": "",
      "RemoveLink":
          "<a id='remove_48cd7d6d-9edc-4451-93de-bd3fbc2d0319' title='Delete' href=\"Javascript:fnUnassignUserContent('48cd7d6d-9edc-4451-93de-bd3fbc2d0319','Are you sure you want to remove the content item?');\">Delete</a> ",
      "RatingLink": "https://enterprisedemo.instancy.com/MyCatalog Details/Contentid/48cd7d6d-9edc-4451-93de-bd3fbc2d0319/componentid/3/componentInstanceID/4234/Muserid/420",
      "DurationEndDate": null,
      "PracticeAssessmentsAction": "",
      "CreateAssessmentAction": "",
      "OverallProgressReportAction": "",
      "EditLink": "",
      "TitleName": "Office Ergonomics",
      "PercentCompleted": 50.0,
      "PercentCompletedClass": "statusInprogress",
      "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
      "CancelOrderData": "",
      "CombinedTransaction": false,
      "EventScheduleType": 0,
      "TypeofEvent": 1,
      "Duration": "",
      "IsViewReview": false,
      "JWVideoKey": "",
      "Credits": "",
      "IsArchived": false,
      "DetailspopupTags": "",
      "ThumbnailIconPath": null,
      "InstanceEventEnroll": "",
      "Modules": "",
      "InstanceEventReSchedule": "",
      "InstanceEventReclass": "",
      "isEnrollFutureInstance": "",
      "ReEnrollmentHistory": "",
      "isBadCancellationEnabled": "true",
      "MediaTypeID": 0,
      "ActionViewQRcode": "",
      "RecordingDetails": null,
      "EnrollmentLimit": null,
      "AvailableSeats": null,
      "NoofUsersEnrolled": null,
      "WaitListLimit": null,
      "WaitListEnrolls": null,
      "isBookingOpened": false,
      "SubSiteMemberShipExpiried": false,
      "ShowLearnerActions": true,
      "SkinID": "0",
      "BackGroundColor": "#2f2d3a",
      "FontColor": "#fff",
      "FilterId": 0,
      "SiteId": 374,
      "UserSiteId": 0,
      "SiteName": null,
      "ContentTypeId": 697,
      "ContentID": "48cd7d6d-9edc-4451-93de-bd3fbc2d0319",
      "Title": "/Content/PublishFiles/chatbotplayer.html?CourseBotID=48cd7d6d-9edc-4451-93de-bd3fbc2d0319&v=1424228854",
      "TotalRatings": null,
      "RatingID": "0",
      "ShortDescription":
          "Office Ergonomics refers to making sure that there's a perfect fit between a product, the purpose it's used for, and the person using it. In an office setting, ergonomics relates to items such as chairs, desks, monitor stands and other elements that comprise an employee's workstation.",
      "ThumbnailImagePath": "/Content/PublishFiles/Images/97ef0b44-4c70-4414-93a9-45369689a4fc/440de296-a2e7-49fb-9445-ebfd3f3e6bd2.png",
      "InstanceParentContentID": "",
      "ImageWithLink": null,
      "AuthorWithLink": "Peter Kilne",
      "EventStartDateTime": null,
      "EventEndDateTime": null,
      "EventStartDateTimeWithoutConvert": null,
      "EventEndDateTimeTimeWithoutConvert": null,
      "expandiconpath": null,
      "AuthorDisplayName": "Peter Kilne",
      "ContentType": "Chatbot",
      "CreatedOn": "07/24/2023",
      "TimeZone": null,
      "Tags": null,
      "SalePrice": null,
      "Currency": null,
      "ViewLink": "/Content/PublishFiles/chatbotplayer.html?CourseBotID=48cd7d6d-9edc-4451-93de-bd3fbc2d0319&v=585916780",
      "DetailsLink": "https://enterprisedemo.instancy.com/MyCatalog Details/Contentid/48cd7d6d-9edc-4451-93de-bd3fbc2d0319/componentid/3/componentInstanceID/4234/Muserid/420",
      "RelatedContentLink": "",
      "ViewSessionsLink": "",
      "SuggesttoConnLink": "48cd7d6d-9edc-4451-93de-bd3fbc2d0319",
      "SuggestwithFriendLink": "48cd7d6d-9edc-4451-93de-bd3fbc2d0319",
      "SharetoRecommendedLink": null,
      "IsCoursePackage": null,
      "IsRelatedcontent": "",
      "isaddtomylearninglogo": null,
      "LocationName": null,
      "BuildingName": null,
      "JoinURL": null,
      "Categorycolor": "#ED1F62",
      "InvitationURL": null,
      "HeaderLocationName": "none",
      "SubSiteUserID": null,
      "PresenterDisplayName": "",
      "PresenterWithLink": null,
      "ShowMembershipExpiryAlert": false,
      "AuthorName": "Peter Kilne",
      "FreePrice": null,
      "SiteUserID": 420,
      "ScoID": 15035,
      "BuyNowLink": "",
      "bit5": false,
      "bit4": false,
      "OpenNewBrowserWindow": false,
      "salepricestrikeoff": "",
      "CreditScoreWithCreditTypes": null,
      "CreditScoreFirstPrefix": null,
      "EventType": 0,
      "InstanceEventReclassStatus": "",
      "ExpiredContentExpiryDate": "",
      "ExpiredContentAvailableUntill": "",
      "Gradient1": null,
      "Gradient2": null,
      "GradientColor": null,
      "ShareContentwithUser": "",
      "bit1": false,
      "ViewType": 2,
      "startpage": "",
      "CategoryID": 0,
      "AddLinkTitle": null,
      "GoogleProductId": null,
      "ItunesProductId": null,
      "ContentName": "Office Ergonomics",
      "FolderPath": "48CD7D6D-9EDC-4451-93DE-BD3FBC2D0319",
      "CloudMediaPlayerKey": "",
      "ActivityId": "http://instancy.com/48cd7d6d-9edc-4451-93de-bd3fbc2d0319",
      "ActualStatus": "incomplete",
      "CoreLessonStatus": " <span title='In Progress' class='statusInprogress'>In Progress</span>",
      "jwstartpage": "en-us/48cd7d6d-9edc-4451-93de-bd3fbc2d0319.html",
      "IsReattemptCourse": false,
      "AttemptsLeft": 0,
      "TotalAttempts": 0,
      "ListPrice": null,
      "ContentModifiedDateTime": "07/24/2023 03:18:39 PM"
    };
    CourseDTOModel aiAgentCourseModel = CourseDTOModel.fromMap(aiAgentModel);
    // aiAgentCourseModel.ContentTypeId = InstancyObjectTypes.aiAgent;
    aiAgentCourseModel.ContentType = "Ai Agents";
    aiAgentCourseModel.ContentName = "Office Ergonomics";
    aiAgentCourseModel.Title = "Office Ergonomics";
    // DataResponseModel<List<CourseDTOModel>> apiResponseModel = await apiController.callApi<List<CourseDTOModel>>(
    //   apiCallModel: apiCallModel,
    // );
    DataResponseModel<List<CourseDTOModel>> apiResponseModel = DataResponseModel<List<CourseDTOModel>>(
      data: [
        CourseDTOModel(
          Title: "Large Language Models: A Deep Dive into their Functionality and Impact",
          TitleName: "Large Language Models: A Deep Dive into their Functionality and Impact",
          ContentName: "Large Language Models: A Deep Dive into their Functionality and Impact",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.article,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Article",
          ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FLLM%20(1).jpg?alt=media&token=ea35d96c-029d-422e-918d-ddbb9d138a3f",
          ShortDescription: "Explore the inner workings and profound influence of these advanced linguistic systems, reshaping how we interact with information and technology.",
        ),
        CourseDTOModel(
          Title: "Generative AI and its Transformative Potential",
          TitleName: "Generative AI and its Transformative Potential",
          ContentName: "Generative AI and its Transformative Potential",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.referenceUrl,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Reference Link",
          ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FGenerative%20AI%20(1).jpg?alt=media&token=42d9004b-9dd8-4d30-a889-982996d6cd6d",
          ShortDescription: "Uncover the revolutionary capabilities of Generative AI, poised to reshape industries and creative expression with its innovative potential.",
        ),
        CourseDTOModel(
          Title: "AI Agents Memory and Personalize Learning",
          TitleName: "AI Agents Memory and Personalize Learning",
          ContentName: "AI Agents Memory and Personalize Learning",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.videos,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Video",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMastering%20Communication%20(1).jpg?alt=media&token=a5031b2e-2f73-4270-b710-6373ede36b4e",
          ShortDescription:
              "Unlock the power of AI agents in personalized learning! This course explores the intricacies of memory systems in AI, guiding you through techniques to tailor learning experiences for individual students. Learn how AI agents adapt content delivery based on learner preferences, track progress, and create personalized pathways. Perfect for educators, AI enthusiasts, and developers looking to revolutionize education with AI.",
        ),
        CourseDTOModel(
          Title: "Artificial Intelligence (AI)",
          TitleName: "Artificial Intelligence (AI)",
          ContentName: "Artificial Intelligence (AI)",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.flashCard,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Flashcards",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FArtificial%20Intelligence%20(1).jpg?alt=media&token=eea140e2-20ec-4077-b42a-ccebd8046624",
          ShortDescription: "Delve into the realm of Artificial Intelligence, where machine learning and cognitive computing converge to redefine the boundaries of human innovation.",
        ),
        CourseDTOModel(
          Title: "AI Note Taker",
          TitleName: "AI Note Taker",
          ContentName: "AI Note Taker",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.podcastEpisode,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Podcast Episode",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FAI%20Note%20Taker%20(1).jpg?alt=media&token=476bc0ba-3fe5-4558-8802-df3273621b83",
          ShortDescription:
              "Experience the future of productivity with an AI-powered note-taking assistant, revolutionizing how information is captured, organized, and accessed for enhanced efficiency and collaboration.",
        ),
        CourseDTOModel(
          Title: "Office Ergonomics",
          TitleName: "Office Ergonomics",
          ContentName: "Office Ergonomics",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.quiz,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Quiz",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FOffice%20Ergonomics%20(1).jpg?alt=media&token=e8b61e56-79d8-4257-bd6e-fdad51d0b9f9",
          ShortDescription: "Discover the science of workplace comfort and efficiency, optimizing your workspace to enhance productivity and well-being through ergonomic principles.",
        ),
        CourseDTOModel(
          Title: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          TitleName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          ContentName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.document,
          MediaTypeID: InstancyMediaTypes.none,
          ViewLink: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
          ContentType: "Documents",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3",
          ShortDescription: "Delve into the dynamic synergy between AI and biotech, uncovering how cutting-edge technology revolutionizes healthcare, agriculture, and beyond.",
        ),
        CourseDTOModel(
          Title: "Customer Query Resolution",
          TitleName: "Customer Query Resolution",
          ContentName: "Customer Query Resolution",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.rolePlay,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Roleplay",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FCustomer%20Query%20Resolution.jpg?alt=media&token=ad125e85-2d39-42cc-b5af-2107a1159f5c",
          ShortDescription:
              "Efficiently address customer inquiries and concerns with personalized assistance and comprehensive solutions, ensuring satisfaction and fostering positive relationships through prompt and effective communication.",
        ),
        CourseDTOModel(
          Title: "Mastering Coding Languages",
          TitleName: "Mastering Coding Languages",
          ContentName: "Mastering Coding Languages",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.learningMaps,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Learning Maps",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMasteringCoding%20Languages.jpg?alt=media&token=49e7113e-e4fe-4905-9c48-0c385e5423f7",
          ShortDescription:
              "Embark on a journey to programming proficiency, mastering the syntax and semantics of coding languages to unlock endless possibilities in software development and innovation.",
        ),
        aiAgentCourseModel,
        // CourseDTOModel(
        //   Title: "AI Learning",
        //   TitleName: "AI Learning",
        //   ContentName: "AI Learning",
        //   AuthorName: "Richard Parker",
        //   AuthorDisplayName: "Richard Parker",
        //   UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        //   ContentTypeId: InstancyObjectTypes.aiAgent,
        //   MediaTypeID: InstancyMediaTypes.none,
        //   ContentType: "AI Agents",
        //   ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FAI%20Learning.jpg?alt=media&token=c9aff7c7-d860-4a84-8bc2-4900ffaf7b5e",
        //   ShortDescription:
        //       "Dive into the world of Artificial Intelligence (AI) with this comprehensive program. Explore key concepts, algorithms, and applications to develop the skills needed for success in this dynamic field.",
        // ),
        CourseDTOModel(
          Title: "Certification in Economic Growth and Development",
          TitleName: "Certification in Economic Growth and Development",
          ContentName: "Certification in Economic Growth and Development",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.events,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Events",
          ThumbnailImagePath: "/Content/SiteFiles/Images/Event.jpg",
          ShortDescription: "Unleash the potential of nations through economic growth and development",
          EventStartDateTime: "30 May 2024",
          EventStartDateTimeWithoutConvert: "05/30/2024 05:30:00 PM",
          EventEndDateTime: "30 May 2024",
          EventEndDateTimeTimeWithoutConvert: "05/30/2024 06:00:00 PM",
          Duration: "30 Minutes",
          AvailableSeats: "10",
        ),
        CourseDTOModel(
          Title: "Technology in Sustainable Urban Planning",
          TitleName: "Technology in Sustainable Urban Planning",
          ContentName: "Technology in Sustainable Urban Planning",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.learningPath,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Learning Path",
          ThumbnailImagePath: "/Content/SiteFiles/Images/Event.jpg",
          ShortDescription: "It explores the integration of advanced technologies in designing and managing urban environments to promote sustainability.",
          // EventStartDateTime: "30 May 2024",
          // EventStartDateTimeWithoutConvert: "05/30/2024 05:30:00 PM",
          // EventEndDateTime: "30 May 2024",
          // EventEndDateTimeTimeWithoutConvert: "05/30/2024 06:00:00 PM",
          // Duration: "30 Minutes",
          // AvailableSeats: "10",
        ),
        CourseDTOModel(
          Title: "Technology in Sustainable Urban Planning",
          TitleName: "Technology in Sustainable Urban Planning",
          ContentName: "Technology in Sustainable Urban Planning",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.microLearning,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Microlearning",
          ThumbnailImagePath: "/Content/SiteFiles/Images/Event.jpg",
          ShortDescription: "It explores the integration of advanced technologies in designing and managing urban environments to promote sustainability.",
        ),
      ],
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<String>>> generateImage({required GenerateImagesRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.StringList,
      url: apiEndpoints.GenerateImages(),
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
    );

    DataResponseModel<List<String>> apiResponseModel = await apiController.callApi<List<String>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> CreateNewContentItem({required CreateNewContentItemRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.Files != null) {
      files.addAll(requestModel.Files!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.CreateNewContentItem(),
      fields: requestModel.toMap(),
      files: files,
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
      isDecodeResponse: false,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<GeneratedFlashcardResponseModel>> generateFlashcard({required FlashcardRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.GeneratedFlashcardResponseModel,
      url: apiEndpoints.GenerateFlashCard(),
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
    );

    DataResponseModel<GeneratedFlashcardResponseModel> apiResponseModel = await apiController.callApi<GeneratedFlashcardResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> chatCompletionCall({required String prompt}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    Map<String, dynamic> requestModel = {"Prompt": prompt};

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.ChatCompletionCall(),
      requestBody: MyUtils.encodeJson(requestModel),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
      isDecodeResponse: false,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<AssessmentGenerateContentResponseModel>> assessmentGenerateContent({required AssessmentGenerateContentRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.AssessmentGenerateContentResponseModel,
      url: apiEndpoints.AssessmentGenerateContent(),
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
      isDecodeResponse: true,
    );

    DataResponseModel<AssessmentGenerateContentResponseModel> apiResponseModel = await apiController.callApi<AssessmentGenerateContentResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<GenerateAssessmentResponseModel>> generateAssessment({required GenerateAssessmentRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.GenerateAssessmentResponseModel,
      url: apiEndpoints.GenerateAssessment(),
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
      isDecodeResponse: true,
    );

    DataResponseModel<GenerateAssessmentResponseModel> apiResponseModel = await apiController.callApi<GenerateAssessmentResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<AvtarResponseModel>> getAllAvtarList() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.AvtarResponseModel,
      url: apiEndpoints.GetAllAvtarList(),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
    );

    DataResponseModel<AvtarResponseModel> apiResponseModel = await apiController.callApi<AvtarResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<List<AvtarVoiceModel>>> getAvtarVoiceList() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.AvatarVoiceList,
      url: apiEndpoints.GetAvtarVoiceList(),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
    );

    DataResponseModel<List<AvtarVoiceModel>> apiResponseModel = await apiController.callApi<List<AvtarVoiceModel>>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<List<BackgroundColorModel>>> getBackgroundColorList() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.BackgroundColorModelList,
      url: apiEndpoints.GetBackgroundColorList(),
      isAuthenticatedApiCall: false,
      isInstancyCall: false,
    );

    DataResponseModel<List<BackgroundColorModel>> apiResponseModel = await apiController.callApi<List<BackgroundColorModel>>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }
}

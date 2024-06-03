import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/thumbnail_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/wiki_component/wiki_controller.dart';
import '../../../backend/wiki_component/wiki_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import '../../../models/wiki_component/response_model/wikiCategoriesModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class CommonCreateAuthoringToolScreen extends StatefulWidget {
  static const String routeName = "/CommonCreateAuthoringScreen";
  final CommonCreateAuthoringToolScreenArgument argument;

  const CommonCreateAuthoringToolScreen({super.key, required this.argument});

  @override
  State<CommonCreateAuthoringToolScreen> createState() => _CommonCreateAuthoringToolScreenState();
}

class _CommonCreateAuthoringToolScreenState extends State<CommonCreateAuthoringToolScreen> with MySafeState {
  bool isLoading = false;

  String appBarTitle = "";

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();
  String selectedCategoriesString = "";
  List<WikiCategoryTable> selectedCategoriesList = [];
  String thumbNailName = "";
  Uint8List? thumbNailBytes;
  late WikiProvider wikiProvider;
  late WikiController wikiController;
  bool isExpanded = false;
  final GlobalKey expansionTile = GlobalKey();

  void initializeData() {
    coCreateContentAuthoringModel = CoCreateContentAuthoringModel();
    coCreateContentAuthoringModel.contentTypeId = widget.argument.objectTypeId;

    if (widget.argument.courseDtoModel != null) {
      CourseDTOModel courseDTOModel = widget.argument.courseDtoModel!;

      coCreateContentAuthoringModel.courseDTOModel = widget.argument.courseDtoModel;
      coCreateContentAuthoringModel.isEdit = true;

      coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;
      coCreateContentAuthoringModel.title = courseDTOModel.ContentName;
      coCreateContentAuthoringModel.description = courseDTOModel.ShortDescription;
      coCreateContentAuthoringModel.thumbNailImageBytes = courseDTOModel.thumbNailFileBytes;
      coCreateContentAuthoringModel.skills = courseDTOModel.Skills;

      coCreateContentAuthoringModel.uploadedDocumentBytes = courseDTOModel.uploadedDocumentBytes;
      coCreateContentAuthoringModel.articleHtmlCode = courseDTOModel.articleHtmlCode;
      coCreateContentAuthoringModel.selectedArticleSourceType = courseDTOModel.selectedArticleSourceType;
      coCreateContentAuthoringModel.flashcardContentModel = courseDTOModel.flashcardContentModel;
      coCreateContentAuthoringModel.quizContentModel = courseDTOModel.quizContentModel;
      coCreateContentAuthoringModel.roleplayContentModel = courseDTOModel.roleplayContentModel;
      coCreateContentAuthoringModel.learningPathModel = courseDTOModel.learningPathModel;
      coCreateContentAuthoringModel.microLearningModel = courseDTOModel.microLearningModel;

      titleController.text = coCreateContentAuthoringModel.title;
      descriptionController.text = coCreateContentAuthoringModel.description;
      thumbNailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      List<WikiCategoryTable> list = wikiProvider.wikiCategoriesList;
      for (String skill in coCreateContentAuthoringModel.skills) {
        WikiCategoryTable? model = list.where((element) => element.name == skill).firstOrNull;
        if (model != null) {
          selectedCategoriesList.add(model);
        }
      }
      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: selectedCategoriesList.map((e) => e.name).toList(),
        separator: ", ",
      );
    } else {
      Map<String, dynamic> map = <String, dynamic>{
        "Titlewithlink": "",
        "rcaction": "",
        "Categories": "",
        "IsSubSite": "False",
        "MembershipName": "",
        "EventAvailableSeats": "",
        "EventCompletedProgress": "",
        "EventContentProgress": "",
        "Count": 0,
        "PreviewLink": "",
        "ApproveLink": "",
        "RejectLink": "",
        "ReadLink": "",
        "AddLink": "javascript:fnAddItemtoMyLearning('7d659fde-70a4-4b30-a1f4-62f709ed3786');",
        "EnrollNowLink": "",
        "CancelEventLink": "",
        "WaitListLink": "",
        "InapppurchageLink": "",
        "AlredyinmylearnigLink": "",
        "RecommendedLink": "",
        "Sharelink": "https://enterprisedemo.instancy.com/InviteURLID/contentId/7d659fde-70a4-4b30-a1f4-62f709ed3786/ComponentId/1",
        "EditMetadataLink": "",
        "ReplaceLink": "",
        "EditLink": "",
        "DeleteLink": "",
        "SampleContentLink": "",
        "TitleExpired": "",
        "PracticeAssessmentsAction": "",
        "CreateAssessmentAction": "",
        "OverallProgressReportAction": "",
        "ContentName": "Test 3",
        "ContentScoID": "15342",
        "isContentEnrolled": "False",
        "ContentViewType": "Subscription",
        "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
        "isWishListContent": 0,
        "AddtoWishList": "Y",
        "RemoveFromWishList": null,
        "Duration": "",
        "Credits": "",
        "DetailspopupTags": "",
        "ThumbnailIconPath": "",
        "JWVideoKey": "",
        "Modules": "",
        "salepricestrikeoff": "",
        "isBadCancellationEnabled": "true",
        "EnrollmentLimit": "",
        "AvailableSeats": "0",
        "NoofUsersEnrolled": "1",
        "WaitListLimit": "",
        "WaitListEnrolls": "0",
        "isBookingOpened": false,
        "EventStartDateforEnroll": null,
        "DownLoadLink": "",
        "EventType": 0,
        "EventScheduleType": 0,
        "EventRecording": false,
        "ShowParentPrerequisiteEventDate": false,
        "ShowPrerequisiteEventDate": false,
        "PrerequisiteDateConflictName": null,
        "PrerequisiteDateConflictDateTime": null,
        "SkinID": "6",
        "FilterId": 0,
        "SiteId": 374,
        "UserSiteId": 0,
        "SiteName": "",
        "ContentTypeId": 9,
        "ContentID": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "Title": "Test 3",
        "TotalRatings": "",
        "RatingID": "0",
        "ShortDescription": "",
        "ThumbnailImagePath": "/Content/SiteFiles/Images/Assessment.jpg",
        "InstanceParentContentID": "",
        "ImageWithLink": "",
        "AuthorWithLink": "Richard Parker",
        "EventStartDateTime": "",
        "EventEndDateTime": "",
        "EventStartDateTimeWithoutConvert": "",
        "EventEndDateTimeTimeWithoutConvert": "",
        "expandiconpath": "",
        "AuthorDisplayName": "Richard Parker",
        "ContentType": "Test",
        "CreatedOn": "",
        "TimeZone": "",
        "Tags": "",
        "SalePrice": "",
        "Currency": "",
        "ViewLink": "",
        "DetailsLink": "https://enterprisedemo.instancy.com/Catalog Details/Contentid/7d659fde-70a4-4b30-a1f4-62f709ed3786/componentid/1/componentInstanceID/3131",
        "RelatedContentLink": "",
        "ViewSessionsLink": null,
        "SuggesttoConnLink": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "SuggestwithFriendLink": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "SharetoRecommendedLink": "",
        "IsCoursePackage": "",
        "IsRelatedcontent": "",
        "isaddtomylearninglogo": "0",
        "LocationName": "",
        "BuildingName": null,
        "JoinURL": "",
        "Categorycolor": "#ED1F62",
        "InvitationURL": "",
        "HeaderLocationName": "",
        "SubSiteUserID": null,
        "PresenterDisplayName": "",
        "PresenterWithLink": "",
        "ShowMembershipExpiryAlert": false,
        "AuthorName": null,
        "FreePrice": "",
        "SiteUserID": 363,
        "ScoID": 15342,
        "BuyNowLink": "",
        "bit5": false,
        "bit4": false,
        "OpenNewBrowserWindow": false,
        "CreditScoreWithCreditTypes": "",
        "CreditScoreFirstPrefix": "",
        "MediaTypeID": 27,
        "isEnrollFutureInstance": "",
        "InstanceEventReclass": "",
        "InstanceEventReclassStatus": "",
        "InstanceEventReSchedule": "",
        "InstanceEventEnroll": "",
        "ReEnrollmentHistory": "",
        "BackGroundColor": "#2f2d3a",
        "FontColor": "#fff",
        "ExpiredContentExpiryDate": "",
        "ExpiredContentAvailableUntill": "",
        "Gradient1": "",
        "Gradient2": "",
        "GradientColor": "radial-gradient(circle,  0%,  100%)",
        "ShareContentwithUser": "",
        "bit1": false,
        "ViewType": 2,
        "startpage": "start.html",
        "CategoryID": 0,
        "AddLinkTitle": "Add to My learning",
        "ContentStatus": "",
        "PercentCompletedClass": "",
        "PercentCompleted": "",
        "GoogleProductId": "",
        "ItunesProductId": "",
        "FolderPath": "17e97c34-af58-4a68-b729-988561f53808",
        "CloudMediaPlayerKey": "",
        "ActivityId": "http://instancy.com/assessment/7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "ActualStatus": null,
        "CoreLessonStatus": null,
        "jwstartpage": null,
        "IsReattemptCourse": false,
        "AttemptsLeft": 0,
        "TotalAttempts": 0,
        "ListPrice": "",
        "ContentModifiedDateTime": null
      };

      CourseDTOModel courseDTOModel = CourseDTOModel.fromMap(map);
      courseDTOModel.ContentID = MyUtils.getNewId();
      courseDTOModel.ContentTypeId = coCreateContentAuthoringModel.contentTypeId;
      courseDTOModel.ContentType = switch (coCreateContentAuthoringModel.contentTypeId) {
        InstancyObjectTypes.article => "Article",
        InstancyObjectTypes.rolePlay => "Roleplay",
        InstancyObjectTypes.events => "Event",
        InstancyObjectTypes.document => "Documents",
        InstancyObjectTypes.referenceUrl => "Reference Link",
        InstancyObjectTypes.videos => "Video",
        InstancyObjectTypes.podcastEpisode => "Podcast Episode",
        InstancyObjectTypes.quiz => "Quiz",
        InstancyObjectTypes.flashCard => "Flashcards",
        InstancyObjectTypes.learningPath => "Learning Path",
        InstancyObjectTypes.aiAgent => "AI Agent",
        InstancyObjectTypes.microLearning => "Microlearning",
        _ => "Test",
      };

      courseDTOModel.AuthorName = "Richard Parker";
      courseDTOModel.AuthorName = "Richard Parker";
      courseDTOModel.AuthorDisplayName = "Richard Parker";

      courseDTOModel.ThumbnailImagePath = "Content/SiteFiles/Images/assignment-thumbnail.png";
      courseDTOModel.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";

      coCreateContentAuthoringModel.newCurrentCourseDTOModel = courseDTOModel;
      coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;

      initializeMetadataForNewContentAccordingToType();
    }
  }

  void initializeMetadataForNewContentAccordingToType() {
    String? title;
    String? description;
    String? thumbnailImageUrl;
    List<String>? skills;

    switch (coCreateContentAuthoringModel.contentTypeId) {
      case InstancyObjectTypes.article:
        {
          title = "Biotechnology and Genetic Engineering using AI: A Review";
          description =
              "This field encompasses the use of artificial intelligence (AI), machine learning, robotics, and data analytics to develop smart solutions that can adapt to changing conditions, optimize performance, and automate complex tasks. Applications include predictive maintenance, autonomous systems, smart infrastructure, and intelligent control systems, all aimed at improving decision-making processes, reducing costs, and increasing the overall effectiveness of engineering projects.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FIntelligent%20Systems%20And%20Applications%20In%20Engineering.jpeg?alt=media&token=af5618ca-7afd-4469-bf8a-ed7b5917a0d7";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.rolePlay:
        {
          title = "Customer Query Resolution";
          description =
              "It involves the efficient and effective handling of customer inquiries, concerns, and issues. This process ensures that customer questions are answered promptly, problems are resolved satisfactorily, and customer satisfaction is maintained. Utilizing a combination of trained support staff, clear communication channels, and robust problem-solving strategies, Customer Query Resolution aims to enhance the overall customer experience and foster loyalty by addressing their needs with care and professionalism.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FCustomer%20Query%20Resolution.avif?alt=media&token=e259b727-4c1b-489e-8e3b-9e71edccef57";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.events:
        {
          title = "Certification in Economic Growth and Development";
          description =
              "This certification covers key concepts, theories, and practical strategies for fostering economic growth, addressing income inequality, and promoting sustainable practices. Ideal for professionals, policymakers, and students, the program offers valuable insights into the economic policies and development strategies that can transform societies and improve living standards. Participants will gain the analytical skills and knowledge necessary to contribute effectively to the field of economic development.";
          thumbnailImageUrl = "/Content/SiteFiles/Images/Event.jpg";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.document:
        {
          title = "Identifying and Addressing Ergonomic Hazards Workbook";
          description =
              "It provides practical guidance on identifying potential risks associated with poor ergonomics, such as musculoskeletal disorders, repetitive strain injuries, and general discomfort. The workbook includes step-by-step instructions, checklists, and interactive exercises to assess ergonomic setups and implement effective solutions.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FIdentifying%20and%20Addressing.png?alt=media&token=6ded5bc1-e599-4b5a-ba20-ef15d402e9f1";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.referenceUrl:
        {
          title = "An Introduction to Generative AI and its Transformative Potential for Enterprises";
          description =
              "This insightful guide explores the innovative field of generative AI, highlighting its capacity to revolutionize various business sectors. It delves into how enterprises can leverage generative AI to enhance creativity, optimize operations, and drive growth. By providing practical examples and industry-specific applications, this introduction offers a comprehensive overview of the transformative impact generative AI can have on modern businesses, making it an essential read for professionals seeking to harness the power of this cutting-edge technology.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FAn%20introduction%20to%20Generative%20AI%20and%20its%20Transformative%20potential%20for%20Enterprises.png?alt=media&token=11ef17a1-7224-41d6-b9ad-0d4894b7fdba";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.videos:
        {
          break;
        }
      case InstancyObjectTypes.podcastEpisode:
        {
          title = "Refining Communication";
          description =
              "It is a comprehensive guide designed to enhance your interpersonal skills and communication techniques. This book delves into the core principles of effective communication, offering practical strategies for improving clarity, empathy, and understanding in both personal and professional interactions. Whether you're looking to strengthen your relationships, excel in your career, or simply become a more effective communicator, \"Refining Communication\" provides the tools and insights you need to succeed.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FRefinig%20Communication.jpg?alt=media&token=5b6141a8-a7f2-4d32-a772-c90c630dc2e6";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.quiz:
        {
          title = "Office Ergonomics";
          description =
              "It focuses on designing and arranging workspaces to fit the needs and capabilities of employees, promoting comfort, efficiency, and well-being. It involves optimizing furniture, equipment, and work practices to prevent strain and injury, enhancing productivity and overall job satisfaction. Key elements include adjustable chairs, desks, monitor placement, proper lighting, and keyboard and mouse positioning. By applying ergonomic principles, businesses can create healthier, more supportive work environments that reduce the risk of musculoskeletal disorders and improve employee performance.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FOffice%20Ergonomics.jpeg?alt=media&token=e1b10d9c-11d1-4e66-9cb1-34f2a0d2054d";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.flashCard:
        {
          title = "Unveiling the Neurons of AI";
          description =
              "Unveiling the Neurons of AI explores the intricate mechanisms and inner workings of artificial intelligence systems, drawing parallels to the human brain's neural networks. This title delves into the foundational algorithms, the architecture of neural networks, and the latest advancements in AI technology, revealing how these artificial 'neurons' process information, learn, and make decisions. Through this exploration, readers gain insight into the complexity and potential of AI, demystifying the science behind the machines shaping our future.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FUnveiling%20the%20Neurons%20of%20Alsss.jpeg?alt=media&token=c1a1d2ba-8b71-4b2b-90cd-005db53eb984";
          skills = ["Customer Service"];

          break;
        }

      case InstancyObjectTypes.learningPath:
        {
          title = "Artificial Intelligence: Transforming the Modern World";
          description =
              "Artificial Intelligence (AI) is at the forefront of a technological revolution that is reshaping every aspect of our modern world. From healthcare to finance, education to entertainment, AI's impact is profound and far-reaching. This comprehensive exploration delves into how AI technologies are transforming industries, enhancing efficiencies, and driving innovation.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FlearningPathThumbnail.png?alt=media&token=6aa46e14-3a64-4b67-bb78-18868c1fa415";
          skills = ["Customer Service"];

          break;
        }
      case InstancyObjectTypes.microLearning:
        {
          title = "Technology in Sustainable Urban Planning";
          description =
              "Technology in Sustainable Urban Planning explores the integration of innovative technologies to create environmentally friendly, resilient, and efficient urban spaces. It focuses on smart solutions such as green infrastructure, renewable energy, IoT-enabled city management, and data-driven approaches to enhance the quality of life, reduce environmental impact, and promote sustainable development in urban areas.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FlearningPathThumbnail.png?alt=media&token=6aa46e14-3a64-4b67-bb78-18868c1fa415";
          skills = ["Customer Service"];

          break;
        }
      default:
        {
          break;
        }
    }

    if (title != null) titleController.text = title;
    if (description != null) descriptionController.text = description;
    if (thumbnailImageUrl != null) coCreateContentAuthoringModel.newCurrentCourseDTOModel?.ThumbnailImagePath = thumbnailImageUrl;

    if (skills != null) {
      selectedCategoriesList.clear();
      List<WikiCategoryTable> list = wikiProvider.wikiCategoriesList;
      for (String skill in skills) {
        WikiCategoryTable? model = list.where((element) => element.name == skill).firstOrNull;
        if (model != null) {
          selectedCategoriesList.add(model);
        }
      }
      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: selectedCategoriesList.map((e) => e.name).toList(),
        separator: ", ",
      );
    }
  }

  String setAppBarTitle(int objectTypeId) {
    bool isEdit = widget.argument.courseDtoModel != null ? true : false;
    if (objectTypeId == InstancyObjectTypes.flashCard) {
      return isEdit ? "Edit Flashcard" : "Create Flashcard";
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      return isEdit ? "Edit Roleplay" : "Create Roleplay";
    } else if (objectTypeId == InstancyObjectTypes.podcastEpisode) {
      return isEdit ? "Edit PodCast Episode" : "Create Podcast Episode";
    } else if (objectTypeId == InstancyObjectTypes.referenceUrl) {
      return isEdit ? "Edit Reference Url" : "Create Reference Url";
    } else if (objectTypeId == InstancyObjectTypes.document) {
      return isEdit ? "Edit Document" : "Create Document";
    } else if (objectTypeId == InstancyObjectTypes.videos) {
      return isEdit ? "Edit Video" : "Create Video";
    } else if (objectTypeId == InstancyObjectTypes.quiz) {
      return isEdit ? "Edit Quiz" : "Create Quiz";
    } else if (objectTypeId == InstancyObjectTypes.article) {
      return isEdit ? "Edit Article" : "Create Article";
    } else if (objectTypeId == InstancyObjectTypes.events) {
      return isEdit ? "Edit Event" : "Create Event";
    } else if (objectTypeId == InstancyObjectTypes.learningPath) {
      return isEdit ? "Edit Learning Path" : "Create Learning Path";
    } else if (objectTypeId == InstancyObjectTypes.aiAgent) {
      return isEdit ? "Edit AI Agent" : "Create AI Agent";
    } else if (objectTypeId == InstancyObjectTypes.microLearning) {
      return isEdit ? "Edit Microlearning" : "Create Microlearning";
    } else {
      return "";
    }
  }

  void onNextTap(int objectTypeId) {
    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.skills = selectedCategoriesList.map((e) => e.name).toList();
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;

    if (objectTypeId == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToAddEditFlashcardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: AddEditFlashcardScreenNavigationArguments(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.podcastEpisode) {
      NavigationController.navigateToCreatePodcastSourceSelectionScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const CreatePodcastSourceSelectionScreenNavigationArguments(
          courseDtoModel: null,
          componentId: 0,
          componentInsId: 0,
          isEdit: false,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.referenceUrl) {
      NavigationController.navigateToReferenceLinkScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        // argument: const AddEditReferenceScreenArguments(componentId: 0, componentInsId: 0),
      );
    } else if (objectTypeId == InstancyObjectTypes.document) {
      NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditDocumentScreenArguments(componentId: 0, componentInsId: 0),
      );
    } else if (objectTypeId == InstancyObjectTypes.videos) {
      NavigationController.navigateToAddEditVideoScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: const AddEditVideoScreenArgument(),
      );
    } else if (objectTypeId == InstancyObjectTypes.quiz) {
      QuizContentModel quizContentModel = QuizContentModel();
      quizContentModel.questionCount = 3;
      quizContentModel.difficultyLevel = "Hard";
      quizContentModel.questions = AppConstants().quizModelList;
      quizContentModel.questionType = "Multiple Choice";
      coCreateContentAuthoringModel.quizContentModel = quizContentModel;

      NavigationController.navigateToAddEditQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditQuizScreenArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.article) {
      NavigationController.navigateToAddEditArticleScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditArticleScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.events) {
      NavigationController.navigateToAddEditEventScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditEventScreenArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      NavigationController.navigateToAddEditRoleplayScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditRolePlayScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.learningPath) {
      NavigationController.navigateToAddEditLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditLearningPathScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.microLearning) {
      NavigationController.navigateToAddEditMicrolearningScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditMicrolearningScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else {}
  }

  Future<void> thumbnailDialog() async {
    dynamic val = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ThumbnailDialog();
      },
    );

    MyPrint.printOnConsole("val: $val");
    if (val == null) return;

    if (val == 1) {
      thumbNailName = await openFileExplorer(
        FileType.image,
        false,
      );
      setState(() {});
      return;
    }

    if (val is Uint8List) {
      thumbNailBytes = val;
      mySetState();
    }
  }

  @override
  void initState() {
    super.initState();
    wikiProvider = context.read<WikiProvider>();
    // wikiController = WikiController(wikiProvider: wikiProvider);
    // wikiController.getWikiCategoriesFromApi(
    //   componentId: InstancyComponents.Catalog,
    //   componentInstanceId: InstancyComponents.CatalogComponentInsId,
    // );

    // isUrl = widget.addWikiContentScreenNavigationArguments.mediaTypeId == InstancyMediaTypes.url;
    // fileType = getFileTypeFromMediaTypeId(
    //   mediaTypeId: widget.addWikiContentScreenNavigationArguments.mediaTypeId,
    // );

    initializeData();
  }

  Future<String> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;
      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      thumbNailBytes = file.bytes;
    } else {
      fileName = "";
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppConfigurations().commonAppBar(
              title: setAppBarTitle(widget.argument.objectTypeId),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  onNextTap(widget.argument.objectTypeId);
                },
                text: "Next",
                fontColor: themeData.colorScheme.onPrimary,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 17,
                    ),
                    getTitleTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getDescriptionTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getCategoryExpansionTile(),
                    const SizedBox(
                      height: 17,
                    ),
                    getThumbNail(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getThumbNail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            thumbnailDialog();
            // thumbNailName = await openFileExplorer(
            //   fileType,
            //   false,
            // );
            // setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: themeData.primaryColor, width: .6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Text(
              "Add Thumbnail Image",
              style: TextStyle(color: themeData.primaryColor),
            ),
          ),
        ),
        if (thumbNailBytes != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.memory(
                    thumbNailBytes!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                InkWell(
                  onTap: () {
                    thumbNailBytes = null;
                    mySetState();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  //region imageView
  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  //endregion

  //region getTitleTextFormField
  Widget getTitleTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      isMandatory: true,
      minLines: 1,
      maxLines: 1,
      controller: titleController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Title",
    );
  }

  //endregion

  //region getDescription
  Widget getDescriptionTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter description";
        }
        return null;
      },
      isMandatory: true,
      minLines: 7,
      maxLines: 7,
      controller: descriptionController,
      labelText: "Description",
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

//endregion

  //region categoryExpansionTile
  Widget getCategoryExpansionTile() {
    return Consumer<WikiProvider>(
      builder: (BuildContext context, WikiProvider provider, _) {
        return Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
          child: Theme(
            data: themeData.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                key: expansionTile,
                backgroundColor: const Color(0xffF8F8F8),
                initiallyExpanded: isExpanded,
                tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                title: Row(
                  children: [
                    getImageView(url: "assets/catalog/categories.png", height: 15, width: 15),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        selectedCategoriesString.isEmpty ? "Skills" : selectedCategoriesString,
                        style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
                      ),
                    ),
                  ],
                ),
                onExpansionChanged: (bool? newVal) {
                  FocusScope.of(context).unfocus();
                },
                children: provider.wikiCategoriesList.map((e) {
                  bool isChecked = selectedCategoriesList.map((e) => e.name).contains(e.name);
                  return Container(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        if (isChecked) {
                          selectedCategoriesList.remove(e);
                        } else {
                          selectedCategoriesList.add(e);
                        }

                        selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                          list: selectedCategoriesList.map((e) => e.name).toList(),
                          separator: ", ",
                        );
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: themeData.primaryColor,
                            value: isChecked,
                            onChanged: (bool? value) {
                              bool isCheckedTemp = value ?? false;
                              if (isCheckedTemp) {
                                if (!isChecked) {
                                  selectedCategoriesList.add(e);
                                }
                              } else {
                                if (isChecked) {
                                  selectedCategoriesList.remove(e);
                                }
                              }
                              selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                                list: selectedCategoriesList.map((e) => e.name).toList(),
                                separator: ",",
                              );
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.name),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          ),
        );
      },
    );
  }

  //endregion

  //Supporting Widgets
  //region textFieldView
  Widget getTexFormField(
      {TextEditingController? controller,
      String iconUrl = "",
      String? Function(String?)? validator,
      String labelText = "Label",
      Widget? suffixWidget,
      required bool isMandatory,
      int? minLines,
      int? maxLines,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      floatingLabelColor: Colors.grey,
      isOutlineInputBorder: true,
      prefixWidget: iconUrl.isNotEmpty
          ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
          : const Icon(
              FontAwesomeIcons.globe,
              size: 15,
              color: Colors.grey,
            ),
      suffixWidget: suffixWidget,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey, fontSize: 15),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red, fontSize: 14),
          )
        ],
      ),
    );
  }
//endregion
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/thumbnail_dialog.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
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

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  String AppBarTitle = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();
  String selectedCategoriesString = "";
  List<ContentFilterCategoryTreeModel> selectedCategoriesList = [];

  String thumbNailName = "";
  Uint8List? thumbNailBytes;
  String thumbnailImagePath = "";

  bool isExpanded = false;
  final GlobalKey expansionTile = GlobalKey();

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    CommonCreateAuthoringToolScreenArgument argument = widget.argument;

    coCreateContentAuthoringModel = argument.coCreateContentAuthoringModel ??
        CoCreateContentAuthoringModel(
          coCreateAuthoringType: argument.coCreateAuthoringType,
          contentTypeId: argument.objectTypeId,
          mediaTypeId: argument.mediaTypeId,
          isEdit: argument.coCreateAuthoringType != CoCreateAuthoringType.Create,
        );

    setAppBarTitle(objectTypeId: argument.objectTypeId, mediaTypeId: argument.mediaTypeId);

    if (argument.courseDtoModel != null) {
      CourseDTOModel courseDTOModel = argument.courseDtoModel!;

      coCreateKnowledgeController.initializeCoCreateContentAuthoringModelFromCourseDTOModel(courseDTOModel: courseDTOModel, coCreateContentAuthoringModel: coCreateContentAuthoringModel);

      titleController.text = coCreateContentAuthoringModel.title;
      descriptionController.text = coCreateContentAuthoringModel.description;
      thumbNailName = coCreateContentAuthoringModel.ThumbnailImageName;
      thumbNailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
      thumbnailImagePath = coCreateContentAuthoringModel.ThumbnailImagePath;

      List<ContentFilterCategoryTreeModel> list = coCreateKnowledgeProvider.skills.getList();
      for (String skill in coCreateContentAuthoringModel.skills) {
        ContentFilterCategoryTreeModel? model = list.where((element) => element.categoryName == skill).firstOrNull;
        if (model != null) {
          selectedCategoriesList.add(model);
        }
      }
      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: selectedCategoriesList.map((e) => e.categoryName).toList(),
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
        "ContentTypeId": 0,
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
        "MediaTypeID": 0,
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
      courseDTOModel.ContentType = switch ("${coCreateContentAuthoringModel.contentTypeId}_${coCreateContentAuthoringModel.mediaTypeId}") {
        "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}" => "Article",
        "${InstancyObjectTypes.rolePlay}_${InstancyMediaTypes.none}" => "Roleplay",
        "${InstancyObjectTypes.events}_${InstancyMediaTypes.virtualClassroomEvent}" => "Event",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.word}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.pDF}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.excel}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.ppt}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.mpp}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.visioTypes}" => "Documents",
        "${InstancyObjectTypes.document}_${InstancyMediaTypes.csv}" => "Documents",
        "${InstancyObjectTypes.reference}_${InstancyMediaTypes.url}" => "Reference Link",
        "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.video}" => "Video",
        "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.audio}" => "Podcast Episode",
        "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}" => "Quiz",
        "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}" => "Flashcards",
        "${InstancyObjectTypes.track}_${InstancyMediaTypes.none}" => "Learning Path",
        "${InstancyObjectTypes.courseBot}_${InstancyMediaTypes.none}" => "AI Agent",
        "${InstancyObjectTypes.contentObject}_${InstancyMediaTypes.microLearning}" => "Microlearning",
        _ => "",
      };

      // AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
      //
      // String name = authenticationProvider.getEmailLoginResponseModel()?.username ?? "";
      // String imageurl = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";
      //
      // courseDTOModel.AuthorName = name;
      // courseDTOModel.AuthorDisplayName = name;
      //
      // courseDTOModel.ThumbnailImagePath = "Content/SiteFiles/Images/assignment-thumbnail.png";
      // courseDTOModel.UserProfileImagePath = imageurl;
      MyPrint.printOnConsole("courseDTOModel.AuthorName: ${courseDTOModel.AuthorName}");

      coCreateContentAuthoringModel.newCurrentCourseDTOModel = courseDTOModel;
      coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;

      // initializeMetadataForNewContentAccordingToType();
    }
  }

  void initializeMetadataForNewContentAccordingToType() {
    String? title;
    String? description;
    String? thumbnailImageUrl;
    List<String>? skills;

    switch ("${coCreateContentAuthoringModel.contentTypeId}_${coCreateContentAuthoringModel.mediaTypeId}") {
      case "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}":
        {
          title = "Biotechnology and Genetic Engineering using AI: A Review";
          description =
              "This field encompasses the use of artificial intelligence (AI), machine learning, robotics, and data analytics to develop smart solutions that can adapt to changing conditions, optimize performance, and automate complex tasks. Applications include predictive maintenance, autonomous systems, smart infrastructure, and intelligent control systems, all aimed at improving decision-making processes, reducing costs, and increasing the overall effectiveness of engineering projects.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FIntelligent%20Systems%20And%20Applications%20In%20Engineering.jpeg?alt=media&token=af5618ca-7afd-4469-bf8a-ed7b5917a0d7";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.rolePlay}_${InstancyMediaTypes.none}":
        {
          title = "Customer Query Resolution";
          description =
              "It involves the efficient and effective handling of customer inquiries, concerns, and issues. This process ensures that customer questions are answered promptly, problems are resolved satisfactorily, and customer satisfaction is maintained. Utilizing a combination of trained support staff, clear communication channels, and robust problem-solving strategies, Customer Query Resolution aims to enhance the overall customer experience and foster loyalty by addressing their needs with care and professionalism.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FCustomer%20Query%20Resolution.avif?alt=media&token=e259b727-4c1b-489e-8e3b-9e71edccef57";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.events}_${InstancyMediaTypes.virtualClassroomEvent}":
        {
          title = "Certification in Economic Growth and Development";
          description =
              "This certification covers key concepts, theories, and practical strategies for fostering economic growth, addressing income inequality, and promoting sustainable practices. Ideal for professionals, policymakers, and students, the program offers valuable insights into the economic policies and development strategies that can transform societies and improve living standards. Participants will gain the analytical skills and knowledge necessary to contribute effectively to the field of economic development.";
          thumbnailImageUrl = "/Content/SiteFiles/Images/Event.jpg";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.word}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.pDF}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.excel}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.ppt}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.mpp}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.visioTypes}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.csv}":
        {
          title = "Identifying and Addressing Ergonomic Hazards Workbook";
          description =
              "It provides practical guidance on identifying potential risks associated with poor ergonomics, such as musculoskeletal disorders, repetitive strain injuries, and general discomfort. The workbook includes step-by-step instructions, checklists, and interactive exercises to assess ergonomic setups and implement effective solutions.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FIdentifying%20and%20Addressing.png?alt=media&token=6ded5bc1-e599-4b5a-ba20-ef15d402e9f1";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.reference}_${InstancyMediaTypes.url}":
        {
          title = "An Introduction to Generative AI and its Transformative Potential for Enterprises";
          description =
              "This insightful guide explores the innovative field of generative AI, highlighting its capacity to revolutionize various business sectors. It delves into how enterprises can leverage generative AI to enhance creativity, optimize operations, and drive growth. By providing practical examples and industry-specific applications, this introduction offers a comprehensive overview of the transformative impact generative AI can have on modern businesses, making it an essential read for professionals seeking to harness the power of this cutting-edge technology.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FAn%20introduction%20to%20Generative%20AI%20and%20its%20Transformative%20potential%20for%20Enterprises.png?alt=media&token=11ef17a1-7224-41d6-b9ad-0d4894b7fdba";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.video}":
        {
          break;
        }
      case "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.audio}":
        {
          title = "Refining Communication";
          description =
              "It is a comprehensive guide designed to enhance your interpersonal skills and communication techniques. This book delves into the core principles of effective communication, offering practical strategies for improving clarity, empathy, and understanding in both personal and professional interactions. Whether you're looking to strengthen your relationships, excel in your career, or simply become a more effective communicator, \"Refining Communication\" provides the tools and insights you need to succeed.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FRefinig%20Communication.jpg?alt=media&token=5b6141a8-a7f2-4d32-a772-c90c630dc2e6";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}":
        {
          title = "Office Ergonomics";
          description =
              "It focuses on designing and arranging workspaces to fit the needs and capabilities of employees, promoting comfort, efficiency, and well-being. It involves optimizing furniture, equipment, and work practices to prevent strain and injury, enhancing productivity and overall job satisfaction. Key elements include adjustable chairs, desks, monitor placement, proper lighting, and keyboard and mouse positioning. By applying ergonomic principles, businesses can create healthier, more supportive work environments that reduce the risk of musculoskeletal disorders and improve employee performance.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FOffice%20Ergonomics.jpeg?alt=media&token=e1b10d9c-11d1-4e66-9cb1-34f2a0d2054d";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}":
        {
          title = "Unveiling the Neurons of AI";
          description =
              "Unveiling the Neurons of AI explores the intricate mechanisms and inner workings of artificial intelligence systems, drawing parallels to the human brain's neural networks. This title delves into the foundational algorithms, the architecture of neural networks, and the latest advancements in AI technology, revealing how these artificial 'neurons' process information, learn, and make decisions. Through this exploration, readers gain insight into the complexity and potential of AI, demystifying the science behind the machines shaping our future.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FUnveiling%20the%20Neurons%20of%20Alsss.jpeg?alt=media&token=c1a1d2ba-8b71-4b2b-90cd-005db53eb984";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }

      case "${InstancyObjectTypes.track}_${InstancyMediaTypes.none}":
        {
          title = "Artificial Intelligence: Transforming the Modern World";
          description =
              "Artificial Intelligence (AI) is at the forefront of a technological revolution that is reshaping every aspect of our modern world. From healthcare to finance, education to entertainment, AI's impact is profound and far-reaching. This comprehensive exploration delves into how AI technologies are transforming industries, enhancing efficiencies, and driving innovation.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FlearningPathThumbnail.png?alt=media&token=6aa46e14-3a64-4b67-bb78-18868c1fa415";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      case "${InstancyObjectTypes.contentObject}_${InstancyMediaTypes.microLearning}":
        {
          title = "Technology in Sustainable Urban Planning";
          description =
              "Technology in Sustainable Urban Planning explores the integration of innovative technologies to create environmentally friendly, resilient, and efficient urban spaces. It focuses on smart solutions such as green infrastructure, renewable energy, IoT-enabled city management, and data-driven approaches to enhance the quality of life, reduce environmental impact, and promote sustainable development in urban areas.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FlearningPathThumbnail.png?alt=media&token=6aa46e14-3a64-4b67-bb78-18868c1fa415";
          skills = ["UX Writing", "Neumorphism"];

          break;
        }
      default:
        {
          break;
        }
    }

    if (title != null) titleController.text = title;
    if (description != null) descriptionController.text = description;
    if (thumbnailImageUrl != null) thumbnailImagePath = thumbnailImageUrl;

    if (skills != null) {
      selectedCategoriesList.clear();
      List<ContentFilterCategoryTreeModel> list = coCreateKnowledgeProvider.skills.getList();
      for (String skill in skills) {
        ContentFilterCategoryTreeModel? model = list.where((element) => element.categoryName == skill).firstOrNull;
        if (model != null) {
          selectedCategoriesList.add(model);
        }
      }
      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: selectedCategoriesList.map((e) => e.categoryName).toList(),
        separator: ", ",
      );
    }
  }

  void setAppBarTitle({required int objectTypeId, required int mediaTypeId}) {
    bool isEdit = [CoCreateAuthoringType.Edit, CoCreateAuthoringType.EditMetadata].contains(coCreateContentAuthoringModel.coCreateAuthoringType);

    String value = "${coCreateContentAuthoringModel.contentTypeId}_${coCreateContentAuthoringModel.mediaTypeId}";
    MyPrint.printOnConsole("value:$value");

    switch (value) {
      case "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}":
        {
          AppBarTitle = isEdit ? "Edit Article" : "Create Article";
          break;
        }
      case "${InstancyObjectTypes.rolePlay}_${InstancyMediaTypes.none}":
        {
          AppBarTitle = isEdit ? "Edit Roleplay" : "Create Roleplay";
          break;
        }
      case "${InstancyObjectTypes.events}_${InstancyMediaTypes.virtualClassroomEvent}":
        {
          AppBarTitle = isEdit ? "Edit Event" : "Create Event";
          break;
        }
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.word}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.pDF}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.excel}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.ppt}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.mpp}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.visioTypes}":
      case "${InstancyObjectTypes.document}_${InstancyMediaTypes.csv}":
        {
          AppBarTitle = isEdit ? "Edit Document" : "Create Document";
          break;
        }
      case "${InstancyObjectTypes.reference}_${InstancyMediaTypes.url}":
        {
          AppBarTitle = isEdit ? "Edit Reference Url" : "Create Reference Url";
          break;
        }
      case "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.video}":
        {
          AppBarTitle = isEdit ? "Edit Video" : "Create Video";
          break;
        }
      case "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.audio}":
        {
          AppBarTitle = isEdit ? "Edit PodCast Episode" : "Create Podcast Episode";
          break;
        }
      case "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}":
        {
          AppBarTitle = isEdit ? "Edit Quiz" : "Create Quiz";
          break;
        }
      case "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}":
        {
          AppBarTitle = isEdit ? "Edit Flashcard" : "Create Flashcard";
          break;
        }

      case "${InstancyObjectTypes.track}_${InstancyMediaTypes.none}":
        {
          AppBarTitle = isEdit ? "Edit Learning Path" : "Create Learning Path";
          break;
        }
      case "${InstancyObjectTypes.courseBot}_${InstancyMediaTypes.none}":
        {
          AppBarTitle = isEdit ? "Edit AI Agent" : "Create AI Agent";
          break;
        }
      case "${InstancyObjectTypes.contentObject}_${InstancyMediaTypes.microLearning}":
        {
          AppBarTitle = isEdit ? "Edit Microlearning" : "Create Microlearning";
          break;
        }
      default:
        {
          break;
        }
    }

    MyPrint.printOnConsole("AppBarTitle:$AppBarTitle");
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
      await openFileExplorer(
        FileType.image,
        false,
      );
    } else if (val is Uint8List) {
      thumbNailBytes = val;
      thumbNailName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
      mySetState();
    }

    MyPrint.printOnConsole("Final thumbNailName:'$thumbNailName'");
  }

  Future<void> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isEmpty) {
      return;
    }

    PlatformFile file = paths.first;
    if (!kIsWeb) {
      MyPrint.printOnConsole("File Path:${file.path}");
    }
    MyPrint.printOnConsole("FileName:${file.name}");
    fileName = MyUtils.regenerateFileName(fileName: file.name) ?? "";
    MyPrint.printOnConsole("regenerated FileName:$fileName");

    if (fileName.isEmpty) {
      return;
    }

    thumbNailName = fileName;
    thumbNailBytes = file.bytes;

    MyPrint.printOnConsole("Got file Name:$thumbNailName");
    MyPrint.printOnConsole("Got file bytes:${thumbNailBytes?.length}");

    mySetState();
  }

  bool validateFormData() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }
    // else if (coCreateKnowledgeProvider.skills.length > 0 && selectedCategoriesList.isEmpty) {
    //   MyToast.showError(context: context, msg: "Please select a Skill");
    //   return false;
    // } else if (thumbNailBytes.checkEmpty && thumbnailImagePath.isEmpty) {
    //   MyToast.showError(context: context, msg: "Please choose Thumbnail Image");
    //   return false;
    // }

    return true;
  }

  Future<void> onNextTap({required int objectTypeId, required int mediaTypeId}) async {
    if (!validateFormData()) {
      return;
    }

    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.skills = selectedCategoriesList.map((e) => e.categoryName).toList();
    coCreateContentAuthoringModel.skillsMap = Map<String, String>.fromEntries(selectedCategoriesList.map((e) => MapEntry<String, String>(e.categoryId, e.categoryName)));
    coCreateContentAuthoringModel.ThumbnailImageName = thumbNailName;
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;
    coCreateContentAuthoringModel.ThumbnailImagePath = thumbnailImagePath;

    bool? isCreated;

    if (objectTypeId == InstancyObjectTypes.flashCard) {
      dynamic value = await NavigationController.navigateToAddEditFlashcardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: AddEditFlashcardScreenNavigationArguments(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.mediaResource && mediaTypeId == InstancyMediaTypes.audio) {
      dynamic value = await NavigationController.navigateToCreatePodcastSourceSelectionScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CreatePodcastSourceSelectionScreenNavigationArguments(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.document) {
      dynamic value = await NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: AddEditDocumentScreenArguments(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.mediaResource && mediaTypeId == InstancyMediaTypes.video) {
      dynamic value = await NavigationController.navigateToAddEditVideoScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditVideoScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.assessment && mediaTypeId == InstancyMediaTypes.test) {
      /*QuizContentModel quizContentModel = QuizContentModel();
      quizContentModel.questionCount = 3;
      quizContentModel.difficultyLevel = "Hard";
      quizContentModel.questions = AppConstants().quizModelList;
      quizContentModel.questionType = "Multiple Choice";*/
      // coCreateContentAuthoringModel.quizContentModel = quizContentModel;

      dynamic value = await NavigationController.navigateToAddEditQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditQuizScreenArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.webPage) {
      dynamic value = await NavigationController.navigateToAddEditArticleScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditArticleScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.events) {
      dynamic value = await NavigationController.navigateToAddEditEventScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditEventScreenArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      dynamic value = await NavigationController.navigateToAddEditRoleplayScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditRolePlayScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.track) {
      dynamic value = await NavigationController.navigateToAddEditLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditLearningPathScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.contentObject && mediaTypeId == InstancyMediaTypes.microLearning) {
      dynamic value = await NavigationController.navigateToAddEditMicroLearningScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditMicroLearningScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isCreated = true;
      }
    } else {}

    if (isCreated == true) {
      Navigator.pop(context, true);
    }
  }

  Future<CourseDTOModel?> saveContent() async {
    if (!validateFormData()) {
      return null;
    }

    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CommonCreateAuthoringToolScreen().saveContent() called", tag: tag);

    isLoading = true;
    mySetState();

    String previousTitle = coCreateContentAuthoringModel.title;
    String previousDescription = coCreateContentAuthoringModel.description;
    List<String> previousSkills = coCreateContentAuthoringModel.skills;
    Map<String, String> previousSkillsMap = coCreateContentAuthoringModel.skillsMap;
    Uint8List? previousThumbnailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
    String previousThumbnailImagePath = coCreateContentAuthoringModel.ThumbnailImagePath;

    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.skills = selectedCategoriesList.map((e) => e.categoryName).toList();
    coCreateContentAuthoringModel.skillsMap = Map<String, String>.fromEntries(selectedCategoriesList.map((e) => MapEntry<String, String>(e.categoryId, e.categoryName)));
    coCreateContentAuthoringModel.ThumbnailImageName = thumbNailName;
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;
    coCreateContentAuthoringModel.ThumbnailImagePath = thumbnailImagePath;

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from CommonCreateAuthoringToolScreen().onEditMetadataTap() because contentId is null or empty");

      coCreateContentAuthoringModel.title = previousTitle;
      coCreateContentAuthoringModel.description = previousDescription;
      coCreateContentAuthoringModel.skills = previousSkills;
      coCreateContentAuthoringModel.skillsMap = previousSkillsMap;
      coCreateContentAuthoringModel.thumbNailImageBytes = previousThumbnailBytes;
      coCreateContentAuthoringModel.ThumbnailImagePath = previousThumbnailImagePath;

      MyToast.showError(context: context, msg: coCreateContentAuthoringModel.isEdit ? "Couldn't Update Content" : "Couldn't Create Content");

      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onEditMetadataTap() async {
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    if (courseDTOModel.ContentTypeId == InstancyObjectTypes.reference && courseDTOModel.MediaTypeID == InstancyMediaTypes.url) {
      await NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: coCreateContentAuthoringModel.title,
          url: coCreateContentAuthoringModel.referenceUrl ?? "",
          isFromAuthoringTool: true,
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: PopScope(
        canPop: !isLoading,
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {},
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppConfigurations().commonAppBar(
                title: AppBarTitle,
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(10.0),
                child: getBottomButtonWidget(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                        getSkillsExpansionTile(),
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
        ),
      ),
    );
  }

  Widget getBottomButtonWidget() {
    if (coCreateContentAuthoringModel.coCreateAuthoringType == CoCreateAuthoringType.EditMetadata) {
      return CommonButton(
        minWidth: double.infinity,
        onPressed: () {
          onEditMetadataTap();
        },
        text: "Edit",
        fontColor: themeData.colorScheme.onPrimary,
      );
    } else if (coCreateContentAuthoringModel.coCreateAuthoringType == CoCreateAuthoringType.Create) {
      if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommonSaveExitButtonRow(
            onSaveAndExitPressed: onSaveAndExitTap,
            onSaveAndViewPressed: onSaveAndViewTap,
          ),
        );
      }
      return CommonButton(
        minWidth: double.infinity,
        onPressed: () {
          onNextTap(objectTypeId: widget.argument.objectTypeId, mediaTypeId: widget.argument.mediaTypeId);
        },
        text: "Next",
        fontColor: themeData.colorScheme.onPrimary,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getThumbNail() {
    if (thumbNailBytes.checkEmpty && thumbnailImagePath.isEmpty) {
      return InkWell(
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
      );
    } else if (thumbNailBytes != null) {
      return Padding(
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
      );
    } else {
      String imageUrl = AppConfigurationOperations(appProvider: DependencyInjection.appProvider).getInstancyImageUrlFromImagePath(imagePath: thumbnailImagePath);

      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonCachedNetworkImage(
                imageUrl: imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () {
                thumbnailImagePath = "";
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
      );
    }
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
        if (val == null || val.trim().isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      isMandatory: true,
      minLines: 1,
      inputFormatters:[LengthLimitingTextInputFormatter(200)],
      // maxLines: 1,
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
        if (val == null || val.trim().isEmpty) {
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

  //region SkillsExpansionTile
  Widget getSkillsExpansionTile() {
    List<ContentFilterCategoryTreeModel> skills = coCreateKnowledgeProvider.skills.getList();

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
          children: skills.map((e) {
            bool isChecked = selectedCategoriesList.map((e) => e.categoryName).contains(e.categoryName);
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
                    list: selectedCategoriesList.map((e) => e.categoryName).toList(),
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
                          list: selectedCategoriesList.map((e) => e.categoryName).toList(),
                          separator: ",",
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.categoryName),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
      List<TextInputFormatter>? inputFormatters,
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
      inputFormatters: inputFormatters,
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

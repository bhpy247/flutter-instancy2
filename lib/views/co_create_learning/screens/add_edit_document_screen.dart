import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/wiki_component/wiki_controller.dart';
import '../../../backend/wiki_component/wiki_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../models/wiki_component/response_model/wikiCategoriesModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditDocumentsScreen extends StatefulWidget {
  static const String routeName = "/DocumentsScreen";
  final AddEditDocumentScreenArguments argument;

  const AddEditDocumentsScreen({super.key, required this.argument});

  @override
  State<AddEditDocumentsScreen> createState() => _AddEditDocumentsScreenState();
}

class _AddEditDocumentsScreenState extends State<AddEditDocumentsScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();

  final GlobalKey expansionTile = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  bool isUrl = true;
  FileType? fileType;
  late WikiProvider wikiProvider;
  late WikiController wikiController;

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;
  String selectedCategoriesString = "";
  List<WikiCategoryTable> selectedCategoriesList = [];
  String thumbNailName = "";
  Uint8List? thumbNailBytes;
  CourseDTOModel model = CourseDTOModel();

  Future<String> openFileExplorer(FileType pickingType, bool multiPick, bool isThumbNail) async {
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
      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileName = file.name;

      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      if (isThumbNail) {
        thumbNailBytes = file.bytes;
      } else {
        fileBytes = file.bytes;
      }
    } else {
      fileName = "";
      fileBytes = null;
      thumbNailBytes = null;
    }
    return fileName;
  }

  FileType? getFileTypeFromMediaTypeId({required int mediaTypeId}) {
    if (mediaTypeId == InstancyMediaTypes.image) {
      return FileType.image;
    } else if (mediaTypeId == InstancyMediaTypes.audio) {
      return FileType.audio;
    } else if (mediaTypeId == InstancyMediaTypes.video) {
      return FileType.video;
    } else if (mediaTypeId == InstancyMediaTypes.pDF) {
      return FileType.custom;
    } else {
      // return FileType.custom;
      return null;
    }
  }

  void onSaveButtonClicked() {
    CoCreateKnowledgeProvider provider = context.read();

    model = widget.argument.courseDtoModel ?? CourseDTOModel();
    model.Title = titleController.text.trim();
    model.TitleName = titleController.text.trim();
    model.ContentName = titleController.text.trim();
    model.ShortDescription = descriptionController.text.trim();
    model.AuthorName = "Richard Parker";
    model.ContentTypeId = InstancyObjectTypes.document;
    model.MediaTypeID = InstancyMediaTypes.none;
    model.AuthorDisplayName = "Richard Parker";
    model.ContentType = "Documents";
    model.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";
    model.ViewLink = "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true";
    model.Categories = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.name).toList(),
      separator: ",",
    );
    MyPrint.printOnConsole(model.Categories);
    model.ThumbnailImagePath =
        "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3";
    model.thumbNailFileBytes = thumbNailBytes;
    // if (widget.arguments.isEdit) {
    //   provider.updateMyKnowledgeListModel(model, widget.arguments.index);
    // } else {
    //   provider.addToMyKnowledgeList(model);
    // }
    //
  }

  void editData() {
    if (widget.argument.courseDtoModel == null) return;
    CourseDTOModel model = widget.argument.courseDtoModel!;
    titleController.text = model.Title;
    descriptionController.text = model.ShortDescription;
    fileName = model.ViewLink;
    List<WikiCategoryTable> categoriesList = wikiProvider.wikiCategoriesList;
    List<String> categoriesidsFromString = model.Categories.split(",").toList();

    selectedCategoriesList = categoriesList.where((element) => categoriesidsFromString.contains(element.name.toString())).toList();
    MyPrint.printOnConsole(selectedCategoriesList);
    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.name).toList(),
      separator: ",",
    );
  }

  void initializeData() {
    coCreateContentAuthoringModel = CoCreateContentAuthoringModel();
    coCreateContentAuthoringModel.contentTypeId = InstancyObjectTypes.document;

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
      coCreateContentAuthoringModel.uploadedDocumentName = courseDTOModel.uploadedFileName;

      titleController.text = coCreateContentAuthoringModel.title;
      descriptionController.text = coCreateContentAuthoringModel.description;
      thumbNailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
      fileBytes = coCreateContentAuthoringModel.uploadedDocumentBytes;
      fileName = coCreateContentAuthoringModel.uploadedDocumentName ?? "";

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
          title = "Intelligent Systems And Applications In Engineering";
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
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FCertification%20in%20Economic%20Growth%20and%20Development.jpg?alt=media&token=e23f5c99-815e-4e94-89e1-fd5a9df0047d";
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
          title = "An introduction to Generative AI and its Transformative potential for Enterprises";
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
          title = "Refinig Communication";
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
          title = "Unveiling the Neurons of Alsss";
          description =
              "Unveiling the Neurons of Alsss delves into the intricate and captivating world of the fictional character Alsss, exploring the depths of their neural architecture. This groundbreaking narrative intertwines the realms of neuroscience and speculative fiction, presenting a vivid portrayal of Alsss' cognitive and emotional landscape. Through a blend of scientific insight and imaginative storytelling, readers are invited to journey through the complex neural networks that define Alsss' thoughts, behaviors, and unique perception of reality.";
          thumbnailImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FUnveiling%20the%20Neurons%20of%20Alsss.jpeg?alt=media&token=c1a1d2ba-8b71-4b2b-90cd-005db53eb984";
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

  Future<CourseDTOModel?> saveFlashcard() async {
    /*if (fileName.checkEmpty) {
      MyToast.showError(context: context, msg: "Please upload the file");
      return null;
    }*/

    coCreateContentAuthoringModel.uploadedDocumentBytes = fileBytes;
    coCreateContentAuthoringModel.uploadedDocumentName = fileName;
    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.skills = selectedCategoriesList.map((e) => e.name).toList();
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    if (courseDTOModel != null) {
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;

      courseDTOModel.Skills = coCreateContentAuthoringModel.skills;

      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
      courseDTOModel.uploadedDocumentBytes = coCreateContentAuthoringModel.uploadedDocumentBytes;
      courseDTOModel.uploadedFileName = coCreateContentAuthoringModel.uploadedDocumentName;

      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    /* NavigationController.navigateToDocumentPreviewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: PDFLaunchScreenNavigationArguments(
        contntName: coCreateContentAuthoringModel.title,
        isNetworkPDF: fileBytes == null,
        // pdfUrl: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
        // pdfUrl: widget.argument.courseDtoModel?.ViewLink ?? "",
        pdfFileBytes: coCreateContentAuthoringModel.uploadedDocumentBytes,
      ),
    );*/
    NavigationController.navigateToPDFLaunchScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: PDFLaunchScreenNavigationArguments(
        contntName: courseDTOModel.ContentName,
        isNetworkPDF: true,
        pdfUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fdocuments%2Fai%20for%20biotechnology.pdf?alt=media&token=ab06fadc-ba08-4114-88e1-529213d117bf",
      ),
    );
    // NavigationController.navigateToFlashCardScreen(
    //   navigationOperationParameters: NavigationOperationParameters(
    //     context: context,
    //     navigationType: NavigationType.pushNamed,
    //   ),
    //   arguments: FlashCardScreenNavigationArguments(
    //     courseDTOModel: courseDTOModel,
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    wikiProvider = context.read<WikiProvider>();
    wikiController = WikiController(wikiProvider: wikiProvider);
    wikiController.getWikiCategoriesFromApi(
      componentId: InstancyComponents.Catalog,
      componentInstanceId: InstancyComponents.CatalogComponentInsId,
    );
    // editData();
    // isUrl = widget.addWikiContentScreenNavigationArguments.mediaTypeId == InstancyMediaTypes.url;
    fileType = getFileTypeFromMediaTypeId(
      mediaTypeId: InstancyMediaTypes.pDF,
    );

    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    // MyPrint.printOnConsole("fileBytes:${fileBytes?.length}");
    // isLoading = false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 20),
              child: bottomButton(),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: widget.argument.courseDtoModel == null ? "Create Document" : "Edit Document",
            ),
            body: mainWidget(),
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 19),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // getImageView(),
              const SizedBox(
                height: 19,
              ),
              getTitleTextFormField(),
              const SizedBox(
                height: 19,
              ),
              // getWidgetFromFileType(fileType),
              // const SizedBox(
              //   height: 19,
              // ),
              getDescriptionTextFormField(),
              // getImagePickerView(),
              const SizedBox(
                height: 19,
              ),
              getCategoryExpansionTile(),
              const SizedBox(
                height: 19,
              ),
              getWidgetFromFileType(fileType),
              const SizedBox(
                height: 19,
              ),
              getThumbNail(FileType.image),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
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
      minLines: 5,
      maxLines: 5,
      controller: descriptionController,
      labelText: "Description",
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  //endregion

  Widget getUploadButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            getWidgetFromFileType(FileType.custom),
            const Spacer(),
            CommonButton(
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
              fontSize: 15,
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  if (!widget.argument.isFromReference && fileName.checkEmpty) {
                    MyToast.showError(context: context, msg: "Please upload the file");
                    return;
                  }

                  CoCreateKnowledgeProvider provider = context.read();

                  CourseDTOModel model = widget.argument.courseDtoModel ?? CourseDTOModel();
                  model.uploadedDocumentBytes = fileBytes;
                  model.ViewLink = websiteUrlController.text.trim();

                  if (widget.argument.isFromReference) {
                    NavigationController.navigateToAddEditReferenceLinkScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      argument: AddEditReferenceScreenArguments(
                        courseDtoModel: model,
                        isEdit: false,
                        index: widget.argument.index,
                        componentId: 0,
                        componentInsId: 0,
                      ),
                    );
                    // NavigationController.navigateToWebViewScreen(
                    //   navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                    //   arguments: WebViewScreenNavigationArguments(
                    //       title: model.Title,
                    //       // url: "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/",
                    //       url: websiteUrlController.text.trim(),
                    //       isFromAuthoringTool: true),
                    // );
                    return;
                  }
                  if (widget.argument.isEdit) {
                    provider.updateMyKnowledgeListModel(model, widget.argument.index);
                  } else {
                    provider.addToMyKnowledgeList(model);
                  }
                  NavigationController.navigateToDocumentPreviewScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    argument: PDFLaunchScreenNavigationArguments(
                      contntName: widget.argument.courseDtoModel?.Title ?? "",
                      isNetworkPDF: fileBytes == null,
                      // pdfUrl: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
                      pdfUrl: widget.argument.courseDtoModel?.ViewLink ?? "",
                      pdfFileBytes: widget.argument.courseDtoModel?.uploadedDocumentBytes,
                    ),
                  );
                }
              },
              text: "Next",
            )
          ],
        ),
      ),
    );
  }

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
                  return Container(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        bool isChecked = !selectedCategoriesList.contains(e);
                        if (isChecked) {
                          selectedCategoriesList.add(e);
                        } else {
                          selectedCategoriesList.remove(e);
                        }

                        selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                          list: selectedCategoriesList.map((e) => e.name).toList(),
                          separator: ",",
                        );
                        setState(() {});

                        // if (isChecked) {
                        //   // selectedCategory = e.name;
                        //   selectedCategoriesList.add(e);
                        //   setState(() {});
                        //
                        // } else {
                        //   // selectedCategory = "";
                        //   selectedCategoriesList.remove(e);
                        // }
                        // print(isChecked);
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: themeData.primaryColor,
                            value: selectedCategoriesList.where((element) => element.name == e.name).checkNotEmpty,
                            onChanged: (bool? value) {
                              bool isChecked = value ?? false;
                              if (isChecked) {
                                selectedCategoriesList.add(e);
                              } else {
                                selectedCategoriesList.remove(e);
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

  //region AddContent Button
  Widget getAddContentButton() {
    return CommonButton(
      minWidth: double.infinity,
      fontSize: 15,
      backGroundColor: themeData.primaryColor,
      // minWidth: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          onSaveButtonClicked();
          if (!widget.argument.isFromReference && fileName.checkEmpty) {
            MyToast.showError(context: context, msg: "Please upload the file");
            return;
          }

          CoCreateKnowledgeProvider provider = context.read();

          CourseDTOModel model = widget.argument.courseDtoModel ?? CourseDTOModel();
          model.uploadedDocumentBytes = fileBytes;
          model.ViewLink = websiteUrlController.text.trim();

          if (widget.argument.isFromReference) {
            NavigationController.navigateToAddEditReferenceLinkScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              argument: AddEditReferenceScreenArguments(
                courseDtoModel: model,
                isEdit: false,
                index: widget.argument.index,
                componentId: 0,
                componentInsId: 0,
              ),
            );
            // NavigationController.navigateToWebViewScreen(
            //   navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            //   arguments: WebViewScreenNavigationArguments(
            //       title: model.Title,
            //       // url: "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/",
            //       url: websiteUrlController.text.trim(),
            //       isFromAuthoringTool: true),
            // );
            return;
          }
          if (widget.argument.isEdit) {
            provider.updateMyKnowledgeListModel(model, widget.argument.index);
          } else {
            provider.addToMyKnowledgeList(model);
          }
          NavigationController.navigateToDocumentPreviewScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            argument: PDFLaunchScreenNavigationArguments(
              contntName: widget.argument.courseDtoModel?.Title ?? "",
              isNetworkPDF: fileBytes == null,
              // pdfUrl: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
              pdfUrl: widget.argument.courseDtoModel?.ViewLink ?? "",
              pdfFileBytes: widget.argument.courseDtoModel?.uploadedDocumentBytes,
            ),
          );
          // NavigationController.navigateToCreateDocumentScreen(
          //   navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          //   argument: AddEditDocumentScreenArguments(
          //     componentId: 0,
          //     componentInsId: 0,
          //     courseDtoModel: model,
          //     isEdit: widget.arguments.isEdit,
          //     index: widget.arguments.index,
          //   ),
          // );
        }
        // Navigator.pop(context);

        // if (formKey.currentState!.validate()) {
        //   FocusScope.of(context).unfocus();
        //   // addCatalogContent();
        // }
      },
      text: widget.argument.courseDtoModel != null ? "Next" : "Next",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }

  Widget bottomButton() {
    return CommonSaveExitButtonRow(
      onSaveAndExitPressed: () {
        if (formKey.currentState!.validate()) {
          onSaveAndExitTap();
        }
      },
      onSaveAndViewPressed: () async {
        if (formKey.currentState!.validate()) {
          await onSaveAndViewTap();
        }
      },
    );
  }
  //endregion

  //region getWidgetAccordingToFileType
  Widget getWidgetFromFileType(FileType? fileType) {
    if (fileType != null) {
      return InkWell(
        onTap: () async {
          fileName = await openFileExplorer(fileType, false, false);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: .5), borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              getImageView(url: "assets/imageUpload.png", height: 15, width: 15),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: labelWithStar(
                  fileName.isEmpty ? "Upload" : fileName,
                  style: fileName.isNotEmpty ? themeData.textTheme.titleSmall : themeData.inputDecorationTheme.hintStyle,
                ),
              ),
              const Icon(Icons.add)
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getThumbNail(FileType? fileType) {
    if (fileType == null) return const SizedBox();
    return Column(
      children: [
        InkWell(
          onTap: () async {
            thumbNailName = await openFileExplorer(fileType, false, true);
            setState(() {});
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
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
              ))
        ],
      ),
    );
  }
//endregion
}

class DocumentPreviewScreen extends StatefulWidget {
  static const String routeName = "/DocumentPreviewScreen";

  final PDFLaunchScreenNavigationArguments arguments;

  const DocumentPreviewScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> with MySafeState {
  late Future<Uint8List?> futureGetPdfBytes;

  Future<Uint8List?> getData() async {
    Uint8List? uint8list;

    if (widget.arguments.isNetworkPDF) {
      uint8list = await getNetworkPdfBytes();
    } else {
      uint8list = await getLocalPdfBytes();
    }

    return uint8list;
  }

  FutureOr<Uint8List> getNetworkPdfBytes() async {
    try {
      Response response = await get(Uri.parse(widget.arguments.pdfUrl));
      return response.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting PDF Bytes:$e");
      MyPrint.printOnConsole(s);
      return Uint8List(0);
    }
  }

  FutureOr<Uint8List> getLocalPdfBytes() async {
    if (widget.arguments.pdfFileBytes != null) {
      return widget.arguments.pdfFileBytes!;
    }

    if (widget.arguments.pdfFilePath.isNotEmpty) {
      return File(widget.arguments.pdfFilePath).readAsBytes();
    }

    return Uint8List(0);
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("PDFLaunchScreen init called with arguments:${widget.arguments}");

    futureGetPdfBytes = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.contntName.isNotEmpty ? widget.arguments.contntName : 'PDF View',
        ),
        actions: [
          IconButton(
            onPressed: () {
              futureGetPdfBytes = getData();
              mySetState();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Uint8List?>(
              future: futureGetPdfBytes,
              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CommonLoader();
                }

                return PdfPreview(
                  build: (PdfPageFormat format) {
                    return Future.value(snapshot.data);
                  },
                  onError: (BuildContext context, Object? error) {
                    return Center(
                      child: Text(
                        "Error in Loading PDF:\n\n$error",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  onPrintError: (BuildContext context, dynamic error) {
                    MyPrint.printOnConsole("Error in Printing PDF:$error");
                  },
                  useActions: false,
                  allowPrinting: true,
                  allowSharing: true,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CommonButton(
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
              fontSize: 15,
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Done",
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_border_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';

class AddEditAiAgentScreen extends StatefulWidget {
  static const String routeName = "/AddEditAiAgentScreen";
  final AddEditAiAgentScreenNavigationArgument arguments;

  const AddEditAiAgentScreen({super.key, required this.arguments});

  @override
  State<AddEditAiAgentScreen> createState() => _AddEditAiAgentScreenState();
}

class _AddEditAiAgentScreenState extends State<AddEditAiAgentScreen> with MySafeState {
  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  TextEditingController titleController = TextEditingController();
  TextEditingController iconController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController promptController = TextEditingController();
  TextEditingController welcomeMessageController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();
  String? selectedTools;
  String thumbNailName = "";
  Uint8List? thumbNailBytes;
  bool isSuggestReplies = false;
  late MyLearningController myLearningController;
  late AppProvider appProvider;

  CourseDTOModel agentDtoModel = CourseDTOModel();

  void agentDtoModelCreation() {
    Map<String, dynamic> map = <String, dynamic>{
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
    agentDtoModel = CourseDTOModel.fromMap(map);
  }

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = CoCreateContentAuthoringModel(
      coCreateAuthoringType: CoCreateAuthoringType.Create,
    );
    coCreateContentAuthoringModel.contentTypeId = InstancyObjectTypes.courseBot;
    coCreateContentAuthoringModel.mediaTypeId = InstancyMediaTypes.none;

    if (widget.arguments.courseDtoModel != null) {
      CourseDTOModel courseDTOModel = widget.arguments.courseDtoModel!;

      coCreateKnowledgeController.initializeCoCreateContentAuthoringModelFromCourseDTOModel(courseDTOModel: courseDTOModel, coCreateContentAuthoringModel: coCreateContentAuthoringModel);

      titleController.text = coCreateContentAuthoringModel.title;
      descriptionController.text = coCreateContentAuthoringModel.description;
      thumbNailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
    } else {
      CourseDTOModel courseDTOModel = CourseDTOModel.fromMap(agentDtoModel.toMap());
      // courseDTOModel.ContentID = MyUtils.getNewId();
      courseDTOModel.ContentTypeId = coCreateContentAuthoringModel.contentTypeId;
      courseDTOModel.ContentType = switch (coCreateContentAuthoringModel.contentTypeId) {
        InstancyObjectTypes.courseBot => "AI Agent",
        _ => "Test",
      };

      courseDTOModel.AuthorName = "Richard Parker";
      courseDTOModel.AuthorName = "Richard Parker";
      courseDTOModel.AuthorDisplayName = "Richard Parker";

      courseDTOModel.ThumbnailImagePath = "Content/SiteFiles/Images/assignment-thumbnail.png";
      courseDTOModel.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";

      coCreateContentAuthoringModel.newCurrentCourseDTOModel = courseDTOModel;
      coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;

      titleController.text = "Office Ergonomics";
      descriptionController.text =
          "Office Ergonomics refers to making sure that there's a perfect fit between a product, the purpose it's used for, and the person using it. In an office setting, ergonomics relates to items such as chairs, desks, monitor stands and other elements that comprise an employee's workstation.";
      promptController.text = "Hello, I'm your AI Agent here to assist you with your queries. Ask Your Questions - Get Instant Answers - Access Course Resources";
      welcomeMessageController.text = "Hi, my name is Office Ergonomics, I’m here to help you with your learning and answer any questions about instancy products and services.";
      // initializeMetadataForNewContentAccordingToType();
    }
  }

  Future<void> onNextTap() async {
    agentDtoModel.ContentName = titleController.text.trim();
    agentDtoModel.Title = titleController.text.trim();
    agentDtoModel.TitleName = titleController.text.trim();
    // await onContentLaunchTap(model: agentDtoModel, isArchived: false);
    // widget.arguments.coCreateContentAuthoringModel.selectedArticleSourceType = _selectedOption;
    //
    // Navigator.pushNamed(
    //   context,
    //   ArticleEditorScreen.routeName,
    //   arguments: ArticleEditorScreenNavigationArgument(
    //     coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
    //   ),
    // );

    /*NavigationController.navigateToArticleEditorScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: ArticleEditorScreenNavigationArgument(
        model: widget.arguments.model,
        selectedSourceType: _selectedOption,
      ),
    );*/
  }

  Future<CourseDTOModel?> saveArticle() async {
    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    courseDTOModel?.ContentTypeId = InstancyObjectTypes.courseBot;
    MyPrint.printOnConsole("ContentId: ${courseDTOModel?.ContentTypeId} : ${courseDTOModel?.ContentType}");
    if (courseDTOModel != null) {
      // courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      // courseDTOModel.Title = coCreateContentAuthoringModel.title;
      // courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;

      courseDTOModel.ContentSkills = coCreateContentAuthoringModel.skills
          .map((e) => ContentFilterCategoryTreeModel(
                categoryId: "0",
                categoryName: e,
              ))
          .toList();

      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      courseDTOModel = CourseDTOModel.fromMap(agentDtoModel.toMap());
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;
      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }
    Navigator.pop(context);

    return courseDTOModel;
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    agentDtoModelCreation();
    myLearningController = MyLearningController(provider: context.read<MyLearningProvider>());
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppConfigurations().commonAppBar(
        title: "Create AI Agent",
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CommonButton(
          minWidth: double.infinity,
          onPressed: () async {
            // await onNextTap();
            saveArticle();
          },
          text: AppStrings.generateWithAI,
          fontColor: themeData.colorScheme.onPrimary,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CommonLoader(),
        child: Padding(
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
                // getIconTextFormField(),
                // const SizedBox(
                //   height: 17,
                // ),
                getPromptTextFormField(),
                const SizedBox(
                  height: 17,
                ),
                getWelComeMessageTextFormField(),
                const SizedBox(
                  height: 17,
                ),
                // getToolsDropDown(),
                // const SizedBox(
                //   height: 17,
                // ),
                getSwitchForSuggestReplies()
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget getIconTextFormField() {
    return getTexFormField(
      // validator: (String? val) {
      //   if (val == null || val.isEmpty) {
      //     return "Please enter icon";
      //   }
      //   return null;
      // },
      isMandatory: false,
      minLines: 1,
      maxLines: 1,
      controller: iconController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Icon",
    );
  }

  Widget getPromptTextFormField() {
    return getTexFormField(
      // validator: (String? val) {
      //   if (val == null || val.isEmpty) {
      //     return "Please enter title";
      //   }
      //   return null;
      // },
      isMandatory: false,
      minLines: 3,
      maxLines: 3,
      controller: promptController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Instructions / Prompt",
    );
  }

  Widget getWelComeMessageTextFormField() {
    return getTexFormField(
      // validator: (String? val) {
      //   if (val == null || val.isEmpty) {
      //     return "Please enter title";
      //   }
      //   return null;
      // },
      isMandatory: false,
      minLines: 3,
      maxLines: 3,

      controller: welcomeMessageController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Welcome message",
    );
  }

  Widget getSwitchForSuggestReplies() {
    return Row(
      children: [
        SizedBox(
          height: 15,
          width: 35,
          child: FittedBox(
            fit: BoxFit.cover,
            child: CupertinoSwitch(
              activeColor: themeData.primaryColor,
              value: isSuggestReplies,
              onChanged: (bool? val) {
                isSuggestReplies = val ?? false;
                mySetState();
              },
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text("Can suggest replies")
      ],
    );
  }

  Widget getToolsDropDown() {
    return CommonBorderDropdown(
        hintText: "Select Tools",
        isExpanded: true,
        items: ["Tools 1", "Tools 2"],
        value: selectedTools,
        onChanged: (val) {
          selectedTools = val ?? "";
        });
  }

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
        style: style ?? const TextStyle(color: Colors.grey, fontSize: 15),
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

  //region imageView
  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

//endregion
}

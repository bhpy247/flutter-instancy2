import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalogContentListComponent.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../component/add_content_dialog.dart';
import '../component/custom_search_view.dart';
import '../component/size_utils.dart';

class MyKnowledgeTab extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const MyKnowledgeTab({
    super.key,
    required this.componentId,
    required this.componentInstanceId,
  });

  @override
  State<MyKnowledgeTab> createState() => _MyKnowledgeTabState();
}

class _MyKnowledgeTabState extends State<MyKnowledgeTab> with MySafeState {
  late AppProvider appProvider;

  late CoCreateKnowledgeController _controller;
  late CoCreateKnowledgeProvider _provider;

  late Future future;

  Future<void> getFutureData() async {
    await _controller.getMyKnowledgeList();
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "View",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () {
            Navigator.pop(context);

            onViewTap(model: model);
          },
          iconData: InstancyIcons.view,
        ),
      InstancyUIActionModel(
        text: "Details",
        actionsEnum: InstancyContentActionsEnum.Details,
        onTap: () {
          Navigator.pop(context);

          onDetailsTap(model: model);
        },
        iconData: InstancyIcons.details,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);

          _provider.myKnowledgeList.removeItems(items: [model], isNotify: true);
        },
        iconData: InstancyIcons.delete,
      ),
      InstancyUIActionModel(
        text: "Share",
        actionsEnum: InstancyContentActionsEnum.Share,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.share,
      ),
    ];

    return actions;
  }

  Future<void> showMoreActions({required CourseDTOModel model}) async {
    List<InstancyUIActionModel> actions = getActionsList(model: model);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  Future<void> onDetailsTap({required CourseDTOModel model}) async {
    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: model.ContentID,
        componentId: widget.componentId,
        componentInstanceId: widget.componentInstanceId,
        userId: model.SiteUserID,
        screenType: InstancyContentScreenType.Catalog,
        courseDtoModel: model,
      ),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {
      /*getContentData = getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );*/
    }
  }

  Future<void> onViewTap({required CourseDTOModel model}) async {
    int objectType = model.ContentTypeId;

    if (objectType == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToFlashCardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.rolePlay) {
      dynamic value = await NavigationController.navigateToRolePlayLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: RolePlayLaunchScreenNavigationArguments(
          courseDTOModel: model,
        ),
      );
    } else if (objectType == InstancyObjectTypes.podcastEpisode) {
      NavigationController.navigateToPodcastEpisodeScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.referenceUrl) {
      NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://www.instancy.com/learn/",
        ),
      );
    } else if (objectType == InstancyObjectTypes.document) {
      NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const PDFLaunchScreenNavigationArguments(
          contntName: "Transformative Potential of Generative AI",
          isNetworkPDF: true,
          pdfUrl: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
        ),
      );
    } else if (objectType == InstancyObjectTypes.videos) {
      NavigationController.navigateToVideoScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.quiz) {
      NavigationController.navigateToQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.article) {
      NavigationController.navigateToArticleScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: ArticleScreenNavigationArguments(courseDTOModel: model),
      );
      /*NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://enterprisedemo.instancy.com/content/publishfiles/1539fc5c-7bde-4d82-a0f6-9612f9e6c426/ins_content.html?fromNativeapp=true",
        ),
      );*/
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();

    _provider = context.read<CoCreateKnowledgeProvider>();
    _controller = CoCreateKnowledgeController(coCreateKnowledgeProvider: _provider);
    future = getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return RefreshIndicator(
          onRefresh: () async {
            future = getFutureData();
            mySetState();
          },
          child: Scaffold(
            body: mainWidget(),
            floatingActionButton: PopUpDialog(
              provider: _provider,
            ),
          ),
        );
      },
    );
  }

  Widget mainWidget() {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) return const Center(child: CommonLoader());

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CoCreateKnowledgeProvider>.value(value: _provider),
          ],
          child: Consumer<CoCreateKnowledgeProvider>(
            builder: (context, CoCreateKnowledgeProvider provider, _) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 15, bottom: 10),
                    child: CustomSearchView(),
                  ),
                  Expanded(
                    child: getCoursesListView(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget getCoursesListView() {
    CoCreateKnowledgeProvider provider = _provider;

    if (provider.isLoading.get()) return const CommonLoader();
    List<CourseDTOModel> list = provider.myKnowledgeList.getList();

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
      itemBuilder: (BuildContext listContext, int index) {
        CourseDTOModel model = list[index];

        return getCatalogContentWidget(model: model);

        /*return MyKnowledgeItemWidget(
          model: model,
          onMoreTap: () {
            showMoreActions(model: model);
          },
          onCardTap: () {
            onViewTap(model: model);
          },
        );*/
      },
    );
  }

  Widget getCatalogContentWidget({required CourseDTOModel model}) {
    LocalStr localStr = appProvider.localStr;

    InstancyUIActionModel primaryAction = InstancyUIActionModel(
      onTap: () {
        onViewTap(model: model);
      },
      text: localStr.catalogActionsheetViewoption,
      actionsEnum: InstancyContentActionsEnum.View,
      iconData: InstancyIcons.view,
    );
    if (model.ContentTypeId == InstancyObjectTypes.events) {
      primaryAction = InstancyUIActionModel(
        onTap: () {
          onDetailsTap(model: model);
        },
        text: localStr.catalogActionsheetDetailsoption,
        actionsEnum: InstancyContentActionsEnum.Details,
        iconData: InstancyIcons.details,
      );
    }

    // MyPrint.printOnConsole("model content final image url:${model.ThumbnailImagePath}");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: CatalogContentListComponent(
        model: model,
        primaryAction: primaryAction,
        onPrimaryActionTap: () async {
          MyPrint.printOnConsole("primaryAction:$primaryAction");

          if (primaryAction.onTap != null) {
            primaryAction.onTap!();
          }
        },
        onMoreButtonTap: () {
          showMoreActions(model: model);
        },
      ),
    );
  }
}

class PopUpDialog extends StatefulWidget {
  final CoCreateKnowledgeProvider provider;

  const PopUpDialog({super.key, required this.provider});

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> with MySafeState {
  final List<KnowledgeTypeModel> knowledgeTypeList = [
    KnowledgeTypeModel(name: "Flashcard", iconUrl: "assets/cocreate/Card.png", objectTypeId: InstancyObjectTypes.flashCard),
    KnowledgeTypeModel(name: "Quiz", iconUrl: "assets/cocreate/Chat Question.png", objectTypeId: InstancyObjectTypes.quiz),
    KnowledgeTypeModel(name: "Podcast Episode", iconUrl: "assets/cocreate/Vector-4.png", objectTypeId: InstancyObjectTypes.podcastEpisode),
    KnowledgeTypeModel(name: "Article", iconUrl: "assets/cocreate/Vector-2.png", objectTypeId: InstancyObjectTypes.article),
    KnowledgeTypeModel(name: "Video", iconUrl: "assets/cocreate/video.png", objectTypeId: InstancyObjectTypes.videos),
    KnowledgeTypeModel(name: "Reference Link", iconUrl: "assets/cocreate/Vector-1.png", objectTypeId: InstancyObjectTypes.referenceUrl),
    KnowledgeTypeModel(name: "Documents", iconUrl: "assets/cocreate/Vector.png", objectTypeId: InstancyObjectTypes.document),
    KnowledgeTypeModel(name: "Event", iconUrl: "assets/cocreate/Vector-3.png", objectTypeId: InstancyObjectTypes.events),
    KnowledgeTypeModel(name: "Roleplay", iconUrl: "assets/cocreate/video.png", objectTypeId: InstancyObjectTypes.rolePlay),
    KnowledgeTypeModel(name: "Learning Maps", iconUrl: "assets/cocreate/Business Hierarchy.png", objectTypeId: InstancyObjectTypes.learningMaps),
    KnowledgeTypeModel(name: "AI Agents", iconUrl: "assets/cocreate/Ai.png", objectTypeId: InstancyObjectTypes.aiAgent),
  ];
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  void onCardTapCallBack({required int objectType}) {
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

    /*Map<String, dynamic> map = <String, dynamic>{
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
      "AddLink": "javascript:fnAddItemtoMyLearning('d40d27cd-dd15-4bf4-b769-f341ceee213d');",
      "EnrollNowLink": "",
      "CancelEventLink": "",
      "WaitListLink": "",
      "InapppurchageLink": "",
      "AlredyinmylearnigLink": "",
      "RecommendedLink": "",
      "Sharelink": "https://qalearning.instancy.com/InviteURLID/contentId/d40d27cd-dd15-4bf4-b769-f341ceee213d/ComponentId/1",
      "EditMetadataLink": "",
      "ReplaceLink": "",
      "EditLink": "",
      "DeleteLink": "",
      "SampleContentLink": "",
      "TitleExpired": "",
      "PracticeAssessmentsAction": "",
      "CreateAssessmentAction": "",
      "OverallProgressReportAction": "",
      "ContentName": "Web Page 141",
      "ContentScoID": "26712",
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
      "SkinID": "1",
      "FilterId": 0,
      "SiteId": 374,
      "UserSiteId": 0,
      "SiteName": "Instancy Social Learning Network",
      "ContentTypeId": 36,
      "ContentID": "d40d27cd-dd15-4bf4-b769-f341ceee213d",
      "Title": "Web Page 141",
      "TotalRatings": "0",
      "RatingID": "0",
      "ShortDescription": "",
      "ThumbnailImagePath": "/Content/SiteFiles/Images/Webpage.jpg",
      "InstanceParentContentID": "",
      "ImageWithLink": "",
      "AuthorWithLink": "",
      "EventStartDateTime": "",
      "EventEndDateTime": "",
      "EventStartDateTimeWithoutConvert": "",
      "EventEndDateTimeTimeWithoutConvert": "",
      "expandiconpath": "",
      "AuthorDisplayName": "Pradeep Rana 123",
      "ContentType": "Webpage",
      "CreatedOn": "",
      "TimeZone": "",
      "Tags": "",
      "SalePrice": "",
      "Currency": "",
      "ViewLink": "",
      "DetailsLink": "https://qalearning.instancy.com/Catalog Details/Contentid/d40d27cd-dd15-4bf4-b769-f341ceee213d/componentid/1/componentInstanceID/3131",
      "RelatedContentLink": "",
      "ViewSessionsLink": null,
      "SuggesttoConnLink": "d40d27cd-dd15-4bf4-b769-f341ceee213d",
      "SuggestwithFriendLink": "d40d27cd-dd15-4bf4-b769-f341ceee213d",
      "SharetoRecommendedLink": "",
      "IsCoursePackage": "",
      "IsRelatedcontent": "",
      "isaddtomylearninglogo": "0",
      "LocationName": "",
      "BuildingName": null,
      "JoinURL": "",
      "Categorycolor": "#67BD4E",
      "InvitationURL": "",
      "HeaderLocationName": "",
      "SubSiteUserID": null,
      "PresenterDisplayName": "",
      "PresenterWithLink": "",
      "ShowMembershipExpiryAlert": false,
      "AuthorName": null,
      "FreePrice": "",
      "SiteUserID": 1962,
      "ScoID": 26712,
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
      "startpage": "ins_content.html",
      "CategoryID": 0,
      "AddLinkTitle": "Add to My learning",
      "ContentStatus": "",
      "PercentCompletedClass": "",
      "PercentCompleted": "",
      "GoogleProductId": "",
      "ItunesProductId": "",
      "FolderPath": "82b071da-52e8-4cd9-a0a8-9b43f3c546e7",
      "CloudMediaPlayerKey": "",
      "ActivityId": "http://instancy.com/d40d27cd-dd15-4bf4-b769-f341ceee213d",
      "ActualStatus": null,
      "CoreLessonStatus": null,
      "jwstartpage": null,
      "IsReattemptCourse": false,
      "AttemptsLeft": 0,
      "TotalAttempts": 0,
      "ListPrice": "",
      "ContentModifiedDateTime": null
    };*/

    CourseDTOModel? courseDTOModel = CourseDTOModel.fromMap(map);

    courseDTOModel.ContentID = MyUtils.getNewId();
    courseDTOModel.AuthorName = "Richard Parker";
    courseDTOModel.AuthorDisplayName = "Richard Parker";
    courseDTOModel.ThumbnailImagePath = "Content/SiteFiles/Images/assignment-thumbnail.png";
    courseDTOModel.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";

    if (objectType == InstancyObjectTypes.flashCard) {
      MyPrint.printOnConsole("in flsh Card");

      courseDTOModel.TitleName = "Flash Card Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Flash Card";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.flashCard;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.rolePlay) {
      MyPrint.printOnConsole("in Role Play");

      courseDTOModel.TitleName = "Role Play Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Roleplay";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.flashCard;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.podcastEpisode) {
      courseDTOModel.TitleName = "Podcast";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Podcast Episode";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.podcastEpisode;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.referenceUrl) {
      courseDTOModel.TitleName = "Instancy";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Reference Url";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.referenceUrl;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.document) {
      courseDTOModel.TitleName = "Document Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Document";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.document;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.videos) {
      courseDTOModel.TitleName = "Video Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Videos";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.videos;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.quiz) {
      courseDTOModel.TitleName = "Quiz Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Quiz";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.quiz;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.article) {
      courseDTOModel.TitleName = "Article Title";
      courseDTOModel.Title = courseDTOModel.TitleName;
      courseDTOModel.AuthorDisplayName = "Pradeep Reddy";
      courseDTOModel.ContentType = "Article";
      courseDTOModel.ContentTypeId = InstancyObjectTypes.article;
      courseDTOModel.MediaTypeID = InstancyMediaTypes.none;
    } else if (objectType == InstancyObjectTypes.events) {
      MyPrint.printOnConsole("in Role Play");

      Map<String, dynamic> eventModelMap = <String, dynamic>{
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
        "AddLink": "",
        "EnrollNowLink": "",
        "CancelEventLink": "",
        "WaitListLink": "",
        "InapppurchageLink": "",
        "AlredyinmylearnigLink": "",
        "RecommendedLink": "",
        "Sharelink": "",
        "EditMetadataLink": "",
        "ReplaceLink": "",
        "EditLink": "",
        "DeleteLink": "",
        "SampleContentLink": "",
        "TitleExpired": "<span class='eventExpiredLabel'>On Demand Recording</span>",
        "PracticeAssessmentsAction": "",
        "CreateAssessmentAction": "",
        "OverallProgressReportAction": "",
        "ContentName": "TechTalk on system upgradation ",
        "ContentScoID": "26474",
        "isContentEnrolled": "False",
        "ContentViewType": "Subscription",
        "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
        "isWishListContent": 0,
        "AddtoWishList": "Y",
        "RemoveFromWishList": null,
        "Duration": "30Mins",
        "Credits": "1.00",
        "DetailspopupTags": "",
        "ThumbnailIconPath": "",
        "JWVideoKey": "",
        "Modules": "",
        "salepricestrikeoff": "",
        "isBadCancellationEnabled": "true",
        "EnrollmentLimit": "10",
        "AvailableSeats": "7",
        "NoofUsersEnrolled": "4",
        "WaitListLimit": "",
        "WaitListEnrolls": "0",
        "isBookingOpened": false,
        "EventStartDateforEnroll": "03/30/2024 04:00 PM",
        "DownLoadLink": "",
        "EventType": 1,
        "EventScheduleType": 0,
        "EventRecording": false,
        "ShowParentPrerequisiteEventDate": false,
        "ShowPrerequisiteEventDate": false,
        "PrerequisiteDateConflictName": null,
        "PrerequisiteDateConflictDateTime": null,
        "SkinID": "",
        "FilterId": 0,
        "SiteId": 374,
        "UserSiteId": 0,
        "SiteName": "Instancy Social Learning Network",
        "ContentTypeId": 70,
        "ContentID": "be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "Title": "TechTalk on system upgradation ",
        "TotalRatings": "0",
        "RatingID": "0",
        "ShortDescription": "",
        "ThumbnailImagePath": "/Content/SiteFiles/Images/Event.jpg",
        "InstanceParentContentID": "",
        "ImageWithLink": "",
        "AuthorWithLink": "",
        "EventStartDateTime": "",
        "EventEndDateTime": "",
        "EventStartDateTimeWithoutConvert": "",
        "EventEndDateTimeTimeWithoutConvert": "",
        "expandiconpath": "<img src='/Content/SiteFiles/Images/details_open.png' />",
        "AuthorDisplayName": "Pradeep Rana 123",
        "ContentType": "Classroom (in-person)",
        "CreatedOn": "",
        "TimeZone": "",
        "Tags": "",
        "SalePrice": "",
        "Currency": "",
        "ViewLink": "",
        "DetailsLink": "https://qalearning.instancy.com/Catalog Details/Contentid/be06f4c0-ebb7-4a4d-9e00-72461c06c422/componentid/1/componentInstanceID/3131",
        "RelatedContentLink": "https://qalearning.instancy.com/CatalogResources-Content/ContentID/be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "ViewSessionsLink": null,
        "SuggesttoConnLink": "be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "SuggestwithFriendLink": "be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "SharetoRecommendedLink": "",
        "IsCoursePackage": "",
        "IsRelatedcontent": "",
        "isaddtomylearninglogo": "0",
        "LocationName": "",
        "BuildingName": null,
        "JoinURL": "",
        "Categorycolor": "#67BD4E",
        "InvitationURL": "http://qalearning.instancy.com//InviteURLID/be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "HeaderLocationName": "",
        "SubSiteUserID": null,
        "PresenterDisplayName": "",
        "PresenterWithLink": "",
        "ShowMembershipExpiryAlert": false,
        "AuthorName": null,
        "FreePrice": "",
        "SiteUserID": 1962,
        "ScoID": 26474,
        "BuyNowLink": "",
        "bit5": true,
        "bit4": false,
        "OpenNewBrowserWindow": false,
        "CreditScoreWithCreditTypes": "",
        "CreditScoreFirstPrefix": "",
        "MediaTypeID": 46,
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
        "startpage": "",
        "CategoryID": 0,
        "AddLinkTitle": "Add to My learning",
        "ContentStatus": "",
        "PercentCompletedClass": "",
        "PercentCompleted": "",
        "GoogleProductId": "",
        "ItunesProductId": "",
        "FolderPath": "BE06F4C0-EBB7-4A4D-9E00-72461C06C422",
        "CloudMediaPlayerKey": "",
        "ActivityId": "http://instancy.com/be06f4c0-ebb7-4a4d-9e00-72461c06c422",
        "ActualStatus": null,
        "CoreLessonStatus": null,
        "jwstartpage": null,
        "IsReattemptCourse": false,
        "AttemptsLeft": 0,
        "TotalAttempts": 0,
        "ListPrice": "",
        "ContentModifiedDateTime": null
      };
      CourseDTOModel model = CourseDTOModel.fromMap(eventModelMap);

      model.ContentID = courseDTOModel.ContentID;
      model.AuthorName = model.AuthorDisplayName;
      model.UserProfileImagePath = "Content/SiteFiles//374/ProfileImages/0.gif";
      model.MediaTypeID = InstancyMediaTypes.none;
      courseDTOModel.ContentType = "Event";

      courseDTOModel = model;
    } else {
      courseDTOModel = null;
    }

    if (courseDTOModel != null) {
      widget.provider.addToMyKnowledgeList(courseDTOModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      overlayColor: Colors.black,
      overlayOpacity: .6,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 2,
      buttonSize: const Size(56.0, 56.0),
      // it's the SpeedDial size which defaults to 56 itself
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: const Size(50, 50),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,

      /// If true user is forced to close dial manually
      closeManually: false,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: true,
      onOpen: () {
        debugPrint('OPENING DIAL');
        // setState(() {});
      },
      onClose: () {
        debugPrint('DIAL CLOSED');
        // isDialOpen.value = false;
      },
      useRotationAnimation: true,
      tooltip: 'Open Speed Dial',
      elevation: 1.0,
      animationCurve: Curves.easeIn,
      isOpenOnStart: false,
      // shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
      // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: List.generate(
        knowledgeTypeList.length,
        (index) => SpeedDialChild(
          onTap: () {
            // Navigator.pop(context);
            isDialOpen.value = false;
            mySetState();
            MyPrint.printOnConsole("Index: ${knowledgeTypeList[index].objectTypeId}");
            onCardTapCallBack(objectType: knowledgeTypeList[index].objectTypeId);
          },
          label: knowledgeTypeList[index].name,
          labelStyle: TextStyle(color: themeData.colorScheme.onPrimary),
          labelBackgroundColor: themeData.primaryColor,
          backgroundColor: themeData.colorScheme.onPrimary,
          elevation: 0,
          labelShadow: [],
          child: Image.asset(
            knowledgeTypeList[index].iconUrl,
            height: 20,
            width: 20,
            color: themeData.primaryColor,
          ),
        ),
      ),
    );
  }
}

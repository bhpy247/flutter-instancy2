import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_controller.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_controller.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_header_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_reference_item_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_tab_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_block_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_track_headers_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_track_overview_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/data_model/my_learning_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/event_track/components/overview_tab_widget.dart';
import 'package:flutter_instancy_2/views/event_track/components/resource_tab_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/course_launch/course_launch_controller.dart';
import '../../../backend/event/event_controller.dart';
import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../backend/my_learning/my_learning_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/profile/profile_provider.dart';
import '../../../models/course_launch/data_model/course_launch_model.dart';
import '../../../models/event_track/data_model/event_track_content_model.dart';
import '../../../models/event_track/request_model/event_track_tab_request_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';
import '../components/content_tab_widget.dart';
import '../components/discussion_tab_widget.dart';
import '../components/glossary_tab_widget.dart';
import '../components/people_tab_widget.dart';
import '../components/session_tab_widget.dart';

class EventTrackScreen extends StatefulWidget {
  static const String routeName = "/EventTrackScreen";

  final EventTrackScreenArguments arguments;

  const EventTrackScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<EventTrackScreen> createState() => _EventTrackScreenState();
}

class _EventTrackScreenState extends State<EventTrackScreen> with SingleTickerProviderStateMixin, MySafeState {
  bool isLoading = false;

  late EventTrackProvider eventTrackProvider;
  late EventTrackController eventTrackController;
  late AppProvider appProvider;

  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;

  late MyConnectionsProvider myConnectionsProvider;
  late MyConnectionsController myConnectionsController;
  late ProfileProvider profileProvider;

  late MyLearningProvider myLearningProvider;
  late MyLearningController myLearningController;

  late EventProvider eventProvider;

  MyLearningCourseDTOModel myLearningCourseDTOModel = MyLearningCourseDTOModel();

  TabController? controller;

  int selectedIndex = 0;

  Future<void> getLearningPathHeaderData({bool isNotify = false}) async {
    await eventTrackController.getEventTrackHeaderData(
      requestModel: EventTrackHeadersRequestModel(
        parentcontentID: widget.arguments.parentContentId,
        objecttypeid: widget.arguments.objectTypeId,
        scoid: widget.arguments.scoId,
        iscontentenrolled: widget.arguments.isContentEnrolled,
      ),
      isNotify: isNotify,
    );
  }

  Future<void> getTabList() async {
    await eventTrackController.getEventTrackTabsData(
      requestModel: EventTrackTabRequestModel(
        parentcontentID: widget.arguments.parentContentId,
        compID: widget.arguments.componentId,
        compInsID: widget.arguments.componentInstanceId,
        objecttypeid: widget.arguments.objectTypeId,
        isRelatedContent: widget.arguments.isRelatedContent.toString(),
      ),
      isNotify: false,
    );

    List<EventTrackTabDTOModel> tabsList = eventTrackProvider.eventTrackTabList.getList();
    MyPrint.printOnConsole("_learningPathProvider.learningPathTabList: ${tabsList.length}");

    if (tabsList.length > 1) {
      List<EventTrackTabDTOModel> trackContentPresent = tabsList.where((element) => element.tabidName == widget.arguments.eventTrackTabType).toList();
      MyPrint.printOnConsole("trackContentPresent : ${trackContentPresent.length}");
      if (trackContentPresent.isNotEmpty) {
        int index = tabsList.indexOf(trackContentPresent.first);
        selectedIndex = index;
        controller = TabController(vsync: this, length: tabsList.length, initialIndex: index);
      } else {
        controller = TabController(
          vsync: this,
          length: tabsList.length,
        );
      }
      mySetState();
    }
    getContentDataFromTabsList(tabsList: tabsList);
  }

  void getContentDataFromTabsList({required List<EventTrackTabDTOModel> tabsList}) {
    for (EventTrackTabDTOModel model in tabsList) {
      switch (model.tabidName) {
        case EventTrackTabs.overview:
          {
            eventTrackController.getOverviewData(
              requestModel: EventTrackOverviewRequestModel(
                parentContentID: widget.arguments.parentContentId,
                objectTypeID: widget.arguments.objectTypeId.toString(),
                iscontentenrolled: widget.arguments.isContentEnrolled.toString(),
              ),
              isNotify: false,
            );
            break;
          }
        case EventTrackTabs.trackContents:
          {
            eventTrackController.getContentsData(
              contentId: widget.arguments.parentContentId,
              objectTypeId: widget.arguments.objectTypeId,
              trackScoId: widget.arguments.scoId,
              isRelatedContent: false,
              isNotify: false,
            );
            break;
          }
        case EventTrackTabs.session:
          {
            break;
          }
        case EventTrackTabs.eventContents:
          {
            eventTrackController.getContentsData(
              contentId: widget.arguments.parentContentId,
              objectTypeId: widget.arguments.objectTypeId,
              isRelatedContent: true,
              isNotify: false,
            );
            break;
          }
        case EventTrackTabs.trackAssignments:
          {
            break;
          }
        case EventTrackTabs.eventAssignments:
          {
            break;
          }
        case EventTrackTabs.discussions:
          {
            /*discussionProvider.forumContentId.set(value: widget.arguments.parentContentId, isNotify: false);
            discussionController.getForumsList(
              isRefresh: true,
              isGetFromCache: false,
              isNotify: true,
            );*/
            break;
          }
        case EventTrackTabs.resources:
          {
            eventTrackController.getResourcesData(
              contentId: widget.arguments.parentContentId,
              isNotify: false,
            );
            break;
          }
        case EventTrackTabs.people:
          {
            /*myConnectionsProvider.peopleListContentId.set(value: widget.arguments.parentContentId, isNotify: false);
            myConnectionsController.getPeopleList(
              isRefresh: true,
              isGetFromCache: false,
              isNotify: true,
            );*/
            break;
          }
        case EventTrackTabs.gloassary:
          {
            eventTrackController.getGlossaryData(
              contentId: widget.arguments.parentContentId,
              isNotify: false,
            );
            break;
          }
      }
    }
  }


  @override
  void initState() {
    super.initState();
    eventTrackProvider = widget.arguments.eventTrackProvider ?? EventTrackProvider();
    eventTrackController = EventTrackController(learningPathProvider: eventTrackProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);

    discussionProvider = DiscussionProvider();
    discussionController = DiscussionController(discussionProvider: discussionProvider);

    myConnectionsProvider = MyConnectionsProvider();
    myConnectionsController = MyConnectionsController(connectionsProvider: myConnectionsProvider);

    eventProvider = EventProvider();
    profileProvider = context.read<ProfileProvider>();

    myLearningProvider = MyLearningProvider();
    myLearningController = MyLearningController(provider: myLearningProvider);

    getLearningPathHeaderData();
    getTabList();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventTrackProvider>.value(value: eventTrackProvider),
        ChangeNotifierProvider<DiscussionProvider>.value(value: discussionProvider),
        ChangeNotifierProvider<MyConnectionsProvider>.value(value: myConnectionsProvider),
      ],
      child: Consumer3<EventTrackProvider, DiscussionProvider, MyConnectionsProvider>(
        builder: (BuildContext context, EventTrackProvider eventTrackProvider, DiscussionProvider discussionProvider, MyConnectionsProvider myConnectionsProvider, _) {
          return WillPopScope(
            onWillPop: () async {
              if(isLoading) {
                return false;
              }

              return true;
            },
            child: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                appBar: getAppBar(),
                body: getMainBodyWidget(),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar getAppBar() {
    return AppConfigurations().commonAppBar(title: widget.arguments.objectTypeId == InstancyObjectTypes.events ? "Related Contents" : "Learning Path");
  }

  Widget getMainBodyWidget() {
    return Column(
      children: [
        getHeaderWidget(),
        Expanded(
          child: tabBarView(),
        ),
      ],
    );
  }

  //region Header Widget
  Widget getHeaderWidget() {
    if (eventTrackProvider.isHeaderDataLoading.get()) {
      // if (true) {
      return const SizedBox();
    }

    EventTrackHeaderDTOModel? headerDTOModel = eventTrackProvider.eventTrackHeaderData.get();
    if (headerDTOModel == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget(headerDTOModel.ThumbnailImagePath),
              const SizedBox(width: 20),
              Expanded(child: detailColumn(headerDTOModel)),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1.5),
      ],
    );
  }

  Widget imageWidget(String url) {
    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 95,
        width: 95,
        child: CommonCachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget detailColumn(EventTrackHeaderDTOModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.TitleName,
                    style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "By ${model.AuthorDisplayName}",
                    style: themeData.textTheme.bodySmall?.copyWith(fontSize: 12, color: const Color(0xff9AA0A6)),
                  ),
                  const SizedBox(height: 8),
                  ratingView(ParsingHelper.parseDoubleMethod(model.TotalRatings)),
                ],
              ),
            ),
            // downloadIcon()
          ],
        ),
        const SizedBox(height: 8),
        if (widget.arguments.objectTypeId != InstancyObjectTypes.events)
          linearProgressBar(
            percentCompleted: ParsingHelper.parseIntMethod(model.percentagecompleted),
            contentStatus: model.ContentStatus,
            displayStatus: model.DisplayStatus,
          ),
      ],
    );
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.cover,
    );
  }

  Widget ratingView(double ratings) {
    return RatingBarIndicator(
      rating: ratings,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.black,
      ),
      itemCount: 5,
      unratedColor: const Color(0xffCBCBD4),
      itemSize: 15.0,
      direction: Axis.horizontal,
    );
  }

  Widget linearProgressBar({required int percentCompleted, required String contentStatus, required String displayStatus}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressBar(
            maxSteps: 100,
            progressType: LinearProgressBar.progressTypeLinear,
            // Use Dots progress
            currentStep: percentCompleted,
            progressColor: AppConfigurations.getContentStatusColorFromActualStatus(status: contentStatus),
            backgroundColor: const Color(0xffDCDCDC),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "$percentCompleted% $displayStatus",
          // "$contentStatus",
          style: themeData.textTheme.titleSmall?.copyWith(fontSize: 12),
        )
      ],
    );
  }

  Widget downloadIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, spreadRadius: 1),
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Icon(
            Icons.file_download_outlined,
            color: Color(0xff242424),
          ),
        ),
      ),
    );
  }

  //endregion

  Widget tabBarView() {
    if (eventTrackProvider.isTabListLoading.get()) {
      return const Center(
        child: CommonLoader(),
      );
    }

    List<EventTrackTabDTOModel> learningPathTabList = eventTrackProvider.eventTrackTabList.getList();
    Widget child;
    PreferredSize? tabBar;
    if (controller != null) {
      child = Container(
        color: Colors.white,
        child: TabBarView(
          controller: controller,
          children: learningPathTabList.map((e) {
            MyPrint.printOnConsole("element:$e");
            return getWidgetAccordingToTabs(e);
          }).toList(),
        ),
      );

      tabBar = PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: SafeArea(
            child: Container(
              /*decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
              ),*/
              child: TabBar(
                  controller: controller,
                  isScrollable: controller!.length > 3,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 10),
                  indicatorPadding: const EdgeInsets.only(top: 20),
                  // indicatorWeight:0,
                  indicatorSize: TabBarIndicatorSize.label,
                  onTap: (int index) {
                    selectedIndex = index;
                    mySetState();
                  },
                  labelStyle: themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5),
                  tabs: List.generate(
                    learningPathTabList.length,
                    (index) => tabTitleWidget(
                      title: learningPathTabList[index].tabName,
                      assetPath: "assets/myLearning/${learningPathTabList[index].tabName.toLowerCase()}.png",
                      index: index,
                    ),
                  )

                  // tabs: learningPathTabList.map((e) {
                  //   return tabTitleWidget(
                  //     title: e.tabName,
                  //     assetPath: "assets/myLearning/${e.tabName.toLowerCase()}.png",
                  //     // index: e.tabID,
                  //
                  //   );
                  // }).toList(),
                  ),
            ),
          ),
        ),
      );
    } else {
      if (learningPathTabList.isNotEmpty) {
        child = getWidgetAccordingToTabs(learningPathTabList.first);
      } else {
        child = Center(
          child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
        );
      }
    }
    return Scaffold(
      appBar: controller != null
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 1,
              bottom: tabBar,
            )
          : null,
      body: child,
    );
  }

  Widget getWidgetAccordingToTabs(EventTrackTabDTOModel learningPathTabTrackModel) {
    Widget resultWidget = const Center(
      child: Text("Coming Soon"),
    );
    switch (learningPathTabTrackModel.tabidName) {
      case EventTrackTabs.overview:
        {
          resultWidget = getOverviewTabWidget();
          break;
        }
      case EventTrackTabs.session:
        {
          resultWidget = getSessionsTabWidget();
          break;
        }
      case EventTrackTabs.trackContents:
        {
          resultWidget = getContentTabWidget();
          break;
        }
      case EventTrackTabs.eventContents:
        {
          resultWidget = getContentTabWidget();
          break;
        }
      case EventTrackTabs.resources:
        {
          resultWidget = getResourceTabWidget();
          break;
        }
      case EventTrackTabs.discussions:
        {
          resultWidget = getDiscussionTabWidget();
          break;
        }
      case EventTrackTabs.people:
        {
          resultWidget = getPeopleTabWidget();
          break;
        }
      case EventTrackTabs.gloassary:
        {
          resultWidget = getGlossaryTabWidget();
          break;
        }
    }
    return resultWidget;
  }

  Widget tabTitleWidget({String title = "", String assetPath = "", int index = 0}) {
    MyPrint.printOnConsole("tabTitleWidget INDEX: $index");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: assetPath.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Image.asset(
                assetPath,
                height: 18,
                width: 18,
                color: selectedIndex == index ? themeData.primaryColor : Styles.indicatorIconColor,
              ),
            ),
          ),
          Flexible(
            child: Text(title),
          ),
        ],
      ),
    );
  }

  Widget getOverviewTabWidget() {
    if (eventTrackProvider.isOverviewDataLoading.get()) {
      return const CommonLoader(isCenter: true);
    }

    EventTrackDTOModel? overviewData = eventTrackProvider.overviewData.get();

    return OverViewTabWidget(overviewData: overviewData);
  }

  Widget getContentTabWidget() {
    if (eventTrackProvider.isContentsDataLoading.get()) {
      return const CommonLoader(isCenter: true);
    }

    List<TrackBlockModel> contentBlocksList = eventTrackProvider.contentsData.getList(isNewInstance: false);

    return ContentTabWidget(
      contentBlocksList: contentBlocksList,
      trackId: widget.arguments.objectTypeId == InstancyObjectTypes.track ? widget.arguments.parentContentId : "",
      eventId: widget.arguments.objectTypeId == InstancyObjectTypes.events ? widget.arguments.parentContentId : "",
      userId: eventTrackController.eventTrackRepository.apiController.apiDataProvider.getCurrentUserId(),
      componentId: widget.arguments.componentId,
      componentInsId: widget.arguments.componentInstanceId,
      onSetCompleteTap: ({required EventTrackContentModel model}) async {
        isLoading = true;
        mySetState();

        bool isSuccess = await myLearningController.setComplete(
          contentId: model.contentid,
          scoId: model.scoid,
        );
        MyPrint.printOnConsole("SetComplete isSuccess:$isSuccess");

        isLoading = false;
        mySetState();

        if (isSuccess) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "SetComplete was successful");
          getLearningPathHeaderData();
          eventTrackController.getContentsData(
            contentId: widget.arguments.parentContentId,
            objectTypeId: widget.arguments.objectTypeId,
            trackScoId: widget.arguments.scoId,
            isRelatedContent: widget.arguments.objectTypeId == InstancyObjectTypes.events,
            isNotify: true,
          );
        }
      },
      onPulledTORefresh: () {
        eventTrackController.getContentsData(
          contentId: widget.arguments.parentContentId,
          objectTypeId: widget.arguments.objectTypeId,
          trackScoId: widget.arguments.scoId,
          isRelatedContent: widget.arguments.objectTypeId == InstancyObjectTypes.events,
          isNotify: true,
        );
      },
      refreshParentAndChildContentsCallback: () {
        getLearningPathHeaderData(isNotify: false);
        eventTrackController.getContentsData(
          contentId: widget.arguments.parentContentId,
          objectTypeId: widget.arguments.objectTypeId,
          trackScoId: widget.arguments.scoId,
          isRelatedContent: widget.arguments.objectTypeId == InstancyObjectTypes.events,
          isNotify: true,
        );
      },
      onContentViewTap: ({required EventTrackContentModel model}) async {
        ApiUrlConfigurationProvider apiUrlConfigurationProvider = eventTrackController.eventTrackRepository.apiController.apiDataProvider;

        isLoading = true;
        mySetState();

        bool isLaunched = await CourseLaunchController(
          appProvider: appProvider,
          authenticationProvider: context.read<AuthenticationProvider>(),
          componentId: widget.arguments.componentId,
          componentInstanceId: widget.arguments.componentInstanceId,
        ).viewCourse(
          context: context,
          model: CourseLaunchModel(
            ContentTypeId: model.objecttypeid,
            MediaTypeId: model.mediatypeid,
            ScoID: model.scoid,
            SiteUserID: apiUrlConfigurationProvider.getCurrentUserId(),
            SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
            ContentID: model.contentid,
            locale: apiUrlConfigurationProvider.getLocale(),
            ActivityId: model.activityid,
            ActualStatus: model.actualstatus,
            ContentName: model.name,
            FolderPath: model.folderpath,
            JWVideoKey: model.jwvideokey,
            jwstartpage: model.jwstartpage,
            startPage: model.startpage,
            bit5: model.bit5,
          ),
        );

        isLoading = false;
        mySetState();

        if (isLaunched) {
          if (widget.arguments.objectTypeId == InstancyObjectTypes.track) getLearningPathHeaderData(isNotify: false);
          eventTrackController.getContentsData(
            contentId: widget.arguments.parentContentId,
            objectTypeId: widget.arguments.objectTypeId,
            trackScoId: widget.arguments.scoId,
            isRelatedContent: widget.arguments.objectTypeId == InstancyObjectTypes.events,
            isNotify: true,
          );
        }
      },
      onReportContentTap: ({required EventTrackContentModel model}) {
        NavigationController.navigateToMyLearningContentProgressScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: MyLearningContentProgressScreenNavigationArguments(
            contentId: model.contentid,
            eventTrackContentModel: model,
            userId: eventTrackController.eventTrackRepository.apiController.apiDataProvider.getCurrentUserId(),
            contentTypeId: model.objecttypeid,
            componentId: widget.arguments.componentId,
            trackId: widget.arguments.objectTypeId == InstancyObjectTypes.track ? widget.arguments.parentContentId : "",
            eventId: widget.arguments.objectTypeId == InstancyObjectTypes.events ? widget.arguments.parentContentId : "",
            seqId: model.sequencenumber.toString(),
          ),
        );
      },
      onCancelEnrollmentTap: ({required EventTrackContentModel model}) async {
        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.contentid,
          isBadCancellationEnabled: model.isBadCancellationEnabled == true,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");

          if (widget.arguments.objectTypeId == InstancyObjectTypes.track) getLearningPathHeaderData(isNotify: false);
          eventTrackController.getContentsData(
            contentId: widget.arguments.parentContentId,
            objectTypeId: widget.arguments.objectTypeId,
            trackScoId: widget.arguments.scoId,
            isRelatedContent: widget.arguments.objectTypeId == InstancyObjectTypes.events,
            isNotify: true,
          );
        }
      },
    );
  }

  Widget getSessionsTabWidget() {
    return SessionTabWidget(
      eventId: widget.arguments.parentContentId,
      eventProvider: eventProvider,
    );
  }

  Widget getResourceTabWidget() {
    if (eventTrackProvider.isResourcesDataLoading.get()) {
      return const CommonLoader(isCenter: true);
    }

    List<EventTrackReferenceItemModel> resourceData = eventTrackProvider.resourcesData.getList(isNewInstance: false);

    return ResourceTabWidget(
      resourceData: resourceData,
    );
  }

  Widget getDiscussionTabWidget() {
    if (discussionProvider.forumListPaginationModel.get().isFirstTimeLoading) {
      return const CommonLoader(isCenter: true);
    }

    return DiscussionTabWidget(
      contentId: widget.arguments.parentContentId,
      discussionProvider: discussionProvider,
    );
  }

  Widget getPeopleTabWidget() {
    if (myConnectionsProvider.peopleListPaginationModel.get().isFirstTimeLoading) {
      return const CommonLoader(isCenter: true);
    }

    return PeopleTabWidget(
      contentId: widget.arguments.parentContentId,
      myConnectionsProvider: myConnectionsProvider,
      createdByUserId: eventTrackProvider.eventTrackHeaderData.get()?.CreatedUserID.toString() ?? "",
    );
  }

  Widget getGlossaryTabWidget() {
    if (eventTrackProvider.isGlossaryDataLoading.get()) {
      return const CommonLoader(isCenter: true);
    }

    List<GlossaryModel> glossaryData = eventTrackProvider.glossaryData.getList(isNewInstance: false);

    return GlossaryTabWidget(
      glossaryData: glossaryData,
    );
  }
}
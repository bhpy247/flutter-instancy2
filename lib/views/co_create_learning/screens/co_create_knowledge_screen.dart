import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/component_configurations_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/catalog/catalogCategoriesForBrowseModel.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/removeFromWishlistModel.dart';
import 'package:flutter_instancy_2/models/common/navigatingBackFromGlobalSearchModel.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/learning_provider_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/waitlist/response_model/add_to_waitList_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/catalog/components/add_wiki_button_component.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalogContentListComponent.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/shared_knowledge_tab.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:flutter_instancy_2/views/common/components/comment_dialog.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/filter/components/selected_filters_listview_component.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'my_knowledge_tab.dart';

class CoCreateKnowledgeScreen extends StatefulWidget {
  static const String routeName = "/CoCreateKnowledgeScreen";

  final CoCreateKnowledgeScreenNavigationArguments arguments;

  const CoCreateKnowledgeScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<CoCreateKnowledgeScreen> createState() => _CoCreateKnowledgeScreenState();
}

class _CoCreateKnowledgeScreenState extends State<CoCreateKnowledgeScreen> with MySafeState {
  TextEditingController textEditingController = TextEditingController();

  Future? getContentData, getFileUploadControlFuture;

  late CatalogProvider catalogProvider;
  late CatalogController catalogController;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late WikiProvider wikiProvider;

  late AppProvider appProvider;

  bool isLoading = false, isWikiButtonEnabled = false;

  int componentId = 0, componentInstanceId = 0;

  //This is only used to decide whether to show Breadcrumb or not
  ContentFilterCategoryTreeModel? selectedCategoryId;
  List<CatalogCategoriesForBrowseModel> pathList = <CatalogCategoriesForBrowseModel>[];

  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  void initialization() {
    catalogProvider = widget.arguments.catalogProvider ?? CatalogProvider();
    catalogController = CatalogController(provider: catalogProvider, apiController: widget.arguments.apiController);

    coCreateKnowledgeProvider = widget.arguments.coCreateKnowledgeProvider ?? CoCreateKnowledgeProvider();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider, apiController: widget.arguments.apiController);

    if (widget.arguments.searchString.checkNotEmpty) {
      catalogProvider.catalogContentSearchString.set(value: widget.arguments.searchString);
    }
    wikiProvider = widget.arguments.wikiProvider ?? WikiProvider();

    appProvider = Provider.of<AppProvider>(context, listen: false);

    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;
    MyPrint.printOnConsole("componentId: $componentId componentinstance $componentInstanceId");

    selectedCategoryId = widget.arguments.selectedCategory;
    if (widget.arguments.subSiteId != null) {
      catalogProvider.filterProvider.selectedLearningProviders.setList(
        list: [
          LearningProviderModel(SiteID: widget.arguments.subSiteId ?? 0),
        ],
      );
    }

    if (selectedCategoryId != null) {
      catalogProvider.filterProvider.setEnabledContentFilterByTypeModelFromList(filterByList: [ContentFilterByTypes.categories], isNotify: false);
      catalogProvider.filterProvider.selectedCategories.setList(
        list: [selectedCategoryId!],
        isClear: true,
        isNotify: false,
      );
    }
    pathList = widget.arguments.categoriesListForPath ?? <CatalogCategoriesForBrowseModel>[];
    if (widget.arguments.searchString.checkNotEmpty) {
      catalogProvider.catalogContentSearchString.set(value: widget.arguments.searchString);
    }
    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      catalogController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );

      if (componentModel.componentConfigurationsModel.DefaultRepositoryID) {
        isWikiButtonEnabled = true;
      }
    }

    if (catalogProvider.catalogContentLength == 0) {
      getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    }

    if (catalogProvider.wishlistContentsLength == 0) {
      catalogController.getWishListContentsListFromApi(
        isRefresh: true,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        isGetFromCache: false,
        isNotify: false,
        HomeComponentId: widget.arguments.HomeComponentId,
        isPinnedContent: false,
      );
    }
  }

  Future<void> getCatalogContentsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      catalogController.getCatalogContentsListFromApi(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        HomeComponentId: widget.arguments.HomeComponentId,
        isPinnedContent: false,
      ),
      if (isRefresh)
        catalogController.getWishListContentsListFromApi(
          isRefresh: true,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          HomeComponentId: widget.arguments.HomeComponentId,
          isPinnedContent: false,
          isGetFromCache: false,
          isNotify: isNotify,
        ),
    ]);
  }

  CatalogUIActionCallbackModel getCatalogUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
    required int index,
  }) {
    return CatalogUIActionCallbackModel(
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () async {
              MyPrint.printOnConsole("on view tap");
              if (isSecondaryAction) Navigator.pop(context);
              onContentLaunchTap(model: model);
              if (model.ViewType == ViewTypesForContent.ViewAndAddToMyLearning && !ParsingHelper.parseBoolMethod(model.isContentEnrolled)) {
                addContentToMyLearning(model: model, index: index, isShowToast: false);
              }
            },
      onAddToMyLearningTap: primaryAction == InstancyContentActionsEnum.AddToMyLearning
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);
              addContentToMyLearning(model: model, index: index);
            },
      onBuyTap: primaryAction == InstancyContentActionsEnum.Buy
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              isLoading = true;
              mySetState();

              bool isBuySuccess = await catalogController.buyCourse(
                context: context,
                model: model,
                ComponentID: componentId,
                ComponentInsID: componentInstanceId,
                isWaitForPostPurchaseProcesses: true,
              );

              isLoading = false;
              mySetState();

              if (isBuySuccess) {
                await getCatalogContentsList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: true,
                );
              }
            },
      onEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(model: model, index: index);
      },
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await onDetailsTap(model: model);
      },
      onReEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await onDetailsTap(model: model);
      },
      onIAmInterestedTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        await onIAmInterestedTap(model.ContentID);
        isLoading = false;
        mySetState();
      },
      onContactTap: () async {
        if (model.startpage.isNotEmpty) {
          MyUtils.launchUrl(url: MyUtils.getSecureUrl(model.startpage));
        }
      },
      onAddToWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        bool isSuccess = await catalogController.addContentToWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        MyPrint.printOnConsole("isSuccess: $isSuccess");
        isLoading = false;
        mySetState();

        if (isSuccess) {
          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }

        if (pageMounted && context.mounted) {
          if (isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemaddedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onRemoveWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        MyPrint.printOnConsole("Component instance id: $componentInstanceId");
        RemoveFromWishlistResponseModel removeFromWishlistResponseModel = await catalogController.removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        isLoading = false;
        mySetState();
        MyPrint.printOnConsole("valueeee: ${removeFromWishlistResponseModel.isSuccess}");
        if (removeFromWishlistResponseModel.isSuccess) {
          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        MyPrint.printOnConsole("Content id: ${model.ContentID}");
        MyPrint.printOnConsole("Content id: ${model.ContentID}");
        isLoading = true;
        mySetState();
        AddToWaitListResponseModel addToWaitListResponseModel = await CatalogController(provider: null).addContentToWaitList(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        MyPrint.printOnConsole("isSuccess: ${addToWaitListResponseModel.isSuccess}");
        isLoading = false;
        mySetState();

        if (addToWaitListResponseModel.isSuccess) {
          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }

        if (pageMounted && context.mounted) {
          if (addToWaitListResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: addToWaitListResponseModel.message);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onCancelEnrollmentTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled == true,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");

          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onViewResources: primaryAction == InstancyContentActionsEnum.ViewResources
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              dynamic value = await NavigationController.navigateToEventTrackScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                arguments: EventTrackScreenArguments(
                  eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
                  objectTypeId: model.ContentTypeId,
                  isRelatedContent: true,
                  parentContentId: model.ContentID,
                  componentId: componentId,
                  scoId: model.ScoID,
                  componentInstanceId: componentInstanceId,
                  isContentEnrolled: model.isCourseEnrolled(),
                  eventTrackContentModel: model,
                ),
              );

              if (value == true) {
                getCatalogContentsList();
              }
            },
      onRescheduleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onRescheduleTap
      },
      onReEnrollmentHistoryTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        String parentEventId = "";
        String instanceEventId = "";

        if (model.EventScheduleType == EventScheduleTypes.parent) {
          parentEventId = model.ContentID;
          instanceEventId = "";
        } else if (model.EventScheduleType == EventScheduleTypes.instance) {
          parentEventId = model.InstanceParentContentID;
          instanceEventId = model.ContentID;
        }

        await NavigationController.navigateToReEnrollmentHistoryScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ReEnrollmentHistoryScreenNavigationArguments(
            parentEventId: parentEventId,
            instanceEventId: instanceEventId,
            ContentName: model.ContentName,
            AuthorDisplayName: model.AuthorDisplayName,
            ThumbnailImagePath: model.ThumbnailImagePath,
          ),
        );
      },
      onRecommendToTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToRecommendToScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: RecommendToScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            componentId: componentId,
          ),
        );
      },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            shareProvider: context.read<ShareProvider>(),
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareWithPeopleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        MyUtils.shareContent(content: model.Sharelink, context: context);
      },
      onDownloadTap: () {},
    );
  }

  Future<void> showMoreAction({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    required int index,
  }) async {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(appProvider: appProvider);
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController
        .getCatalogScreenSecondaryActions(
          catalogCourseDTOModel: model,
          localStr: localStr,
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            index: index,
          ),
          isWishlistMode: false,
        )
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onIAmInterestedTap(String contentId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommentDialog(
          contentId: contentId,
          catalogController: catalogController,
        );
      },
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
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          userId: model.SiteUserID,
          siteId: widget.arguments.subSiteId,
          screenType: InstancyContentScreenType.Catalog,
          courseDtoModel: model),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {
      getContentData = getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  Future<void> addContentToMyLearning({required CourseDTOModel model, required int index, bool isShowToast = true}) async {
    if (model.AddLink == ContentAddLinkOperations.redirecttodetails) {
      onDetailsTap(model: model);
      return;
    }

    isLoading = true;
    mySetState();

    String contentId = model.ContentID;

    bool isSuccess = await catalogController.addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: contentId,
        multiInstanceParentId: model.InstanceParentContentID,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: "",
        ComponentID: componentId,
        ComponentInsID: componentInstanceId,
        objecttypeId: model.ContentTypeId,
        scoId: model.ScoID,
        courseDTOModel: model,
      ),
      context: context,
      onPrerequisiteDialogShowEnd: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowEnd called");

        isLoading = true;
        mySetState();
      },
      onPrerequisiteDialogShowStarted: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowStarted called");
        isLoading = false;
        mySetState();
      },
      hasPrerequisites: model.hasPrerequisiteContents(),
      isShowToast: isShowToast,
      isWaitForOtherProcesses: true,
    );
    MyPrint.printOnConsole("isSuccess $isSuccess");

    isLoading = false;
    mySetState();
  }

  Future<void> onContentLaunchTap({required CourseDTOModel model}) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = catalogController.catalogRepository.apiController.apiDataProvider;

    isLoading = true;
    mySetState();

    GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
      requestModel: UpdateContentGamificationRequestModel(
        contentId: model.ContentID,
        scoId: model.ScoID,
        objecttypeId: model.ContentTypeId,
        GameAction: GamificationActionType.Launched,
        isCourseLaunch: true,
      ),
    );

    bool isLaunched = await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    ).viewCourse(
      context: context,
      model: CourseLaunchModel(
        ContentTypeId: model.ContentTypeId,
        MediaTypeId: model.MediaTypeID,
        ScoID: model.ScoID,
        SiteUserID: model.SiteUserID,
        SiteId: model.SiteId,
        ContentID: model.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: model.ActivityId,
        ActualStatus: model.ActualStatus,
        ContentName: model.ContentName,
        FolderPath: model.FolderPath,
        JWVideoKey: model.JWVideoKey,
        jwstartpage: model.jwstartpage,
        startPage: model.startpage,
        courseDTOModel: model,
      ),
    );

    isLoading = false;
    mySetState();

    if (isLaunched) {
      /*getCatalogContentsList(
        isRefresh: true,
        isNotify: true,
        isGetFromCache: false,
      );*/
    }
  }

  Future<void> navigateToFilterScreen({String? contentFilterByTypes}) async {
    MyPrint.printOnConsole("navigateToFilterScreen called with contentFilterByTypes:$contentFilterByTypes");

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);

    if (componentModel == null) {
      return;
    }

    dynamic value = await NavigationController.navigateToFiltersScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FiltersScreenNavigationArguments(
        componentId: componentId,
        filterProvider: catalogProvider.filterProvider,
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
        contentFilterByTypes: contentFilterByTypes,
      ),
    );
    MyPrint.printOnConsole("Filter Value:$value");

    if (value == true) {
      getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: widget.arguments.isShowAppbar ? getAppBar() : null,
        body: AppUIComponents.getBackGroundBordersRounded(context: context, child: getTabBarView()),
      ),
    );
  }

  Widget getTabBarView() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: themeData.tabBarTheme.indicatorColor ?? themeData.primaryColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            tabs: const [
              Tab(
                // icon: Icon(Icons.library_books),
                text: 'Shared Knowledge',
              ),
              Tab(
                // icon: Icon(Icons.share),
                text: 'My Knowledge',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SharedKnowledgeTab(
              componentId: componentId,
              componentInstanceId: componentInstanceId,
            ),
            MyKnowledgeTab(
              componentId: componentId,
              componentInstanceId: componentInstanceId,
            ),
          ],
        ),
      ),
    );
  }

  Widget getSharedKnowledge() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
      ],
      child: Consumer<CatalogProvider>(
        builder: (BuildContext context, CatalogProvider catalogProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              floatingActionButton: isWikiButtonEnabled
                  ? AddWikiButtonComponent(
                      componentId: componentId,
                      componentInstanceId: componentInstanceId,
                      wikiProvider: wikiProvider,
                      isHandleChatBotSpaceMargin: !widget.arguments.isShowAppbar,
                    )
                  : null,
              body: getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      // title: "Catalog",
      title: "Co-create Knowledge",
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await NavigationController.navigateToWishlist(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: WishListScreenNavigationArguments(
                      componentId: widget.arguments.componentId,
                      componentInstanceId: widget.arguments.componentInstanceId,
                      catalogProvider: catalogProvider,
                    ),
                  );
                  getCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(FontAwesomeIcons.heart),
                    ),
                    if (catalogProvider.maxWishlistContentsCount.get() > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeData.primaryColor,
                          ),
                          child: Text(
                            "${catalogProvider.maxWishlistContentsCount.get()}",
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        getBreadcrumbWidget(),
        getSearchTextFormField(),
        const SizedBox(height: 10),
        getSelectedFiltersListviewWidget(),
        Expanded(
          child: getCatalogContentsListView(),
        ),
      ],
    );
  }

  Widget getSelectedFiltersListviewWidget() {
    FilterProvider filterProvider = catalogProvider.filterProvider;

    return SelectedFiltersListviewComponent(
      filterProvider: filterProvider,
      onResetFilter: () {
        FilterController(filterProvider: filterProvider).resetFilterData();
        getCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onFilterChipTap: ({required String contentFilterByTypes}) {
        if (contentFilterByTypes.isEmpty) return;

        navigateToFilterScreen(contentFilterByTypes: contentFilterByTypes);
      },
    );
  }

  Widget getCatalogContentsListView() {
    return getContentsListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: catalogProvider.catalogContentLength,
      paginationModel: catalogProvider.catalogContentPaginationModel.get(),
      onRefresh: () async {
        getCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getCatalogContentsList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getContentsListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ItemScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    if (paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: AppConfigurations.commonNoDataView(),
            ),
          ],
        ),
      );
    }

    List<CourseDTOModel> list = catalogProvider.catalogCategoryContent.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && list.isEmpty) || index == list.length) {
            if (paginationModel.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CommonLoader(
                    size: 70,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (contentsLength - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
            onPagination();
          }

          CourseDTOModel model = list[index];

          return getCatalogContentWidget(model: model, index: index);
        },
      ),
    );
  }

  Widget getCatalogContentWidget({required CourseDTOModel model, required int index}) {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(
      appProvider: appProvider,
    );

    List<InstancyUIActionModel> options = catalogUIActionsController
        .getCatalogScreenPrimaryActions(
          catalogCourseDTOModel: model,
          localStr: localStr,
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            isSecondaryAction: false,
            index: index,
          ),
          isWishlistMode: false,
        )
        .toList();

    // MyPrint.printOnConsole("${model.Title} : options:$options");

    InstancyUIActionModel? primaryAction = options.firstElement;
    // MyPrint.printOnConsole("primaryAction in Page:$primaryAction");
    // MyPrint.printOnConsole("primaryAction in Page:${primaryAction?.actionsEnum}");
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: CatalogContentListComponent(
        model: model,
        primaryAction: primaryAction,
        onPrimaryActionTap: () async {
          MyPrint.printOnConsole("primaryAction:$primaryActionEnum");

          if (primaryAction?.onTap != null) {
            primaryAction!.onTap!();
          }
        },
        onMoreButtonTap: () {
          showMoreAction(model: model, primaryAction: primaryActionEnum, index: index);
        },
      ),
    );
  }

  //region breadCrumbWidget
  Widget getBreadcrumbWidget() {
    if (pathList.isEmpty) return const SizedBox();

    List<ContentFilterCategoryTreeModel> selectedCategories = catalogProvider.filterProvider.selectedCategories.getList(isNewInstance: false);
    if (selectedCategories.length != 1 || selectedCategories.first.categoryId != selectedCategoryId?.categoryId) {
      selectedCategoryId = null;
      pathList.clear();
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // height: 50,
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        alignment: Alignment.centerLeft,
        child: BreadCrumb.builder(
          itemCount: 1 + pathList.length,
          overflow: const WrapOverflow(
            spacing: 5,
            runSpacing: 5,
          ),
          builder: (int index) {
            if (index == 0) {
              return getBreadCrumbItem(
                text: "All",
                isClickable: true,
                onTap: () {
                  for (int i = 0; i < pathList.length; i++) {
                    Navigator.pop(context);
                  }
                },
              );
            }

            index--;

            CatalogCategoriesForBrowseModel categoryModel = pathList[index];

            bool isClickable = pathList.last != categoryModel;

            return getBreadCrumbItem(
              text: categoryModel.categoryName,
              isClickable: isClickable,
              onTap: () {
                for (CatalogCategoriesForBrowseModel categoriesForBrowseModel in pathList.reversed) {
                  if (categoriesForBrowseModel == categoryModel) {
                    break;
                  }
                  Navigator.pop(context);
                }
              },
            );
          },
          divider: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  BreadCrumbItem getBreadCrumbItem({
    required String text,
    bool isClickable = false,
    void Function()? onTap,
  }) {
    return BreadCrumbItem(
      onTap: isClickable ? onTap : null,
      content: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          //fontWeight: FontWeight.w600,
          decoration: isClickable ? TextDecoration.underline : null,
          color: isClickable ? const Color(0xff4167BD) : const Color(0xff1D293F),
        ),
      ),
    );
  }

  //endregion

  //region searchTextFormField
  Widget getSearchTextFormField() {
    if (!widget.arguments.isShowSearchTextField) return const SizedBox();

    onSubmitted(String text) {
      bool isSearch = false;
      if (text.isEmpty) {
        if (catalogProvider.catalogContentSearchString.get().isNotEmpty) {
          isSearch = true;
        }
      } else {
        if (text != catalogProvider.catalogContentSearchString.get()) {
          isSearch = true;
        }
      }
      if (isSearch) {
        catalogProvider.catalogContentSearchString.set(value: text);
        getCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      }
    }

    Widget? filterSuffixIcon;

    if (catalogProvider.filterEnabled.get()) {
      int selectedFiltersCount = catalogProvider.filterProvider.selectedFiltersCount();

      filterSuffixIcon = Stack(
        children: [
          Container(
            margin: selectedFiltersCount > 0 ? const EdgeInsets.only(top: 5, right: 5) : null,
            child: InkWell(
              onTap: () async {
                navigateToFilterScreen();
              },
              child: const Icon(
                Icons.tune,
              ),
            ),
          ),
          if (selectedFiltersCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.primaryColor,
                ),
                child: Text(
                  selectedFiltersCount.toString(),
                  style: themeData.textTheme.labelSmall?.copyWith(
                    color: themeData.colorScheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    Widget? sortSuffixIcon;

    if (catalogProvider.sortEnabled.get()) {
      bool isSortingSelected = false;
      // MyPrint.printOnConsole("selected sort : ${catalogProvider.filterProvider.selectedSort.get()}");
      // if(catalogProvider.filterProvider.selectedSort.get().isNotEmpty){
      //   isSortingSelected = true;
      // }

      sortSuffixIcon = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () async {
                dynamic value = await NavigationController.navigateToSortingScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: SortingScreenNavigationArguments(
                    componentId: componentId,
                    filterProvider: catalogProvider.filterProvider,
                  ),
                );
                MyPrint.printOnConsole("Sort Value:$value");

                if (value == true) {
                  getCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                }
              },
              child: const Icon(Icons.sort),
            ),
            Positioned(
              right: 0,
              child: Visibility(
                visible: isSortingSelected,
                child: Container(
                  height: 7,
                  width: 7,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget? clearSearchSuffixIcon;
    if (textEditingController.text.isNotEmpty || (catalogProvider.catalogContentSearchString.get().isNotEmpty && catalogProvider.catalogContentSearchString.get() == textEditingController.text)) {
      clearSearchSuffixIcon = IconButton(
        onPressed: () async {
          textEditingController.clear();
          onSubmitted("");
        },
        icon: const Icon(
          Icons.close,
        ),
      );
    }

    Widget? cameraSuffixIcon;

    cameraSuffixIcon = InkWell(
      onTap: () {
        NavigationController.navigateToLensScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: LensScreenNavigationArguments(
            componentId: componentId,
            componentInsId: componentInstanceId,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Icon(Icons.camera_alt_outlined),
      ),
    );

    List<Widget> actions = <Widget>[];
    actions.add(cameraSuffixIcon);
    if (clearSearchSuffixIcon != null) actions.add(clearSearchSuffixIcon);
    if (filterSuffixIcon != null) actions.add(filterSuffixIcon);
    if (sortSuffixIcon != null) actions.add(sortSuffixIcon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: CommonTextFormField(
          onTap: () async {
            MyPrint.printOnConsole("Hello");
            FocusScope.of(context).requestFocus(FocusNode());
            NavigatingBackFromGlobalSearchModel? val = await NavigationController.navigateToGlobalSearchScreen(
              navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
              arguments: GlobalSearchScreenNavigationArguments(
                  componentName: "Catalog",
                  componentId: componentId,
                  componentInsId: componentInstanceId,
                  filterProvider: context.read<FilterProvider>(),
                  componentConfigurationsModel: ComponentConfigurationsModel(),
                  searchString: textEditingController.text.trim()),
            );
            if (val == null) return;

            if (val.isSuccess) {
              if (val.searchString.checkNotEmpty) {
                catalogProvider.catalogContentSearchString.set(value: val.searchString);
                textEditingController.text = val.searchString;
              }
              if (val.siteId != 0) {
                catalogProvider.filterProvider.selectedLearningProviders.setList(
                  list: [
                    LearningProviderModel(SiteID: val.siteId),
                  ],
                );
              }
              MyPrint.printOnConsole("val.siteId : ${val.siteId} , ${val.searchString}");
              mySetState();
              getCatalogContentsList(
                isRefresh: true,
                isGetFromCache: false,
                isNotify: true,
              );
            }
          },
          borderRadius: 50,
          boxConstraints: const BoxConstraints(minWidth: 55),
          prefixWidget: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: "Search",
          isOutlineInputBorder: true,
          controller: textEditingController,
          onSubmitted: onSubmitted,
          onChanged: (String text) {
            mySetState();
          },
          suffixWidget: actions.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                )
              : null,
        ),
      ),
    );
  }
//endregion
}

/*class _CoCreateKnowledgeScreenState extends State<CoCreateKnowledgeScreen> with MySafeState {
  @override
  void initState() {
    super.initState();
    ThemeHelper().changeTheme('primary');
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: getTabBarView(),
        );
      },
    );
  }

  Widget getTabBarView() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: themeData.tabBarTheme.indicatorColor ?? themeData.primaryColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
            tabs: const [
              Tab(
                // icon: Icon(Icons.library_books),
                text: 'My Knowledge',
              ),
              Tab(
                // icon: Icon(Icons.share),
                text: 'Share Knowledge',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MyKnowledgeTab(
              componentId: 0,
              componentInstanceId: 0,
            ),
            ShareKnowledgeTab(),
          ],
        ),
      ),
    );
  }
}*/

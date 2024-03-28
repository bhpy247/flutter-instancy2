import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/navigatingBackFromGlobalSearchModel.dart';
import 'package:flutter_instancy_2/models/dto/global_search_course_dto_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/all_filters_model.dart';
import 'package:flutter_instancy_2/models/global_search/response_model/global_search_component_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/filter/screens/sort_screen.dart';
import 'package:flutter_instancy_2/views/global_search/component/global_search_component.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/global_search/global_search_provider.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/global_search/global_search_ui_action_callback_model.dart';
import '../../../backend/ui_actions/global_search/global_search_ui_action_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class GlobalSearchScreen extends StatefulWidget {
  static const String routeName = "/GlobalSearchScreen";

  final GlobalSearchScreenNavigationArguments arguments;

  const GlobalSearchScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> with MySafeState {
  late ThemeData themeData;
  late Future future;
  late AppProvider appProvider;
  late int componentId;
  late FilterProvider filterProvider;
  late FilterController filterController;
  late GlobalSearchController globalSearchController;
  late GlobalSearchProvider globalSearchProvider;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  FocusNode focusNode = FocusNode();

  late ComponentConfigurationsModel componentConfigurationsModel;
  bool isShowSearchComponentSelector = true;

  TextEditingController searchTextController = TextEditingController();

  Future onViewProfileTap({int userid = 0}) async {
    await NavigationController.navigateToConnectionProfileScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: ConnectionProfileScreenNavigationArguments(
        profileProvider: null,
        userId: userid,
      ),
    );
  }

  Future<void> onDetailsTap({required CourseDTOModel model, required SearchComponents searchComponents, required int componentId, required int componentInsId}) async {
    MyPrint.printOnConsole("contentId ${model.ContentID}");
    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
          contentId: model.ContentID,
          componentId: searchComponents.componentID,
          componentInstanceId: searchComponents.componentInstanceID,
          userId: model.SiteUserID,
          siteId: searchComponents.siteID,
          courseDtoModel: model),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {
      // getContentData = getCatalogContentsList(
      //   isRefresh: true,
      //   isGetFromCache: false,
      //   isNotify: true,
      // );
    }
  }

  Future<void> showMoreActionsForGlobalSearch({
    required GlobalSearchCourseDTOModel globalSearchResultModel,
    required SearchComponents searchComponents,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) async {
    LocalStr localStr = appProvider.localStr;

    GlobalSearchUiActionController uiActionController = GlobalSearchUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = uiActionController
        .getSecondaryActions(
      globalSearchCourseDtoModel: globalSearchResultModel,
          localStr: localStr,
          uiActionCallbackModel: GlobalSearchUIActionCallbackModel(onShareWithConnectionTap: () {
            Navigator.pop(context);

            NavigationController.navigateToShareWithConnectionsScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              arguments: ShareWithConnectionsScreenNavigationArguments(
                shareContentType: ShareContentType.catalogCourse,
                contentId: globalSearchResultModel.ContentID,
                shareProvider: context.read<ShareProvider>(),
                contentName: globalSearchResultModel.Title,
              ),
            );
          }, onShareWithPeopleTap: () {
            Navigator.pop(context);

            NavigationController.navigateToShareWithPeopleScreen(
              navigationOperationParameters: NavigationOperationParameters(
                context: context,
                navigationType: NavigationType.pushNamed,
              ),
              arguments: ShareWithPeopleScreenNavigationArguments(
                shareContentType: ShareContentType.catalogCourse,
                contentId: globalSearchResultModel.ContentID,
                contentName: globalSearchResultModel.Title,
              ),
            );
          }, onDetailsTap: () {
            Navigator.pop(context);
            if (searchComponents.componentID == InstancyComponents.PeopleList) {
              String id = globalSearchResultModel.ViewProfileLink.split("profileuserid/").last.split("/").first;
              onViewProfileTap(userid: ParsingHelper.parseIntMethod(id));
              return;
            }
            onDetailsTap(
              model: globalSearchResultModel,
              searchComponents: searchComponents,
              componentId: searchComponents.componentID,
              componentInsId: searchComponents.componentInstanceID,
            );
          }, onShareTap: () {
            if (isSecondaryAction) Navigator.pop(context);

            MyUtils.shareContent(content: globalSearchResultModel.Sharelink, context: context);
          }, onViewProfileTap: () {
            Navigator.pop(context);
            String id = globalSearchResultModel.ViewProfileLink.split("profileuserid/").last.split("/").first;
            onViewProfileTap(userid: ParsingHelper.parseIntMethod(id));
          }
              // onAddToMyLearningTap: () {},
              ),
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

  void sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SortingScreen(
          arguments: SortingScreenNavigationArguments(
            componentId: componentId,
            filterProvider: filterProvider,
          ),
        );
      },
    );
  }

  void filterOnTap() {
    NavigationController.navigateToFiltersScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FiltersScreenNavigationArguments(
        componentId: componentId,
        filterProvider: filterProvider,
        componentConfigurationsModel: componentConfigurationsModel,
      ),
    );
  }

  Future<void> getData() async {
    if (globalSearchProvider.globalSearchComponent.getMap().checkEmpty) {
      await globalSearchController.getGlobalSearchComponent();
      changeTheValueOfAllCheckBox(true);
      globalSearchProvider.isAllChecked.set(value: true);
    }
  }

  // ApiController setNewInstanceOfApiController(SearchComponents components, int? userId) {
  //   ApiUrlConfigurationProvider existingProvider = ApiController().apiDataProvider;
  //
  //   ApiController apiController = ApiController.getNewInstance();
  //
  //   ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
  //
  //   apiUrlConfigurationProvider.setMainSiteUrl(existingProvider.getMainSiteUrl());
  //   apiUrlConfigurationProvider.setMainClientUrlType(existingProvider.getMainClientUrlType());
  //   apiUrlConfigurationProvider.setCurrentBaseApiUrl(existingProvider.getCurrentBaseApiUrl());
  //   apiUrlConfigurationProvider.setCurrentSiteUrl(components.learnerSiteURL);
  //   apiUrlConfigurationProvider.setCurrentAuthUrl(existingProvider.getCurrentAuthUrl());
  //   apiUrlConfigurationProvider.setCurrentSiteLearnerUrl(components.learnerSiteURL);
  //   apiUrlConfigurationProvider.setCurrentSiteLMSUrl(existingProvider.getCurrentSiteLMSUrl());
  //   apiUrlConfigurationProvider.setCurrentClientUrlType(existingProvider.getCurrentClientUrlType());
  //   apiUrlConfigurationProvider.setCurrentUserId(userId ?? existingProvider.getCurrentUserId());
  //   apiUrlConfigurationProvider.setCurrentSiteId(components.siteID);
  //   apiUrlConfigurationProvider.setLocale(existingProvider.getLocale());
  //   apiUrlConfigurationProvider.setAuthToken(existingProvider.getAuthToken());
  //   return apiController;
  // }

  void onSeeAllTap({required SearchComponents searchComponent, int? userId}) {
    MyPrint.printOnConsole("searchComponent: $searchComponent");
    switch (searchComponent.componentID) {
      case InstancyComponents.Catalog:
        NavigationController.navigateToCatalogContentsListScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: CatalogContentsListScreenNavigationArguments(
            componentInstanceId: InstancyComponents.CatalogComponentInsId,
            componentId: InstancyComponents.Catalog,
            searchString: searchTextController.text.trim(),
            isShowSearchTextField: false,
            catalogProvider: CatalogProvider(),
            subSiteId: searchComponent.siteID,
          ),
        );
        break;
      case InstancyComponents.PeopleList:
        NavigationController.navigateToMyConnectionMainScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: MyConnectionsMainScreenNavigationArguments(
            componentInsId: InstancyComponents.PeopleListComponentInsId,
            componentId: InstancyComponents.PeopleList,
            isShowSearchTextField: false,
            isShowAppbar: true,
            searchString: searchTextController.text.trim(),
            myConnectionsProvider: MyConnectionsProvider(),
            // apiController: setNewInstanceOfApiController(
            //   searchComponent,
            //   userId,
            // ),
          ),
        );
        break;
      case InstancyComponents.MyLearning:
        NavigationController.navigateToMyLearningScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: MyLearningScreenNavigationArguments(
            componentInsId: searchComponent.componentInstanceID,
            componentId: InstancyComponents.MyLearning,
            isShowSearchTextField: false,
            isShowAppbar: true,
            searchString: searchTextController.text.trim(),
            myLearningProvider: MyLearningProvider(),
            // apiController: setNewInstanceOfApiController(
            //   searchComponent,
            //   userId,
            // ),
          ),
        );
        break;
      case InstancyComponents.discussionForumComponent:
        NavigationController.navigateToDiscussionForumMainScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: DiscussionForumScreenNavigationArguments(
            componentInsId: searchComponent.componentInstanceID,
            componentId: InstancyComponents.discussionForumComponent,
            isShowSearchTextField: false,
            isShowAppbar: true,
            discussionProvider: DiscussionProvider(),
            searchString: searchTextController.text.trim(),
            // apiController: setNewInstanceOfApiController(
            //   searchComponent,
            //   userId,
            // ),
          ),
        );
        break;
      case InstancyComponents.AskTheExpert:
        NavigationController.navigateToAskTheExpertMainScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: AskTheExpertScreenNavigationArguments(
            componentInsId: InstancyComponents.CatalogComponentInsId,
            componentId: InstancyComponents.Catalog,
            isShowSearchTextField: false,
            isShowAppbar: true,
            askTheExpertProvider: AskTheExpertProvider(),
            searchString: searchTextController.text.trim(),
            // apiController: setNewInstanceOfApiController(
            //   searchComponent,
            //   userId,
            // ),
          ),
        );
        break;
      case InstancyComponents.CatalogEvents:
        NavigationController.navigateToEventCatalogMainScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: EventCatalogTabScreenNavigationArguments(
            componentInsId: searchComponent.componentInstanceID,
            componentId: searchComponent.componentID,
            isShowSearchTextField: false,
            isShowAppbar: true,
            siteId: searchComponent.siteID,
            eventProvider: EventProvider(),
            searchString: searchTextController.text.trim(),
            // apiController: setNewInstanceOfApiController(
            //   searchComponent,
            //   userId,
            // ),
          ),
        );

      // NavigationController.naTo(
      //   navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      //   arguments: CatalogContentsListScreenNavigationArguments(
      //     componentInstanceId: InstancyComponents.CatalogComponentInsId,
      //     componentId: InstancyComponents.Catalog,
      //   ),
      // );
      default:
        break;
    }
  }

  void changeTheValueOfAllCheckBox(bool changedValue) {
    Map<String, List<SearchComponents>> list = globalSearchProvider.globalSearchComponent.getMap();

    Map<String, List<SearchComponents>> tempList = {};
    list.forEach((key, value) {
      tempList[key] = _setValueCheckValueToTrue(value, changedValue);
    });
    list.addAll(tempList);
    globalSearchProvider.globalSearchComponent.setMap(map: list, isNotify: true);
  }

  List<SearchComponents> _setValueCheckValueToTrue(List<SearchComponents> list, bool value) {
    return list.map((e) {
      e.check = value;
      return SearchComponents.fromJson(e.toJson());
    }).toList();
  }

  Future<void> onSubmitCall({String value = ""}) async {
    isLoading = true;
    mySetState();
    List<SearchComponents> searchComponent = [], addCheckComponent = [];

    globalSearchProvider.globalSearchComponent.getMap().values.forEach((element) {
      searchComponent.addAll(element);
    });
    for (var element in searchComponent) {
      if (element.check) {
        MyPrint.printOnConsole("Is Check ${element.componentID} : ${element.check}");
        addCheckComponent.add(element);
      }
    }
    if (addCheckComponent.length == 1) {
      if (addCheckComponent.first.componentID == widget.arguments.componentId) {
        Navigator.pop(
          context,
          NavigatingBackFromGlobalSearchModel(
            searchString: searchTextController.text.trim(),
            isSuccess: true,
            siteId: addCheckComponent.first.siteID,
          ),
        );
        return;
      }
    }
    globalSearchProvider.globalSearchListSearchString.set(value: value);

    globalSearchProvider.courseListBasedOnIdMap.setMap(map: {}, isClear: true);
    // globalSearchProvider.globalSearchListSearchString.set(value: value);
    isShowSearchComponentSelector = false;
    await globalSearchController.getIdBasedSearchedCourseList(componentId: 225, componentInsId: 4021);
    isLoading = false;
    mySetState();

    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    globalSearchProvider = widget.arguments.globalSearchProvider ?? context.read<GlobalSearchProvider>();
    globalSearchController = GlobalSearchController(globalSearchProvider: globalSearchProvider);
    componentId = widget.arguments.componentId;
    filterProvider = widget.arguments.filterProvider;
    componentConfigurationsModel = widget.arguments.componentConfigurationsModel;
    filterController = FilterController(filterProvider: filterProvider);
    filterController.initializeMainFiltersList(
      componentConfigurationsModel: componentConfigurationsModel,
    );
    future = getData();
    if (widget.arguments.searchString.checkNotEmpty) {
      searchTextController.text = widget.arguments.searchString;
    }
  }
  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);

    return ChangeNotifierProvider<FilterProvider>.value(
      value: filterProvider,
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: getAppBarWithTextFormField(),
            body: getMainWidget(),
          );
        },
      ),
    );
  }

  //region Main Widget
  Widget getMainWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        future = getData();
      },
      child: FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) return const Center(child: CommonLoader());
          if (globalSearchProvider.isLoading.get()) {
            return const Center(child: CommonLoader());
          }
          if (isShowSearchComponentSelector) {
            return getGlobalSearchComponentWidget();
          }
          Map<SearchComponents, List<GlobalSearchCourseDTOModel>> map = globalSearchProvider.courseListBasedOnIdMap.getMap();

          if (map.checkEmpty) {
            return Center(child: AppConfigurations.commonNoDataView());
          }
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: const CommonLoader(),
            child: SingleChildScrollView(
              child: Column(
                children: map.entries.map((e) => getWidgetBasedOnTheId(objectType: e.key, list: e.value)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getWidgetBasedOnTheId({required SearchComponents objectType, required List<GlobalSearchCourseDTOModel> list}) {
    return getResultComponentWidget(searchComponents: objectType, list: list);
  }

  //endregion

  //region getSearchAbleTextAppBar
  AppBar getAppBarWithTextFormField() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1.5,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 20),
        child: Form(
          key: formKey,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  size: 22,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: CommonTextFormField(
                  controller: searchTextController,
                  borderColor: Colors.transparent,
                  hintText: "Search",
                  node: focusNode,
                  onSubmitted: (String value) async {
                    // if(formKey.currentState?.validate() ?? false){
                    if (searchTextController.text.trim().checkEmpty) {
                      MyToast.showError(context: context, msg: "Please enter the text");
                      return;
                    }
                    await onSubmitCall(value: value);
                    mySetState();
                    // },
                  },
                  focusedBorderColor: Colors.transparent,
                  validator: (String? val) {
                    if (val == null || val.checkEmpty) {
                      return "Please enter the value";
                    }
                    return null;
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close),
              ),
              InkWell(
                onTap: () {
                  // sortBottomSheet();
                  if (isShowSearchComponentSelector) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    FocusScope.of(context).requestFocus(focusNode);
                  }
                  isShowSearchComponentSelector = !isShowSearchComponentSelector;
                  mySetState();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: AppConfigurations().getImageView(url: "assets/orderList.png", width: 18, height: 18),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     filterOnTap();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 9.0).copyWith(right: 12),
              //     child: AppConfigurations().getImageView(url: "assets/filters.png", width: 18, height: 18),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //endregion

  //region getRecentViews
  Widget getRecentsViews() {
    return Column(
      children: [
        getBackgroundGreyText("Recents"),
        getRecentList(),
      ],
    );
  }

  Widget getRecentList() {
    return ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return recentListComponent();
        });
  }

  Widget recentListComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ).copyWith(top: 10),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Text(
            "Web Development",
            style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
          )),
          AppConfigurations().getImageView(url: "assets/arrowUpLeft.png", height: 13, width: 13),
        ],
      ),
    );
  }

  //endregion

  //region getSuggestionView
  Widget getSuggestionView() {
    return Column(
      children: [getBackgroundGreyText("Suggestions"), getSuggestionList()],
    );
  }

  Widget getSuggestionList() {
    return ListView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return suggestionListComponent();
        });
  }

  Widget suggestionListComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ).copyWith(top: 10),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right_alt,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Text(
            "Design",
            style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
          )),
          // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
        ],
      ),
    );
  }

  //endregion

  //region getBackgroundGreyText
  Widget getBackgroundGreyText(String text, {bool isIconVisible = false, String iconAsset = "assets/catalog.png"}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Visibility(
            visible: isIconVisible,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: coursesIcon(
                assetName: iconAsset,
              ),

              // child: AppConfigurations().getImageView(url: iconAsset, width: 18, height: 18),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.25),
            ),
          ),
        ],
      ),
    );
  }

  //endregion

  //region getCatalogContentView
  Widget getCatalogView({required List<GlobalSearchCourseDTOModel> list}) {
    if (list.checkEmpty) return const SizedBox();
    return Column(
      children: [getBackgroundGreyText("Catalog", isIconVisible: true), getCatalogList()],
    );
  }

  Widget getCatalogList() {
    return ListView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return catalogListComponent();
        });
  }

  Widget catalogListComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
        ).copyWith(top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(5), child: CachedNetworkImage(imageUrl: "https://picsum.photos/200/300", height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              "Design",
              style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
            )),
            const Icon(
              Icons.more_vert,
              size: 20,
            )
            // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
          ],
        ),
      ),
    );
  }

  //endregion

  Widget myLearningListComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
        ).copyWith(top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(5), child: CachedNetworkImage(imageUrl: "https://picsum.photos/300", height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Design Classroom",
                  style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Manoj Kumar",
                  style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 11),
                ),
              ],
            )),
            const Icon(
              Icons.more_vert,
              size: 20,
            )
            // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
          ],
        ),
      ),
    );
  }

  //endregion  // region getMyLearningView

  //region Result View
  Widget getResultComponentWidget({required SearchComponents searchComponents, required List<GlobalSearchCourseDTOModel> list}) {
    if (list.checkEmpty) return const SizedBox();
    return Column(
      children: [
        getBackgroundGreyText(
          "${searchComponents.name} - ${searchComponents.siteName}",
          isIconVisible: true,
          iconAsset: AppConfigurations.getContentIconFromObjectAndMediaType(objectTypeId: 8, mediaTypeId: 61),
        ),
        getComponentItemList(list: list, searchComponents: searchComponents),
        CommonButton(
          text: "See All",
          fontColor: Colors.white,
          onPressed: () {
            int userId = list.where((element) => element.SiteUserID != 0).toList().first.SiteUserID;
            onSeeAllTap(searchComponent: searchComponents, userId: userId);
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      "assets/catalog_gs.png",
      height: 15,
      width: 15,
      fit: BoxFit.cover,
      color: Colors.black,
    );
  }

  Widget getComponentItemList({required List<GlobalSearchCourseDTOModel> list, required SearchComponents searchComponents}) {
    return ListView.builder(
      itemCount: list.length > 3 ? 3 : list.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return myConnectionListComponent(list[index], searchComponents);
      },
    );
  }

  Widget myConnectionListComponent(GlobalSearchCourseDTOModel model, SearchComponents searchComponents) {
    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: model.ThumbnailImagePath,
      ),
    );
    Widget? getThumbNailWidget;
    if (searchComponents.componentID == InstancyComponents.PeopleList) {
      if (profileImageUrl.checkEmpty) {
        String nameInitials = "${model.Title.split(" ").first.substring(0, 1)}${model.Title.split(" ").last.substring(0, 1)}";
        getThumbNailWidget = Container(
          height: 50,
          color: themeData.primaryColor,
          width: 50,
          child: Center(
            child: Text(
              nameInitials,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      } else {
        getThumbNailWidget = CommonCachedNetworkImage(
          imageUrl: profileImageUrl,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      }
    } else {
      getThumbNailWidget = CommonCachedNetworkImage(
        imageUrl: profileImageUrl,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
        ).copyWith(top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: getThumbNailWidget,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.Title,
                    style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    model.AuthorName,
                    style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 11),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                showMoreActionsForGlobalSearch(globalSearchResultModel: model, searchComponents: searchComponents);
              },
              child: const Icon(
                Icons.more_vert,
                size: 20,
              ),
            )
            // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
          ],
        ),
      ),
    );
  }

  //endregion

  Widget getGlobalSearchComponentWidget() {
    return GlobalSearchComponent(
      componentName: widget.arguments.componentName,
      componentId: widget.arguments.componentId,
      globalSearchProvider: globalSearchProvider,
    );
  }

  Widget getFilterItemsListView({required List<AllFilterModel> list}) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);

        AllFilterModel allFilterModel = list[index];

        return Theme(
          data: theme,
          child: InkWell(
            onTap: () {
              MyPrint.printOnConsole("Click menu ${allFilterModel.categoryName}");
              /*if (myLearningBloc.allFilterModelList[i].categoryName == "Group By") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SortScreen(
                        isGroupby: true, refresh: refresh)));
              }
              else if (myLearningBloc.allFilterModelList[i].categoryName == "Sort By") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SortScreen(
                        isGroupby: false, refresh: refresh)));
              }
              else if (myLearningBloc.allFilterModelList[i].categoryName == "Filter By") {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContentFilterByScreen(refresh: refresh, componentId: widget.componentId,)));
              }*/
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    decoration: BoxDecoration(
                      // color: Color(int.parse("0xFF${appProvider.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      // border: Border.all(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")).withOpacity(0.15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          allFilterModel.categoryName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          // color: InsColor(appBloc).appIconColor,
                        ),
                      ],
                    ),
                  ),
                  // selectedWigets(myLearningBloc.allFilterModelList[i].categoryName)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

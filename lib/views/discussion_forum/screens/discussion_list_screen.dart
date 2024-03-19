import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/profile/profile_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_controller.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../api/api_controller.dart';
import '../../../backend/discussion/discussion_controller.dart';
import '../../../backend/discussion/discussion_provider.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/common/navigatingBackFromGlobalSearchModel.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../models/discussion/data_model/forum_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/dicussionCard.dart';

class DiscussionListScreen extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;
  final bool isShowSearchString;
  final int? userId;
  final int? siteId;
  final String? clientUrl;
  final ApiController? apiController;

  const DiscussionListScreen({
    super.key,
    required this.componentId,
    required this.componentInstanceId,
    this.isShowSearchString = true,
    this.userId,
    this.siteId,
    this.clientUrl,
    this.apiController,
  });

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();
}

class _DiscussionListScreenState extends State<DiscussionListScreen> with MySafeState {
  late ThemeData themeData;
  late AppProvider appProvider;
  int componentId = 0, componentInstanceId = 0;
  bool isLoading = false;
  bool isShowAddForumFloatingButton = false;
  TextEditingController textEditingController = TextEditingController();

  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;
  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> getDiscussionForumList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      discussionController.getForumsList(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
    ]);
  }

  DiscussionForumUIActionCallbackModel getDiscussionForumUIActionCallbackModel({
    required ForumModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
    required int index,
  }) {
    return DiscussionForumUIActionCallbackModel(
      onAddToTopic: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addTopic(model: model);
      },
      onEdit: () async {
        if (isSecondaryAction) Navigator.pop(context);

        dynamic value = await NavigationController.navigateToCreateEditDiscussionForumScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: CreateEditDiscussionForumScreenNavigationArguments(forumModel: model, isEdit: true, componentId: componentId, componentInsId: componentInstanceId),
        );
        if (value != true) return;

        getDiscussionForumList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: false,
        );
        discussionController.getMyDiscussionForumsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onDelete: () async {
        if (isSecondaryAction) Navigator.pop(context);

        discussionProvider.isLoading.set(value: true);

        bool isSuccess = await discussionController.deleteForum(
          context: context,
          forumModel: model,
        );

        discussionProvider.isLoading.set(value: false, isNotify: !isSuccess);

        if (isSuccess) {
          if (model.CreatedUserID == discussionController.discussionRepository.apiController.apiDataProvider.getCurrentUserId()) {
            discussionController.getMyDiscussionForumsList(
              isRefresh: true,
              isGetFromCache: false,
              isNotify: false,
              componentId: componentId,
              componentInstanceId: componentInstanceId,
            );
          }
          getDiscussionForumList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onViewLikes: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        await discussionController.showForumLikedUserList(
          context: context,
          forumModel: model,
        );

        isLoading = false;
        mySetState();
      },
      onShareWithConnectionTap: () {
        MyPrint.printOnConsole("Forum Id: ${model.ForumID}");
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.discussionForum,
            contentName: model.Name,
            forumId: model.ForumID,
            shareProvider: context.read<ShareProvider>(),
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
            shareContentType: ShareContentType.discussionForum,
            // contentName: model.Name,
            forumId: model.ForumID,
          ),
        );
      },
    );
  }

  Future<void> showMoreAction({
    required ForumModel model,
    InstancyContentActionsEnum? primaryAction,
    required int index,
  }) async {
    LocalStr localStr = appProvider.localStr;

    DiscussionForumUiActionController discussionForumUiActionController = DiscussionForumUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = discussionForumUiActionController
        .getDiscussionForumScreenSecondaryActions(
          forumModel: model,
          localStr: localStr,
          discussionForumUIActionCallbackModel: getDiscussionForumUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            index: index,
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

  Future<void> addTopic({required ForumModel model}) async {
    dynamic value = await NavigationController.navigateToCreateEditTopicScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      arguments: CreateEditTopicScreenNavigationArguments(
        componentId: widget.componentId,
        componentInsId: widget.componentInstanceId,
        forumModel: model,
      ),
    );

    if (value != true) return;

    getDiscussionForumList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: false,
    );
    discussionController.getMyDiscussionForumsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  void initializations({
    bool isNotify = false,
  }) {
    ProfileController profileController = ProfileController(profileProvider: context.read<ProfileProvider>());
    isShowAddForumFloatingButton = profileController.isShowAddForumButton();

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      discussionController.initializeConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }

    PaginationModel paginationModel = discussionProvider.forumListPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && discussionProvider.forumsList.length == 0) {
      discussionProvider.forumContentId.set(value: "", isNotify: false);
      getDiscussionForumList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: isNotify,
      );
    }
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    discussionProvider = context.read<DiscussionProvider>();
    discussionController = DiscussionController(discussionProvider: discussionProvider, apiController: widget.apiController);
    initializations();
    textEditingController.text = discussionProvider.forumListSearchString.get();
    // if (discussionProvider.forumsListLength == 0) {
    //   getDiscussionForumList(
    //     isRefresh: true,
    //     isGetFromCache: false,
    //     isNotify: false,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DiscussionProvider>.value(value: discussionProvider),
      ],
      child: Consumer2<DiscussionProvider, MainScreenProvider>(
        builder: (context, DiscussionProvider discussionProvider, MainScreenProvider mainScreenProvider, _) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: mainScreenProvider.isChatBotButtonEnabled.get() && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0,
                ),
                child: Visibility(
                  visible: isShowAddForumFloatingButton,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      dynamic value = await NavigationController.navigateToCreateEditDiscussionForumScreen(
                        navigationOperationParameters: NavigationOperationParameters(
                          context: context,
                          navigationType: NavigationType.pushNamed,
                        ),
                        arguments: CreateEditDiscussionForumScreenNavigationArguments(
                          forumModel: null,
                          componentId: componentId,
                          componentInsId: componentInstanceId,
                        ),
                      );
                      if (value != true) return;

                      getDiscussionForumList(
                        isRefresh: true,
                        isGetFromCache: false,
                        isNotify: false,
                      );
                      discussionController.getMyDiscussionForumsList(
                        isRefresh: true,
                        isGetFromCache: false,
                        isNotify: true,
                      );
                    },
                  ),
                ),
              ),
              body: getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        getSearchTextFromField(),
        Expanded(
          child: getDiscussionForumListView(),
        )
      ],
    );
  }

  Widget getSearchTextFromField() {
    if (!widget.isShowSearchString) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CommonTextFormField(
        isOutlineInputBorder: true,
        borderRadius: 30,
        onTap: () async {
          NavigatingBackFromGlobalSearchModel? val = await NavigationController.navigateToGlobalSearchScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            arguments: GlobalSearchScreenNavigationArguments(
                componentId: componentId,
                componentInsId: componentInstanceId,
                filterProvider: context.read<FilterProvider>(),
                componentConfigurationsModel: ComponentConfigurationsModel(),
                componentName: "Discussion"),
          );
          if (val == null || val.isSuccess == false) return;
          discussionProvider.forumListSearchString.set(value: val.searchString);
          textEditingController.text = val.searchString;
          getDiscussionForumList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
          mySetState();
        },
        onChanged: (val) {
          mySetState();
        },
        controller: textEditingController,
        contentPadding: EdgeInsets.zero,
        hintText: "Search",
        suffixWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (textEditingController.text.checkNotEmpty)
              InkWell(
                onTap: () {
                  textEditingController.clear();
                  discussionProvider.forumListSearchString.set(value: "");
                  getDiscussionForumList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.clear,
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            getCategoriesFilterIcon(provider: discussionProvider),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        prefixWidget: const Icon(Icons.search),
        onSubmitted: (String? val) {
          discussionProvider.forumListSearchString.set(value: val ?? "");
          getDiscussionForumList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
          mySetState();
        },
      ),
    );
  }

  Widget getCategoriesFilterIcon({required DiscussionProvider provider}) {
    return InkWell(
      onTap: () async {
        bool? isTrue = await NavigationController.navigateToCategoriesSearchScreen(
          navigationOperationParameters: NavigationOperationParameters(
              context: context, navigationType: NavigationType.pushNamed, arguments: const DiscussionForumCategoriesSearchScreenNavigationArguments(isFromMyDiscussion: false)),
        );
        if (isTrue == null) return;
        if (isTrue) {
          getDiscussionForumList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Column(
                children: [
                  Icon(Icons.category),
                ],
              ),
              if (provider.filterCategoriesIds.get().checkNotEmpty)
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget getDiscussionForumListView() {
    return getDiscussionForumListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: discussionProvider.forumsList.length,
      paginationModel: discussionProvider.forumListPaginationModel.get(),
      onRefresh: () async {
        getDiscussionForumList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getDiscussionForumList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getDiscussionForumListViewWidget({
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

    List<ForumModel> forumsList = discussionProvider.forumsList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: forumsList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && forumsList.isEmpty) || index == forumsList.length) {
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

          ForumModel model = forumsList[index];

          return getDiscussionForumContentWidget(model: model, index: index);
        },
      ),
    );
  }

  Widget getDiscussionForumContentWidget({required ForumModel model, required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: DiscussionCard(
        onLikeTap: () async {
          isLoading = true;
          mySetState();
          await discussionController.showForumLikedUserList(context: context, forumModel: model);
          isLoading = false;
          mySetState();
        },
        forumModel: model,
        onCardTap: () async {
          await NavigationController.navigateToDiscussionDetailScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: DiscussionDetailScreenNavigationArguments(
              componentId: widget.componentId,
              componentInsId: widget.componentInstanceId,
              forumModel: model,
              ForumId: model.ForumID,
            ),
          );
          mySetState();
        },
        onAddTopicTap: () {
          addTopic(model: model);
        },
        onMoreTap: () {
          showMoreAction(model: model, index: index);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_controller.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/discussion/discussion_controller.dart';
import '../../../backend/discussion/discussion_provider.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../component/dicussionCard.dart';

class MyDiscussionListScreen extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const MyDiscussionListScreen({super.key, required this.componentId, required this.componentInstanceId});

  @override
  State<MyDiscussionListScreen> createState() => _MyDiscussionListScreenState();
}

class _MyDiscussionListScreenState extends State<MyDiscussionListScreen> with MySafeState {
  late ThemeData themeData;
  late AppProvider appProvider;
  int componentId = 0, componentInstanceId = 0;
  bool isLoading = false;

  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;
  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> getDiscussionForumList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      discussionController.getMyDiscussionForumsList(
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
          arguments: CreateEditDiscussionForumScreenNavigationArguments(
            forumModel: model,
            isEdit: true,
          ),
        );
        if (value != true) return;

        discussionController.getForumsList(
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
          discussionController.getForumsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
            componentId: componentId,
            componentInstanceId: componentInstanceId,
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
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.discussionForum,
            contentId: model.ForumID.toString(),
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
            contentId: model.ForumID.toString(),
            contentName: model.Name,
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

    DiscussionForumUiActionController catalogUIActionsController = DiscussionForumUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = catalogUIActionsController
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

    discussionController.getForumsList(
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
    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      discussionController.initializeConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }

    PaginationModel paginationModel = discussionProvider.myDiscussionForumListPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && discussionProvider.myDiscussionForumsList.length == 0) {
      discussionProvider.myDiscussionForumContentId.set(value: "", isNotify: false);
      discussionController.getMyDiscussionForumsList(
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
    discussionController = DiscussionController(discussionProvider: discussionProvider);

    initializations();
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
                child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    dynamic value = await NavigationController.navigateToCreateEditDiscussionForumScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      arguments: const CreateEditDiscussionForumScreenNavigationArguments(forumModel: null),
                    );
                    if (value != true) return;

                    discussionController.getForumsList(
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
        Expanded(child: getDiscussionForumListView()),
      ],
    );
  }

  Widget getSearchTextFromField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const CommonTextFormField(
        isOutlineInputBorder: true,
        borderRadius: 30,
        contentPadding: EdgeInsets.zero,
        hintText: "Search",
        prefixWidget: Icon(Icons.search),
      ),
    );
  }

  Widget getDiscussionForumListView() {
    return getDiscussionForumListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: discussionProvider.myDiscussionForumsList.length,
      paginationModel: discussionProvider.myDiscussionForumListPaginationModel.get(),
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

    List<ForumModel> forumsList = discussionProvider.myDiscussionForumsList.getList(isNewInstance: false);

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

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_controller.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/models/learning_communities/data_model/learning_communities_dto_model.dart';
import 'package:flutter_instancy_2/views/learning_communities/components/learning_communities_card.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/main_screen/main_screen_provider.dart';
import '../../../backend/profile/profile_controller.dart';
import '../../../backend/profile/profile_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/modal_progress_hud.dart';

class AllLearningCommunitesScreen extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const AllLearningCommunitesScreen({super.key, required this.componentId, required this.componentInstanceId});

  @override
  State<AllLearningCommunitesScreen> createState() => _AllLearningCommunitesScreenState();
}

class _AllLearningCommunitesScreenState extends State<AllLearningCommunitesScreen> with MySafeState {
  late AppProvider appProvider;
  int componentId = 0, componentInstanceId = 0;
  bool isLoading = false;
  bool isShowAddForumFloatingButton = false;
  TextEditingController textEditingController = TextEditingController();

  late LearningCommunitiesProvider learningCommunitiesProvider;
  late LearningCommunitiesController learningCommunitiesController;
  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> getQuestionList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      learningCommunitiesController.getAllLearningCommunities(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
    ]);
  }

  void initializations({
    bool isNotify = false,
  }) {
    learningCommunitiesProvider = context.read<LearningCommunitiesProvider>();
    learningCommunitiesController = LearningCommunitiesController(learningCommunitiesProvider: learningCommunitiesProvider);
    ProfileController profileController = ProfileController(profileProvider: context.read<ProfileProvider>());
    isShowAddForumFloatingButton = profileController.isShowAddForumButton();

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    // NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    // if (componentModel != null) {
    //   // learningCommunitiesController.initializeConfigurationsFromComponentConfigurationsModel(
    //   //   componentConfigurationsModel: componentModel.componentConfigurationsModel,
    //   // );
    // }

    PaginationModel paginationModel = learningCommunitiesProvider.allLearningCommunitiesPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && learningCommunitiesProvider.allLearningCommunitiesList.length == 0) {
      // learningCommunitiesProvider.filterCategoriesIds.set(value: "-1", isNotify: false);
      learningCommunitiesController.getAllLearningCommunities(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      );
    }
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    learningCommunitiesProvider = context.read<LearningCommunitiesProvider>();

    initializations();
    // textEditingController.text = learningCommunitiesProvider.questionListSearchString.get();
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
        ChangeNotifierProvider<LearningCommunitiesProvider>.value(value: learningCommunitiesProvider),
      ],
      child: Consumer2<LearningCommunitiesProvider, MainScreenProvider>(
        builder: (context, LearningCommunitiesProvider learningCommunitiesProvider, MainScreenProvider mainScreenProvider, _) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
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
        // getSearchTextFromField(),
        Expanded(
          child: getQuestionListView(),
        )
      ],
    );
  }

  Widget getQuestionListView() {
    return getQuestionListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: learningCommunitiesProvider.allLearningCommunitiesList.length,
      paginationModel: learningCommunitiesProvider.allLearningCommunitiesPaginationModel.get(),
      onRefresh: () async {
        getQuestionList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getQuestionList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getQuestionListViewWidget({
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

    List<PortalListing> questionList = learningCommunitiesProvider.allLearningCommunitiesList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: questionList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && questionList.isEmpty) || index == questionList.length) {
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

          PortalListing model = questionList[index];

          return getQuestionsContentWidget(model: model);
        },
      ),
    );
  }

  Widget getQuestionsContentWidget({required PortalListing model}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: LearningCommunitiesCard(
        model: model,
        onGoToCommunityTap: () {
          learningCommunitiesController.goToCommunityOrJoinCommunity(context: context, mobileSiteUrl: model.learnerSiteURL, SiteId: model.learningPortalID, portalListing: model);
        },
        onJoinCommunityTap: () {
          learningCommunitiesController.goToCommunityOrJoinCommunity(context: context, mobileSiteUrl: model.learnerSiteURL, SiteId: model.learningPortalID, isJoin: true, portalListing: model);
        },
      ),
    );
  }
}

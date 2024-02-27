import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../backend/learning_communities/learning_communities_controller.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/learning_communities/data_model/learning_communities_dto_model.dart';
import '../../common/components/common_loader.dart';
import '../components/learning_communities_card.dart';

class MyLearningCommunitiesScreen extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const MyLearningCommunitiesScreen({super.key, required this.componentId, required this.componentInstanceId});

  @override
  State<MyLearningCommunitiesScreen> createState() => _MyLearningCommunitiesScreenState();
}

class _MyLearningCommunitiesScreenState extends State<MyLearningCommunitiesScreen> {
  late LearningCommunitiesProvider learningCommunitiesProvider;
  late LearningCommunitiesController learningCommunitiesController;
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
  final ItemScrollController catalogContentScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    learningCommunitiesProvider = context.read<LearningCommunitiesProvider>();
    learningCommunitiesController = LearningCommunitiesController(learningCommunitiesProvider: learningCommunitiesProvider);
  }

  Future<void> getQuestionList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      learningCommunitiesController.getAllLearningCommunities(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: widget.componentId,
        componentInstanceId: widget.componentInstanceId,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningCommunitiesProvider>(
      builder: (context, LearningCommunitiesProvider provider, _) {
        return getMainWidget();
      },
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        Expanded(
          child: getQuestionListViewWidget(
            scrollController: catalogContentScrollController,
            contentsLength: learningCommunitiesProvider.myLearningCommunitiesList.length,
            paginationModel: learningCommunitiesProvider.allLearningCommunitiesPaginationModel.get(),
            // contentsLength: 10,
            // paginationModel: PaginationModel(pageSize: 1,hasMore: false,isFirstTimeLoading: false,isLoading: false,pageIndex: 10,refreshLimit: 2),
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
          ),
        )
      ],
    );
  }

  Widget getQuestionListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ItemScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    MyPrint.printOnConsole("questionList :${contentsLength}");

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

    List<PortalListing> questionList = learningCommunitiesProvider.myLearningCommunitiesList.getList(isNewInstance: false);

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
          learningCommunitiesController.goToCommunityOrJoinCommunity(context: context, mobileSiteUrl: model.learnerSiteURL, SiteId: model.learningPortalID, portalListing: model);
        },
      ),
    );
  }
}

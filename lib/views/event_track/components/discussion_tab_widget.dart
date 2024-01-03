import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_controller.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../discussion_forum/component/dicussionCard.dart';

class DiscussionTabWidget extends StatefulWidget {
  final String contentId;
  final DiscussionProvider discussionProvider;
  final int componentId, componentInsId;

  const DiscussionTabWidget({Key? key, required this.contentId, required this.discussionProvider, required this.componentId, required this.componentInsId}) : super(key: key);

  @override
  State<DiscussionTabWidget> createState() => _DiscussionTabWidgetState();
}

class _DiscussionTabWidgetState extends State<DiscussionTabWidget> with MySafeState {
  late ThemeData themeData;
  bool isLoading = false;

  late AppProvider appProvider;

  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;

  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  void initializations({
    bool isNotify = false,
  }) {
    discussionProvider = widget.discussionProvider;
    discussionController = DiscussionController(discussionProvider: discussionProvider);

    PaginationModel paginationModel = discussionProvider.forumListPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && discussionProvider.forumsList.length == 0) {
      discussionProvider.forumContentId.set(value: widget.contentId, isNotify: false);
      discussionController.getForumsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: isNotify,
      );
    }
  }

  Future<void> getDiscussionForumList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      discussionController.getForumsList(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: widget.componentId,
        componentInstanceId: widget.componentInsId,
      ),
    ]);
  }

  Future<void> addTopic({required ForumModel model}) async {
    dynamic value = await NavigationController.navigateToCreateEditTopicScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      arguments: CreateEditTopicScreenNavigationArguments(
        componentId: widget.componentId,
        componentInsId: widget.componentInsId,
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

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    initializations();
  }

  @override
  void didUpdateWidget(covariant DiscussionTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (discussionProvider != widget.discussionProvider) {
      initializations(isNotify: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return getDiscussionForumListView();

    // PaginationModel paginationModel = discussionProvider.forumListPaginationModel.get();
    // if (paginationModel.isFirstTimeLoading) {
    //   return const CommonLoader(
    //     isCenter: true,
    //   );
    // }
    //
    // if (!paginationModel.isLoading && discussionProvider.forumsList.length == 0) {
    //   return RefreshIndicator(
    //     onRefresh: () async {
    //       discussionController.getForumsList(
    //         isRefresh: true,
    //         isGetFromCache: false,
    //         isNotify: true,
    //       );
    //     },
    //     child: ListView(
    //       physics: const AlwaysScrollableScrollPhysics(),
    //       children: [
    //         const SizedBox(height: 200),
    //         Center(
    //           child: Text(
    //             appProvider.localStr.commoncomponentLabelNodatalabel,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    //
    // List<ForumModel> forumsList = discussionProvider.forumsList.getList(isNewInstance: false);
    //
    // return RefreshIndicator(
    //   onRefresh: () async {
    //     discussionController.getForumsList(
    //       isRefresh: true,
    //       isGetFromCache: false,
    //       isNotify: true,
    //     );
    //   },
    //   child: ListView.builder(
    //     padding: const EdgeInsets.all(13),
    //     physics: const AlwaysScrollableScrollPhysics(),
    //     itemCount: forumsList.length + 1,
    //     itemBuilder: (BuildContext context, int index) {
    //       if ((index == 0 && paginationModel.isLoading) || (index == forumsList.length)) {
    //         if (paginationModel.isLoading) {
    //           return const CommonLoader(
    //             isCenter: true,
    //           );
    //         } else {
    //           return const SizedBox();
    //         }
    //       }
    //
    //       if (index > (forumsList.length - paginationModel.refreshLimit)) {
    //         if (paginationModel.hasMore && !paginationModel.isLoading) {
    //           discussionController.getForumsList(
    //             isRefresh: false,
    //             isGetFromCache: false,
    //             isNotify: false,
    //           );
    //         }
    //       }
    //
    //       return getDiscussionCardItemWidget(forumModel: forumsList[index]);
    //     },
    //   ),
    // );
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
          MyPrint.printOnConsole("like called");
          await discussionController.showForumLikedUserList(context: context, forumModel: model);
          isLoading = false;
          mySetState();
        },
        forumModel: model,
        onAddTopicTap: () {
          addTopic(model: model);
        },
      ),
    );
  }

  //region DiscussionCard
  Widget getDiscussionCardItemWidget({required ForumModel forumModel}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getProfileView(
                profileImageUrl: forumModel.DFProfileImage,
                author: forumModel.UpdatedAuthor,
                createdDate: forumModel.CreatedDate,
              ),
              getTitleText(title: forumModel.Name),
              getDescriptionText(description: forumModel.Description),
              getBottomButtonView(
                likeCount: forumModel.TotalLikes.map((e) => e.UserID).toSet().length,
                topicsCount: forumModel.NoOfTopics,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileView({
    required String profileImageUrl,
    required String author,
    required String createdDate,
  }) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: profileImageUrl));
    // MyPrint.printOnConsole("Track Discussion Thumbnail Image Url:$imageUrl");

    String createdTimeString = "";
    // MyPrint.printOnConsole("createdDate:$createdDate");
    DateTime? createdDateTime = ParsingHelper.parseDateTimeMethod(createdDate, dateFormat: "MM/dd/yyyy hh:mm:ss aa");
    // MyPrint.printOnConsole("createdDateTime:$createdDateTime");
    if (createdDateTime != null) {
      createdTimeString = "${DateTime.now().difference(createdDateTime).inDays} Days ago";
    }

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.transparent),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: imageUrl,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author,
                style: themeData.textTheme.titleSmall,
              ),
              if (createdTimeString.isNotEmpty)
                Text(
                  createdTimeString,
                  style: themeData.textTheme.titleSmall,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getTitleText({required String title}) {
    if (title.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget getDescriptionText({required String description}) {
    if (description.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Html(
        data: description,
        style: {
          "body": Style(fontSize: FontSize.small),
        },
        // style: themeData.textTheme.bodySmall,
      ),
    );
  }

  Widget getBottomButtonView({
    required int likeCount,
    required int topicsCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          getIconWithValue(icon: FontAwesomeIcons.thumbsUp, onTap: () {}, iconValue: likeCount),
          const SizedBox(width: 15),
          getIconWithValue(icon: FontAwesomeIcons.message, onTap: () {}, iconValue: topicsCount),
          const Spacer(),
          addTopicButton(onTap: () {}),
        ],
      ),
    );
  }

  Widget getIconWithValue({IconData? icon, int? iconValue, Function()? onTap}) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 20,
            color: Styles.discussionTileIconColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "$iconValue",
          style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13, color: Styles.discussionTileIconColor),
        )
      ],
    );
  }

  Widget addTopicButton({Function()? onTap}) {
    return CommonButton(
      onPressed: onTap,
      minWidth: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      text: "Add Topic",
      fontSize: themeData.textTheme.bodySmall?.fontSize,
      fontColor: themeData.colorScheme.onPrimary,
    );
  }
//endregion
}

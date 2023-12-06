import 'package:flutter/material.dart';
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

import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../common/components/common_cached_network_image.dart';

class DiscussionTabWidget extends StatefulWidget {
  final String contentId;
  final DiscussionProvider discussionProvider;

  const DiscussionTabWidget({
    Key? key,
    required this.contentId,
    required this.discussionProvider,
  }) : super(key: key);

  @override
  State<DiscussionTabWidget> createState() => _DiscussionTabWidgetState();
}

class _DiscussionTabWidgetState extends State<DiscussionTabWidget> {
  late ThemeData themeData;

  late AppProvider appProvider;

  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;

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

    PaginationModel paginationModel = discussionProvider.forumListPaginationModel.get();
    if (paginationModel.isFirstTimeLoading) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    if (!paginationModel.isLoading && discussionProvider.forumsList.length == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          discussionController.getForumsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            Center(
              child: Text(
                appProvider.localStr.commoncomponentLabelNodatalabel,
              ),
            ),
          ],
        ),
      );
    }

    List<ForumModel> forumsList = discussionProvider.forumsList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: () async {
        discussionController.getForumsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(13),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: forumsList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && paginationModel.isLoading) || (index == forumsList.length)) {
            if (paginationModel.isLoading) {
              return const CommonLoader(
                isCenter: true,
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (forumsList.length - paginationModel.refreshLimit)) {
            if (paginationModel.hasMore && !paginationModel.isLoading) {
              discussionController.getForumsList(
                isRefresh: false,
                isGetFromCache: false,
                isNotify: false,
              );
            }
          }

          return getDiscussionCardItemWidget(forumModel: forumsList[index]);
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
    if(createdDateTime != null) {
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
              if(createdTimeString.isNotEmpty) Text(
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
    if(title.isEmpty) {
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
    if(description.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        description,
        style: themeData.textTheme.bodySmall,
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

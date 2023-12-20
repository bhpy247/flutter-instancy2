import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';

class DiscussionCard extends StatefulWidget {
  final int index;
  final ForumModel forumModel;
  final bool isDiscussionDetail;
  final Function()? onCardTap, onAddTopicTap, onMoreTap, onLikeTap;

  const DiscussionCard({
    super.key,
    this.index = 0,
    required this.forumModel,
    this.onCardTap,
    this.onAddTopicTap,
    this.onMoreTap,
    this.onLikeTap,
    this.isDiscussionDetail = false,
  });

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> with MySafeState {
  ForumModel forumModel = ForumModel();

  bool addTopicEnabled = false;

  void checkAddTopicEnabled() {
    MyPrint.printOnConsole("checkAddTopicEnabled called");
    addTopicEnabled = DiscussionForumUiActionController(appProvider: context.read<AppProvider>()).showAddToTopic(
      parameterModel: DiscussionForumUiActionParameterModel(
        CreatedUserID: forumModel.CreatedUserID,
        CreateNewTopic: forumModel.CreateNewTopic,
      ),
    );
    MyPrint.printOnConsole("addTopicEnabled:$addTopicEnabled");
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    forumModel = widget.forumModel;
    checkAddTopicEnabled();
  }

  @override
  void didUpdateWidget(covariant DiscussionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.forumModel == oldWidget.forumModel) {
      return;
    }

    forumModel = widget.forumModel;
    checkAddTopicEnabled();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return InkWell(
      onTap: () {
        if (widget.onCardTap != null) widget.onCardTap!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13).copyWith(bottom: 5),
        margin: const EdgeInsets.only(bottom: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileView(),
                  const SizedBox(
                    height: 12,
                  ),
                  if (forumModel.ForumThumbnailPath.checkNotEmpty) thumbNailWidget(forumModel.ForumThumbnailPath),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    forumModel.Name,
                    style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (forumModel.Description.checkNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        forumModel.Description,
                        style: themeData.textTheme.bodyMedium?.copyWith(color: const Color(0xff757575), fontWeight: FontWeight.w400),
                      ),
                    ),
                  bottomRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget thumbNailWidget(String url) {
    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole('thumbnailImageUrl:$url');

    if (url.checkEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: CommonCachedNetworkImage(
        imageUrl: url,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) {
          return const Icon(
            Icons.image,
            color: Colors.grey,
          );
        },
      ),
    );
    //for video thumbnail
    /*return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonCachedNetworkImage(
            imageUrl: url,
            height: 75,
            width: 75,
            fit: BoxFit.cover,

          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.play_arrow,size: 15,)),
          )
        ],
      ),
    );*/
  }

  Widget profileView() {
    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: forumModel.DFProfileImage,
      ),
    );
    // MyPrint.printOnConsole('profileImageUrl:$profileImageUrl');

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              // imageUrl: "https://picsum.photos/200/300",
              imageUrl: profileImageUrl,
              // imageUrl: imageUrl,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              errorIconSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forumModel.Author,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      // "13 days ago",
                      DatePresentation.getFormattedDate(dateFormat: "dd MMMM yyyy", dateTime: DateFormat("MM/dd/yyyy hh:mm:ss a").parse(forumModel.CreatedDate)) ?? "",
                      // DatePresentation.niceDateFormatter(forumModel.CreatedDate, endTimeStamp),
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
              if (!widget.isDiscussionDetail)
                InkWell(
                  onTap: widget.onMoreTap,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 18,
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget bottomRow() {
    return Row(
      children: [
        iconTextButton(
          iconData: forumModel.isLikedByMe ? Icons.thumb_up_alt_outlined : Icons.thumb_up_alt_rounded,
          text: forumModel.totalLikeUserCount.toString(),
          onTap: widget.onLikeTap,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: iconTextButton(iconData: Icons.message_outlined, text: forumModel.NoOfTopics.toString())),
        addTopicButton()
      ],
    );
  }

  Widget iconTextButton({required IconData iconData, String text = " ", Function()? onTap}) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(iconData, color: Styles.iconColor, size: 18),
          ),
        ),
        Text(
          text,
          style: themeData.textTheme.bodySmall,
        )
      ],
    );
  }

  Widget addTopicButton() {
    if (!addTopicEnabled) return const SizedBox();

    return CommonButton(
      onPressed: widget.onAddTopicTap,
      text: "Add Topic",
      fontSize: 13,
      fontColor: Colors.white,
      borderRadius: 2,
      height: 27,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 17),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/learning_communities/data_model/learning_communities_dto_model.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';

class LearningCommunitiesCard extends StatefulWidget {
  final PortalListing model;
  final void Function()? onJoinCommunityTap;
  final void Function()? onGoToCommunityTap;

  const LearningCommunitiesCard({super.key, required this.model, this.onGoToCommunityTap, this.onJoinCommunityTap});

  @override
  State<LearningCommunitiesCard> createState() => _LearningCommunitiesCardState();
}

class _LearningCommunitiesCardState extends State<LearningCommunitiesCard> with MySafeState {
  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget(widget.model.picture),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: detailColumn()),
        ],
      ),
    );
  }

  Widget imageWidget(String url) {
    // MyPrint.printOnConsole("mylearning content image url:$url");

    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // if(url.startsWith("https://")) url = url.replaceFirst("https://", "http://");
    // url = "https://enterprisedemo-admin.instancy.com/Content/SiteFiles/Images/elearning%20Courses.png";
    // url = "http://enterprisedemo.instancy.com/Content/SiteFiles/Images/elearning%20Courses.png";
    // url = "https://upgradedenterprise.instancy.com/content/onboarding/1_image.png";
    // url = "https://qacontent.blob.core.windows.net/qainstancycontent/content/sitefiles/images/media resource.jpg";
    // url = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url);
    // MyPrint.printOnConsole("mylearning content final image url:$url");

    return SizedBox(
      width: 100,
      child: AspectRatio(
        aspectRatio: 1.12,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CommonCachedNetworkImage(
            imageUrl: url,
            shimmerIconSize: 60,
            errorIconSize: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget detailColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.model.name,
                style: themeData.textTheme.titleMedium?.copyWith(
                  color: const Color(0xff1D293F),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
            if (ParsingHelper.parseBoolMethod(widget.model.labelAlreadyaMember))
              Text(
                "Member",
                style: themeData.textTheme.titleMedium?.copyWith(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 11),
              ),
            // Icon(
            //   Icons.more_vert,
            //   size: 20,
            // )
          ],
        ),
        const SizedBox(height: 5),
        Text(
          widget.model.description,
          style: themeData.textTheme.titleMedium?.copyWith(
            color: const Color(0xff1D293F),
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CommonButton(
              onPressed: () {
                if (ParsingHelper.parseBoolMethod(widget.model.labelAlreadyaMember)) {
                  if (widget.onGoToCommunityTap != null) {
                    widget.onGoToCommunityTap!();
                  }
                } else {
                  if (widget.onJoinCommunityTap != null) {
                    widget.onJoinCommunityTap!();
                  }
                }
              },
              text: ParsingHelper.parseBoolMethod(widget.model.labelAlreadyaMember) ? "Go To Community" : "Join Community",
              fontColor: themeData.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ],
        )
        /*getPrimaryActionButton(
          model: model,
          context: context,
          primaryAction: widget.primaryAction,
        ),*/
      ],
    );
  }
}

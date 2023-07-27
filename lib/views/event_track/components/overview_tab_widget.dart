import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../backend/app_theme/style.dart';
import '../../../models/event_track/data_model/event_track_dto_model.dart';
import '../../common/components/common_cached_network_image.dart';

class OverViewTabWidget extends StatefulWidget {
  final EventTrackDTOModel? overviewData;

  const OverViewTabWidget({
    Key? key,
    required this.overviewData,
  }) : super(key: key);

  @override
  State<OverViewTabWidget> createState() => _OverViewTabWidgetState();
}

class _OverViewTabWidgetState extends State<OverViewTabWidget> {
  late ThemeData themeData;

  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    if (widget.overviewData == null) {
      return Center(
        child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
      );
    }

    EventTrackDTOModel overviewData = widget.overviewData!;
    MyPrint.printOnConsole("EventTrackDTOModel Description: ${overviewData.longdescription}");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getDescriptionDetails(description: overviewData.longdescription),
          getMiddleContentView(
            createdOnDate: overviewData.createddate,
            communityName: overviewData.OrgName,
          ),
          getAuthorView(overviewData: overviewData),
        ],
      ),
    );
  }

  //region Description details
  Widget getDescriptionDetails({required String description}) {
    if (description.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
          const SizedBox(
            height: 10,
          ),
          Html(data: description),
          // getReadMoreText(
          //   trimLines: 3,
          //   text: "htmlparser.HtmlParser(input)",
          // )
        ],
      ),
    );
  }

  Widget getReadMoreText({String text = "", int trimLines = 6}) {
    return ReadMoreText(
      text,
      trimLines: trimLines,
      style: themeData.textTheme.titleSmall?.copyWith(color: Styles().lightTextColor.withOpacity(0.8)),
      colorClickableText: themeData.primaryColor,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Read more.',
      trimExpandedText: 'Read less.',
      lessStyle: themeData.textTheme.titleSmall?.copyWith(
        color: themeData.primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
      moreStyle: themeData.textTheme.titleSmall
          ?.copyWith(color: themeData.primaryColor, fontSize: 14, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
    );
  }

  //endregion

  Widget getMiddleContentView({required String createdOnDate, required String communityName}) {
    if (createdOnDate.isEmpty && communityName.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          if (createdOnDate.isNotEmpty) getWidgetWithTitle(title: "Created on", icon: FontAwesomeIcons.calendar, data: createdOnDate),
          if (communityName.isNotEmpty) getWidgetWithTitle(title: "Community", icon: FontAwesomeIcons.globe, data: communityName),
        ],
      ),
    );
  }

  //region getAuthorView
  Widget getAuthorView({required EventTrackDTOModel overviewData}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.circleUser,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                "Author",
                style: themeData.textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          profileView(
            about: overviewData.About,
            profileImageUrl: overviewData.ProfileImgPath,
            authorName: overviewData.DisplayName,
            contentCount: overviewData.contentCount,
            totalRatings: overviewData.totalRatings,
          ),
          // const SizedBox(height: 10),
          // getQuotesView(),
        ],
      ),
    );
  }

  Widget profileView({
    required String profileImageUrl,
    required String authorName,
    required String contentCount,
    required String totalRatings,
    required String about,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.transparent)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: MyUtils.getSecureUrl(profileImageUrl),
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Html(data: authorName),
                        /*Text(
                      authorName,
                      style: themeData.textTheme.titleSmall,
                    ),*/
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 15,
                              color: Styles.starYellowColor,
                            ),
                            Text(
                              totalRatings,
                              style: themeData.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_outlined,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        contentCount,
                        style: themeData.textTheme.titleSmall?.copyWith(fontSize: 12, color: Styles().lightTextColor),
                      ),
                    ],
                  )
                ],
              ),
              Visibility(visible: about.isNotEmpty, child: getQuotesView(about))
            ],
          ),
        ),
      ],
    );
  }

  Widget getQuotesView(String about) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.quoteLeft,
                  size: 20,
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  about,
                  style: themeData.textTheme.titleSmall?.copyWith(fontSize: 12, height: 1.5),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //endregion

//region CommonPageWidgets
  Widget getWidgetWithTitle({String title = "", IconData? icon, String data = ""}) {
    return Column(
      children: [
        const Divider(height: 0, thickness: 1.5),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                title,
                style: themeData.textTheme.bodySmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
              )),
              Text(
                data,
                style: themeData.textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        const Divider(height: 0, thickness: 1.5),
      ],
    );
  }

//endregion
}

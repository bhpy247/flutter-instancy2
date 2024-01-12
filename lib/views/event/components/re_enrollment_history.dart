import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/models/event/response_model/re_entrollment_history_response_model.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/modal_progress_hud.dart';

class ReEnrollmentHistory extends StatefulWidget {
  static const String routeName = "/reEnrollmentHistory";
  final ReEnrollmentHistoryScreenNavigationArguments arguments;

  const ReEnrollmentHistory({super.key, required this.arguments});

  @override
  State<ReEnrollmentHistory> createState() => _ReEnrollmentHistoryState();
}

class _ReEnrollmentHistoryState extends State<ReEnrollmentHistory> {
  bool isLoading = false;

  late EventController eventController;
  late EventProvider eventProvider;
  late ThemeData themeData;

  Future? getFuture;

  ReEnrollmentHistoryResponseModel? responseModel;

  Future<void> getFutureData() async {
    responseModel = await eventController.getReEnrollmentHistory(
      context: context,
      eventId: widget.arguments.parentEventId,
      instanceId: widget.arguments.instanceEventId,
    );
  }

  @override
  void initState() {
    super.initState();
    eventProvider = context.read<EventProvider>();
    eventController = EventController(eventProvider: eventProvider);
    getFuture = getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: getAppBar(),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: getMainWidget(),
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return FutureBuilder(
        future: getFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getBody();
          }
          return const CommonLoader();
        });
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Re-enrollment History",
      actions: [
        /*Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await NavigationController.navigateToWishlist(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: WishListScreenNavigationArguments(
                      componentId: widget.arguments.componentId,
                      componentInstanceId: widget.arguments.componentInsId,
                      // eventProvider: eventProvider,
                    ),
                  );
                  getEventCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(FontAwesomeIcons.heart),
                    ),
                    if (eventProvider.maxWishlistContentsCount.get() > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeData.primaryColor,
                          ),
                          child: Text(
                            "${eventProvider.maxWishlistContentsCount.get()}",
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget getBody() {
    return Column(
      children: [getHeaderData(), Expanded(child: getHistoryList())],
    );
  }

  Widget getHeaderData() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1)]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            imageWidget(url: widget.arguments.ThumbnailImagePath, context: context),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    responseModel?.name ?? widget.arguments.ContentName,
                    style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (widget.arguments.AuthorDisplayName.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      "By ${widget.arguments.AuthorDisplayName}",
                      style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F).withOpacity(.6), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget({required String url, required BuildContext context}) {
    // MyPrint.printOnConsole("catalog content image url:$url");

    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole("catalog content final image url:$url");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          errorIconSize: 60,
        ),
      ),
    );
  }

  Widget getHistoryList() {
    if (responseModel == null) return const SizedBox();
    return ListView.builder(
      padding: const EdgeInsets.all(21),
      itemCount: responseModel?.scheduleReportDataDTO.length,
      itemBuilder: (BuildContext context, int index) {
        return getHistoryData(responseModel!.scheduleReportDataDTO[index]);
      },
    );
  }

  Widget getHistoryData(ScheduleReportDataDTO model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getRichText(leftText: "Event Type", rightText: model.mediaName),
          const SizedBox(
            height: 5,
          ),
          getRichText(leftText: "Attendance", rightText: model.status),
          const SizedBox(
            height: 5,
          ),
          getRichText(leftText: "Location", rightText: model.locationName),
          const SizedBox(
            height: 5,
          ),
          getRichText(leftText: "Start Date", rightText: DatePresentation.reEnrollmentHistoryFromString(model.eventStartDateTime)),
          const SizedBox(
            height: 5,
          ),
          getRichText(leftText: "End Date", rightText: DatePresentation.reEnrollmentHistoryFromString(model.eventEndDateTime)),
        ],
      ),
    );
  }

  Widget getRichText({String leftText = "", String rightText = ""}) {
    return RichText(
      text: TextSpan(
        text: "$leftText: ",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: rightText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

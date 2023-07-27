import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/event/event_controller.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/event/data_model/event_session_course_dto_model.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';

class SessionTabWidget extends StatefulWidget {
  final String eventId;
  final EventProvider? eventProvider;

  const SessionTabWidget({
    Key? key,
    required this.eventId,
    this.eventProvider,
  }) : super(key: key);

  @override
  State<SessionTabWidget> createState() => _SessionTabWidgetState();
}

class _SessionTabWidgetState extends State<SessionTabWidget> {
  late ThemeData themeData;
  late AppProvider appProvider;
  late EventController eventController;
  late EventProvider eventProvider;

  void getSessionData({required String eventId}) async {
    MyPrint.printOnConsole("SessionTabWidget().getSessionData() init called with eventId:'$eventId'");
    await eventController.getEventSessionsList(
      eventId: eventId,
    );
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("SessionTabWidget init called with eventId:'${widget.eventId}'");

    appProvider = context.read<AppProvider>();
    eventProvider = widget.eventProvider ?? EventProvider();
    eventController = EventController(eventProvider: eventProvider);
    if (eventProvider.eventSessionData.getList().isEmpty) {
      getSessionData(eventId: widget.eventId);
    }
  }

  @override
  void didUpdateWidget(covariant SessionTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.eventId != oldWidget.eventId) {
      getSessionData(eventId: widget.eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
      ],
      child: Consumer<EventProvider>(builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
        themeData = Theme.of(context);
        if (eventProvider.isLoadingEventSessionData.get()) {
          return const CommonLoader(
            isCenter: true,
          );
        }

        Widget child;

        List<EventSessionCourseDTOModel> scheduleData = eventProvider.eventSessionData.getList(isNewInstance: false);

        if (scheduleData.isEmpty) {
          child = Center(
            child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
          );
        } else {
          child = ListView.builder(
            shrinkWrap: true,
            itemCount: scheduleData.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              EventSessionCourseDTOModel eventSessionCourseDTOModel = scheduleData[index];

              return ModifiedEventSessionsCards(model: eventSessionCourseDTOModel);
            },
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: getWidgetWithTitle(
            title: appProvider.localStr.detailsLabelSessionstitlelable,
            widget: child,
          ),
        );
      }),
    );
  }

  Widget getWidgetWithTitle({String title = "", Widget? widget, Widget? trailingWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //         child: Text(
        //           title,
        //           style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        //         )),
        //     trailingWidget ?? Container()
        //   ],
        // ),
        const SizedBox(
          height: 10,
        ),
        widget ?? Container()
      ],
    );
  }
}

class ModifiedEventSessionsCards extends StatelessWidget {
  final EventSessionCourseDTOModel model;

  const ModifiedEventSessionsCards({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late ThemeData themeData = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [const BoxShadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 3, spreadRadius: 1)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // imageWidget(url: model.ThumbnailImagePath, context: context),
          // const SizedBox(width: 20),
          Expanded(child: detailColumn(context: context)),
        ],
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

  Widget detailColumn({required BuildContext context}) {
    ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  coursesIcon(assetName: AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: model.MediaTypeID, objectTypeId: model.ContentTypeId)),
                  const SizedBox(width: 10),
                  Text(
                    model.ContentType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff757575),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 0),
        Text(
          model.Title,
          style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F), fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.AuthorDisplayName,
              style: themeData.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: const Color(0xff9AA0A6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              child: eventStartDateAndTime(model: model, context: context),
            ),
          ],
        ),
      ],
    );
  }

  Widget eventStartDateAndTime({required EventSessionCourseDTOModel model, required BuildContext context}) {
    // MyPrint.printOnConsole("model. endDateTime: '${model.EventEndDateTime} to ${model.EventEndDateTimeTimeWithoutConvert}'");

    AppProvider appProvider = context.read<AppProvider>();

    if (model.EventStartDateTimeWithoutConvert.isEmpty || appProvider.appSystemConfigurationModel.dateTimeFormat.isEmpty) return const SizedBox();

    DateTime? startDateTime = ParsingHelper.parseDateTimeMethod(model.EventStartDateTimeWithoutConvert, dateFormat: appProvider.appSystemConfigurationModel.dateTimeFormat);
    DateTime? endDateTime = ParsingHelper.parseDateTimeMethod(model.EventEndDateTimeTimeWithoutConvert, dateFormat: appProvider.appSystemConfigurationModel.dateTimeFormat);

    if (startDateTime == null) return const SizedBox();

    ThemeData themeData = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "dd MMM yyyy")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Time: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "hh:mm aa")} to ${DatePresentation.getFormattedDate(dateTime: endDateTime, dateFormat: "hh:mm aa")} (${model.Duration})",
            // "Time: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "hh:mm aa")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          ),
          // const SizedBox(height: 4),
          // Text(
          //   "Available seats : ${model.AvailableSeats}",
          //   style: themeData.textTheme.labelSmall?.copyWith(
          //     fontSize: 10,
          //     fontWeight: FontWeight.w600,
          //     color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.contain,
    );
  }
}

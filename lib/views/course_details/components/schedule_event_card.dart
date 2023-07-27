import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/catalog/data_model/catalog_course_dto_model.dart';

class ScheduleEventCard extends StatelessWidget {
  final CatalogCourseDTOModel catalogCourseDtoModel;
  final void Function()? onEnrollTap, onCancelEnrollmentTap;

  const ScheduleEventCard({
    Key? key,
    required this.catalogCourseDtoModel,
    this.onEnrollTap,
    this.onCancelEnrollmentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    MyPrint.printOnConsole("catalogCourseDtoModel.eventStartDateTime:'${catalogCourseDtoModel.EventStartDateTime}'");

    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getEventDateWidget(
                  eventStartDateTime: catalogCourseDtoModel.EventStartDateTime,
                  themeData: themeData,
                  context: context,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.5,
                              color: themeData.primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(catalogCourseDtoModel.ContentType.isNotEmpty) Text(
                                  catalogCourseDtoModel.ContentType,
                                  style: themeData.textTheme.bodyMedium,
                                ),
                                getEventTimeWidget(
                                  eventStartDateTime: catalogCourseDtoModel.EventStartDateTime,
                                  themeData: themeData,
                                  context: context,
                                ),
                                if(catalogCourseDtoModel.Title.isNotEmpty) Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2).copyWith(top: 20),
                                  child: Text(
                                    catalogCourseDtoModel.Title,
                                    style: themeData.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if(catalogCourseDtoModel.ShortDescription.isNotEmpty) Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    catalogCourseDtoModel.ShortDescription,
                                    style: themeData.textTheme.bodyMedium,
                                  ),
                                ),
                                if(catalogCourseDtoModel.Duration.isNotEmpty) Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Text(
                                        catalogCourseDtoModel.Duration,
                                        style: themeData.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade700,
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 1.5, color: Colors.grey.shade700),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' by ${catalogCourseDtoModel.PresenterDisplayName}',
                                        style: themeData.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    catalogCourseDtoModel.LocationName,
                                    style: themeData.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                getEnrollButton(themeData: themeData),
                                getCancelEnrollmentButton(themeData: themeData),
                                if(catalogCourseDtoModel.AvailableSeats.isNotEmpty) Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '${catalogCourseDtoModel.AvailableSeats} Seats Remain',
                                    style: themeData.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getEventDateWidget({required String eventStartDateTime, required ThemeData themeData, required BuildContext context}) {
    AppProvider appProvider = context.read<AppProvider>();

    DateTime? dateTime = ParsingHelper.parseDateTimeMethod(eventStartDateTime, dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat);
    String? newDateTime = DatePresentation.getFormattedDate(dateFormat: "EEEE, d MMM yyyy", dateTime: dateTime);
    // MyPrint.printOnConsole("newDateTime:$newDateTime");
    if (newDateTime == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        newDateTime,
        style: themeData.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getEventTimeWidget({required String eventStartDateTime, required ThemeData themeData, required BuildContext context}) {
    if(eventStartDateTime.isEmpty) {
      return const SizedBox();
    }

    AppProvider appProvider = context.read<AppProvider>();

    DateTime? dateTime = ParsingHelper.parseDateTimeMethod(eventStartDateTime, dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat);
    String? newDateTime = DatePresentation.getFormattedDate(dateFormat: "h:mm a", dateTime: dateTime);
    if (newDateTime == null) {
      return const SizedBox();
    }

    return Text(
      '(${DateFormat('h:mm a').format(DateFormat(appProvider.appSystemConfigurationModel.eventDateTimeFormat).parse(catalogCourseDtoModel.EventStartDateTime))}-${DateFormat('h:mm a').format(DateFormat(appProvider.appSystemConfigurationModel.eventDateTimeFormat).parse(catalogCourseDtoModel.EventEndDateTime))})',
      // newDateTime,
      style: themeData.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getEnrollButton({required ThemeData themeData}) {
    if(catalogCourseDtoModel.isContentEnrolled == "1" || catalogCourseDtoModel.isContentEnrolled.toLowerCase() == "true") {
      return const SizedBox();
    }

    return MaterialButton(
      disabledColor: themeData.primaryColor.withOpacity(0.5),
      color: themeData.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Enroll',
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: () {
        if(onEnrollTap != null) {
          onEnrollTap!();
        }
      },
    );
  }

  Widget getCancelEnrollmentButton({required ThemeData themeData}) {
    if(catalogCourseDtoModel.isContentEnrolled == "0" || catalogCourseDtoModel.isContentEnrolled.toLowerCase() == "false") {
      return const SizedBox();
    }

    return MaterialButton(
      disabledColor: themeData.primaryColor.withOpacity(0.5),
      color: themeData.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Cancel Enrollment',
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: () {
        if(onCancelEnrollmentTap != null) {
          onCancelEnrollmentTap!();
        }
      },
    );
  }
}

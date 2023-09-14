import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/course/data_model/CourseDTOModel.dart';

class EventSessionCard extends StatelessWidget {
  final CourseDTOModel courseDTOModel;

  const EventSessionCard({
    Key? key,
    required this.courseDTOModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    MyPrint.printOnConsole("eventSessionCourseDTOModel.eventStartDateTime:'${courseDTOModel.EventStartDateTime}'");

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
                  eventStartDateTime: courseDTOModel.EventStartDateTime,
                  themeData: themeData,
                  context: context,
                ),
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
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (courseDTOModel.ContentType.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  courseDTOModel.ContentType,
                                  style: themeData.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            getEventTimeWidget(
                              eventStartDateTime: courseDTOModel.EventStartDateTime,
                              themeData: themeData,
                              context: context,
                            ),
                            if (courseDTOModel.ContentStatus.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  courseDTOModel.ContentStatus,
                                  style: themeData.textTheme.bodyMedium?.copyWith(
                                    color: themeData.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            if (courseDTOModel.Title.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3).copyWith(top: 10),
                                child: Text(
                                  courseDTOModel.Title,
                                  style: themeData.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (courseDTOModel.ShortDescription.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  courseDTOModel.ShortDescription,
                                  style: themeData.textTheme.bodyMedium,
                                ),
                              ),
                            if (courseDTOModel.Duration.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    Text(
                                      courseDTOModel.Duration,
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
                                    ' by ${courseDTOModel.PresenterDisplayName}',
                                      style: themeData.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                courseDTOModel.LocationName,
                                style: themeData.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // getEnrollButton(themeData: themeData),
                            if (courseDTOModel.AvailableSeats.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  '${courseDTOModel.AvailableSeats} Seats Remain',
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
    AppProvider appProvider = context.read<AppProvider>();

    if(eventStartDateTime.isEmpty) {
      return const SizedBox();
    }

    DateTime? dateTime = ParsingHelper.parseDateTimeMethod(eventStartDateTime, dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat);
    String? newDateTime = DatePresentation.getFormattedDate(dateFormat: "h:mm a", dateTime: dateTime);
    if (newDateTime == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        '(${DateFormat('h:mm a').format(DateFormat(appProvider.appSystemConfigurationModel.eventDateTimeFormat).parse(courseDTOModel.EventStartDateTime))}-${DateFormat('h:mm a').format(DateFormat(appProvider.appSystemConfigurationModel.eventDateTimeFormat).parse(courseDTOModel.EventEndDateTime))})',
        // newDateTime,
        style: themeData.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget getEnrollButton({required ThemeData themeData}) {
    if (courseDTOModel.isContentEnrolled == "1" || courseDTOModel.isContentEnrolled.toLowerCase() == "true") {
      return const SizedBox();
    }

    return MaterialButton(
      disabledColor: themeData.primaryColor.withOpacity(0.5),
      color: themeData.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
        /*setState(() {
          loaderEnroll = true;
          contentID = catalogCourseDtoModel.contentID;
        });
        catalogBloc.add(AddEnrollEvent(
          selectedContent: catalogCourseDtoModel.addLink,
          componentID: 107,
          componentInsID: 3291,
          additionalParams: '',
          targetDate: '',
          rescheduleenroll: widget.isFromReschedule ? 'rescheduleenroll' : '',
        ));*/
      },
    );
  }
}

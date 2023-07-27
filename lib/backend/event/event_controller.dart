import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/event/data_model/event_session_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event/response_model/event_session_data_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/view_recording_request_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/event/components/event_cancel_enrolment_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_controller.dart';
import '../../utils/my_print.dart';
import '../../utils/my_toast.dart';
import '../../utils/parsing_helper.dart';
import '../navigation/navigation_arguments.dart';
import '../navigation/navigation_operation_parameters.dart';
import '../navigation/navigation_type.dart';
import 'event_provider.dart';
import 'event_repository.dart';

class EventController {
  late EventProvider _eventProvider;
  late EventRepository _eventRepository;

  EventController({required EventProvider? eventProvider, EventRepository? repository, ApiController? apiController}) {
    _eventProvider = eventProvider ?? EventProvider();
    _eventRepository = repository ?? EventRepository(apiController: apiController ?? ApiController());
  }

  EventProvider get eventProvider => _eventProvider;

  EventRepository get eventRepository => _eventRepository;

  Future<bool> cancelEventEnrollment({
    required BuildContext context,
    required String eventId,
    required bool isBadCancellationEnabled,
    LocalStr? localStr,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().cancelEventEnrollment() called with eventId:'$eventId' and isBadCancellationEnabled:$isBadCancellationEnabled", tag: tag);

    EventRepository repository = eventRepository;

    bool isCancel = await checkCancelEnrollmentFromDialog(
      context: context,
      localStr: localStr,
    );
    MyPrint.printOnConsole("isCancel:$isCancel", tag: tag);

    if (!isCancel) {
      MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because user has opted to not cancel", tag: tag);
      return false;
    }

    bool isBadCancel = false;

    if (isBadCancellationEnabled) {
      DataResponseModel<String> dataResponseModel = await repository.checkIsFallUnderBadCancelEnrollment(eventId: eventId);
      MyPrint.printOnConsole("checkIsFallUnderBadCancelEnrollment response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because checkIsFallUnderBadCancelEnrollment had some error", tag: tag);
        return false;
      }

      isBadCancel = dataResponseModel.data == "true";
    }
    MyPrint.printOnConsole("isBadCancel:$isBadCancel", tag: tag);

    DataResponseModel<String> dataResponseModel = await repository.cancelEnrolledEvent(
      eventId: eventId,
      isBadCancel: isBadCancel,
    );
    MyPrint.printOnConsole("cancelEnrolledEvent response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because cancelEnrolledEvent had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == 'true';
  }

  Future<bool> checkCancelEnrollmentFromDialog({required BuildContext context, LocalStr? localStr}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventCancelEnrollmentDialog(
          localStr: localStr,
        );
      },
    );

    return value == true;
  }

  Future<List<EventSessionCourseDTOModel>> getEventSessionsList({
    required String eventId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().getEventSessionsList() called with eventId:'$eventId'", tag: tag);

    EventProvider provider = eventProvider;

    if (eventId.isEmpty) {
      MyPrint.printOnConsole("Returning from EventController().getEventSessionsList() eventId is empty", tag: tag);
      provider.isLoadingEventSessionData.set(value: false, isNotify: isNotify);
      provider.eventSessionData.setList(list: [], isNotify: true);
      return [];
    }

    List<EventSessionCourseDTOModel> courseList = <EventSessionCourseDTOModel>[];

    provider.isLoadingEventSessionData.set(value: true, isNotify: isNotify);

    DataResponseModel<EventSessionDataResponseModel> response = await eventRepository.getEventSessionData(eventId: eventId);
    MyPrint.logOnConsole("getEventSessionData response:$response", tag: tag);

    provider.isLoadingEventSessionData.set(value: false, isNotify: true);

    if (response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().getEventSessionsList() because getEventSessionData had some error", tag: tag);
      return courseList;
    }

    if (response.data != null) {
      courseList = response.data!.CourseList;
    }
    MyPrint.logOnConsole("final EventSessionData courseList:$courseList", tag: tag);

    provider.eventSessionData.setList(list: courseList, isNotify: true);

    return courseList;
  }

  Future<void> joinVirtualEvent({required BuildContext? context, required String joinUrl}) async {
    MyPrint.printOnConsole("EventController().joinVirtualEvent() called with joinUrl:$joinUrl");

    if (joinUrl.isNotEmpty) {
      MyUtils.launchUrl(url: joinUrl, launchMode: LaunchMode.externalApplication);
    } else {
      if (context != null) MyToast.showError(context: context, msg: "No url found");
    }
  }

  Future<bool> addEventToCalender(
      {required BuildContext context,
      required String EventStartDateTime,
      required EventEndDateTime,
      required String eventDateTimeFormat,
      required String Title,
      required String ShortDescription,
      required String LocationName,
      bool isFromDetail = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().addEventToCalender() called", tag: tag);

    try {
      MyPrint.printOnConsole("eventDateTimeFormat:$eventDateTimeFormat", tag: tag);
      MyPrint.printOnConsole("eventStartDateTime:$EventStartDateTime", tag: tag);
      MyPrint.printOnConsole("eventEndDateTime:$EventEndDateTime", tag: tag);
      // if(isFromDetail){
      //   final startDateTime = DateFormat('dd MMM yyyy').parse(EventStartDateTime);
      //   final startNewFormat = DateFormat('dd/MM/yy hh:mm a');
      //   EventStartDateTime = startNewFormat.format(startDateTime);
      //
      //   final dateTime = DateFormat('dd MMM yyyy').parse(EventEndDateTime);
      //   final newFormat = DateFormat('dd/MM/yy hh:mm a');
      //   EventEndDateTime = newFormat.format(dateTime);
      // }
      MyPrint.printOnConsole('eventDateTimeFormat:$eventDateTimeFormat', tag: tag);

      DateTime? startDate = ParsingHelper.parseDateTimeMethod(
        EventStartDateTime,
        // dateFormat: isFromDetail ? "dd MMM yyyy" : eventDateTimeFormat,
        dateFormat: isFromDetail ? "MM/dd/yyyy hh:mm:ss a" : eventDateTimeFormat,
      );
      DateTime? endDate = ParsingHelper.parseDateTimeMethod(
        EventEndDateTime,
        // dateFormat: isFromDetail ? "dd MMM yyyy" : eventDateTimeFormat,
        dateFormat: isFromDetail ? "MM/dd/yyyy hh:mm:ss a" : eventDateTimeFormat,
      );
      MyPrint.printOnConsole('startDate:$startDate', tag: tag);
      MyPrint.printOnConsole('endDate:$endDate', tag: tag);

      if (startDate == null || endDate == null) {
        MyToast.showError(context: context, msg: "Couldn't Perform Operation");
        return false;
      }

      Event event = Event(
        title: Title,
        description: ShortDescription,
        location: LocationName,
        startDate: startDate,
        endDate: endDate,
        allDay: false,
      );
      MyPrint.printOnConsole("addEvent2Cal event.endDate:${event.endDate} event.startDate ${event.startDate}", tag: tag);

      bool isSuccess = await Add2Calendar.addEvent2Cal(event);
      MyPrint.printOnConsole("addEvent2Cal isSuccess:$isSuccess", tag: tag);

      return isSuccess;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventController().addEventToCalender():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return false;
  }

  Future<void> viewRecordingForEvent({required ViewRecordingRequestModel model, required BuildContext context}) async {
    MyPrint.printOnConsole("EventController().viewRecordingForEvent() called with recordingUrl:${model.eventRecordingURL}");

    String recordingType = model.recordingType.toLowerCase();
    MyPrint.printOnConsole("recordingType:'$recordingType'");

    if (recordingType == "url") {
      if (model.eventRecordingURL.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() eventRecordingURL is empty");
        MyToast.showError(context: context, msg: "Recording URL Not Available");
        return;
      }

      MyUtils.launchUrl(url: model.eventRecordingURL, launchMode: LaunchMode.externalApplication);
    } else if (recordingType == "video") {
      if (model.jwVideoPath.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() jwVideoPath is empty");
        MyToast.showError(context: context, msg: "Recording File Not Available");
        return;
      }

      String siteUrl = ApiController().apiDataProvider.getCurrentSiteUrl();
      MyPrint.printOnConsole("SiteUrl : $siteUrl");

      if (siteUrl.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() siteUrl is empty");
        return;
      }

      String launchUrl = "$siteUrl${model.jwVideoPath}";

      NavigationController.navigateToCourseLaunchWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CourseLaunchWebViewScreenNavigationArguments(
          courseUrl: launchUrl,
          courseName: model.contentName,
          contentTypeId: model.contentTypeId,
        ),
      );
    }
  }
}

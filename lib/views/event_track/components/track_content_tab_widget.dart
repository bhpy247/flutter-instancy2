import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_track/event_track_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/event/event_controller.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/profile/profile_provider.dart';
import '../../../backend/ui_actions/event_track/event_track_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/event_track/request_model/view_recording_request_model.dart';
import '../../../utils/my_print.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'track_content_card.dart';

class TrackContentTabWidget extends StatefulWidget {
  final List<TrackDTOModel> contentBlocksList;
  final String trackId;
  final int userId;
  final int componentId;
  final int componentInsId;
  final void Function()? onPulledTORefresh;
  final void Function()? refreshParentAndChildContentsCallback;
  final void Function({required TrackCourseDTOModel model})? onContentViewTap;
  final void Function({required TrackCourseDTOModel model})? onReportContentTap;
  final void Function({required TrackCourseDTOModel model})? onSetCompleteTap;
  final void Function({required TrackCourseDTOModel model})? onCancelEnrollmentTap;

  const TrackContentTabWidget({
    Key? key,
    required this.contentBlocksList,
    this.trackId = "",
    required this.userId,
    required this.componentId,
    required this.componentInsId,
    this.onPulledTORefresh,
    this.refreshParentAndChildContentsCallback,
    this.onContentViewTap,
    this.onReportContentTap,
    this.onSetCompleteTap,
    this.onCancelEnrollmentTap,
  }) : super(key: key);

  @override
  State<TrackContentTabWidget> createState() => _TrackContentTabWidgetState();
}

class _TrackContentTabWidgetState extends State<TrackContentTabWidget> with MySafeState {
  late AppProvider appProvider;

  Map<String, dynamic> data = {};
  List<int> intList = [];

  EventTrackUIActionCallbackModel getUIActionCallbackModel({
    required TrackCourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    MyPrint.printOnConsole("In the content tab widget");
    return EventTrackUIActionCallbackModel(
      onEnrollTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        onDetailsTap(model: model);
      },
      onCancelEnrollmentTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        if (widget.onCancelEnrollmentTap != null) {
          widget.onCancelEnrollmentTap!(model: model);
        }
      },
      onRescheduleTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        onDetailsTap(model: model, isRescheduleEvent: true);
      },
      onSetCompleteTap: () {
        if (isSecondaryAction) Navigator.pop(context);
        if (widget.onSetCompleteTap != null) {
          widget.onSetCompleteTap!(model: model);
        }
      },
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              if (widget.onContentViewTap != null) {
                widget.onContentViewTap!(model: model);
              }
            },
      onPlayTap: primaryAction == InstancyContentActionsEnum.Play
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              if (widget.onContentViewTap != null) {
                widget.onContentViewTap!(model: model);
              }
            },
      onReportTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        if (widget.onReportContentTap != null) {
          widget.onReportContentTap!(model: model);
        }
      },
      onJoinTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        // EventController(eventProvider: null).joinVirtualEvent(context: context, joinUrl: model.participanturl);
      },
      onViewQRCodeTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToQRCodeImageScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: QRCodeImageScreenNavigationArguments(qrCodePath: model.ActionViewQRcode),
        );
      },
      onViewRecordingTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        MyPrint.printOnConsole("onViewRecordingTap called for ContentTypeId:${model.ContentTypeId} and ContentID:${model.ContentID}");

        EventRecordingDetailsModel? recordingDetails = model.RecordingDetails;

        if (recordingDetails == null) {
          MyPrint.printOnConsole("recordingDetails are null");
          return;
        }
        ViewRecordingRequestModel viewRecordingRequestModel = ViewRecordingRequestModel(
          contentName: recordingDetails.ContentName,
          contentID: recordingDetails.ContentID,
          contentTypeId: ParsingHelper.parseIntMethod(recordingDetails.ContentTypeId),
          eventRecordingURL: recordingDetails.EventRecordingURL,
          eventRecording: recordingDetails.EventRecording,
          jWVideoKey: recordingDetails.JWVideoKey,
          language: recordingDetails.Language,
          recordingType: recordingDetails.RecordingType,
          scoID: recordingDetails.ScoID,
          jwVideoPath: recordingDetails.ViewLink,
          viewType: recordingDetails.ViewType,
        );
        EventController(eventProvider: null).viewRecordingForEvent(model: viewRecordingRequestModel, context: context);
      },
      onViewResourcesTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        MyPrint.printOnConsole("onViewResourcesTap called for ContentTypeId:${model.ContentTypeId} and ContentID:${model.ContentID}");

        dynamic value = await NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            objectTypeId: model.ContentTypeId,
            isRelatedContent: model.ContentTypeId == InstancyObjectTypes.events,
            parentContentId: model.ContentID,
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            componentId: widget.componentId,
            componentInstanceId: widget.componentInsId,
            scoId: model.ScoID,
            isContentEnrolled: model.isCourseEnrolled(),
          ),
        );

        if (value == true) {
          if (widget.refreshParentAndChildContentsCallback != null) widget.refreshParentAndChildContentsCallback!();
        }
      },
    );
  }

  Future<void> showMoreAction({required TrackCourseDTOModel model}) async {
    MyPrint.printOnConsole("showMoreAction called for EventTrackContent:${model.ContentID}");

    LocalStr localStr = appProvider.localStr;

    ProfileProvider profileProvider = context.read<ProfileProvider>();

    EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
      appProvider: appProvider,
      myLearningProvider: MyLearningProvider(),
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = uiActionsController
        .getTrackContentsSecondaryActions(
          contentModel: model,
          localStr: localStr,
          myLearningUIActionCallbackModel: getUIActionCallbackModel(
            model: model,
            // primaryAction: primaryAction,
            isSecondaryAction: true,
          ),
        )
        .toList();
    MyPrint.printOnConsole("secondary options:$options");

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDetailsTap({required TrackCourseDTOModel model, bool isRescheduleEvent = false}) async {
    String parentContentId = model.ContentID;
    // String parentContentId = model.eventparentid;
    MyPrint.printOnConsole("parentContentId:'$parentContentId'");

    if (isRescheduleEvent && parentContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from onRescheduleTap because parentContentId is empty");
      return;
    }

    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: isRescheduleEvent ? parentContentId : model.ContentID,
        parentTrackId: widget.trackId,
        componentId: isRescheduleEvent ? InstancyComponents.Catalog : widget.componentId,
        componentInstanceId: widget.componentInsId,
        userId: ApiController().apiDataProvider.getCurrentUserId(),
        screenType: InstancyContentScreenType.MyLearning,
        isRescheduleEvent: isRescheduleEvent,
      ),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (widget.refreshParentAndChildContentsCallback != null) {
      widget.refreshParentAndChildContentsCallback!();
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onPulledTORefresh != null) {
          widget.onPulledTORefresh!();
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.contentBlocksList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          TrackDTOModel model = widget.contentBlocksList[index];

          return getContentBlockWidget(trackBlockModel: model);
        },
      ),
    );
  }

  Widget getContentBlockWidget({required TrackDTOModel trackBlockModel}) {
    if (trackBlockModel.blockID.isNotEmpty) {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            trackBlockModel.blockname,
            style: themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          children: getContentsListWidget(contents: trackBlockModel.TrackList).toList(),
        ),
      );
    } else {
      return Column(
        children: getContentsListWidget(contents: trackBlockModel.TrackList).toList(),
      );
    }
  }

  Iterable<Widget> getContentsListWidget({required List<TrackCourseDTOModel> contents}) sync* {
    AppProvider appProvider = context.read<AppProvider>();
    ProfileProvider profileProvider = context.read<ProfileProvider>();

    LocalStr localStr = appProvider.localStr;

    for (TrackCourseDTOModel model in contents) {
      EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
        appProvider: appProvider,
        myLearningProvider: MyLearningProvider(),
        profileProvider: profileProvider,
      );

      List<InstancyUIActionModel> options = uiActionsController
          .getTrackContentsPrimaryActions(
            contentModel: model,
            myLearningUIActionCallbackModel: getUIActionCallbackModel(
              model: model,
              isSecondaryAction: false,
              primaryAction: null,
            ),
            localStr: localStr,
          )
          .toList();

      InstancyUIActionModel? primaryAction = options.firstElement;
      InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

      yield TrackContentCard(
        eventTrackContentModel: model,
        primaryAction: primaryAction,
        onMoreButtonTap: () {
          showMoreAction(model: model);
        },
        onPrimaryActionTap: () {
          MyPrint.printOnConsole("primaryActionsEnum:$primaryActionEnum");

          if (primaryAction?.onTap != null) primaryAction!.onTap!();
        },
      );
    }
  }
}
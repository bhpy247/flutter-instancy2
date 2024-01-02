import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_track/event_track_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:provider/provider.dart';

import '../../../backend/profile/profile_provider.dart';
import '../../../backend/ui_actions/event_track/event_track_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../utils/my_print.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'event_related_content_card.dart';

class EventRelatedContentTabWidget extends StatefulWidget {
  final List<RelatedTrackDataDTOModel> relatedContentsList;
  final PaginationModel paginationModel;
  final int contentsLength;
  final String eventId;
  final int userId;
  final int componentId;
  final int componentInsId;
  final void Function()? onPulledTORefresh;
  final void Function()? onPagination;
  final void Function()? refreshParentAndChildContentsCallback;
  final void Function({required RelatedTrackDataDTOModel model})? onContentViewTap;
  final void Function({required RelatedTrackDataDTOModel model})? onSetCompleteTap;

  const EventRelatedContentTabWidget({
    super.key,
    required this.relatedContentsList,
    required this.paginationModel,
    required this.contentsLength,
    required this.eventId,
    required this.userId,
    required this.componentId,
    required this.componentInsId,
    this.onPulledTORefresh,
    this.onPagination,
    this.refreshParentAndChildContentsCallback,
    this.onContentViewTap,
    this.onSetCompleteTap,
  });

  @override
  State<EventRelatedContentTabWidget> createState() => _EventRelatedContentTabWidgetState();
}

class _EventRelatedContentTabWidgetState extends State<EventRelatedContentTabWidget> {
  late AppProvider appProvider;

  EventTrackUIActionCallbackModel getUIActionCallbackModel({
    required RelatedTrackDataDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    MyPrint.printOnConsole("In the content tab widget");
    return EventTrackUIActionCallbackModel(
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
    );
  }

  Future<void> showMoreAction({required RelatedTrackDataDTOModel model}) async {
    MyPrint.printOnConsole("showMoreAction called for EventTrackContent:${model.ContentID}");

    LocalStr localStr = appProvider.localStr;

    ProfileProvider profileProvider = context.read<ProfileProvider>();

    EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
      appProvider: appProvider,
      myLearningProvider: MyLearningProvider(),
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = uiActionsController
        .getEventRelatedContentsSecondaryActions(
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

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!widget.paginationModel.isLoading && widget.contentsLength == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          widget.onPulledTORefresh?.call();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: AppConfigurations.commonNoDataView(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onPulledTORefresh != null) {
          widget.onPulledTORefresh!();
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.relatedContentsList.length + 1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && widget.relatedContentsList.isEmpty) || index == widget.relatedContentsList.length) {
            if (widget.paginationModel.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CommonLoader(
                    size: 70,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (widget.contentsLength - widget.paginationModel.refreshLimit) && widget.paginationModel.hasMore && !widget.paginationModel.isLoading) {
            if (widget.onPagination != null) widget.onPagination!();
          }

          RelatedTrackDataDTOModel model = widget.relatedContentsList[index];

          return getContentsCard(model: model);
        },
      ),
    );
  }

  Widget getContentsCard({required RelatedTrackDataDTOModel model}) {
    AppProvider appProvider = context.read<AppProvider>();
    ProfileProvider profileProvider = context.read<ProfileProvider>();

    LocalStr localStr = appProvider.localStr;

    EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
      appProvider: appProvider,
      myLearningProvider: MyLearningProvider(),
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = uiActionsController
        .getEventRelatedContentsPrimaryActions(
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

    return EventRelatedContentCard(
      contentModel: model,
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

import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_reference_item_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';

import '../../models/event_track/data_model/event_track_header_dto_model.dart';
import '../../models/event_track/data_model/event_track_tab_dto_model.dart';
import '../common/common_provider.dart';

class EventTrackProvider extends CommonProvider {
  EventTrackProvider() {
    isHeaderDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    eventTrackHeaderData = CommonProviderPrimitiveParameter<EventTrackHeaderDTOModel>(
      value: EventTrackHeaderDTOModel(),
      notify: notify,
    );

    isTabListLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    eventTrackTabList = CommonProviderListParameter<EventTrackTabDTOModel>(
      list: [],
      notify: notify,
    );

    isOverviewDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    overviewData = CommonProviderPrimitiveParameter<EventTrackDTOModel?>(
      value: null,
      notify: notify,
    );

    isGlossaryDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    glossaryData = CommonProviderListParameter<GlossaryModel>(
      list: <GlossaryModel>[],
      notify: notify,
    );

    isResourcesDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    resourcesData = CommonProviderListParameter<EventTrackReferenceItemModel>(
      list: <EventTrackReferenceItemModel>[],
      notify: notify,
    );

    isTrackContentsDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    trackContentsData = CommonProviderListParameter<TrackDTOModel>(
      list: <TrackDTOModel>[],
      notify: notify,
    );

    isTrackAssignmentsDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    trackAssignmentsData = CommonProviderListParameter<TrackDTOModel>(
      list: <TrackDTOModel>[],
      notify: notify,
    );

    eventRelatedContentsData = CommonProviderListParameter<RelatedTrackDataDTOModel>(
      list: <RelatedTrackDataDTOModel>[],
      notify: notify,
    );
    eventRelatedContentsDataPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );

    eventRelatedAssignmentsData = CommonProviderListParameter<RelatedTrackDataDTOModel>(
      list: <RelatedTrackDataDTOModel>[],
      notify: notify,
    );
    eventRelatedAssignmentsDataPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isHeaderDataLoading;
  late CommonProviderPrimitiveParameter<EventTrackHeaderDTOModel?> eventTrackHeaderData;

  late CommonProviderPrimitiveParameter<bool> isTabListLoading;
  late final CommonProviderListParameter<EventTrackTabDTOModel> eventTrackTabList;

  int get eventTrackTabListLength => eventTrackTabList.getList(isNewInstance: false).length;

  late CommonProviderPrimitiveParameter<bool> isOverviewDataLoading;
  late final CommonProviderPrimitiveParameter<EventTrackDTOModel?> overviewData;

  late CommonProviderPrimitiveParameter<bool> isGlossaryDataLoading;
  late final CommonProviderListParameter<GlossaryModel> glossaryData;

  late CommonProviderPrimitiveParameter<bool> isResourcesDataLoading;
  late final CommonProviderListParameter<EventTrackReferenceItemModel> resourcesData;

  late CommonProviderPrimitiveParameter<bool> isTrackContentsDataLoading;
  late final CommonProviderListParameter<TrackDTOModel> trackContentsData;

  late CommonProviderPrimitiveParameter<bool> isTrackAssignmentsDataLoading;
  late final CommonProviderListParameter<TrackDTOModel> trackAssignmentsData;

  late final CommonProviderListParameter<RelatedTrackDataDTOModel> eventRelatedContentsData;
  late CommonProviderPrimitiveParameter<PaginationModel> eventRelatedContentsDataPaginationModel;

  late final CommonProviderListParameter<RelatedTrackDataDTOModel> eventRelatedAssignmentsData;
  late CommonProviderPrimitiveParameter<PaginationModel> eventRelatedAssignmentsDataPaginationModel;
}

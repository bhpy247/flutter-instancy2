import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_reference_item_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_block_model.dart';

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

    isContentsDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    contentsData = CommonProviderListParameter<TrackBlockModel>(
      list: <TrackBlockModel>[],
      notify: notify,
    );
    assignmentsData = CommonProviderListParameter<TrackBlockModel>(
      list: <TrackBlockModel>[],
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

  late CommonProviderPrimitiveParameter<bool> isContentsDataLoading;
  late final CommonProviderListParameter<TrackBlockModel> contentsData;
  late final CommonProviderListParameter<TrackBlockModel> assignmentsData;
}

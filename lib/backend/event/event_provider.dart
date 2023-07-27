import 'package:flutter_instancy_2/backend/common/common_provider.dart';

import '../../models/event/data_model/event_session_course_dto_model.dart';

class EventProvider extends CommonProvider {
  EventProvider() {
    eventSessionData = CommonProviderListParameter<EventSessionCourseDTOModel>(
      list: <EventSessionCourseDTOModel>[],
      notify: notify,
    );
    isLoadingEventSessionData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late final CommonProviderListParameter<EventSessionCourseDTOModel> eventSessionData;
  int get eventSessionDataLength => eventSessionData.getList(isNewInstance: false).length;
  late final CommonProviderPrimitiveParameter<bool> isLoadingEventSessionData;

  void resetData() {
    eventSessionData.setList(list: [], isClear: true, isNotify: false);
    isLoadingEventSessionData.set(value: false, isNotify: true);
  }
}

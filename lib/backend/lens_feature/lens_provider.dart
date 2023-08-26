import 'package:flutter_instancy_2/backend/common/common_provider.dart';

import '../../models/event/data_model/event_session_course_dto_model.dart';

class LensProvider extends CommonProvider {
  LensProvider() {
    coursesList = CommonProviderListParameter<EventSessionCourseDTOModel>(
      list: <EventSessionCourseDTOModel>[],
      notify: notify,
    );
    isLoadingContents = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late final CommonProviderListParameter<EventSessionCourseDTOModel> coursesList;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContents;

  void resetData() {
    coursesList.setList(list: [], isClear: true, isNotify: false);
    isLoadingContents.set(value: false, isNotify: true);
  }
}

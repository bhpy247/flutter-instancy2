import 'package:flutter_instancy_2/backend/common/common_provider.dart';

import '../../models/course/data_model/CourseDTOModel.dart';

class CourseDetailsProvider extends CommonProvider {
  CourseDetailsProvider() {
    contentDetailsDTOModel = CommonProviderPrimitiveParameter<CourseDTOModel?>(
      value: null,
      notify: notify,
    );
    isLoadingCourseDTOModel = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    scheduleData = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );
    isLoadingContentDetailsScheduleData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late final CommonProviderPrimitiveParameter<CourseDTOModel?> contentDetailsDTOModel;
  late final CommonProviderPrimitiveParameter<bool> isLoadingCourseDTOModel;

  late final CommonProviderListParameter<CourseDTOModel> scheduleData;

  int get scheduleDataLength => scheduleData.getList(isNewInstance: false).length;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContentDetailsScheduleData;
}
import 'package:flutter_instancy_2/backend/common/common_provider.dart';

import '../../models/catalog/data_model/catalog_course_dto_model.dart';
import '../../models/content_details/data_model/content_details_dto_model.dart';

class CourseDetailsProvider extends CommonProvider {
  CourseDetailsProvider() {
    contentDetailsDTOModel = CommonProviderPrimitiveParameter<ContentDetailsDTOModel?>(
      value: null,
      notify: notify,
    );
    isLoadingContentDetailsDTOModel = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    scheduleData = CommonProviderListParameter<CatalogCourseDTOModel>(
      list: <CatalogCourseDTOModel>[],
      notify: notify,
    );
    isLoadingContentDetailsScheduleData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late final CommonProviderPrimitiveParameter<ContentDetailsDTOModel?> contentDetailsDTOModel;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContentDetailsDTOModel;

  late final CommonProviderListParameter<CatalogCourseDTOModel> scheduleData;
  int get scheduleDataLength => scheduleData.getList(isNewInstance: false).length;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContentDetailsScheduleData;
}
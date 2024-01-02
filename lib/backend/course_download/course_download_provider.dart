import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';

class CourseDownloadProvider extends CommonProvider {
  CourseDownloadProvider() {
    isLoadingCourseDownloadsData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    courseDownloadList = CommonProviderListParameter<String>(
      list: <String>[],
      notify: notify,
    );
    courseDownloadMap = CommonProviderMapParameter<String, CourseDownloadDataModel>(
      map: <String, CourseDownloadDataModel>{},
      notify: notify,
      newInstancialization: (MapEntry<String, CourseDownloadDataModel> entry) {
        return MapEntry(entry.key, CourseDownloadDataModel.fromMap(entry.value.toMap()));
      },
    );
  }

  late CommonProviderPrimitiveParameter<bool> isLoadingCourseDownloadsData;
  late CommonProviderListParameter<String> courseDownloadList;
  late CommonProviderMapParameter<String, CourseDownloadDataModel> courseDownloadMap;

  CourseDownloadDataModel? getCourseDownloadDataModelFromId({required courseDownloadId, bool isNewInstance = true}) {
    return courseDownloadMap.getMap(isNewInstance: isNewInstance)[courseDownloadId];
  }
}

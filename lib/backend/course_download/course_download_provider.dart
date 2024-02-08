import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';

class CourseDownloadProvider extends CommonProvider {
  static final CourseDownloadProvider _instance = CourseDownloadProvider._();

  factory CourseDownloadProvider() => _instance;

  CourseDownloadProvider._() {
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

  void resetData({bool isNotify = false}) {
    isLoadingCourseDownloadsData.set(value: false, isNotify: false);
    courseDownloadList.setList(list: <String>[], isNotify: false);
    courseDownloadMap.setMap(map: <String, CourseDownloadDataModel>{}, isNotify: false);

    notify(isNotify: isNotify);
  }
}

import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/common/main_hive_controller.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:hive/hive.dart';

class CourseDownloadRepository {
  final ApiController apiController;

  const CourseDownloadRepository({required this.apiController});

  // region Box Initialization
  Future<Box<dynamic>?> getMyCourseDownloadModelsBox() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().getMyCourseDownloadModelsBox() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await MainHiveController().initializeMyCourseDownloadModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    MyPrint.printOnConsole("Final MyCourseDownloadModelsBox:$box", tag: tag);

    return box;
  }

  Future<Box<dynamic>?> getMyCourseDownloadIdsBox() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().getMyCourseDownloadIdsBox() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await MainHiveController().initializeMyCourseDownloadIdsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    MyPrint.printOnConsole("Final MyCourseDownloadIdsBox:$box", tag: tag);

    return box;
  }

  // endregion

  // region Model Box Operations
  Future<bool> setCourseDownloadDataModelInHive({required String downloadId, required CourseDownloadDataModel? model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().setCourseDownloadDataModelInHive() called with downloadId:'$downloadId', model is null:${model == null}", tag: tag);

    bool isSuccess = false;

    Box<dynamic>? box = await getMyCourseDownloadModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().setCourseDownloadDataModelInHive() because box is null", tag: tag);
      return false;
    }

    try {
      if (model != null) {
        await box.put(downloadId, model.toMap());
      } else {
        await box.delete(downloadId);
      }
      MyPrint.printOnConsole("Value Setted Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().setCourseDownloadDataModelInHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<CourseDownloadDataModel?> getCourseDownloadDataModelByIdFromHive({required String downloadId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().getCourseDownloadDataModelByIdFromHive() called with downloadId:'$downloadId'", tag: tag);

    Box<dynamic>? box = await getMyCourseDownloadModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().getCourseDownloadDataModelByIdFromHive() because box is null", tag: tag);
      return null;
    }

    try {
      CourseDownloadDataModel? model;

      Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(downloadId));
      if (map.isNotEmpty) {
        model = CourseDownloadDataModel.fromMap(map);
      }
      MyPrint.printOnConsole("Final Model Not Null:${model != null}", tag: tag);
      return model;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().getCourseDownloadDataModelByIdFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  Future<Map<String, CourseDownloadDataModel>> getAllCourseDownloadModelsFromHive({List<String>? downloadIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().getAllCourseDownloadModelsFromHive() called with downloadIds:'$downloadIds'", tag: tag);

    Box<dynamic>? box = await getMyCourseDownloadModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().getAllCourseDownloadModelsFromHive() because box is null", tag: tag);
      return <String, CourseDownloadDataModel>{};
    }

    try {
      Map<String, CourseDownloadDataModel> map = <String, CourseDownloadDataModel>{};

      Map<String, Map<String, dynamic>> mapsList = <String, Map<String, dynamic>>{};
      if (downloadIds != null) {
        downloadIds.removeWhere((element) => element.isEmpty);
        for (String downloadId in downloadIds) {
          Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(downloadId));
          if (map.isNotEmpty) mapsList[downloadId] = map;
        }
      } else {
        List<String> downloadIdsList = ParsingHelper.parseListMethod<dynamic, String>(box.keys.toList());
        mapsList = Map<String, Map<String, dynamic>>.fromEntries(downloadIdsList.map((String downloadId) {
          Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(downloadId));

          return MapEntry<String, Map<String, dynamic>>(downloadId, map);
        }));
        mapsList.removeWhere((key, value) => value.isEmpty);
      }
      MyPrint.printOnConsole("mapsList length:${mapsList.length}", tag: tag);

      map.addAll(mapsList.map((String downloadId, Map<String, dynamic> downloadMap) => MapEntry(downloadId, CourseDownloadDataModel.fromMap(downloadMap))));

      MyPrint.printOnConsole("Final list length:${map.length}", tag: tag);
      return map;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().getAllCourseDownloadModelsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return <String, CourseDownloadDataModel>{};
    }
  }

  Future<bool> removeCourseDownloadDataModelsFromHive({required List<String> downloadIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().removeCourseDownloadDataModelsFromHive() called with downloadIds:'$downloadIds'", tag: tag);

    bool isSuccess = false;

    if (downloadIds.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().removeCourseDownloadDataModelsFromHive() because downloadIds is empty", tag: tag);
      return false;
    }

    Box<dynamic>? box = await getMyCourseDownloadModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().removeCourseDownloadDataIdsFromHive() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(downloadIds);
      MyPrint.printOnConsole("Items Removed Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().removeCourseDownloadDataModelsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  // endregion

  // region Ids Box Operations
  Future<List<String>> getAllCourseDownloadIdsFromHive() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().getAllCourseDownloadIdsFromHive() called", tag: tag);

    Box<dynamic>? box = await getMyCourseDownloadIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().getAllCourseDownloadIdsFromHive() because box is null", tag: tag);
      return <String>[];
    }

    try {
      MyPrint.printOnConsole("Values length in hive:${box.values.length}", tag: tag);

      List<String> list = ParsingHelper.parseListMethod<dynamic, String>(box.values.toList());

      MyPrint.printOnConsole("Final list length:${list.length}", tag: tag);
      return list;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().getAllCourseDownloadIdsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return <String>[];
    }
  }

  Future<bool> addCourseDownloadIdsInHive({required List<String> downloadIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().addCourseDownloadIdsInHive() called with downloadIds:'$downloadIds'", tag: tag);

    bool isSuccess = false;

    Box<dynamic>? box = await getMyCourseDownloadIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().addCourseDownloadIdsInHive() because box is null", tag: tag);
      return false;
    }

    try {
      await box.addAll(downloadIds);
      MyPrint.printOnConsole("Values Setted Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().addCourseDownloadIdsInHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> removeCourseDownloadIdsFromHive({required List<String> downloadIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadRepository().removeCourseDownloadIdsFromHive() called with downloadIds:'$downloadIds'", tag: tag);

    bool isSuccess = false;

    if (downloadIds.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().removeCourseDownloadIdsFromHive() because downloadIds is empty", tag: tag);
      return false;
    }

    Box<dynamic>? box = await getMyCourseDownloadIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadRepository().removeCourseDownloadDataIdsFromHive() because box is null", tag: tag);
      return false;
    }

    try {
      Map<int, String> map = ParsingHelper.parseMapMethod<dynamic, dynamic, int, String>(box.toMap());

      List<int> keys = <int>[];
      map.forEach((key, value) {
        if (downloadIds.contains(value)) {
          keys.add(key);
        }
      });

      MyPrint.printOnConsole("downloadId keys to be deleted:$keys");

      await box.deleteAll(keys);
      MyPrint.printOnConsole("Items Removed Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadRepository().removeCourseDownloadIdsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }
// endregion
}

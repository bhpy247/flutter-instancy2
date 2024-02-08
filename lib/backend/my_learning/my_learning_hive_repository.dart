import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/common/main_hive_controller.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:hive/hive.dart';

class MyLearningHiveRepository {
  final ApiController apiController;

  const MyLearningHiveRepository({required this.apiController});

  // region Box Initialization
  Future<Box<String>?> getMyLearningIdsBox() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getMyLearningIdsBox() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<String>? box = await MainHiveController().initializeMyLearningIdsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    MyPrint.printOnConsole("Final MyLearningIdsBox:$box", tag: tag);

    return box;
  }

  Future<Box<dynamic>?> getMyLearningModelsBox() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getMyLearningModelsBox() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await MainHiveController().initializeMyLearningModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    MyPrint.printOnConsole("Final MyLearningModelsBox:$box", tag: tag);

    return box;
  }

  // endregion

  // region Ids Box Operations
  Future<List<String>> getAllMyLearningIdsFromHive() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getAllMyLearningIdsFromHive() called", tag: tag);

    Box<String>? box = await getMyLearningIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().getAllMyLearningIdsFromHive() because box is null", tag: tag);
      return <String>[];
    }

    try {
      MyPrint.printOnConsole("Values length in hive:${box.values.length}", tag: tag);

      List<String> list = box.values.toList();

      MyPrint.printOnConsole("Final list length:${list.length}", tag: tag);
      return list;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().getAllMyLearningIdsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return <String>[];
    }
  }

  Future<bool> addMyLearningCourseIdInHive({required List<String> myLearningCourseIds, bool isClear = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().addMyLearningCourseIdInHive() called with myLearningCourseIds:'$myLearningCourseIds', isClear:$isClear", tag: tag);

    bool isSuccess = false;

    Box<String>? box = await getMyLearningIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().addMyLearningCourseIdInHive() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) await MainHiveController().clearMyLearningIdsBox();

      await box.addAll(myLearningCourseIds);
      MyPrint.printOnConsole("Values Setted Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().addMyLearningCourseIdInHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> removeMyLearningCourseIdsFromHive({required List<String> myLearningCourseIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().removeMyLearningCourseIdsFromHive() called with myLearningCourseIds:'$myLearningCourseIds'", tag: tag);

    bool isSuccess = false;

    if (myLearningCourseIds.isEmpty) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().removeMyLearningCourseIdsFromHive() because downloadIds is empty", tag: tag);
      return false;
    }

    Box<String>? box = await getMyLearningIdsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().removeCourseDownloadDataIdsFromHive() because box is null", tag: tag);
      return false;
    }

    try {
      Map<int, String> map = ParsingHelper.parseMapMethod<dynamic, dynamic, int, String>(box.toMap());

      List<int> keys = <int>[];
      map.forEach((key, value) {
        if (myLearningCourseIds.contains(value)) {
          keys.add(key);
        }
      });

      MyPrint.printOnConsole("myLearningCourseId keys to be deleted:$keys");

      await box.deleteAll(keys);
      MyPrint.printOnConsole("Items Removed Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().removeMyLearningCourseIdsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

// endregion

  // region Model Box Operations
  Future<bool> setMyLearningCourseModelInHive({required Map<String, CourseDTOModel?> courseModelsMap, bool isClear = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().setMyLearningCourseModelInHive() called with courseModelsMap length:'${courseModelsMap.length}', isClear:$isClear", tag: tag);

    bool isSuccess = false;

    Box<dynamic>? box = await getMyLearningModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().setMyLearningCourseModelInHive() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) await MainHiveController().clearMyLearningModelsBox();

      List<Future> futures = [];

      courseModelsMap.forEach((String courseId, CourseDTOModel? courseDTOModel) {
        if (courseDTOModel != null) {
          futures.add(box.put(courseId, courseDTOModel.toMap()));
        } else {
          futures.add(box.delete(courseId));
        }
      });

      if (futures.isNotEmpty) await Future.wait(futures);

      MyPrint.printOnConsole("Value Setted Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().setMyLearningCourseModelInHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<CourseDTOModel?> getMyLearningCourseModelByIdFromHive({required String courseId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getMyLearningCourseModelByIdFromHive() called with courseId:'$courseId'", tag: tag);

    Box<dynamic>? box = await getMyLearningModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().getMyLearningCourseModelByIdFromHive() because box is null", tag: tag);
      return null;
    }

    try {
      CourseDTOModel? model;

      Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(courseId));
      if (map.isNotEmpty) {
        model = CourseDTOModel.fromMap(map);
      }
      MyPrint.printOnConsole("Final Model Not Null:${model != null}", tag: tag);
      return model;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().getMyLearningCourseModelByIdFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  Future<Map<String, CourseDTOModel>> getAllMyLearningCourseModelsFromHive({List<String>? courseIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getAllMyLearningCourseModelsFromHive() called with courseIds:'$courseIds'", tag: tag);

    Box<dynamic>? box = await getMyLearningModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().getAllMyLearningCourseModelsFromHive() because box is null", tag: tag);
      return <String, CourseDTOModel>{};
    }

    try {
      Map<String, CourseDTOModel> coursesMap = <String, CourseDTOModel>{};

      if (courseIds != null) {
        courseIds.removeWhere((element) => element.isEmpty);
        for (String courseId in courseIds) {
          Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(courseId));
          if (map.isNotEmpty) coursesMap[courseId] = CourseDTOModel.fromMap(map);
        }
      } else {
        List<String> courseIdsList = ParsingHelper.parseListMethod<dynamic, String>(box.keys.toList());
        for (String courseId in courseIdsList) {
          Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(courseId));
          if (map.isNotEmpty) coursesMap[courseId] = CourseDTOModel.fromMap(map);
        }
      }

      MyPrint.printOnConsole("Final list length:${coursesMap.length}", tag: tag);
      return coursesMap;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().getAllMyLearningCourseModelsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return <String, CourseDTOModel>{};
    }
  }

  Future<bool> removeCourseDownloadDataModelsFromHive({required List<String> downloadIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().removeCourseDownloadDataModelsFromHive() called with downloadIds:'$downloadIds'", tag: tag);

    bool isSuccess = false;

    if (downloadIds.isEmpty) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().removeCourseDownloadDataModelsFromHive() because downloadIds is empty", tag: tag);
      return false;
    }

    Box<dynamic>? box = await getMyLearningModelsBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from MyLearningHiveRepository().removeCourseDownloadDataIdsFromHive() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(downloadIds);
      MyPrint.printOnConsole("Items Removed Successfully", tag: tag);
      isSuccess = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyLearningHiveRepository().removeCourseDownloadDataModelsFromHive():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

// endregion

  // region Composite Operations
  Future<List<CourseDTOModel>> getAllMyLearningCourseModelsListFromHive() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningHiveRepository().getAllMyLearningCourseModelsListFromHive() called", tag: tag);

    List<CourseDTOModel> finalCourseModelsList = <CourseDTOModel>[];

    List<String> courseIdsList = [];
    Map<String, CourseDTOModel> courseModelsMap = <String, CourseDTOModel>{};

    await Future.wait([
      getAllMyLearningIdsFromHive().then((List<String> courseIds) {
        courseIdsList = courseIds;
      }),
      getAllMyLearningCourseModelsFromHive().then((Map<String, CourseDTOModel> courseModels) {
        courseModelsMap = courseModels;
      }),
    ]);

    MyPrint.printOnConsole("courseIdsList length:${courseIdsList.length}", tag: tag);
    MyPrint.printOnConsole("courseModelsMap length:${courseModelsMap.length}", tag: tag);

    for (String courseId in courseIdsList) {
      CourseDTOModel? courseDTOModel = courseModelsMap[courseId];

      if (courseDTOModel != null) {
        finalCourseModelsList.add(courseDTOModel);
      }
    }

    MyPrint.printOnConsole("finalCourseModelsList length:${finalCourseModelsList.length}", tag: tag);

    return finalCourseModelsList;
  }
// endregion
}

import '../../api/api_controller.dart';
import '../../models/catalog/data_model/catalog_course_dto_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/content_details/data_model/content_details_dto_model.dart';
import '../../models/content_details/request_model/course_details_request_model.dart';
import '../../models/content_details/request_model/course_details_schedule_data_request_model.dart';
import '../../models/content_details/response_model/course_details_schedule_data_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'course_details_provider.dart';
import 'course_details_repository.dart';

class CourseDetailsController {
  late CourseDetailsProvider _courseDetailsProvider;
  late CourseDetailsRepository _courseDetailsRepository;

  CourseDetailsController({required CourseDetailsProvider? courseDetailsProvider, CourseDetailsRepository? repository, ApiController? apiController}) {
    _courseDetailsProvider = courseDetailsProvider ?? CourseDetailsProvider();
    _courseDetailsRepository = repository ?? CourseDetailsRepository(apiController: apiController ?? ApiController());
  }
  
  CourseDetailsProvider get courseDetailsProvider => _courseDetailsProvider;
  CourseDetailsRepository get courseDetailsRepository => _courseDetailsRepository;

  Future<ContentDetailsDTOModel?> getCourseDetailsData({
    required CourseDetailsRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDetailsController().getCourseDetailsData() called with requestModel:'$requestModel'", tag: tag);

    CourseDetailsProvider provider = courseDetailsProvider;

    ContentDetailsDTOModel? courseDetailsModel;

    provider.isLoadingContentDetailsDTOModel.set(value: true, isNotify: isNotify);

    DataResponseModel<ContentDetailsDTOModel> response = await courseDetailsRepository.getCourseDetailsData(requestModel: requestModel);
    MyPrint.logOnConsole("getContentDetailsData response:$response", tag: tag);

    provider.isLoadingContentDetailsDTOModel.set(value: false, isNotify: isNotify);

    if(response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CourseDetailsController().getCourseDetailsData() because getContentDetailsData had some error", tag: tag);
      return courseDetailsModel;
    }

    if(response.data != null) {
      courseDetailsModel = response.data!;
    }
    MyPrint.logOnConsole("final courseDetailsModel:$courseDetailsModel", tag: tag);

    provider.contentDetailsDTOModel.set(value: courseDetailsModel);

    return courseDetailsModel;
  }

  Future<List<CatalogCourseDTOModel>> getCourseDetailsScheduleData({
    required CourseDetailsScheduleDataRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDetailsController().getCourseDetailsScheduleData() called with requestModel:'$requestModel'", tag: tag);

    CourseDetailsProvider provider = courseDetailsProvider;

    List<CatalogCourseDTOModel> courseList = <CatalogCourseDTOModel>[];

    provider.isLoadingContentDetailsScheduleData.set(value: true, isNotify: isNotify);

    DataResponseModel<CourseDetailsScheduleDataResponseModel> response = await courseDetailsRepository.getScheduleData(requestModel: requestModel);
    MyPrint.logOnConsole("getScheduleData response:$response", tag: tag);

    provider.isLoadingContentDetailsScheduleData.set(value: false, isNotify: false);

    if(response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CourseDetailsController().getCourseDetailsScheduleData() because getScheduleData had some error", tag: tag);
      return courseList;
    }

    if(response.data != null) {
      courseList = response.data!.courseList;
    }
    MyPrint.logOnConsole("final ScheduleData courseList:$courseList", tag: tag);

    provider.scheduleData.setList(list: courseList, isNotify: true);

    return courseList;
  }
}
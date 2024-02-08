import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';

class CourseOfflineProvider extends CommonProvider {
  CourseOfflineProvider() {
    cmiData = CommonProviderMapParameter<String, CMIModel>(
      map: <String, CMIModel>{},
      notify: notify,
      newInstancialization: (MapEntry<String, CMIModel> mapEntry) {
        return MapEntry(mapEntry.key, CMIModel.fromMap(mapEntry.value.toMap()));
      },
    );
    learnerSessionData = CommonProviderMapParameter<String, LearnerSessionModel>(
      map: <String, LearnerSessionModel>{},
      notify: notify,
      newInstancialization: (MapEntry<String, LearnerSessionModel> mapEntry) {
        return MapEntry(mapEntry.key, LearnerSessionModel.fromMap(mapEntry.value.toMap()));
      },
    );
    studentResponseData = CommonProviderMapParameter<String, StudentCourseResponseModel>(
      map: <String, StudentCourseResponseModel>{},
      notify: notify,
      newInstancialization: (MapEntry<String, StudentCourseResponseModel> mapEntry) {
        return MapEntry(mapEntry.key, StudentCourseResponseModel.fromMap(mapEntry.value.toMap()));
      },
    );
  }

  late CommonProviderMapParameter<String, CMIModel> cmiData;
  late CommonProviderMapParameter<String, LearnerSessionModel> learnerSessionData;
  late CommonProviderMapParameter<String, StudentCourseResponseModel> studentResponseData;
}

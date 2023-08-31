import '../../models/course/data_model/mobile_lms_course_model.dart';

class NavigationResponse {
  const NavigationResponse();
}

class SurfaceTrackingKeywordSearchScreenNavigationResponse extends NavigationResponse {
  final MobileLmsCourseModel courseModel;
  final String arVrContentLaunchTypes;

  const SurfaceTrackingKeywordSearchScreenNavigationResponse({
    required this.courseModel,
    required this.arVrContentLaunchTypes,
  });
}

import '../../models/course/data_model/CourseDTOModel.dart';

class NavigationResponse {
  const NavigationResponse();
}

class SurfaceTrackingKeywordSearchScreenNavigationResponse extends NavigationResponse {
  final CourseDTOModel courseModel;
  final String arVrContentLaunchTypes;

  const SurfaceTrackingKeywordSearchScreenNavigationResponse({
    required this.courseModel,
    required this.arVrContentLaunchTypes,
  });
}

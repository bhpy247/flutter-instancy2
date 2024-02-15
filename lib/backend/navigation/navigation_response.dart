import 'package:flutter_instancy_2/utils/my_utils.dart';

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

class ConnectionProfileScreenNavigationResponse extends NavigationResponse {
  final bool isPeopleListingActionPerformed;

  const ConnectionProfileScreenNavigationResponse({
    this.isPeopleListingActionPerformed = false,
  });

  @override
  String toString() {
    return MyUtils.encodeJson(<String, dynamic>{
      "isPeopleListingActionPerformed": isPeopleListingActionPerformed,
    });
  }
}

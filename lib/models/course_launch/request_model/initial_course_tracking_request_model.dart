import '../../../utils/my_utils.dart';

class InitialCourseTrackingRequestModel {
  int UserID;
  int ScoID;

  InitialCourseTrackingRequestModel({
    required this.UserID,
    required this.ScoID,
  });

  Map<String, String> toJson() {
    return {
      "UserID": UserID.toString(),
      "ScoID": ScoID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
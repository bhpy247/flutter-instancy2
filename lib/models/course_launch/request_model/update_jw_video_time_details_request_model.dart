import '../../../utils/my_utils.dart';

class UpdateJWVideoTimeDetailsRequestModel {
  String time = '';
  String videoID = '';
  String parentContentID = '';
  int userID = 0;

  UpdateJWVideoTimeDetailsRequestModel({
    this.time = '',
    this.videoID = '',
    this.parentContentID = '',
    this.userID = 0,
  });

  Map<String, String> toJson() {
    return {
      "time": time,
      "videoID": videoID,
      "parentContentID": parentContentID,
      "userID": userID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

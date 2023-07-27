class CourseDetailsUIActionParameterModel {
  final int objectTypeId;
  final int mediaTypeId;
  final int viewType;
  final int eventScheduleType;
  final bool isContentEnrolled;
  final String eventEndDateTime;

  const CourseDetailsUIActionParameterModel({
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.viewType = 0,
    this.eventScheduleType = 0,
    this.isContentEnrolled = false,
    this.eventEndDateTime = "",
  });
}

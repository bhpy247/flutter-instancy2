class MyCourseDownloadUIActionParameterModel {
  final String CoreLessonStatus;
  final int ContentTypeId;
  final int MediaTypeId;
  final bool isCourseDownloaded;
  final bool isCourseDownloading;
  final bool isFileDownloading;
  final bool isFileDownloadingPaused;
  final bool isFileDownloaded;
  final bool isFileExtracting;
  final bool isFileExtracted;

  const MyCourseDownloadUIActionParameterModel({
    this.CoreLessonStatus = "",
    this.ContentTypeId = -1,
    this.MediaTypeId = -1,
    this.isCourseDownloaded = false,
    this.isCourseDownloading = false,
    this.isFileDownloading = false,
    this.isFileDownloadingPaused = false,
    this.isFileDownloaded = false,
    this.isFileExtracting = false,
    this.isFileExtracted = false,
  });
}

import '../../../configs/app_constants.dart';

class MyLearningUIActionConfigs {
  static const Map<int, List<int>?> downloadableObjects = <int, List<int>?>{
    InstancyObjectTypes.contentObject: [
      InstancyMediaTypes.microLearning,
      InstancyMediaTypes.learningModule,
    ],
    InstancyObjectTypes.assessment: [
      InstancyMediaTypes.test,
      InstancyMediaTypes.survey,
    ],
    InstancyObjectTypes.mediaResource: [
      InstancyMediaTypes.image,
      InstancyMediaTypes.video,
      InstancyMediaTypes.audio,
    ],
    InstancyObjectTypes.document: [
      InstancyMediaTypes.word,
      InstancyMediaTypes.pDF,
      InstancyMediaTypes.excel,
      InstancyMediaTypes.ppt,
      InstancyMediaTypes.mpp,
      InstancyMediaTypes.visioTypes,
    ],
    InstancyObjectTypes.dictionaryGlossary: null,
    InstancyObjectTypes.html: [
      InstancyMediaTypes.htmlZIPFile,
      InstancyMediaTypes.singleHTMLFile,
    ],
    InstancyObjectTypes.webPage: null,
    InstancyObjectTypes.certificate: null,
  };

  static const Map<int, List<int>?> playEnabledObjects = <int, List<int>?>{
    InstancyObjectTypes.mediaResource: [
      InstancyMediaTypes.video,
      InstancyMediaTypes.audio,
    ],
  };

  static bool checkContentTypeConfiguration({
    required int objectTypeId,
    required int mediaTypeId,
    required Map<int, List<int>?> objects,
  }) {
    bool isValid = false;

    bool isTypeMatched = false, isSubtypeMatched = false;

    if (objects.containsKey(objectTypeId)) {
      isTypeMatched = true;

      List<int>? list = objects[objectTypeId];

      isSubtypeMatched = list == null || list.contains(mediaTypeId);
    }

    isValid = isTypeMatched && isSubtypeMatched;

    return isValid;
  }

  static bool isNonTrackableContent({required int objectTypeId, required int mediaTypeId}) {
    bool isEnabled = true;

    if (![
          InstancyObjectTypes.mediaResource,
          InstancyObjectTypes.reference,
          InstancyObjectTypes.document,
        ].contains(objectTypeId) ||
        [
          InstancyMediaTypes.corpAcademy,
          InstancyMediaTypes.psyTechAssessment,
          InstancyMediaTypes.dISCAssessment,
          InstancyMediaTypes.assessment24x7,
          InstancyMediaTypes.embedAudio,
          InstancyMediaTypes.embedVideo,
        ].contains(mediaTypeId)) {
      isEnabled = false;
    }

    return isEnabled;
  }

  static bool isContentDownloadEnabled({required int objectTypeId, required int mediaTypeId}) {
    return checkContentTypeConfiguration(
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      objects: downloadableObjects,
    );
  }

  static bool isPlayEnabled({required int objectTypeId, required int mediaTypeId}) {
    return checkContentTypeConfiguration(
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      objects: playEnabledObjects,
    );
  }
}

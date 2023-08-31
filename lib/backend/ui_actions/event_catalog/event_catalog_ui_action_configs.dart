import '../../../configs/app_constants.dart';

class EventCatalogUiActions {
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

  static const Map<int, List<int>?> setCompleteEnabledObjects = <int, List<int>?>{
    InstancyObjectTypes.mediaResource: null,
    InstancyObjectTypes.document: null,
    InstancyObjectTypes.webPage: null,
    InstancyObjectTypes.reference: [
      InstancyMediaTypes.onlineCourse,
      InstancyMediaTypes.classroomCourse,
      InstancyMediaTypes.virtualClassroom,
      InstancyMediaTypes.url,
      InstancyMediaTypes.liveMeeting,
      InstancyMediaTypes.recording,
      InstancyMediaTypes.book,
      InstancyMediaTypes.document,
      InstancyMediaTypes.conference,
      InstancyMediaTypes.video,
      InstancyMediaTypes.audio,
      InstancyMediaTypes.webLink,
      InstancyMediaTypes.blendedOnlineClassroom,
      InstancyMediaTypes.assessorService,
      InstancyMediaTypes.image,
      InstancyMediaTypes.teachingSlidesReference,
      InstancyMediaTypes.animationReference,
    ],
    InstancyObjectTypes.dictionaryGlossary: null,
    InstancyObjectTypes.html: null,
    InstancyObjectTypes.certificate: null,
  };

  static const Map<int, List<int>?> playEnabledObjects = <int, List<int>?>{
    InstancyObjectTypes.mediaResource: [
      InstancyMediaTypes.video,
      InstancyMediaTypes.audio,
    ],
  };

  static const Map<int, List<int>?> reportEnabledObjects = <int, List<int>?>{
    InstancyObjectTypes.mediaResource: null,
    InstancyObjectTypes.document: null,
    InstancyObjectTypes.dictionaryGlossary: null,
    InstancyObjectTypes.html: null,
    InstancyObjectTypes.aICC: null,
    InstancyObjectTypes.webPage: null,
    InstancyObjectTypes.certificate: null,
    InstancyObjectTypes.events: null,
    InstancyObjectTypes.externalTraining: null,
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

  static bool isSetCompleteEnabled({required int objectTypeId, required int mediaTypeId}) {
    return checkContentTypeConfiguration(
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      objects: setCompleteEnabledObjects,
    );
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

  static bool isReportEnabled({required int objectTypeId, required int mediaTypeId}) {
    return !checkContentTypeConfiguration(
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      objects: reportEnabledObjects,
    );
  }
}

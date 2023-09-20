import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/catalog_dto_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:googleapis/vision/v1.dart' as vision_api;
import 'package:googleapis_auth/auth_io.dart';

import '../../api/api_controller.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../models/catalog/request_model/catalog_request_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';
import '../Catalog/catalog_repository.dart';
import '../configurations/app_configuration_operations.dart';

class LensController {
  late LensProvider _lensProvider;
  late LensRepository _lensRepository;

  LensController({required LensProvider? lensProvider, LensRepository? repository, ApiController? apiController}) {
    _lensProvider = lensProvider ?? LensProvider();
    _lensRepository = repository ?? LensRepository(apiController: apiController ?? ApiController());
  }

  LensProvider get lensProvider => _lensProvider;

  LensRepository get lensRepository => _lensRepository;

  Future<void> performImageSearch({required Uint8List imageBytes, required String path, bool isNotify = true}) async {
    String tag = MyUtils.getNewId(isFromUUuid: true);
    MyPrint.printOnConsole("LensController().performImageSearch() called with imageBytes:${imageBytes.length}, isNotify:$isNotify", tag: tag);

    LensProvider provider = lensProvider;

    provider.isLoadingContents.set(value: true, isNotify: isNotify);

    List<vision_api.EntityAnnotation>? detectionResponse = await detectLabelsFromImageUsingVisionApi(imageBytes);
    List<String> labels = (detectionResponse ?? <vision_api.EntityAnnotation>[]).map((e) => e.description ?? "").toSet().toList()..removeWhere((element) => element.isEmpty);
    MyPrint.printOnConsole("labels:$labels", tag: tag);

    lensProvider.labels.setList(list: labels, isClear: true, isNotify: false);

    if (labels.isEmpty) {
      provider.resetContentsData(isNotify: false);
    } else {
      await getCatalogContentsListFromApi(isRefresh: true, isGetFromCache: false, isNotify: false);
    }

    provider.isLoadingContents.set(value: false, isNotify: true);
  }

  Future<List<vision_api.EntityAnnotation>?> detectLabelsFromImageUsingVisionApi(Uint8List bytes) async {
    String tag = MyUtils.getNewId(isFromUUuid: true);
    MyPrint.printOnConsole("LensController().detectLabelsFromImageUsingVisionApi() called with bytes", tag: tag);

    MyPrint.printOnConsole("bytes length:${bytes.length}", tag: tag);

    try {
      String encodedImage = base64Encode(bytes);

      vision_api.VisionApi visionApi = vision_api.VisionApi(clientViaApiKey(GCPCredentials.apiKey));
      vision_api.BatchAnnotateImagesResponse response = await visionApi.images.annotate(vision_api.BatchAnnotateImagesRequest(
        requests: [
          vision_api.AnnotateImageRequest(
            image: vision_api.Image(content: encodedImage),
            features: [
              vision_api.Feature(
                maxResults: 10,
                // type: "OBJECT_LOCALIZATION",
                type: "LABEL_DETECTION",
              ),
            ],
          ),
        ],
      ));
      MyPrint.logOnConsole("response:${MyUtils.encodeJson(response.toJson())}", tag: tag);

      List<vision_api.EntityAnnotation>? labelAnnotations = response.responses?.firstElement?.labelAnnotations;
      MyPrint.printOnConsole("labelAnnotations:${labelAnnotations?.length}", tag: tag);

      return labelAnnotations;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in DataController.detectLabelsFromImageUsingVisionApi():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  Future<void> performOCRSearch({required String filePath, bool isNotify = true}) async {
    String tag = MyUtils.getNewId(isFromUUuid: true);
    MyPrint.printOnConsole("LensController().performOCRSearch() called with filePath:$filePath, isNotify:$isNotify", tag: tag);

    LensProvider provider = lensProvider;

    if (filePath.isEmpty) {
      MyPrint.printOnConsole("Returning from LensController().performOCRSearch() because filePath is empty", tag: tag);
    }

    provider.isLoadingContents.set(value: true, isNotify: isNotify);

    List<String> recognizedTextList = await getRecognizedText(filePath: filePath);
    MyPrint.printOnConsole("recognizedTextList:$recognizedTextList", tag: tag);

    lensProvider.labels.setList(list: recognizedTextList, isClear: true, isNotify: false);

    if (recognizedTextList.isEmpty) {
      provider.resetContentsData(isNotify: false);
    } else {
      await getCatalogContentsListFromApi(isRefresh: true, isGetFromCache: false, isNotify: false);
    }

    provider.isLoadingContents.set(value: false, isNotify: isNotify);
  }

  Future<List<String>> getRecognizedText({required String filePath}) async {
    String tag = MyUtils.getNewId(isFromUUuid: true);
    MyPrint.printOnConsole("LensController().getRecognizedText() called with filePath:$filePath", tag: tag);

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(filePath));
    MyPrint.printOnConsole("Text: ${recognizedText.text} TextBlock : ${recognizedText.blocks.length} ");

    List<String> labels = <String>[];

    if (recognizedText.blocks.isNotEmpty) {
      labels = recognizedText.blocks.map((e) => e.text).toSet().toList()..removeWhere((element) => element.isEmpty);
    }

    MyPrint.printOnConsole("labels:$labels");
    MyPrint.printOnConsole("labels length:${labels.length}");

    return labels;
  }

  Future<List<CourseDTOModel>> getCatalogContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "LensController().getCatalogContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify",
        tag: tag);

    LensProvider provider = lensProvider;
    PaginationModel paginationModel = provider.contentsPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = lensRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.contentsList.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.contentsList.getList(isNewInstance: true);
    }
    //endregion

    provider.currentSearchId.set(value: tag, isNotify: false);

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: isNotify,
      );
      provider.contentsList.setList(list: <CourseDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Lens Screen Catalog Contents', tag: tag);
      return provider.contentsList.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.contentsList.getList(isNewInstance: true);
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    int componentId = provider.componentId.get();
    int componentInstanceId = provider.componentInstanceId.get();

    CatalogRequestModel catalogRequestModel = getCatalogRequestModelModelFromProviderData(
      provider: provider,
      paginationModel: provider.contentsPaginationModel.get(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<CatalogResponseDTOModel> response = await CatalogRepository(apiController: lensRepository.apiController).getCatalogContentList(
      requestModel: catalogRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: false,
      isFromOffline: false,
    );
    MyPrint.printOnConsole("Lens Screen Catalog Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Lens Screen Catalog Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    if (provider.currentSearchId.get() != tag) {
      MyPrint.printOnConsole('Returning from LensController().getCatalogContentsListFromApi() because it is not response of latest request', tag: tag);
      return provider.contentsList.getList(isNewInstance: true);
    }

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("Lens Screen Catalog Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: contentsList.length == provider.pageSize.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: isNotify,
    );
    provider.contentsList.setList(list: contentsList, isClear: false, isNotify: true);
    //endregion

    return provider.contentsList.getList(isNewInstance: true);
  }

  CatalogRequestModel getCatalogRequestModelModelFromProviderData({
    required LensProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
    required ApiUrlConfigurationProvider apiUrlConfigurationProvider,
  }) {
    int pageIndex = paginationModel.pageIndex;
    int pageSize = provider.pageSize.get();

    String searchText = provider.searchString.get();
    if (searchText.isEmpty) {
      searchText = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: provider.labels.getList(),
        separator: " ",
      );
    }

    return CatalogRequestModel(
      componentID: ParsingHelper.parseStringMethod(componentId),
      componentInsID: ParsingHelper.parseStringMethod(componentInstanceId),
      searchText: searchText,
      userID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentUserId()),
      siteID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      orgUnitID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      locale: apiUrlConfigurationProvider.getLocale().isNotEmpty ? apiUrlConfigurationProvider.getLocale() : "en-us",
      pageIndex: pageIndex,
      pageSize: pageSize,
      objecttypes: AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: provider.selectedContentTypes.getList().map((e) => e).toList(),
      ),
      // certification: "all",
    );
  }
}

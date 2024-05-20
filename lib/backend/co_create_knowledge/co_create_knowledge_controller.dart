import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../api/api_controller.dart';
import 'co_create_knowledge_provider.dart';
import 'co_create_knowledge_repository.dart';

class CoCreateKnowledgeController {
  late CoCreateKnowledgeProvider _coCreateKnowledgeProvider;
  late CoCreateKnowledgeRepository _coCreateKnowledgeRepository;

  CoCreateKnowledgeController({required CoCreateKnowledgeProvider? coCreateKnowledgeProvider, CoCreateKnowledgeRepository? repository, ApiController? apiController}) {
    _coCreateKnowledgeProvider = coCreateKnowledgeProvider ?? CoCreateKnowledgeProvider();
    _coCreateKnowledgeRepository = repository ?? CoCreateKnowledgeRepository(apiController: apiController ?? ApiController());
  }

  CoCreateKnowledgeProvider get coCreateKnowledgeProvider => _coCreateKnowledgeProvider;

  CoCreateKnowledgeRepository get coCreateKnowledgeRepository => _coCreateKnowledgeRepository;

  Future<bool> getMyKnowledgeList() async {
    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

    DataResponseModel<List<CourseDTOModel>> response = await coCreateKnowledgeRepository.getMyKnowledgeList(componentId: 3, componentInstanceId: 3);

    if (response.data?.isEmpty ?? false) return false;
    provider.myKnowledgeList.setList(list: response.data ?? []);
    provider.isLoading.set(value: false, isNotify: false);
    return true;
  }

  Future<bool> getSharedKnowledgeList() async {
    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

    DataResponseModel<List<CourseDTOModel>> response = await coCreateKnowledgeRepository.getMyKnowledgeList(componentId: 3, componentInstanceId: 3);

    if (response.data?.isEmpty ?? false) return false;
    provider.shareKnowledgeList.setList(list: response.data ?? []);
    provider.isLoading.set(value: false, isNotify: false);
    return true;
  }

// Future<List<FileUploadControlsModel>> getFileUploadControlsFromApi({
//   bool isRefresh = true,
//   bool isGetFromCache = false,
//   bool isNotify = true,
//   required int componentId,
//   required int componentInstanceId,
// }) async {
//   List<FileUploadControlsModel> fileUploadControlList = [];
//
//   CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
//
//   DataResponseModel<List<FileUploadControlsModel>> response = await coCreateKnowledgeRepository.getFileUploadControlsModel(
//     componentId: componentId,
//     componentInstanceId: componentInstanceId,
//     isStoreDataInHive: true,
//   );
//
//   List<FileUploadControlsModel> fileUploadControlsModelList = response.data ?? <FileUploadControlsModel>[];
//   MyPrint.printOnConsole("fileUploadControlsModelList Length got in Api:${fileUploadControlsModelList.length}");
//
//   //region Set Provider Data After Getting Data From Api
//   // if (contentsList.length < provider.pageSize) provider.setHasMoreMyLearningData(value: false);
//   // if(contentsList.isNotEmpty) provider.setMyLearningPageIndex(value: provider.myLearningPageIndex + 1);
//   provider.setFileUploadControlsModelList(fileUploadControlsModelList);
//   // provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
//   // provider.setIsMyLearningContentsFirstTimeLoading(false, isNotify: false);
//   // provider.setIsMyLearningContentsLoading(false, isNotify: true);
//   // //endregion
//
//   return fileUploadControlList;
// }
//
// Future<CoCreateKnowledgeCategoriesModel> getCoCreateKnowledgeCategoriesFromApi({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true, required int componentId, required int componentInstanceId}) async {
//   CoCreateKnowledgeCategoriesModel wikiCategoriesModel = CoCreateKnowledgeCategoriesModel();
//   CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
//   DataResponseModel<CoCreateKnowledgeCategoriesModel> response = await coCreateKnowledgeRepository.getCoCreateKnowledgeCategories(
//     componentId: componentId,
//     componentInstanceId: componentInstanceId,
//     isStoreDataInHive: true,
//   );
//   wikiCategoriesModel = response.data ?? CoCreateKnowledgeCategoriesModel();
//   MyPrint.printOnConsole("wikiCategoriesModel length:${wikiCategoriesModel.wikiCategoriesList.length}");
//   if (wikiCategoriesModel.wikiCategoriesList.isNotEmpty) {
//     provider.setCoCreateKnowledgeCategoriesList(wikiCategoriesModel.wikiCategoriesList);
//   }
//   return wikiCategoriesModel;
// }
//
// Future<DataResponseModel<String>> addContent({required CoCreateKnowledgeUploadRequestModel wikiUploadRequestModel}) async {
//   String tag = MyUtils.getNewId();
//   MyPrint.printOnConsole("CoCreateKnowledgeController().addContent() called", tag: tag);
//
//   ApiUrlConfigurationProvider apiUrlConfigurationProvider = coCreateKnowledgeRepository.apiController.apiDataProvider;
//   wikiUploadRequestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
//   wikiUploadRequestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
//   wikiUploadRequestModel.locale = apiUrlConfigurationProvider.getLocale();
//
//   DataResponseModel<String> response = await coCreateKnowledgeRepository.addCatalogContent(wikiUploadRequestModel: wikiUploadRequestModel);
//   MyPrint.printOnConsole("Add Content Response:${response.data}", tag: tag);
//   MyPrint.printOnConsole("Add Content Response Type:${response.data?.runtimeType}", tag: tag);
//
//   DataResponseModel<String> newResponse;
//
//   String data = response.data ?? "";
//   if (data.startsWith("failed") || data.startsWith("A content item already exists with this name.")) {
//     // MyPrint.printOnConsole("")
//     newResponse = DataResponseModel<String>(
//       data: response.data,
//       appErrorModel: AppErrorModel(
//         message: response.data!,
//       ),
//     );
//   } else {
//     newResponse = response;
//
//     BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
//     if (context != null && context.mounted) {
//       GamificationController(provider: context!.read<GamificationProvider>()).UpdateContentGamification(
//         requestModel: UpdateContentGamificationRequestModel(
//           contentId: "",
//           scoId: -1,
//           objecttypeId: -1,
//           GameAction: GamificationActionType.AddedContent,
//         ),
//       );
//     }
//   }
//
//   return newResponse;
// }
}

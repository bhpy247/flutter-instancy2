import 'package:flutter/cupertino.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../models/common/data_response_model.dart';
import '../../models/wiki_component/request_model/wiki_upload_request_model.dart';
import '../../models/wiki_component/response_model/fileUploadControlModel.dart';
import '../../models/wiki_component/response_model/wikiCategoriesModel.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class WikiController {
  late WikiProvider _wikiProvider;
  late WikiRepository _wikiRepository;

  WikiController({required WikiProvider? wikiProvider, WikiRepository? repository, ApiController? apiController}) {
    _wikiProvider = wikiProvider ?? WikiProvider();
    _wikiRepository = repository ?? WikiRepository(apiController: apiController ?? ApiController());
  }

  WikiProvider get wikiProvider => _wikiProvider;

  WikiRepository get wikiRepository => _wikiRepository;

  Future<List<FileUploadControlsModel>> getFileUploadControlsFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    List<FileUploadControlsModel> fileUploadControlList = [];

    WikiProvider provider = wikiProvider;

    DataResponseModel<List<FileUploadControlsModel>> response = await wikiRepository.getFileUploadControlsModel(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
    );

    List<FileUploadControlsModel> fileUploadControlsModelList = response.data ?? <FileUploadControlsModel>[];
    MyPrint.printOnConsole("fileUploadControlsModelList Length got in Api:${fileUploadControlsModelList.length}");

    //region Set Provider Data After Getting Data From Api
    // if (contentsList.length < provider.pageSize) provider.setHasMoreMyLearningData(value: false);
    // if(contentsList.isNotEmpty) provider.setMyLearningPageIndex(value: provider.myLearningPageIndex + 1);
    provider.setFileUploadControlsModelList(fileUploadControlsModelList);
    // provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
    // provider.setIsMyLearningContentsFirstTimeLoading(false, isNotify: false);
    // provider.setIsMyLearningContentsLoading(false, isNotify: true);
    // //endregion

    return fileUploadControlList;
  }

  Future<WikiCategoriesModel> getWikiCategoriesFromApi({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true, required int componentId, required int componentInstanceId}) async {
    WikiCategoriesModel wikiCategoriesModel = WikiCategoriesModel();
    WikiProvider provider = wikiProvider;
    DataResponseModel<WikiCategoriesModel> response = await wikiRepository.getWikiCategories(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
    );
    wikiCategoriesModel = response.data ?? WikiCategoriesModel();
    MyPrint.printOnConsole("wikiCategoriesModel length:${wikiCategoriesModel.wikiCategoriesList.length}");
    if (wikiCategoriesModel.wikiCategoriesList.isNotEmpty) {
      provider.setWikiCategoriesList(wikiCategoriesModel.wikiCategoriesList);
    }
    return wikiCategoriesModel;
  }

  Future<DataResponseModel<String>> addContent({required WikiUploadRequestModel wikiUploadRequestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("WikiController().addContent() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = wikiRepository.apiController.apiDataProvider;
    wikiUploadRequestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    wikiUploadRequestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    wikiUploadRequestModel.locale = apiUrlConfigurationProvider.getLocale();

    DataResponseModel<String> response = await wikiRepository.addCatalogContent(wikiUploadRequestModel: wikiUploadRequestModel);
    MyPrint.printOnConsole("Add Content Response:${response.data}", tag: tag);
    MyPrint.printOnConsole("Add Content Response Type:${response.data?.runtimeType}", tag: tag);

    DataResponseModel<String> newResponse;

    String data = response.data ?? "";
    if (data.startsWith("failed") || data.startsWith("A content item already exists with this name.")) {
      // MyPrint.printOnConsole("")
      newResponse = DataResponseModel<String>(
        data: response.data,
        appErrorModel: AppErrorModel(
          message: response.data!,
        ),
      );
    } else {
      newResponse = response;

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        GamificationController(provider: context!.read<GamificationProvider>()).UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: "",
            scoId: -1,
            objecttypeId: -1,
            GameAction: GamificationActionType.AddedContent,
          ),
        );
      }
    }

    return newResponse;
  }
}

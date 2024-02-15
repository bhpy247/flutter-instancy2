import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_repository.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_repository.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/authentication/request_model/email_login_request_model.dart';
import 'package:flutter_instancy_2/models/learning_communities/data_model/learning_communities_dto_model.dart';
import 'package:flutter_instancy_2/models/learning_communities/request_model/learning_communities_request_model.dart';
import 'package:flutter_instancy_2/utils/shared_pref_manager.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../configs/app_constants.dart';
import '../../models/authentication/data_model/native_login_dto_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class LearningCommunitiesController {
  late LearningCommunitiesProvider _learningCommunitiesProvider;
  late LearningCommunitiesRepository _learningCommunitiesRepository;

  LearningCommunitiesController({required LearningCommunitiesProvider? learningCommunitiesProvider, LearningCommunitiesRepository? repository, ApiController? apiController}) {
    _learningCommunitiesProvider = learningCommunitiesProvider ?? LearningCommunitiesProvider();
    _learningCommunitiesRepository = repository ?? LearningCommunitiesRepository(apiController: apiController ?? ApiController());
  }

  LearningCommunitiesProvider get learningCommunitiesProvider => _learningCommunitiesProvider;

  LearningCommunitiesRepository get learningCommunitiesRepository => _learningCommunitiesRepository;

  Future<bool> getAllLearningCommunities({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = -1,
    int componentInstanceId = -1,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "DiscussionController().getForumsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    LearningCommunitiesProvider provider = learningCommunitiesProvider;
    LearningCommunitiesRepository repository = learningCommunitiesRepository;
    PaginationModel paginationModel = provider.allLearningCommunitiesPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.allLearningCommunitiesList.getList().isNotEmpty) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return true;
    }
    //endregion

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
        notify: false,
      );
      provider.allLearningCommunitiesList.setList(list: <PortalListing>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Forum Contents', tag: tag);
      return false;
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return false;
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
    GetLearningCommunitiesRequestModel requestModel = getAllLearningCommunitiesRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<LearningCommunitiesDtoModel> response = await repository.getLearningCommunitiesList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("Forum Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Forum Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<PortalListing> questionList = response.data?.portallisting ?? <PortalListing>[];
    MyPrint.printOnConsole("Forum List Length got in Api:${questionList.length}", tag: tag);

    List<PortalListing> newQuestionList = <PortalListing>[];
    // Map<int, PortalListing> newQuestionMap = provider.questionListMap.getMap(isNewInstance: false);

    // Map<int, PortalListing> questionMap = provider.questionListMap.getMap(isNewInstance: true);
    for (PortalListing questionModel in questionList) {
      newQuestionList.add(questionModel);
    }

    List<PortalListing> myLearningList = questionList.where((element) => ParsingHelper.parseBoolMethod(element.labelAlreadyaMember)).toList();
    //region Set Provider Data After Getting Data From Api
    // provider.maxQuestionListCount.set(value: response.data?.rowcount ?? 0, isNotify: false);
    provider.allLearningCommunitiesList.setList(list: newQuestionList, isClear: false, isNotify: false);
    provider.myLearningCommunitiesList.setList(list: myLearningList, isClear: false, isNotify: false);
    // provider.questionListMap.setMap(map: newQuestionMap, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: questionList.length == provider.pageSize.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetLearningCommunitiesRequestModel getAllLearningCommunitiesRequestModelFromProviderData({
    required LearningCommunitiesProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    return GetLearningCommunitiesRequestModel(
      ComponentID: componentId,
      ComponentInstanceID: componentInstanceId,
      SearchText: provider.allLearningCommunitiesSearchString.get(),
      FilterCondition: "",
      SortCondition: provider.sortingData.get(),
      RecordCount: provider.pageSize.get(),
    );
  }

  Future<bool> goToCommunityOrJoinCommunity({required BuildContext context, required int SiteId, required String mobileSiteUrl}) async {
    String tag = MyUtils.getNewId();
    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    NativeLoginDTOModel? emailLoginResponseModel = authenticationProvider.getEmailLoginResponseModel();

    MyPrint.printOnConsole("LearningCommunitiesController().goToCommunityOrJoinCommunity() called with SiteId : $SiteId mobileSiteUrl:$mobileSiteUrl", tag: tag);

    EmailLoginRequestModel emailLoginRequestModel = EmailLoginRequestModel(
      mobileSiteUrl: mobileSiteUrl,
      userName: emailLoginResponseModel?.email ?? "",
      password: emailLoginResponseModel?.password ?? "",
      downloadContent: "true",
      siteId: SiteId,
      isFromSignUp: false,
    );

    DataResponseModel<NativeLoginDTOModel> responseModel = await AuthenticationRepository(apiController: learningCommunitiesRepository.apiController).loginWithEmailAndPassword(
      login: emailLoginRequestModel,
    );

    if (responseModel.data == null && responseModel.statusCode != 200) {
      return false;
    }

    NativeLoginDTOModel nativeLoginDTOModel = responseModel.data!;

    SharedPrefManager prefManager = SharedPrefManager();
    AuthenticationController authenticationController = AuthenticationController(provider: authenticationProvider);

    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteLearnerUrl("");
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteLMSUrl("");
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteId(-1);
    if (context.mounted) {
      authenticationController.clearAllProviderData(context: context);
    }
    prefManager.setBool(SharedPreferenceVariables.isSubSite, true);
    learningCommunitiesRepository.apiController.apiDataProvider.setIsSubSiteEntered(true);

    prefManager.setString(SharedPreferenceVariables.currentSiteUrl, mobileSiteUrl);
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteUrl(mobileSiteUrl);

    prefManager.setInt(SharedPreferenceVariables.currentSiteId, SiteId);
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteId(SiteId);

    nativeLoginDTOModel.email = emailLoginResponseModel?.email ?? "";
    nativeLoginDTOModel.password = emailLoginResponseModel?.password ?? "";

    authenticationController.authenticationHiveRepository.saveLoggedInUserDataInHive(responseModel: nativeLoginDTOModel);
    authenticationProvider.setEmailLoginResponseModel(emailLoginResponseModel: nativeLoginDTOModel);
    if (context.mounted) {
      NavigationController.navigateToSplashScreen(navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil));
    }

    return true;
  }

  Future navigateBackToTheMainSiteUrl({required BuildContext context}) async {
    String tag = MyUtils.getNewId();

    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    NativeLoginDTOModel? emailLoginResponseModel = authenticationProvider.getEmailLoginResponseModel();
    String mainSiteUrl = learningCommunitiesRepository.apiController.apiDataProvider.getMainSiteUrl();

    int siteId = learningCommunitiesRepository.apiController.apiDataProvider.getCurrentSiteId();

    MyPrint.printOnConsole("LearningCommunitiesController().goToCommunityOrJoinCommunity() called with SiteId : $siteId mobileSiteUrl:", tag: tag);

    EmailLoginRequestModel emailLoginRequestModel = EmailLoginRequestModel(
      mobileSiteUrl: mainSiteUrl,
      password: emailLoginResponseModel?.password ?? "",
      userName: emailLoginResponseModel?.email ?? "",
      downloadContent: "true",
      siteId: siteId,
      isFromSignUp: false,
    );

    DataResponseModel<NativeLoginDTOModel> responseModel = await AuthenticationRepository(apiController: learningCommunitiesRepository.apiController).loginWithEmailAndPassword(
      login: emailLoginRequestModel,
    );

    if (responseModel.data == null || responseModel.statusCode != 200) {
      return false;
    }

    NativeLoginDTOModel nativeLoginDTOModel = responseModel.data!;

    SharedPrefManager prefManager = SharedPrefManager();
    AuthenticationController authenticationController = AuthenticationController(provider: authenticationProvider);

    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteLearnerUrl("");
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteLMSUrl("");
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteId(-1);
    if (context.mounted) {
      authenticationController.clearAllProviderData(context: context);
    }

    prefManager.setBool(SharedPreferenceVariables.isSubSite, false);
    learningCommunitiesRepository.apiController.apiDataProvider.setIsSubSiteEntered(false);

    prefManager.setString(SharedPreferenceVariables.currentSiteUrl, mainSiteUrl);
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteUrl(mainSiteUrl);

    prefManager.setInt(SharedPreferenceVariables.currentSiteId, nativeLoginDTOModel.siteid);
    learningCommunitiesRepository.apiController.apiDataProvider.setCurrentSiteId(nativeLoginDTOModel.siteid);

    nativeLoginDTOModel.email = emailLoginResponseModel?.email ?? "";
    nativeLoginDTOModel.password = emailLoginResponseModel?.password ?? "";

    authenticationController.authenticationHiveRepository.saveLoggedInUserDataInHive(responseModel: nativeLoginDTOModel);
    authenticationProvider.setEmailLoginResponseModel(emailLoginResponseModel: nativeLoginDTOModel);
    if (context.mounted) {
      NavigationController.navigateToSplashScreen(navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil));
    }

    return true;
  }
}

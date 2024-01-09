import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/country_response_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/create_education_request_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/create_experience_request_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/remove_experience_request_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/user_save_profile_data_request_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/education_title_response_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/profile_response_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/sign_up_response_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/profile/data_model/user_profile_header_dto_model.dart';
import '../../models/profile/request_model/remove_education_request_model.dart';
import '../../models/profile/request_model/update_profile_request_model.dart';
import '../../models/profile/request_model/user_profile_header_data_request_model.dart';
import '../../utils/my_print.dart';

class ProfileRepository {
  final ApiController apiController;

  const ProfileRepository({required this.apiController});

  Future<DataResponseModel<ProfileResponseModel>> getUserInfo({required int userId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.profileResponseModel,
      url: apiEndpoints.apiGetUserInfoV1(
        userId: userId,
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        locale: apiUrlConfigurationProvider.getLocale(),
      ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<ProfileResponseModel> apiResponseModel = await apiController.callApi<ProfileResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<SignUpResponseModel>> updateProfileInfo({required UpdateProfileRequestModel updateProfileRequestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().updateProfileInfo() called with userID:${updateProfileRequestModel.userId}, requestValue:${updateProfileRequestModel.strProfileJSON}');

    if (updateProfileRequestModel.userId == 0) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "User ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    updateProfileRequestModel.userId = apiUrlConfigurationProvider.getCurrentUserId();
    updateProfileRequestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    updateProfileRequestModel.localeId = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.SignUpResponseModel,
      url: apiEndpoints.apiUpdatePersonalDetailsInProfile(),
      requestBody: updateProfileRequestModel.toJson(),
    );

    DataResponseModel<SignUpResponseModel> apiResponseModel = await apiController.callApi<SignUpResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  // Future<DataResponseModel<String>> updateProfileInfo({required String userID, required String requestValue}) async {
  //   MyPrint.printOnConsole('ProfileRepository().updateProfileInfo() called with userID:$userID, requestValue:$requestValue');
  //
  //   if(userID.isEmpty) {
  //     return DataResponseModel(
  //       appErrorModel: AppErrorModel(
  //         message: "User ID is empty",
  //       ),
  //     );
  //   }
  //
  //   ApiEndpoints apiEndpoints = apiController.apiEndpoints;
  //
  //   MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
  //
  //   ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
  //
  //   String data = '''\"UserGroupIDs\":\"\",\"RoleIDs\":\"\",\"Cmd\":\"$requestValue\",\"CMGroupIDs\":\"\"''';
  //   String replaceDataString = data.replaceAll("\"", "\\\"");
  //   data = '''"{$replaceDataString}"''';
  //
  //   ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
  //     restCallType: RestCallType.simplePostCall,
  //     parsingType: ModelDataParsingType.string,
  //     url: apiEndpoints.apiUpdatePersonalDetailsInProfile(),
  //     queryParameters: {
  //       "studId" : userID,
  //       "SiteURL" : apiUrlConfigurationProvider.getCurrentSiteUrl(),
  //     },
  //     requestBody: data,
  //   );
  //
  //   DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
  //     apiCallModel: apiCallModel,
  //   );
  //
  //   return apiResponseModel;
  // }

  Future<DataResponseModel<CountryResponseModel>> getMultipleChoicesListForProfileEdit() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.countryResponseModel,
      url: apiEndpoints.getUserDetails(),
      queryParameters: {
        "UserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "siteURL": apiUrlConfigurationProvider.getCurrentSiteUrl(),
        "strlocaleId": apiUrlConfigurationProvider.getLocale(),
      },
    );

    DataResponseModel<CountryResponseModel> apiResponseModel = await apiController.callApi<CountryResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> createExperience({required CreateExperienceRequestModel createExperienceRequestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().createExperience() called with createExperienceRequestModel:$createExperienceRequestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    createExperienceRequestModel.userId = apiUrlConfigurationProvider.getCurrentUserId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.createExperience(),
      requestBody: MyUtils.encodeJson(createExperienceRequestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> updateExperience({required CreateExperienceRequestModel createExperienceRequestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().updateExperience() called with createExperienceRequestModel:$createExperienceRequestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.updateExperience(),
      requestBody: MyUtils.encodeJson(createExperienceRequestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> removeExperience({required RemoveExperienceRequestModel removeExperienceRequestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().removeExperience() called with removeExperienceRequestModel:$removeExperienceRequestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.removeExperience(),
      requestBody: MyUtils.encodeJson(removeExperienceRequestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> createEducation({required CreateEducationRequestModel requestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().createEducation() called with createExperienceRequestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userId = apiUrlConfigurationProvider.getCurrentUserId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.createEducation(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> updateEducation({required CreateEducationRequestModel requestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().updateEducation() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.updateEducation(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> removeEducation({required RemoveEducationRequestModel requestModel}) async {
    MyPrint.printOnConsole('ProfileRepository().removeEducation() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.removeEducation(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EducationTitleResponseModel>> getEducationTitles() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.educationTitleResponseModel,
      url: apiEndpoints.getEducationTitles(),
    );

    DataResponseModel<EducationTitleResponseModel> apiResponseModel = await apiController.callApi<EducationTitleResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<bool>> updateProfileImage({required String fileName, required Uint8List bytes}) async {
    MyPrint.printOnConsole('ProfileRepository().updateProfileImage() called with fileName:$fileName, bytes length:${bytes.lengthInBytes / 1024} KB');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    String base64String = await compute<Uint8List, String>((Uint8List bytes) {
      return base64Encode(bytes);
    }, bytes)
        .then((String value) {
      return value;
    }).catchError((e, s) {
      MyPrint.printOnConsole("Error in Encoding Bytes to String:$e");
      MyPrint.printOnConsole(s);
      return "";
    });

    String replaceDataString = base64String.replaceAll("\"", "\\\"");
    String addQuotes = ('"$replaceDataString"');

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.bool,
      url: apiEndpoints.uploadProfileImage(),
      queryParameters: {
        "fileName": fileName,
        "siteURL": apiUrlConfigurationProvider.getCurrentSiteUrl(),
        "UserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
      },
      requestBody: addQuotes,
    );

    DataResponseModel<bool> apiResponseModel = await apiController.callApi<bool>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<UserProfileHeaderDTOModel>> getProfileHeaderData({required UserProfileHeaderDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    requestModel.strLocale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.userProfileHeaderDTOModel,
      url: apiEndpoints.getUserProfileHeaderData(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<UserProfileHeaderDTOModel> apiResponseModel = await apiController.callApi<UserProfileHeaderDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<SignUpResponseModel>> saveProfileData({required UserSaveProfileDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intCompID = InstancyComponents.NewSignUpForm;
    requestModel.intCompInsID = InstancyComponents.NewSignUpFormComponentInsId;
    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.localeId = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.SignUpResponseModel,
      url: apiEndpoints.apiSaveProfile(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<SignUpResponseModel> apiResponseModel = await apiController.callApi<SignUpResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}

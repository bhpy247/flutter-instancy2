import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/forgot_password_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/mobile_create_sign_up_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/signup_field_response_model.dart';
import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:http/http.dart';

import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/authentication/request_model/email_login_request_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../utils/my_print.dart';

class AuthenticationRepository {
  final ApiController apiController;

  const AuthenticationRepository({required this.apiController});

  Future<DataResponseModel<NativeLoginDTOModel>> loginWithEmailAndPassword({required EmailLoginRequestModel login}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.NativeLoginDTOModel,
      url: apiEndpoints.apiPostLoginDetails(),
      requestBody: MyUtils.encodeJson(login.toJson()),
      isAuthenticatedApiCall: false,
    );

    DataResponseModel<NativeLoginDTOModel> apiResponseModel = await apiController.callApi<NativeLoginDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  /*Future<DataResponseModel<EmailLoginResponseModel>> loginWithEmailAndPassword({required EmailLoginRequestModel login}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.emailLoginResponseModel,
      url: apiEndpoints.apiPostLoginDetails(),
      requestBody: MyUtils.encodeJson(login.toJson()),
      isAuthenticatedApiCall: false,
    );

    DataResponseModel<EmailLoginResponseModel> apiResponseModel = await apiController.callApi<EmailLoginResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }*/

  Future<DataResponseModel<ForgotPasswordResponseModel>> getForgotPasswordStatus({required String email}) async {
    try {
      print('email req $email');

      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

      ApiCallModel apiCallModel = ApiCallModel(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.forgotPasswordResponseModel,
        url: apiEndpoints.apiGetUserStatusAPI(email:email), siteUrl: apiEndpoints.siteUrl,
      );

      DataResponseModel<ForgotPasswordResponseModel> apiResponseModel = await apiController.callApi<ForgotPasswordResponseModel>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("Response data of the getForgotPasswordStatus: ${apiResponseModel.data}");

      return apiResponseModel;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationRepository.loginWithEmailAndPassword():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<ForgotPasswordResponseModel>(
        appErrorModel: AppErrorModel(
          exception: e as Exception,
          stackTrace: s,
        ),
      );
    }
  }

  Future<DataResponseModel> resetUserdata({required  UserStatus userStatus, required String resetId}) async {
    try {
      print('userStatus $userStatus');

      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.dynamic,
        url: apiEndpoints.resetUserDataAPI(userId: userStatus.userid.toString(), resetId: resetId),
        isAuthenticatedApiCall: false,
        // requestBody: MyUtils.encodeJson({"email":email}),
      );

      DataResponseModel apiResponseModel = await apiController.callApi(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("Response data of the resetUserDataApi: ${apiResponseModel.runtimeType}");
      // if(apiResponseModel.data.statusCode == 200){
      //
      // }

      return apiResponseModel;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationRepository.loginWithEmailAndPassword():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<String>(
        appErrorModel: AppErrorModel(
          exception: e as Exception,
          stackTrace: s,
        ),
      );
    }
  }

  Future<DataResponseModel> sendPassword({required  int siteId, required int userId, required String email, required String resetId}) async {
    try {
      // print('userStatus $userStatus');

      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.dynamic,
        url: apiEndpoints.sendPwdResetAPI(siteId: siteId, userId: userId, email: email, newguId: resetId),
        isAuthenticatedApiCall: false,
      );

      DataResponseModel apiResponseModel = await apiController.callApi(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("Response data of the sendPassword: ${apiResponseModel.data}");


      return apiResponseModel;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationRepository.loginWithEmailAndPassword():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<Response>(
        appErrorModel: AppErrorModel(
          exception: e as Exception,
          stackTrace: s,
        ),
      );
    }
  }

  Future<DataResponseModel<SignupFieldResponseModel>> getSignupFields({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    try {
      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.signupFieldResponseModel,
        isAuthenticatedApiCall: false,
        url: apiEndpoints.getSignUpFieldsURL(
          locale: apiUrlConfigurationProvider.getLocale(),
          siteId: -1,
          componentId: componentId,
          componentInstanceid: componentInstanceId,
        ),
        isGetDataFromHive: isFromOffline,
        isStoreDataInHive: isStoreDataInHive,
      );

      // MyPrint.printOnConsole("Response data of the apiCallModel: ${apiCallModel.url}");

      DataResponseModel<SignupFieldResponseModel> apiResponseModel = await apiController.callApi(
        apiCallModel: apiCallModel,
      );

      MyPrint.printOnConsole("Response data of the resetUserDataApi: $apiResponseModel");
      return apiResponseModel;
    }
    catch (e,s) {
      MyPrint.printOnConsole("Error in AuthenticationRepository.getSignupFields():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<SignupFieldResponseModel>(
        appErrorModel: AppErrorModel(
          exception: e as Exception,
          stackTrace: s,
        ),
      );
    }
  }

  Future<DataResponseModel<MobileCreateSignUpResponseModel>> signUpUser({required String val}) async {
    try {
      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

      String requestBody = '''"{\n    \\"UserGroupIDs\\" : \\"\\",\n    \\"RoleIDs\\" : \\"\\",\n    \\"Cmd\\" : \\"$val\\",\n    \\"CMGroupIDs\\" : \\"\\"\n}"''';
      // String requestBody = '''"{\\\"UserGroupIDs\\\" : \\\"\\\",\\\"RoleIDs\\\" : \\\"\\\",\\\"Cmd\\\" : \\\"$val\\\",\\\"CMGroupIDs\\\" : \\\"\\\"}"''';

      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simplePostCall,
        parsingType: ModelDataParsingType.MobileCreateSignUpResponseModel,
        url: apiEndpoints.apiSignUpUser(locale: apiController.apiDataProvider.getLocale()),
        isAuthenticatedApiCall: false,
        requestBody: requestBody,
      );

      DataResponseModel<MobileCreateSignUpResponseModel> apiResponseModel = await apiController.callApi<MobileCreateSignUpResponseModel>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("Response data of the signUpUser: ${apiResponseModel.data}");

      return apiResponseModel;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationRepository.loginWithEmailAndPassword():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<MobileCreateSignUpResponseModel>(
        appErrorModel: AppErrorModel(
          exception: e as Exception,
          stackTrace: s,
        ),
      );
    }
  }
}
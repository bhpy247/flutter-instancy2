import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/request_model/save_social_network_users_request_model.dart';
import 'package:flutter_instancy_2/models/authentication/request_model/social_login_request_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/forgot_password_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/mobile_create_sign_up_response_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/save_social_network_users_response_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/signup_field_response_model.dart';
import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<DataResponseModel<SaveSocialNetworkUsersResponseDtoModel>> saveSocialNetworkUsers({required SaveSocialNetworkUsersRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.SaveSocialNetworkUsersResponseDtoModel,
      url: apiEndpoints.SaveSocialNetworkUsers(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isAuthenticatedApiCall: false,
    );

    DataResponseModel<SaveSocialNetworkUsersResponseDtoModel> apiResponseModel = await apiController.callApi<SaveSocialNetworkUsersResponseDtoModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<NativeLoginDTOModel>> loginWithSocialCredentials({required SocialLoginRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.NativeLoginDTOModel,
      url: apiEndpoints.SocialLogin(),
      queryParameters: requestModel.toJson(),
      isAuthenticatedApiCall: false,
    );

    DataResponseModel<NativeLoginDTOModel> apiResponseModel = await apiController.callApi<NativeLoginDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<UserCredential?> signInWithGoogle({required BuildContext context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationRepository().signInWithGoogle() called", tag: tag);

    AuthProvider? authProvider;
    AuthCredential? authCredential;

    if (kIsWeb) {
      MyPrint.printOnConsole("Initializing authProvider because it's web platform", tag: tag);

      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      authProvider = googleProvider;
      /*googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });*/
    } else {
      MyPrint.printOnConsole("Initializing authCredential because it's native platform", tag: tag);

      GoogleSignInAccount? googleSignInAccount;

      try {
        MyPrint.printOnConsole("Initializing Google signIn", tag: tag);

        GoogleSignIn.kSignInCanceledError;
        googleSignInAccount = await GoogleSignIn(scopes: [
          'https://www.googleapis.com/auth/userinfo.email',
          "https://www.googleapis.com/auth/userinfo.profile",
        ]).signIn();

        MyPrint.printOnConsole("Google signIn Completed with account:$googleSignInAccount", tag: tag);
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Google Sign In:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }

      if (googleSignInAccount == null) {
        MyPrint.printOnConsole("Returning from AuthenticationRepository().signInWithGoogle() because googleSignInAccount is null", tag: tag);
        return null;
      }

      MyPrint.printOnConsole("Initializing Getting Auth Credentials", tag: tag);
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      MyPrint.printOnConsole("Initialized Auth Credentials", tag: tag);
    }

    UserCredential? userCredential = await firebaseSocialLogin(context: context, authProvider: authProvider, credential: authCredential);

    return userCredential;
  }

  Future<UserCredential?> signInWithFacebook({required BuildContext context}) async {
    AuthProvider? authProvider;
    AuthCredential? authCredential;

    if (kIsWeb) {
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });
      authProvider = facebookProvider;
    } else {
      LoginResult? loginResult;

      try {
        // Trigger the sign-in flow
        loginResult = await FacebookAuth.instance.login();
      } catch (e) {
        MyPrint.printOnConsole("Error in Facebook:$e");
      }

      if (loginResult == null || loginResult.accessToken == null) {
        return null;
      }

      // Create a credential from the access token
      authCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    }

    UserCredential? userCredential = await firebaseSocialLogin(context: context, authProvider: authProvider, credential: authCredential);

    return userCredential;
  }

  Future<UserCredential?> signInWithTwitter({required BuildContext context}) async {
    AuthProvider authProvider = TwitterAuthProvider();

    UserCredential? userCredential = await firebaseSocialLogin(context: context, authProvider: authProvider);

    return userCredential;
  }

  Future<UserCredential?> firebaseSocialLogin({required BuildContext context, AuthProvider? authProvider, AuthCredential? credential}) async {
    try {
      if (!kIsWeb && credential != null) {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      } else if (authProvider != null) {
        UserCredential userCredential;

        if (kIsWeb) {
          userCredential = await FirebaseAuth.instance.signInWithPopup(authProvider);
        } else {
          userCredential = await FirebaseAuth.instance.signInWithProvider(authProvider);
        }

        return userCredential;

        // Or use signInWithRedirect
        // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      }
    } on FirebaseAuthException catch (e) {
      MyPrint.printOnConsole("Code:${e.code}");
      switch (e.code) {
        case "account-exists-with-different-credential":
          {
            List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(e.email!);
            MyPrint.printOnConsole("Methods:$methods");

            MyPrint.printOnConsole("Message:Account Already Exist With Different Method");
            if (context.mounted) MyToast.showError(context: context, msg: "Account Already Exist With Different Method");
          }
          break;

        case "invalid-credential":
          {
            MyPrint.printOnConsole("Message:Invalid Credentials");
            if (context.mounted) MyToast.showError(context: context, msg: "Invalid Credentials");
          }
          break;

        case "operation-not-allowed":
          {
            MyPrint.printOnConsole("Message:${e.message}");
            if (context.mounted) MyToast.showError(context: context, msg: "${e.message}");
          }
          break;

        case "user-disabled":
          {
            MyPrint.printOnConsole("Message:${e.message}");
            if (context.mounted) MyToast.showError(context: context, msg: "${e.message}");
          }
          break;

        case "user-not-found":
          {
            MyPrint.printOnConsole("Message:${e.message}");
            if (context.mounted) MyToast.showError(context: context, msg: "${e.message}");
          }
          break;

        case "wrong-password":
          {
            MyPrint.printOnConsole("Message:${e.message}");
            if (context.mounted) MyToast.showError(context: context, msg: "${e.message}");
          }
          break;

        default:
          {
            MyPrint.printOnConsole("Message:${e.message}");
            if (context.mounted) MyToast.showError(context: context, msg: "${e.message}");
          }
      }

      return null;
    } catch (e, s) {
      return null;
    }
    return null;
  }

  Future<DataResponseModel<ForgotPasswordResponseModel>> getForgotPasswordStatus({required String email}) async {
    try {
      print('email req $email');

      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

      ApiCallModel apiCallModel = ApiCallModel(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.forgotPasswordResponseModel,
        url: apiEndpoints.apiGetUserStatusAPI(email: email),
        siteUrl: apiEndpoints.siteUrl,
      );

      DataResponseModel<ForgotPasswordResponseModel> apiResponseModel = await apiController.callApi<ForgotPasswordResponseModel>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("Response data of the getForgotPasswordStatus: ${apiResponseModel.data}");

      return apiResponseModel;
    } catch (e, s) {
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

  Future<DataResponseModel> resetUserdata({required UserStatus userStatus, required String resetId}) async {
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
    } catch (e, s) {
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

  Future<DataResponseModel> sendPassword({required int siteId, required int userId, required String email, required String resetId}) async {
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
    } catch (e, s) {
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
    } catch (e, s) {
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
    } catch (e, s) {
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

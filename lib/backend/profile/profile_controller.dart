import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/common/instancy_picked_file_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/data_field_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/education_title_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/profile_group_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_header_dto_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/update_profile_request_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/user_profile_header_data_request_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/education_title_response_model.dart';
import 'package:flutter_instancy_2/models/profile/response_model/profile_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/profile/component/confirm_remove_experience_by_user_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/authentication/response_model/country_response_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/profile/data_model/user_privilege_model.dart';
import '../../models/profile/data_model/user_profile_details_model.dart';
import '../../models/profile/response_model/sign_up_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/profile/component/confirm_remove_education_by_user_dialog.dart';
import '../authentication/authentication_provider.dart';

class ProfileController {
  late final ProfileProvider profileProvider;
  late ProfileRepository profileRepository;

  ProfileController({required ProfileProvider? profileProvider, ProfileRepository? repository, ApiController? apiController}) {
    this.profileProvider = profileProvider ?? ProfileProvider();
    profileRepository = repository ?? ProfileRepository(apiController: apiController ?? ApiController());
  }

  //region ProfileInfoMain
  Future<void> getProfileInfoMain({
    required int userId,
    bool isGetFromCache = false,
    required AuthenticationProvider authenticationProvider,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getNewLearningResourcesListMain() called with isGetFromCache:$isGetFromCache", tag: tag);

    if (isGetFromCache) {
      await getProfileInfo(userId: userId, isGetFromCache: true, isNotify: true, authenticationProvider: authenticationProvider);

      if (profileProvider.userExperienceData.getList(isNewInstance: false).isNotEmpty ||
          profileProvider.userEducationData.getList(isNewInstance: false).isNotEmpty ||
          profileProvider.profileDataFields.getList(isNewInstance: false).isNotEmpty ||
          profileProvider.userPrivilegeData.getList(isNewInstance: false).isNotEmpty) {
        getProfileInfo(userId: userId, isGetFromCache: false, isNotify: true, authenticationProvider: authenticationProvider);
      } else {
        await getProfileInfo(userId: userId, isGetFromCache: false, isNotify: true, authenticationProvider: authenticationProvider);
      }
    } else {
      await getProfileInfo(userId: userId, isGetFromCache: false, isNotify: true, authenticationProvider: authenticationProvider);
    }
  }

  Future<void> getProfileInfo({required int userId, bool isGetFromCache = false, bool isNotify = false, required AuthenticationProvider authenticationProvider}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getNewLearningResourcesList() called with userId:$userId, isGetFromCache:$isGetFromCache", tag: tag);

    DataResponseModel<ProfileResponseModel> response = await profileRepository.getUserInfo(
      userId: userId,
      isStoreDataInHive: !isGetFromCache,
      isFromOffline: isGetFromCache,
    );
    MyPrint.printOnConsole("userExperienceData Length:${response.data?.userExperienceData.length ?? 0}", tag: tag);
    MyPrint.printOnConsole("userEducationData Length:${response.data?.userEducationData.length ?? 0}", tag: tag);
    MyPrint.printOnConsole("profileDataFieldName Length:${response.data?.profileDataFieldName.length ?? 0}", tag: tag);
    MyPrint.printOnConsole("userPrivileges Length:${response.data?.userPrivileges.length ?? 0}", tag: tag);

    if (response.data != null) {
      ProfileResponseModel profileResponseModel = response.data!;

      profileProvider.userExperienceData.setList(list: profileResponseModel.userExperienceData, isNotify: false);
      profileProvider.userEducationData.setList(list: profileResponseModel.userEducationData, isNotify: false);
      profileProvider.profileDataFields.setList(list: profileResponseModel.profileDataFieldName, isNotify: false);
      profileProvider.userPrivilegeData.setList(list: profileResponseModel.userPrivileges, isNotify: false);
      profileProvider.userProfileDetails.setList(list: profileResponseModel.userProfileDetails, isNotify: false);

      UserProfileDetailsModel? userProfileDetailsModel = profileResponseModel.userProfileDetails.firstElement;

      if (userProfileDetailsModel != null) {
        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel != null) {
          successfulUserLoginModel.image = "${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel.picture}";
        }
        MyPrint.printOnConsole('successfulUserLoginModel.img : ${successfulUserLoginModel?.image}');
        authenticationProvider.setEmailLoginResponseModel(emailLoginResponseModel: successfulUserLoginModel);
      }
      //region Personal Info, Contact Info and Back Office Info Initialization
      Map<String, dynamic> profileDetailsMap = profileResponseModel.userProfileDetails.firstElement?.toJson() ?? <String, dynamic>{};
      for (ProfileGroupModel profileGroupModel in profileResponseModel.userProfileGroups) {
        if (profileGroupModel.groupid == ProfileGroupType.personalInfo) {
          List<DataFieldModel> data = initializeDataFieldModelValueFromProfileDetailsMap(
            profileGroupModel: profileGroupModel,
            profileDetailsMap: profileDetailsMap,
          );
          profileProvider.userPersonalInfoDataList.setList(list: data, isNotify: false);
        } else if (profileGroupModel.groupid == ProfileGroupType.contactInfo) {
          List<DataFieldModel> data = initializeDataFieldModelValueFromProfileDetailsMap(
            profileGroupModel: profileGroupModel,
            profileDetailsMap: profileDetailsMap,
          );
          profileProvider.userContactInfoDataList.setList(list: data, isNotify: false);
        } else if (profileGroupModel.groupid == ProfileGroupType.backOfficeInfo) {
          List<DataFieldModel> data = initializeDataFieldModelValueFromProfileDetailsMap(
            profileGroupModel: profileGroupModel,
            profileDetailsMap: profileDetailsMap,
          );
          profileProvider.userBackOfficeInfoDataList.setList(list: data, isNotify: false);
        }
      }

      //endregion
    }

    profileProvider.notify(isNotify: isNotify);
  }

  List<DataFieldModel> initializeDataFieldModelValueFromProfileDetailsMap({
    required ProfileGroupModel profileGroupModel,
    required Map<String, dynamic> profileDetailsMap,
  }) {
    List<DataFieldModel> data = [];

    for (DataFieldModel dataFieldModel in profileGroupModel.datafilelist) {
      if (profileDetailsMap.containsKey(dataFieldModel.datafieldname.toLowerCase().toString()) && dataFieldModel.datafieldname.toLowerCase().toString() != 'picture') {
        data.add(dataFieldModel);
      }
    }

    for (DataFieldModel dataFieldModel in data) {
      if (profileDetailsMap.containsKey(dataFieldModel.datafieldname.toLowerCase().toString())) {
        dataFieldModel.valueName = profileDetailsMap[dataFieldModel.datafieldname.toLowerCase().toString()] ?? "";
      }

      if (dataFieldModel.aliasname.toLowerCase().toString() == 'dateofbirth' && dataFieldModel.valueName.isNotEmpty) {
        DateTime? tempDate = DateFormat("yyyy-MM-ddThh:mm:ss").tryParse(dataFieldModel.valueName);
        MyPrint.printOnConsole("tempDate:$tempDate");

        if (tempDate != null) {
          String date = DateFormat("MM/dd/yyyy").format(tempDate);
          dataFieldModel.valueName = date;
        }
      }

      dataFieldModel.initializeProfileConfigDataUIControlModel();

      /*editData.add(ProfileEditList(
        datafieldname: data.datafieldname,
        aliasname: data.aliasname,
        attributedisplaytext: data.attributedisplaytext,
        groupid: data.groupid,
        displayorder: data.displayorder,
        attributeconfigid: data.attributeconfigid,
        isrequired: data.isrequired,
        iseditable: data.iseditable,
        enduservisibility: data.enduservisibility,
        uicontroltypeid: data.uicontroltypeid,
        name: data.name,
        minlength: data.minlength,
        maxlength: data.maxlength,
        valueName: data.valueName,
        table5: data.table5,
      ));*/
    }
    // print('profileeditlist ${editUserData.length} ${editContactData.length} ${editBackOfficeData.length}');

    return data;
  }

  //endregion

  Future<bool> updateProfileDetails(List<DataFieldModel> list, {required int componentId, required int componentInsId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProfileController().updateProfileDetails() called with list:$list", tag: tag);

    bool isSuccess = false;

    try {
      Map<String, String> dataFieldMap = {};
      for (DataFieldModel dataFieldModel in list) {
        dataFieldMap[dataFieldModel.datafieldname] = dataFieldModel.valueName;
        // String fieldValue = ''' '${dataFieldModel.valueName}' ''';
        //
        // requestValue = '$requestValue${dataFieldModel.datafieldname.toLowerCase()}=${fieldValue.trim()},';
      }
      MyPrint.printOnConsole('dataFieldMap  $dataFieldMap', tag: tag);

      UpdateProfileRequestModel updateProfileRequestModel = UpdateProfileRequestModel(
        strProfileJSON: MyUtils.encodeJson(dataFieldMap),
        isnativeapp: true,
        type: "profile",
        intCompID: componentId,
        intCompInsID: componentInsId,
      );

      DataResponseModel<SignUpResponseModel> responseModel = await profileRepository.updateProfileInfo(updateProfileRequestModel: updateProfileRequestModel);
      MyPrint.printOnConsole("updatePersonalInfo responseModel:$responseModel", tag: tag);

      if (responseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from ProfileController().updateProfileDetails() because some error occurred:${responseModel.appErrorModel}");
        return isSuccess;
      }

      isSuccess = responseModel.data?.Response?.Message == "success";

      if (isSuccess) {
        GamificationController(provider: NavigationController.mainNavigatorKey.currentContext?.read<GamificationProvider>())
            .UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: "",
            scoId: 0,
            GameAction: GamificationActionType.Updated,
          ),
        )
            .then((value) {
          BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
          MyPrint.printOnConsole("context:$context", tag: tag);
          if (context != null) {
            GamificationController gamificationController = GamificationController(provider: context.read<GamificationProvider>());
            gamificationController.getUserAchievementDataForDrawer(isNotify: false);
            gamificationController.getUserAchievementsData(isRefresh: true, isNotify: false);
            gamificationController.getLeaderBoardData(isRefresh: true, isNotify: false);
          }
        });
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ProfileController().updateProfileDetails():$e");
      MyPrint.printOnConsole(s);
    }

    return isSuccess;
  }

  Future<List<Table5>> getMultipleChoicesList({bool isFromCache = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProfileController().getMultipleChoicesList() called with isFromCache:$isFromCache", tag: tag);

    List<Table5> choices = <Table5>[];

    MyPrint.printOnConsole("Choices Length in profileProvider:${profileProvider.multipleChoicesList.getList(isNewInstance: false).length}", tag: tag);

    try {
      if (isFromCache && profileProvider.multipleChoicesList.getList(isNewInstance: false).isNotEmpty) {
        choices = profileProvider.multipleChoicesList.getList(isNewInstance: true);
      } else {
        DataResponseModel<CountryResponseModel> responseModel = await profileRepository.getMultipleChoicesListForProfileEdit();
        if (responseModel.data != null) {
          choices = responseModel.data!.table5;
          profileProvider.multipleChoicesList.setList(list: choices);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ProfileController().getMultipleChoicesList():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final Choices Length:${choices.length}", tag: tag);

    return choices;
  }

  Future<bool> checkRemoveExperienceByUserFromDialog({required BuildContext context, LocalStr? localStr}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmRemoveExperienceByUserDialog(
          localStr: localStr,
        );
      },
    );

    return value == true;
  }

  Future<bool> checkRemoveEducationByUserFromDialog({required BuildContext context, LocalStr? localStr}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmRemoveEducationByUserDialog(
          localStr: localStr,
        );
      },
    );

    return value == true;
  }

  Future<List<EducationTitleModel>> getEducationTitles({bool isFromCache = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProfileController().getEducationTitles() called with isFromCache:$isFromCache", tag: tag);

    List<EducationTitleModel> titles = <EducationTitleModel>[];

    MyPrint.printOnConsole("educationTitlesList Length in profileProvider:${profileProvider.educationTitlesList.getList(isNewInstance: false).length}", tag: tag);

    try {
      if (isFromCache && profileProvider.educationTitlesList.getList(isNewInstance: false).isNotEmpty) {
        titles = profileProvider.educationTitlesList.getList(isNewInstance: true);
      } else {
        DataResponseModel<EducationTitleResponseModel> responseModel = await profileRepository.getEducationTitles();
        if (responseModel.data != null) {
          titles = responseModel.data!.educationTitleList;
          profileProvider.educationTitlesList.setList(list: titles);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ProfileController().getEducationTitles():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final titles Length:${titles.length}", tag: tag);

    return titles;
  }

  Future<bool> updateProfileImage() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProfileController().updateProfileImage() called", tag: tag);

    bool isUpdated = false;

    // List<InstancyPickedFileModel> images = await AppController.pickImages(imageSource: InstancyImagePickSource.gallery, pickMultiple: false);
    List<InstancyPickedFileModel> images = await AppController.pickFiles(
      filePickType: InstancyFilePickType.image,
      pickMultiple: false,
    );
    MyPrint.printOnConsole("Picked images length:${images.length}", tag: tag);

    InstancyPickedFileModel? image = images.firstElement;

    if (image == null || image.bytes == null) {
      MyPrint.printOnConsole("Returning from ProfileController().updateProfileImage() because picked file or bytes are Null", tag: tag);
      return isUpdated;
    }

    DataResponseModel<bool> responseModel = await profileRepository.updateProfileImage(fileName: image.fileName, bytes: image.bytes!);
    MyPrint.printOnConsole("updateProfileImage responseModel:$responseModel", tag: tag);

    if (responseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from ProfileController().updateProfileImage() because Some error occurred in updating profile image:${responseModel.appErrorModel}", tag: tag);
      return isUpdated;
    }

    isUpdated = responseModel.data ?? false;

    return isUpdated;
  }

  Future<UserProfileHeaderDTOModel?> getProfileHeaderDataAndStoreInProvider({required UserProfileHeaderDataRequestModel requestModel, bool isFromCache = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProfileController().getProfileHeaderDataAndStoreInProvider() called with isFromCache:$isFromCache", tag: tag);

    UserProfileHeaderDTOModel? headerDTOModel;

    MyPrint.printOnConsole("educationTitlesList Length in profileProvider:${profileProvider.educationTitlesList.getList(isNewInstance: false).length}", tag: tag);

    try {
      if (isFromCache && profileProvider.headerDTOModel.get() != null) {
        headerDTOModel = profileProvider.headerDTOModel.get();
      } else {
        DataResponseModel<UserProfileHeaderDTOModel> responseModel = await profileRepository.getProfileHeaderData(requestModel: requestModel);
        if (responseModel.data != null) {
          headerDTOModel = responseModel.data!;
        }
        profileProvider.headerDTOModel.set(value: headerDTOModel);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ProfileController().getProfileHeaderDataAndStoreInProvider():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final headerDTOModel:$headerDTOModel", tag: tag);

    return headerDTOModel;
  }

  bool isShowAddForumButton() {
    MyPrint.printOnConsole("isShowAddForumButton called");

    bool showPrivilege = false;
    List<UserPrivilegeModel> userPrivilege = profileProvider.userPrivilegeData.getList();
    MyPrint.printOnConsole("userPrivilege called ${userPrivilege.length}");

    if (userPrivilege.checkNotEmpty) {
      for (var element in userPrivilege) {
        if (element.privilegeid == DiscussionForumPrivileges.showAddForumButton) {
          return true;
        }
      }
    }
    return showPrivilege;
  }

  bool isShowAllFeedBackData() {
    MyPrint.printOnConsole("isShowAddForumButton called");

    bool showPrivilege = false;
    List<UserPrivilegeModel> userPrivilege = profileProvider.userPrivilegeData.getList();
    MyPrint.printOnConsole("userPrivilege called ${userPrivilege.length}");

    if (userPrivilege.checkNotEmpty) {
      for (var element in userPrivilege) {
        MyPrint.printOnConsole("element : ${element.privilegeid}");
        if (element.privilegeid == FeedbackPrivileges.ViewallFeedback) {
          return true;
        }
      }
    }
    return showPrivilege;
  }
}

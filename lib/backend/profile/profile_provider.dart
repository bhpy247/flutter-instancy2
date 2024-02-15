import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/country_response_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/profile_data_field_name_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_education_data_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_experience_data_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_privilege_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_header_dto_model.dart';

import '../../models/profile/data_model/data_field_model.dart';
import '../../models/profile/data_model/education_title_model.dart';
import '../../models/profile/data_model/user_profile_details_model.dart';

class ProfileProvider extends CommonProvider {
  ProfileProvider() {
    userExperienceData = CommonProviderListParameter<UserExperienceDataModel>(
      list: <UserExperienceDataModel>[],
      notify: notify,
    );
    userEducationData = CommonProviderListParameter<UserEducationDataModel>(
      list: <UserEducationDataModel>[],
      notify: notify,
    );
    profileDataFields = CommonProviderListParameter<ProfileDataFieldNameModel>(
      list: <ProfileDataFieldNameModel>[],
      notify: notify,
    );
    userPrivilegeData = CommonProviderListParameter<UserPrivilegeModel>(
      list: <UserPrivilegeModel>[],
      notify: notify,
    );
    userProfileDetails = CommonProviderListParameter<UserProfileDetailsModel>(
      list: <UserProfileDetailsModel>[],
      notify: notify,
    );
    userPersonalInfoDataList = CommonProviderListParameter<DataFieldModel>(
      list: <DataFieldModel>[],
      newInstancialization: (DataFieldModel dataFieldModel) {
        return DataFieldModel.fromJson(dataFieldModel.toJson());
      },
      notify: notify,
    );
    userContactInfoDataList = CommonProviderListParameter<DataFieldModel>(
      list: <DataFieldModel>[],
      notify: notify,
    );
    userBackOfficeInfoDataList = CommonProviderListParameter<DataFieldModel>(
      list: <DataFieldModel>[],
      notify: notify,
    );

    userPersonalInfoForEditingDataList = CommonProviderListParameter<DataFieldModel>(
      list: <DataFieldModel>[],
      newInstancialization: (DataFieldModel dataFieldModel) {
        return DataFieldModel.fromJson(dataFieldModel.toJson());
      },
      notify: notify,
    );
    userPersonalInfoEditingEnabled = CommonProviderPrimitiveParameter(
      value: false,
      notify: notify,
    );

    userContactInfoForEditingDataList = CommonProviderListParameter<DataFieldModel>(
      list: <DataFieldModel>[],
      newInstancialization: (DataFieldModel dataFieldModel) {
        return DataFieldModel.fromJson(dataFieldModel.toJson());
      },
      notify: notify,
    );
    userContactInfoEditingEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    multipleChoicesList = CommonProviderListParameter<Table5>(
      list: <Table5>[],
      notify: notify,
    );
    educationTitlesList = CommonProviderListParameter<EducationTitleModel>(
      list: <EducationTitleModel>[],
      notify: notify,
    );

    headerDTOModel = CommonProviderPrimitiveParameter<UserProfileHeaderDTOModel?>(
      value: null,
      notify: notify,
    );
  }

  late final CommonProviderListParameter<UserExperienceDataModel> userExperienceData;
  late final CommonProviderListParameter<UserEducationDataModel> userEducationData;
  late final CommonProviderListParameter<ProfileDataFieldNameModel> profileDataFields;
  late final CommonProviderListParameter<UserPrivilegeModel> userPrivilegeData;
  late final CommonProviderListParameter<UserProfileDetailsModel> userProfileDetails;
  late final CommonProviderListParameter<DataFieldModel> userPersonalInfoDataList;
  late final CommonProviderListParameter<DataFieldModel> userContactInfoDataList;
  late final CommonProviderListParameter<DataFieldModel> userBackOfficeInfoDataList;

  late final CommonProviderListParameter<DataFieldModel> userPersonalInfoForEditingDataList;
  late final CommonProviderPrimitiveParameter<bool> userPersonalInfoEditingEnabled;

  late final CommonProviderListParameter<DataFieldModel> userContactInfoForEditingDataList;
  late final CommonProviderPrimitiveParameter<bool> userContactInfoEditingEnabled;

  late final CommonProviderListParameter<Table5> multipleChoicesList;
  late final CommonProviderListParameter<EducationTitleModel> educationTitlesList;

  late final CommonProviderPrimitiveParameter<UserProfileHeaderDTOModel?> headerDTOModel;

  void resetData() {
    userExperienceData.setList(list: [], isNotify: false);
    userEducationData.setList(list: [], isNotify: false);
    profileDataFields.setList(list: [], isNotify: false);
    userPrivilegeData.setList(list: [], isNotify: false);
    userProfileDetails.setList(list: [], isNotify: false);
    userPersonalInfoDataList.setList(list: [], isNotify: false);
    userContactInfoDataList.setList(list: [], isNotify: false);
    userBackOfficeInfoDataList.setList(list: [], isNotify: false);

    userPersonalInfoForEditingDataList.setList(list: [], isClear: true, isNotify: false);
    userPersonalInfoEditingEnabled.set(value: false, isNotify: false);

    userContactInfoForEditingDataList.setList(list: [], isClear: true, isNotify: false);
    userContactInfoEditingEnabled.set(value: false, isNotify: false);

    multipleChoicesList.setList(list: [], isClear: true, isNotify: false);
    educationTitlesList.setList(list: [], isClear: true, isNotify: false);

    headerDTOModel.set(value: null, isNotify: true);
  }
}
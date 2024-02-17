import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_response.dart';
import 'package:flutter_instancy_2/backend/profile/profile_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/my_connections/request_model/people_listing_actions_request_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/data_field_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_header_dto_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/user_profile_header_data_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/profile/component/education_tab_screen_view.dart';
import 'package:flutter_instancy_2/views/profile/component/profile_data_fields_screen.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../component/experience_tab_screen_view.dart';

class ConnectionProfileScreen extends StatefulWidget {
  static const String routeName = "/ConnectionProfileScreen";

  final ConnectionProfileScreenNavigationArguments arguments;

  const ConnectionProfileScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<ConnectionProfileScreen> createState() => _ConnectionProfileScreenState();
}

class _ConnectionProfileScreenState extends State<ConnectionProfileScreen> with MySafeState, SingleTickerProviderStateMixin {
  bool isLoading = false;

  late AppProvider appProvider;
  late ProfileProvider profileProvider;
  late ProfileController profileController;

  late int connectionUserId;
  bool isMyProfile = false;

  Future<void>? futureGetData;

  TabController? controller;

  int selectedTabIndex = 0;

  bool isPeopleListingActionPerformed = false;

  void initializations() {
    profileProvider = widget.arguments.profileProvider ?? ProfileProvider();
    profileController = ProfileController(profileProvider: profileProvider);

    isMyProfile = widget.arguments.userId == ApiController().apiDataProvider.getCurrentUserId();
    connectionUserId = widget.arguments.userId;

    futureGetData = getFutureData();
    mySetState();
  }

  Future<void> getCountriesList() async {
    MyPrint.printOnConsole("getCountriesList called");
    await profileController.getMultipleChoicesList(isFromCache: true);
  }

  void initializePersonalDataFromParent() {
    MyPrint.printOnConsole("initializePersonalDataFromParent called");
    profileProvider.userPersonalInfoForEditingDataList.setList(
        list: profileProvider.userPersonalInfoDataList.getList(isNewInstance: false).map((e) {
      DataFieldModel dataFieldModel = DataFieldModel.fromJson(e.toJson());
      dataFieldModel.initializeProfileConfigDataUIControlModel();

      return dataFieldModel;
    }).toList());
  }

  void initializeContactDataFromParent() {
    MyPrint.printOnConsole("initializePersonalDataFromParent called");
    profileProvider.userContactInfoForEditingDataList.setList(
        list: profileProvider.userContactInfoDataList.getList(isNewInstance: false).map((e) {
      DataFieldModel dataFieldModel = DataFieldModel.fromJson(e.toJson());
      dataFieldModel.initializeProfileConfigDataUIControlModel();

      return dataFieldModel;
    }).toList());
  }

  Future<void> getFutureData({bool isGetProfileData = true, bool isGetProfileHeaderData = true}) async {
    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: InstancyComponents.MyProfile);

    List<Future> futures = <Future>[
      if (isGetProfileData)
        profileController.getProfileInfoMain(
          authenticationProvider: Provider.of<AuthenticationProvider>(context, listen: false),
          userId: widget.arguments.userId,
        ),
      if (isGetProfileHeaderData)
        profileController.getProfileHeaderDataAndStoreInProvider(
          requestModel: UserProfileHeaderDataRequestModel(
            intCompID: componentModel?.componentid ?? InstancyComponents.MyProfile,
            intCompInsID: componentModel?.repositoryid ?? 0,
            intProfileUserID: connectionUserId.toString(),
            viewconnection: false.toString(),
          ),
          isFromCache: false,
        ),
    ];

    if (futures.isNotEmpty) await Future.wait(futures);

    mySetState();
  }

  void setImageInProfileProvider(ProfileProvider profileProvider) {
    UserProfileDetailsModel? userProfileDetailsModel = profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;

    if (userProfileDetailsModel != null) {
      AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
      if (successfulUserLoginModel != null) {
        successfulUserLoginModel.image = "${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel.picture}";
      }
      MyPrint.printOnConsole('successfulUserLoginModel.img : ${successfulUserLoginModel?.image}');
      authenticationProvider.setEmailLoginResponseModel(emailLoginResponseModel: successfulUserLoginModel);
    }
  }

  void onPeopleListingActionStarted() {
    isLoading = true;
    mySetState();
  }

  void onPeopleListingActionPerformed({bool isSuccess = false}) {
    isLoading = false;

    if (isSuccess) {
      isPeopleListingActionPerformed = true;
      futureGetData = getFutureData(isGetProfileHeaderData: true, isGetProfileData: false);
    }
    mySetState();
  }

  Future<void> onAddToMyConnectionsTap({required UserProfileHeaderDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await MyConnectionsController(connectionsProvider: MyConnectionsProvider()).addToMyConnection(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: connectionUserId,
        UserName: model.Displayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onRemoveFromMyConnectionsTap({required UserProfileHeaderDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await MyConnectionsController(connectionsProvider: MyConnectionsProvider()).removeFromMyConnection(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: connectionUserId,
        UserName: model.Displayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onAcceptConnectionRequestTap({required UserProfileHeaderDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await MyConnectionsController(connectionsProvider: MyConnectionsProvider()).acceptConnectionRequest(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: connectionUserId,
        UserName: model.Displayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onRejectConnectionRequestTap({required UserProfileHeaderDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await MyConnectionsController(connectionsProvider: MyConnectionsProvider()).rejectConnectionRequest(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: connectionUserId,
        UserName: model.Displayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onSendMessageTap({required UserProfileHeaderDTOModel model}) async {
    bool isNavigated = MessageController(provider: context.read<MessageProvider>()).navigateToUserChatScreenFromOtherScreen(userIdToNavigate: connectionUserId);
    if (isNavigated) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = Provider.of<AppProvider>(context, listen: false);
    controller = TabController(vsync: this, length: 4);
    initializations();
    // getCountriesList();
  }

  @override
  void didUpdateWidget(covariant ConnectionProfileScreen oldWidget) {
    if (widget.arguments.profileProvider != profileProvider || widget.arguments.userId != oldWidget.arguments.userId) {
      initializations();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop || isLoading) return;

        Navigator.pop(context, ConnectionProfileScreenNavigationResponse(isPeopleListingActionPerformed: isPeopleListingActionPerformed));
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: ChangeNotifierProvider<ProfileProvider>.value(
          value: profileProvider,
          child: Scaffold(
            appBar: AppConfigurations().commonAppBar(title: "Profile"),
            body: SafeArea(
              child: Consumer<ProfileProvider>(
                builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                  return futureGetData != null
                      ? FutureBuilder(
                          future: futureGetData,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return getMainBody();
                            } else {
                              return const Center(child: CommonLoader());
                            }
                          },
                        )
                      : getMainBody();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainBody() {
    UserProfileDetailsModel? userProfileDetailsModel = profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;

    // MyPrint.printOnConsole("profileProvider.userPersonalInfoDataList.length:${profileProvider.userPersonalInfoDataList.getList(isNewInstance: false).length}");
    // MyPrint.printOnConsole("profileProvider.userContactInfoDataList.length:${profileProvider.userContactInfoDataList.getList(isNewInstance: false).length}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getBasicProfileDetailsWidget(userProfileDetailsModel: userProfileDetailsModel),
        const SizedBox(height: 0),
        getConnectionStatusActionsWidget(headerDTOModel: profileProvider.headerDTOModel.get()),
        const SizedBox(height: 16),
        // Divider(),
        Expanded(child: getTabBarView())
      ],
    );
  }

  Widget getBasicProfileDetailsWidget({required UserProfileDetailsModel? userProfileDetailsModel}) {
    String firstName = "", lastName = "", shortName = "", imageUrl = "", displayName = "";
    if (userProfileDetailsModel != null) {
      firstName = userProfileDetailsModel.firstname;
      lastName = userProfileDetailsModel.lastname;
      displayName = userProfileDetailsModel.displayname;
      if (firstName.isNotEmpty) shortName = shortName + firstName[0];
      if (lastName.isNotEmpty) shortName = shortName + lastName[0];
      if (displayName.isEmpty) displayName = "$firstName $lastName";
      imageUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: userProfileDetailsModel.picture);
    }
    // MyPrint.printOnConsole("imageUrl:$imageUrl");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getProfileImageWidget(
            imageUrl: imageUrl,
            shortName: shortName,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                  ),
                ),
                const SizedBox(height: 1),
                if ((userProfileDetailsModel?.jobtitle).checkNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      userProfileDetailsModel!.jobtitle,
                      style: themeData.textTheme.labelMedium?.copyWith(
                        // letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        color: Styles.lightTextColor2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //region Profile Image Widget
  Widget getProfileImageWidget({required String imageUrl, required shortName}) {
    if (imageUrl.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: themeData.primaryColor)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CommonCachedNetworkImage(
            imageUrl: MyUtils.getSecureUrl(imageUrl),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => getProfileImageShortNameWidget(shortName: shortName),
          ),
        ),
      );
    } else {
      return getProfileImageShortNameWidget(shortName: shortName);
    }
  }

  Widget getProfileImageShortNameWidget({required String shortName}) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: themeData.primaryColor,
      child: Text(
        shortName,
        style: themeData.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  //endregion

  Widget getConnectionStatusActionsWidget({required UserProfileHeaderDTOModel? headerDTOModel}) {
    if (headerDTOModel == null) {
      return const SizedBox();
    }

    bool isAddToMyConnectionsEnabled = headerDTOModel.intConnStatus == -1;
    bool isRequestSent = headerDTOModel.intConnStatus == 0 && headerDTOModel.AcceptAction.isEmpty && headerDTOModel.RejectAction.isEmpty;
    bool isAcceptConnectionEnabled = headerDTOModel.AcceptAction.isNotEmpty;
    bool isRemoveConnectionEnabled = headerDTOModel.intConnStatus == 1;
    bool isSendMessageEnabled = isRemoveConnectionEnabled;

    List<Widget> children = [
      if (isAddToMyConnectionsEnabled)
        CommonButton(
          onPressed: () {
            onAddToMyConnectionsTap(model: headerDTOModel);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          backGroundColor: themeData.primaryColor,
          text: appProvider.localStr.myconnectionsActionsheetAddtomyconnectionsoption,
          fontSize: 13,
          fontColor: themeData.colorScheme.onPrimary,
          borderRadius: 5,
        ),
      if (isRequestSent)
        CommonButton(
          onPressed: () {},
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          backGroundColor: themeData.textTheme.bodySmall?.color?.withAlpha(20),
          text: appProvider.localStr.myConnectionsActionSheetRequestSentOption,
          // text: "Request Sent",
          fontSize: 13,
          borderRadius: 5,
        ),
      if (isAcceptConnectionEnabled) ...[
        Flexible(
          child: CommonButton(
            onPressed: () {
              onAcceptConnectionRequestTap(model: headerDTOModel);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            backGroundColor: themeData.primaryColor,
            text: appProvider.localStr.myconnectionsActionsheetAcceptconnectionoption,
            fontSize: 13,
            fontColor: themeData.colorScheme.onPrimary,
            borderRadius: 5,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: CommonButton(
            onPressed: () {
              onRejectConnectionRequestTap(model: headerDTOModel);
            },
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            backGroundColor: themeData.textTheme.bodySmall?.color?.withAlpha(20),
            text: appProvider.localStr.myconnectionsActionsheetIgnoreconnectionoption,
            // text: "Reject",
            fontSize: 13,
            borderRadius: 5,
          ),
        ),
      ],
      if (isRemoveConnectionEnabled)
        CommonButton(
          onPressed: () {
            List<InstancyUIActionModel> options = <InstancyUIActionModel>[
              InstancyUIActionModel(
                text: appProvider.localStr.myconnectionsActionsheetRemoveconnectionoption,
                iconData: InstancyIcons.remove,
                onTap: () {
                  Navigator.pop(context);

                  onRemoveFromMyConnectionsTap(model: headerDTOModel);
                },
              ),
            ];

            InstancyUIActions().showAction(
              context: context,
              actions: options,
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          borderColor: Colors.transparent,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
              Text(
                "Connected",
                style: TextStyle(
                  color: themeData.colorScheme.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 15,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      if (isSendMessageEnabled)
        Flexible(
          child: CommonButton(
            onPressed: () {
              onSendMessageTap(model: headerDTOModel);
            },
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            iconData: Icons.send,
            text: appProvider.localStr.myconnectionsActionsheetSendmessageoption,
            backGroundColor: Colors.transparent,
            borderColor: themeData.colorScheme.primary,
            iconColor: themeData.colorScheme.primary,
            fontColor: themeData.colorScheme.primary,
            fontWeight: FontWeight.bold,
            borderWidth: 1.2,
            fontSize: 13,
            iconSize: 15,
          ),
        ),
    ];

    if (children.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget getTabBarView() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          shadowColor: Colors.black.withOpacity(0.3),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: themeData.primaryColor.withOpacity(.5), width: .5),
                ),
              ),
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TabBar(
                        isScrollable: true,
                        controller: controller,
                        // automaticIndicatorColorAdjustment: true,
                        onTap: (int index) {
                          selectedTabIndex = index;
                          setState(() {});
                        },
                        // unselectedLabelStyle: TextStyle(color: Colors.lightGreenAccent),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        labelPadding: const EdgeInsets.only(bottom: 7, left: 8, right: 8),
                        indicatorPadding: const EdgeInsets.only(top: 40),
                        indicator: BoxDecoration(color: themeData.primaryColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5),
                        tabs: [
                          tabTitleWidget(title: "About", assetPath: "assets/profile.png", index: 0),
                          tabTitleWidget(title: "Contact", assetPath: "assets/call.png", index: 1),
                          tabTitleWidget(title: "Experience", assetPath: "assets/experience.png", index: 2),
                          tabTitleWidget(title: "Education", assetPath: "assets/education.png", index: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            // physics:  NeverScrollableScrollPhysics(),
            controller: controller,
            children: <Widget>[
              getAboutTabWidget(),
              getContactTabWidget(),
              getExperienceTabWidget(),
              getEducationTabWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabTitleWidget({String title = "", String assetPath = "", int index = 0}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: assetPath.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Image.asset(
                assetPath,
                height: 15,
                width: 15,
                fit: BoxFit.cover,
                color: controller?.index == index ? themeData.primaryColor : Styles.indicatorIconColor,
              ),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }

  Widget getAboutTabWidget() {
    // return const AboutTabView();

    bool isEditingEnabled = profileProvider.userPersonalInfoEditingEnabled.get();

    return ProfileDataFieldsScreen(
      list: isEditingEnabled ? profileProvider.userPersonalInfoForEditingDataList.getList(isNewInstance: false) : profileProvider.userPersonalInfoDataList.getList(isNewInstance: false),
      showEdit: false,
      isEditingEnabled: isEditingEnabled,
      onEditing: (bool isEditing) {
        initializePersonalDataFromParent();
        profileProvider.userPersonalInfoEditingEnabled.set(value: !isEditing);
      },
      onSaveChanges: (List<DataFieldModel> list) async {
        MyPrint.printOnConsole("On Save Changes Called with list:$list");
        profileProvider.userPersonalInfoEditingEnabled.set(value: false);

        isLoading = true;
        mySetState();
        AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel != null) {
          String userName = successfulUserLoginModel.username;
          for (var element in list) {
            MyPrint.printOnConsole("dataFieldName: ${element.datafieldname}");
            if (element.datafieldname == "FirstName") {
              userName = element.valueName;
            } else if (element.datafieldname == "LastName") {
              userName += " ${element.valueName}";
            } else if (element.datafieldname == "DisplayName") {
              if (element.valueName.isNotEmpty) {
                userName = element.valueName;
              }
            }
          }
          successfulUserLoginModel.username = userName;
        }
        authenticationProvider.setEmailLoginResponseModel(emailLoginResponseModel: successfulUserLoginModel);
        bool isUpdated = await profileController.updateProfileDetails(
          list,
          componentId: widget.arguments.componentId,
          componentInsId: widget.arguments.componentInstanceId,
        );

        isLoading = false;
        if (isUpdated) {
          futureGetData = getFutureData();
        }

        mySetState();
      },
      choicesList: [],
    );
  }

  Widget getContactTabWidget() {
    // return ContactTabScreenView();

    bool isEditingEnabled = profileProvider.userContactInfoEditingEnabled.get();

    return ProfileDataFieldsScreen(
      list: isEditingEnabled ? profileProvider.userContactInfoForEditingDataList.getList(isNewInstance: false) : profileProvider.userContactInfoDataList.getList(isNewInstance: false),
      showEdit: false,
      isEditingEnabled: isEditingEnabled,
      onEditing: (bool isEditing) {
        initializeContactDataFromParent();
        profileProvider.userContactInfoEditingEnabled.set(value: !isEditing);
      },
      onSaveChanges: (List<DataFieldModel> list) async {
        MyPrint.printOnConsole("On Save Changes Called with list:$list");
        profileProvider.userContactInfoEditingEnabled.set(value: false);

        isLoading = true;
        mySetState();

        bool isUpdated = await profileController.updateProfileDetails(list, componentId: widget.arguments.componentId, componentInsId: widget.arguments.componentInstanceId);

        isLoading = false;
        if (isUpdated) {
          futureGetData = getFutureData();
        }
        mySetState();
      },
      choicesList: [],
    );
  }

  Widget getExperienceTabWidget() {
    return ExperienceTabScreenView(
      experienceData: profileProvider.userExperienceData.getList(isNewInstance: false),
      showAdd: false,
      showEdit: false,
      onAddEditData: () {
        futureGetData = getFutureData();
        mySetState();
      },
    );
  }

  Widget getEducationTabWidget() {
    return EducationTabScreenView(
      educationData: profileProvider.userEducationData.getList(isNewInstance: false),
      showAdd: false,
      showEdit: false,
      onAddEditData: () {
        futureGetData = getFutureData();
        mySetState();
      },
      profileProvider: profileProvider,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_controller.dart';
import 'package:flutter_instancy_2/models/share/data_model/share_connection_user_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../backend/configurations/app_configuration_operations.dart';
import '../../backend/navigation/navigation.dart';
import '../../backend/share/share_provider.dart';
import '../common/components/common_button.dart';
import '../common/components/common_loader.dart';

class ShareWithConnectionsScreen extends StatefulWidget {
  static const String routeName = "/ShareWithConnectionsScreen";

  final ShareWithConnectionsScreenNavigationArguments arguments;

  const ShareWithConnectionsScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<ShareWithConnectionsScreen> createState() => _ShareWithConnectionsScreenState();
}

class _ShareWithConnectionsScreenState extends State<ShareWithConnectionsScreen> with MySafeState {
  late ThemeData themeData;

  late AppProvider appProvider;
  late ShareProvider shareProvider;
  late ShareController shareController;

  final TextEditingController searchController = TextEditingController();

  Future<void> getData({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
  }) async {
    await shareController.getConnectionsList(isRefresh: isRefresh, isGetFromCache: isGetFromCache, isNotify: isNotify);
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    shareProvider = widget.arguments.shareProvider ?? ShareProvider();
    shareController = ShareController(shareProvider: shareProvider);

    shareProvider.selectedConnectionsList.setList(list: [], isClear: true, isNotify: false);
    getData(isRefresh: false, isGetFromCache: true, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShareProvider>.value(value: shareProvider),
      ],
      child: Consumer<ShareProvider>(
        builder: (BuildContext context, ShareProvider shareProvider, Widget? child) {
          return Scaffold(
            appBar: getAppBar(shareProvider: shareProvider),
            body: getMainBody(shareProvider: shareProvider),
            bottomNavigationBar: getBottomBarButtonsRow(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? getAppBar({required ShareProvider shareProvider}) {
    int selectedConnectionsLength = shareProvider.selectedConnectionsLength;

    return AppBar(
      centerTitle: true,
      title: Text(
        selectedConnectionsLength == 0 ? "Share With Connections" : "$selectedConnectionsLength Selected",
        // style: themeData.textTheme.titleLarge?.copyWith(
        //   fontWeight: FontWeight.w600,
        //   letterSpacing: 0.8
        // ),
      ),
      elevation: 0,
    );
  }

  Widget getMainBody({required ShareProvider shareProvider}) {
    if (shareProvider.isConnectionsLoading.get()) {
      return const Center(
        child: CommonLoader(),
      );
    }
    else if (shareProvider.mainConnectionsLength == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          getData(
            isRefresh: true,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Center(
              child: Text(
                appProvider.localStr.commoncomponentLabelNodatalabel,
              ),
            ),
          ],
        ),
      );
    }

    // MyPrint.printOnConsole("My Learning Contents length In MyLearningScreen().getMyLearningContentsListView():${contents.length}");

    List<ShareConnectionUserModel> connections = shareProvider.searchedConnectionsList.getList(isNewInstance: false);
    List<int> selectedConnections = shareProvider.selectedConnectionsList.getList(isNewInstance: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10).copyWith(bottom: 0),
      child: Column(
        children: [
          getSearchTextField(),
          const SizedBox(height: 10,),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getData(
                  isRefresh: true,
                  isNotify: true,
                );
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: connections.length,
                itemBuilder: (BuildContext context, int index) {
                  ShareConnectionUserModel userModel = connections[index];

                  return getConnectionUserCard(
                    userModel: userModel,
                    isSelected: selectedConnections.contains(userModel.userId),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchTextField() {
    return CommonTextFormField(
      controller: searchController,
      hintText: "Search",
      isOutlineInputBorder: true,
      borderRadius: 100,
      prefixWidget: const Icon(Icons.search),
      suffixWidget: searchController.text.isNotEmpty ? GestureDetector(
        onTap: () {
          searchController.clear();
          shareProvider.searchString.set(value: "", isNotify: false);
          shareController.initializeSearchedConnectionsFromString();
          MyUtils.hideShowKeyboard(isHide: true);
        },
        child: const Icon(Icons.close),
      ) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      onSubmitted: (val) {
        shareProvider.searchString.set(value: val, isNotify: false);
        shareController.initializeSearchedConnectionsFromString();
      },
      onChanged: (val) {
        MyPrint.printOnConsole("onChanged called with val:$val");
        shareProvider.searchString.set(value: val, isNotify: false);
        shareController.initializeSearchedConnectionsFromString();
      },
    );
  }

  Widget getConnectionUserCard({required ShareConnectionUserModel userModel, required bool isSelected}) {
    String imageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: userModel.usersImage,
      ),
    );
    // MyPrint.printOnConsole("imageUrl:$imageUrl");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: GestureDetector(
        onTap: () {
          shareProvider.addRemoveUserInSelectedUsersList(userId: userModel.userId, isAdd: !isSelected);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isSelected ? Colors.grey.shade400 : Colors.grey,
            ),
            color: isSelected ? Colors.grey.shade200 : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipOval(
                        child: CommonCachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                          errorIconSize: 30,
                        ),
                      ),
                      if(isSelected) Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: themeData.colorScheme.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: themeData.primaryColor,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(userModel.userName.isNotEmpty) Text(
                        userModel.userName,
                        style: themeData.textTheme.bodyMedium,
                        /*style: TextStyle(
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),*/
                      ),
                      if(userModel.addressCountry.isNotEmpty) Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          userModel.addressCountry,
                          style: themeData.textTheme.labelMedium?.copyWith(
                            color: themeData.textTheme.labelMedium!.color!.withOpacity(0.54),
                          ),
                          // style: TextStyle(color: AppColors.getAppTextColor().withOpacity(0.54)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? getBottomBarButtonsRow() {
    int selectedConnectionsLength = shareProvider.selectedConnectionsLength;

    if(selectedConnectionsLength <= 0) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backGroundColor: Colors.white,
              borderColor: themeData.primaryColor,
              fontColor: themeData.primaryColor,
              fontWeight: FontWeight.w600,
              // isPrimary: false,
              text: "Cancel",
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                NavigationController.navigateToShareWithPeopleScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: ShareWithPeopleScreenNavigationArguments(
                    shareContentType: widget.arguments.shareContentType,
                    contentId: widget.arguments.contentId,
                    contentName: widget.arguments.contentName,
                    topicId: widget.arguments.topicId,
                    forumId: widget.arguments.forumId,
                    isSuggestToConnections: true,
                    userIds: shareProvider.selectedConnectionsList.getList(),
                    scoId: widget.arguments.scoId,
                    objecttypeId: widget.arguments.objecttypeId,
                  ),
                );
              },
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              fontColor: Colors.white,
              fontWeight: FontWeight.w600,
              // isPrimary: true,
              text: "Share",
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_controller.dart';
import 'package:flutter_instancy_2/models/share/data_model/share_connection_user_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../backend/navigation/navigation.dart';
import '../../backend/share/share_provider.dart';
import '../common/components/common_button.dart';
import '../common/components/common_loader.dart';

class RecommendToScreen extends StatefulWidget {
  static const String routeName = "/RecommendToScreen";

  final RecommendToScreenNavigationArguments arguments;

  const RecommendToScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<RecommendToScreen> createState() => _RecommendToScreenState();
}

class _RecommendToScreenState extends State<RecommendToScreen> with MySafeState {
  late AppProvider appProvider;
  late ShareProvider shareProvider;
  late ShareController shareController;

  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  Future<void> getData({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
  }) async {
    await shareController.getRecommendToUserList(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
      contentId: widget.arguments.contentId,
    );
  }

  Future<void> onRecommendButtonClick() async {
    isLoading = true;
    mySetState();

    String selectedUserId = shareProvider.recommendSelectedUserList.getList().join(",");
    String contentId = widget.arguments.contentId;
    String contentName = widget.arguments.contentName;
    int componentId = widget.arguments.componentId;

    await shareController.insertRecommendedContent(recommendedTo: selectedUserId, componentId: widget.arguments.componentId, contentId: contentId, addtoMyLearning: "0");

    await shareController.insertRecommendedContentNotification(componentId: componentId, contentId: contentId, addtoMyLearning: "0", recommendedTo: selectedUserId);

    await shareController.sendMailToRecommendedUsers(contentId: contentId, contentName: contentName, componentId: componentId, selectedUser: selectedUserId);

    shareProvider.recommendSelectedUserList.setList(list: [], isClear: true, isNotify: false);

    isLoading = false;
    mySetState();

    await getData(isRefresh: true, isGetFromCache: false, isNotify: true);
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    shareProvider = widget.arguments.shareProvider ?? ShareProvider();
    shareController = ShareController(shareProvider: shareProvider);

    shareProvider.recommendSelectedUserList.setList(list: [], isClear: true, isNotify: false);
    getData(isRefresh: true, isGetFromCache: false, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShareProvider>.value(value: shareProvider),
      ],
      child: Consumer<ShareProvider>(
        builder: (BuildContext context, ShareProvider shareProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: getAppBar(shareProvider: shareProvider),
              body: getMainBody(shareProvider: shareProvider),
              bottomNavigationBar: getBottomBarButtonsRow(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? getAppBar({required ShareProvider shareProvider}) {
    return AppBar(
      centerTitle: true,
      title: Text(
        // selectedConnectionsLength == 0 ? "Recommend To" : "$selectedConnectionsLength Selected",
        "Recommend To",
        style: themeData.textTheme.titleLarge?.copyWith(color: themeData.colorScheme.onPrimary, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      ),
      elevation: 0,
      backgroundColor: themeData.primaryColor,
      iconTheme: themeData.iconTheme.copyWith(
        color: themeData.colorScheme.onPrimary,
      ),
    );
  }

  Widget getMainBody({required ShareProvider shareProvider}) {
    if (shareProvider.isRecommendConnectionsLoading.get()) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (shareProvider.recommendedUserListLength == 0) {
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

    List<ShareConnectionUserModel> connections = shareProvider.recommendedSearchedUserList.getList(isNewInstance: false);
    List<int> selectedConnections = shareProvider.recommendSelectedUserList.getList(isNewInstance: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10).copyWith(bottom: 0),
      child: Column(
        children: [
          getSearchTextField(),
          const SizedBox(
            height: 10,
          ),
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
                    isSelected: userModel.isRecommended == 1 || userModel.isContentInMyLearning == 1 || selectedConnections.contains(userModel.userId),
                    isAlreadyAddedToMyLearning: userModel.isRecommended == 1 || userModel.isContentInMyLearning == 1,
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
      suffixWidget: searchController.text.isNotEmpty
          ? GestureDetector(
              onTap: () {
                searchController.clear();
                shareProvider.recommendSearchString.set(value: "", isNotify: false);
                shareController.initializeRecommendSearchedUserFromString();
                MyUtils.hideShowKeyboard(isHide: true);
              },
              child: const Icon(Icons.close),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      onSubmitted: (val) {
        shareProvider.recommendSearchString.set(value: val, isNotify: false);
        shareController.initializeRecommendSearchedUserFromString();
      },
      onChanged: (val) {
        MyPrint.printOnConsole("onChanged called with val:$val");
        shareProvider.recommendSearchString.set(value: val, isNotify: false);
        shareController.initializeRecommendSearchedUserFromString();
      },
    );
  }

  Widget getConnectionUserCard({required ShareConnectionUserModel userModel, required bool isSelected, required bool isAlreadyAddedToMyLearning}) {
    String imageUrl = userModel.picture.isEmpty
        ? 'https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg'
        : (userModel.picture.startsWith("http") ? userModel.picture : "${appProvider.siteConfigurations.siteUrl}${userModel.picture}");
    MyPrint.printOnConsole("userModel.isRecommended:${userModel.isRecommended}");
    // isSelected = (userModel.isRecommended == 1 || userModel.isContentInMyLearning == 1);
    // imageUrl = "https://instancylivesites.blob.core.windows.net/upgradedenterprise/content/sitefiles/374/profileimages/374_profile-pic%20(1).png";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      // color: Colors.red,
      child: GestureDetector(
        onTap: isAlreadyAddedToMyLearning
            ? null
            : () {
                shareProvider.addRemoveUserInRecommendSelectedUserList(userId: userModel.userId, isAdd: !isSelected);
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isAlreadyAddedToMyLearning
                  ? Colors.grey.shade400
                  : isSelected
                      ? Colors.grey.shade400
                      : Colors.grey,
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
                        ),
                      ),
                      if (isSelected)
                        Container(
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
                      if (userModel.userName.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              userModel.userName,
                              style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: isAlreadyAddedToMyLearning ? Colors.grey : Colors.black),
                              /*style: TextStyle(
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),*/
                            ),
                            if (userModel.isContentInMyLearning == 1)
                              Text(
                                " (Content already in My Learning)",
                                style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13, color: isAlreadyAddedToMyLearning ? Colors.grey : Colors.black),
                              ),
                            if (userModel.isRecommended == 1 && userModel.isContentInMyLearning == 0)
                              Text(
                                " (Content already recommended)",
                                style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13, color: isAlreadyAddedToMyLearning ? Colors.grey : Colors.black),
                              ),
                          ],
                        ),
                      if (userModel.addressCountry.isNotEmpty)
                        Container(
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
    int selectedConnectionsLength = shareProvider.recommendSelectedUserListLength;
    // MyPrint.printOnConsole("selectedConnectionsLength:$selectedConnectionsLength");

    if (selectedConnectionsLength <= 0) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
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
          const SizedBox(width: 25),
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                onRecommendButtonClick();
                // NavigationController.navigateToShareWithPeopleScreen(
                //   navigationOperationParameters: NavigationOperationParameters(
                //     context: context,
                //     navigationType: NavigationType.pushNamed,
                //   ),
                //   arguments: ShareWithPeopleScreenNavigationArguments(
                //     shareContentType: widget.arguments.shareContentType,
                //     contentId: widget.arguments.contentId,
                //     contentName: widget.arguments.contentName,
                //     isSuggestToConnections: true,
                //     userIds: shareProvider.recommendSelectedUserList.getList(),
                //   ),
                // );
              },
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              fontColor: Colors.white,
              fontWeight: FontWeight.w600,
              // isPrimary: true,
              text: "Recommend",
            ),
          ),
        ],
      ),
    );
  }
}

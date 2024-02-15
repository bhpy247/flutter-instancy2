import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/my_connections/data_model/people_listing_item_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../api/api_controller.dart';
import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class PeopleTabWidget extends StatefulWidget {
  final String contentId;
  final String createdByUserId;
  final MyConnectionsProvider myConnectionsProvider;

  const PeopleTabWidget({
    Key? key,
    required this.contentId,
    required this.createdByUserId,
    required this.myConnectionsProvider,
  }) : super(key: key);

  @override
  State<PeopleTabWidget> createState() => _PeopleTabWidgetState();
}

class _PeopleTabWidgetState extends State<PeopleTabWidget> {
  late ThemeData themeData;

  late AppProvider appProvider;

  late MyConnectionsProvider myConnectionsProvider;
  late MyConnectionsController myConnectionsController;

  void initializations({
    bool isNotify = false,
  }) {
    myConnectionsProvider = widget.myConnectionsProvider;
    myConnectionsController = MyConnectionsController(connectionsProvider: myConnectionsProvider);

    PaginationModel paginationModel = myConnectionsProvider.peopleListPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && myConnectionsProvider.peopleListLength == 0) {
      myConnectionsProvider.peopleListContentId.set(value: widget.contentId, isNotify: false);
      myConnectionsController.getPeopleList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: isNotify,
      );
    }
  }

  Future<void> showMoreActionForProfile({required PeopleListingItemDTOModel userModel}) async {
    MyPrint.printOnConsole("PeopleTabWidget().showMoreActionForProfile() called with userId:${userModel.ObjectID}");

    InstancyUIActions().showAction(
      context: context,
      actions: [
        InstancyUIActionModel(
          onTap: () {
            Navigator.pop(context);

            navigateToProfileDetails(userModel: userModel);
          },
          text: appProvider.localStr.myconnectionsActionsheetViewprofileoption,
          iconData: InstancyIcons.viewProfile,
          iconSize: 30,
        ),
      ],
    );
  }

  Future<void> navigateToProfileDetails({required PeopleListingItemDTOModel userModel}) async {
    MyPrint.printOnConsole("PeopleTabWidget().navigateToProfileDetails() called with userId:${userModel.ObjectID}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;
    if (apiUrlConfigurationProvider.getCurrentUserId() == -1) {
      return;
    }

    NavigationController.navigateToConnectionProfileScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: ConnectionProfileScreenNavigationArguments(
        profileProvider: null,
        userId: userModel.ObjectID,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    initializations();
  }

  @override
  void didUpdateWidget(covariant PeopleTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (myConnectionsProvider != widget.myConnectionsProvider) {
      initializations(isNotify: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Column(
      children: [
        getAuthorView(),
        Expanded(
          child: getConnectionView(),
        ),
      ],
    );
  }

  //region getAuthorView
  Widget getAuthorView() {
    String createdByUserId = widget.createdByUserId;

    if (createdByUserId.isEmpty) {
      return const SizedBox();
    }

    Iterable<PeopleListingItemDTOModel> peopleList = myConnectionsProvider.peopleList.getList(isNewInstance: false).where((element) => element.ObjectID.toString() == createdByUserId);
    if (peopleList.isEmpty) {
      return const SizedBox();
    }

    PeopleListingItemDTOModel authorModel = peopleList.first;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.circleUser,
                size: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Author",
                style: themeData.textTheme.bodySmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getAuthorProfileView(authorModel: authorModel),
        ],
      ),
    );
  }

  Widget getAuthorProfileView({required PeopleListingItemDTOModel authorModel}) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: authorModel.MemberProfileImage));
    // MyPrint.printOnConsole("Track Discussion Thumbnail Image Url:$imageUrl");

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.transparent)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: imageUrl,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            authorModel.UserDisplayname,
            style: themeData.textTheme.titleSmall,
          ),
        ),
        IconButton(
          onPressed: () {
            showMoreActionForProfile(userModel: authorModel);
          },
          icon: const Icon(
            Icons.more_vert,
            size: 25,
            // color: Colors.grey,
          ),
        ),
      ],
    );
  }

  //endregion

  //region connectionView
  Widget getConnectionView() {
    return Column(
      children: [
        if (!myConnectionsProvider.peopleListPaginationModel.get().isFirstTimeLoading)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 32,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Connection",
                  style: themeData.textTheme.bodySmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        Expanded(child: getConnectionList())
      ],
    );
  }

  Widget getConnectionList() {
    PaginationModel paginationModel = myConnectionsProvider.peopleListPaginationModel.get();
    if (paginationModel.isFirstTimeLoading) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    if (!paginationModel.isLoading && myConnectionsProvider.peopleListLength == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          myConnectionsController.getPeopleList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            Center(
              child: Text(
                appProvider.localStr.commoncomponentLabelNodatalabel,
              ),
            ),
          ],
        ),
      );
    }

    List<PeopleListingItemDTOModel> peopleList = myConnectionsProvider.peopleList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: () async {
        myConnectionsController.getPeopleList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: peopleList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && paginationModel.isLoading) || (index == peopleList.length)) {
            if (paginationModel.isLoading) {
              return const CommonLoader(
                isCenter: true,
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (peopleList.length - paginationModel.refreshLimit)) {
            if (paginationModel.hasMore && !paginationModel.isLoading) {
              myConnectionsController.getPeopleList(
                isRefresh: false,
                isGetFromCache: false,
                isNotify: false,
              );
            }
          }

          PeopleListingItemDTOModel model = peopleList[index];
          if (model.ObjectID.toString() == widget.createdByUserId) {
            return const SizedBox();
          } else {
            return getConnectionData(model: model);
          }
        },
      ),
    );
  }

  Widget getConnectionData({required PeopleListingItemDTOModel model}) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.MemberProfileImage));
    // MyPrint.printOnConsole("Track Discussion Thumbnail Image Url:$imageUrl");

    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 17, right: 17),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5))),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.transparent)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CommonCachedNetworkImage(
                imageUrl: imageUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.UserDisplayname,
                  style: themeData.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showMoreActionForProfile(userModel: model);
            },
            icon: const Icon(
              Icons.more_vert,
              size: 25,
              // color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
//endregion
}

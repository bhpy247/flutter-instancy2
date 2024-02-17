import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_response.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/my_connections/data_model/people_listing_item_dto_model.dart';
import 'package:flutter_instancy_2/models/my_connections/request_model/people_listing_actions_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/my_connections/components/connection_list_user_card.dart';
import 'package:provider/provider.dart';

class ConnectionsListScreen extends StatefulWidget {
  final MyConnectionsProvider? myConnectionsProvider;
  final String filterType;
  final int componentId;
  final int componentInsId;
  final void Function()? onPeopleListingActionPerformed;
  final void Function({required bool isLoading})? setParentLoading;

  const ConnectionsListScreen({
    super.key,
    required this.myConnectionsProvider,
    required this.filterType,
    required this.componentId,
    required this.componentInsId,
    this.onPeopleListingActionPerformed,
    this.setParentLoading,
  });

  @override
  State<ConnectionsListScreen> createState() => _ConnectionsListScreenState();
}

class _ConnectionsListScreenState extends State<ConnectionsListScreen> with MySafeState {
  late AppProvider appProvider;
  late MyConnectionsProvider myConnectionsProvider;
  late MyConnectionsController myConnectionsController;

  late int componentId;
  late int componentInsId;

  TextEditingController textEditingController = TextEditingController();

  Future<void> getConnectionsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      myConnectionsController.getPeopleList(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        filterType: widget.filterType,
        componentId: componentId,
        componentInstanceId: componentInsId,
      ),
    ]);
  }

  Future<void> navigateToProfileDetails({required PeopleListingItemDTOModel userModel}) async {
    MyPrint.printOnConsole("PeopleTabWidget().navigateToProfileDetails() called with userId:${userModel.ObjectID}");

    if (userModel.ViewProfileAction.isEmpty) {
      MyPrint.printOnConsole("Returning from PeopleTabWidget().navigateToProfileDetails() because View Profile Not Enabled");
      return;
    }

    ConnectionProfileScreenNavigationResponse navigationResponse = await NavigationController.navigateToConnectionProfileScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: ConnectionProfileScreenNavigationArguments(
        profileProvider: null,
        userId: userModel.ObjectID,
      ),
    );
    MyPrint.printOnConsole("ConnectionProfileScreenNavigationResponse:$navigationResponse");

    if (navigationResponse.isPeopleListingActionPerformed) {
      onPeopleListingActionPerformed(isSuccess: true);
    }
  }

  Future<void> onCardTap({required PeopleListingItemDTOModel model}) async {
    navigateToProfileDetails(userModel: model);
  }

  Future<void> onAddToMyConnectionsTap({required PeopleListingItemDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await myConnectionsController.addToMyConnection(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: model.ObjectID,
        UserName: model.UserDisplayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onRemoveFromMyConnectionsTap({required PeopleListingItemDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await myConnectionsController.removeFromMyConnection(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: model.ObjectID,
        UserName: model.UserDisplayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onAcceptConnectionRequestTap({required PeopleListingItemDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await myConnectionsController.acceptConnectionRequest(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: model.ObjectID,
        UserName: model.UserDisplayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onRejectConnectionRequestTap({required PeopleListingItemDTOModel model}) async {
    onPeopleListingActionStarted();

    bool isSuccess = await myConnectionsController.rejectConnectionRequest(
      requestModel: PeopleListingActionsRequestModel(
        SelectedObjectID: model.ObjectID,
        UserName: model.UserDisplayname,
      ),
      context: context,
    );

    MyPrint.printOnConsole("isSuccess:$isSuccess");

    onPeopleListingActionPerformed(isSuccess: isSuccess);
  }

  Future<void> onSendMessageTap({required PeopleListingItemDTOModel model}) async {
    MessageController(provider: context.read<MessageProvider>()).navigateToUserChatScreenFromOtherScreen(userIdToNavigate: model.ObjectID);
  }

  void onPeopleListingActionStarted() {
    if (widget.setParentLoading != null) {
      widget.setParentLoading!(isLoading: true);
    }
  }

  void onPeopleListingActionPerformed({bool isSuccess = false}) {
    if (widget.setParentLoading != null) {
      widget.setParentLoading!(isLoading: false);
    }

    if (isSuccess) {
      if (widget.onPeopleListingActionPerformed != null) {
        widget.onPeopleListingActionPerformed!();
      }

      getConnectionsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    myConnectionsProvider = widget.myConnectionsProvider ?? MyConnectionsProvider();
    myConnectionsController = MyConnectionsController(connectionsProvider: myConnectionsProvider);

    componentId = widget.componentId;
    componentInsId = widget.componentInsId;

    textEditingController.text = myConnectionsProvider.peopleListSearchString.get();

    if (myConnectionsProvider.isPeopleListingActionPerformed.get()) {
      myConnectionsProvider.isPeopleListingActionPerformed.set(value: false, isNotify: false);
      getConnectionsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    } else if (myConnectionsProvider.peopleListLength == 0) {
      getConnectionsList(
        isRefresh: false,
        isGetFromCache: true,
        isNotify: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyConnectionsProvider>.value(value: myConnectionsProvider),
      ],
      child: Consumer<MyConnectionsProvider>(
        builder: (BuildContext context, MyConnectionsProvider myConnectionsProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: myConnectionsProvider.isLoading.get(),
            child: Scaffold(
              body: getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        getSearchTextFromField(),
        Expanded(
          child: getConnectionsListView(),
        )
      ],
    );
  }

  Widget getSearchTextFromField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CommonTextFormField(
              isOutlineInputBorder: true,
              borderRadius: 30,
              onChanged: (val) {
                mySetState();
              },
              controller: textEditingController,
              contentPadding: EdgeInsets.zero,
              hintText: appProvider.localStr.commoncomponentLabelSearchlabel,
              suffixWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textEditingController.text.checkNotEmpty)
                    InkWell(
                      onTap: () {
                        textEditingController.clear();
                        myConnectionsProvider.peopleListSearchString.set(value: "", isNotify: false);
                        getConnectionsList(
                          isRefresh: true,
                          isGetFromCache: false,
                          isNotify: true,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.clear,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                ],
              ),
              prefixWidget: const Icon(Icons.search),
              onSubmitted: (String? val) {
                myConnectionsProvider.peopleListSearchString.set(value: val ?? "", isNotify: false);
                getConnectionsList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getConnectionsListView() {
    return getConnectionsListViewWidget(
      paginationModel: myConnectionsProvider.peopleListPaginationModel.get(),
      onRefresh: () async {
        getConnectionsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getConnectionsList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
        Future.delayed(const Duration(milliseconds: 10), () {
          mySetState();
        });
      },
    );
  }

  Widget getConnectionsListViewWidget({
    required PaginationModel paginationModel,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    if (paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!paginationModel.isLoading && myConnectionsProvider.peopleList.length == 0) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: AppConfigurations.commonNoDataView(),
            ),
          ],
        ),
      );
    }

    List<PeopleListingItemDTOModel> peopleList = myConnectionsProvider.peopleList.getList(isNewInstance: false);

    bool isShowListView = myConnectionsProvider.isShowListView.get();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${myConnectionsProvider.maxPeopleListCount.get()} Connections",
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  myConnectionsProvider.isShowListView.set(value: !isShowListView, isNotify: true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    isShowListView ? Icons.grid_on : Icons.list,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: isShowListView
                ? getListViewWidget(
                    peopleList: peopleList,
                    paginationModel: paginationModel,
                    onPagination: onPagination,
                  )
                : getGridViewWidget(
                    peopleList: peopleList,
                    paginationModel: paginationModel,
                    onPagination: onPagination,
                  ),
          ),
        ),
        /*if (!isShowListView && paginationModel.isLoading)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(
              child: CommonLoader(
                size: 70,
              ),
            ),
          ),*/
      ],
    );
  }

  Widget getListViewWidget({
    required List<PeopleListingItemDTOModel> peopleList,
    required PaginationModel paginationModel,
    required Future<void> Function() onPagination,
  }) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: peopleList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if ((index == 0 && peopleList.isEmpty) || index == peopleList.length) {
          if (paginationModel.isLoading) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: const Center(
                child: CommonLoader(
                  size: 70,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }

        if (index > (peopleList.length - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
          onPagination();
        }

        PeopleListingItemDTOModel model = peopleList[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: getUserCardWidget(model: model),
        );
      },
    );
  }

  Widget getGridViewWidget({
    required List<PeopleListingItemDTOModel> peopleList,
    required PaginationModel paginationModel,
    required Future<void> Function() onPagination,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // MyPrint.printOnConsole("maxWidth:${constraints.maxWidth}");

        int crossAxisCount = switch (constraints.maxWidth) {
          < 600 => 2,
          < 750 => 3,
          < 1000 => 4,
          < 1200 => 5,
          < 1400 => 6,
          < 1600 => 7,
          < 1800 => 8,
          < 2000 => 9,
          < 2200 => 10,
          < 2400 => 11,
          < 2600 => 12,
          < 2800 => 13,
          < 3000 => 14,
          < 3200 => 15,
          < 3400 => 16,
          < 3600 => 17,
          _ => 2,
        };

        int totalRows = (peopleList.length / crossAxisCount).ceil();

        const double crossAxisSpacing = 10;
        const double mainAxisSpacing = 10;

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: totalRows + 1,
          itemBuilder: (BuildContext context, int index) {
            if ((index == 0 && peopleList.isEmpty) || index == totalRows) {
              if (paginationModel.isLoading) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Center(
                    child: CommonLoader(
                      size: 70,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }

            int index1 = index * crossAxisCount;
            // MyPrint.printOnConsole("index1:$index1");

            int lastIndex = index1;

            List<PeopleListingItemDTOModel> models = <PeopleListingItemDTOModel>[];
            for (int i = 0; i < crossAxisCount; i++) {
              int itemIndex = index1 + i;

              if (itemIndex < peopleList.length) {
                lastIndex = itemIndex;
                models.add(peopleList[itemIndex]);
              }
            }

            if (lastIndex > (peopleList.length - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
              onPagination();
            }

            List<Widget> children = <Widget>[];

            for (PeopleListingItemDTOModel model in models) {
              children.add(Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: mainAxisSpacing),
                  child: AspectRatio(
                    aspectRatio: 0.93,
                    child: getUserCardWidget(model: model),
                  ),
                ),
              ));
            }
            if (children.length < crossAxisCount) {
              children.addAll(List.generate(crossAxisCount - children.length, (index) {
                return const Expanded(
                  child: SizedBox(),
                );
              }));
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: crossAxisSpacing),
              child: Row(
                children: children,
              ),
            );
          },
        );
      },
    );
  }

  Widget getUserCardWidget({required PeopleListingItemDTOModel model}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ConnectionListUserCard(
        model: model,
        isListViewMode: myConnectionsProvider.isShowListView.get(),
        onCardTap: onCardTap,
        onAddToMyConnectionsTap: onAddToMyConnectionsTap,
        onRemoveFromMyConnectionsTap: onRemoveFromMyConnectionsTap,
        onAcceptConnectionRequestTap: onAcceptConnectionRequestTap,
        onRejectConnectionRequestTap: onRejectConnectionRequestTap,
        onSendMessageTap: onSendMessageTap,
      ),
    );
  }
}

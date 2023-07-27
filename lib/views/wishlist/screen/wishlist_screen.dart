import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/models/catalog/data_model/catalog_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/Catalog/catalog_provider.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/event/event_controller.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/catalog/catalog_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../catalog/components/catalogContentListComponent.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class WishListScreen extends StatefulWidget {
  static const String routeName = "/WishListScreen";
  final WishListScreenNavigationArguments arguments;

  const WishListScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with MySafeState {
  TextEditingController textEditingController = TextEditingController();

  Future? getContentData;
  late CatalogProvider catalogProvider;
  late CatalogController catalogController;
  late AppProvider appProvider;
  bool isLoading = false;
  int componentId = 0, componentInstanceId = 0;
  ScrollController catalogContentScrollController = ScrollController();

  void initialization() {
    catalogProvider = widget.arguments.catalogProvider ?? CatalogProvider();
    catalogController = CatalogController(provider: catalogProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);

    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;
    MyPrint.printOnConsole("componentId: $componentId componentinstance $componentInstanceId");

    if (catalogProvider.wishlistContentsLength == 0) {
      getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    }
    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      catalogController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }
  }

  Future<void> getCatalogContentsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    catalogController.getWishListContentsListFromApi(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
  }
  CatalogUIActionCallbackModel getCatalogUIActionCallbackModel({
    required CatalogCourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return CatalogUIActionCallbackModel(
      onViewTap: primaryAction == InstancyContentActionsEnum.View ? null : () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onViewTap
      },
      onAddToMyLearningTap: primaryAction == InstancyContentActionsEnum.AddToMyLearning ? null : () async {
        if(isSecondaryAction) Navigator.pop(context);
        addContentToMyLearning(model: model);
      },
      onBuyTap: primaryAction == InstancyContentActionsEnum.Buy ? null : () {
        if(isSecondaryAction) Navigator.pop(context);

        catalogController.buyCourse(context: context);
      },
      onEnrollTap: () async {
        if(isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(model: model);
      },
      onDetailsTap: () async {
        if(isSecondaryAction) Navigator.pop(context);

        dynamic value = await NavigationController.navigateToCourseDetailScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: CourseDetailScreenNavigationArguments(
            contentId: model.ContentID,
            componentId: componentId,
            componentInstanceId: componentInstanceId,
            userId: model.SiteUserID,
            screenType: InstancyContentScreenType.Catalog,
          ),
        );

        if (value == true) {
          getContentData = getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onIAmInterestedTap:() async {

      },
      onContactTap:() async {

      },
      onAddToWishlist: () async {
        if(isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();
        bool isSuccess = await catalogController.addContentToWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        MyPrint.printOnConsole("isSuccess: $isSuccess");
        isLoading = false;
        mySetState();

        if (isSuccess) {
          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }

        if (pageMounted && context.mounted) {
          if (isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemaddedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onRemoveWishlist: () async {
        if(isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        MyPrint.printOnConsole("Component instance id: $componentInstanceId");
        RemoveFromWishlistResponseModel removeFromWishlistResponseModel = await catalogController.removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        isLoading = false;
        mySetState();
        MyPrint.printOnConsole("valueeee: ${removeFromWishlistResponseModel.isSuccess}");
        if (removeFromWishlistResponseModel.isSuccess) {
          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onAddToWaitListTap
      },
      onCancelEnrollmentTap: () async {
        if(isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled == true,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");

          getCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onViewResources: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onViewResources
      },
      onRescheduleTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onRescheduleTap
      },
      onReEnrollmentHistoryTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onViewResources
      },
      onRecommendToTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onReEnrollmentHistoryTap
      },
      onShareWithConnectionTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            shareProvider: context.read<ShareProvider>(),
          ),
        );
      },
      onShareWithPeopleTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
          ),
        );
      },
      onShareTap: () {
        if(isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onShareTap
      },
    );
  }

  Future<void> showMoreAction({
    required CatalogCourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(
      appProvider: appProvider,
    );
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController.getCatalogScreenSecondaryActions(
      catalogCourseDTOModel: model,
      localStr: localStr,
      catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
        model: model,
        primaryAction: primaryAction,
      ),
      isWishlistMode: true,
    ).toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> addContentToMyLearning({required CatalogCourseDTOModel model}) async {
    isLoading = true;
    mySetState();
    bool isSuccess = await catalogController.addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: model.ContentID,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: "",
        ComponentID: componentId,
        ComponentInsID: componentInstanceId,
      ),
      context: context,
      isShowToast: true,
      hasPrerequisites: model.hasPrerequisiteContents(),
      isWaitForOtherProcesses: true,
    );

    isLoading = false;
    mySetState();

    if (isSuccess) {
      getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppConfigurations().commonAppBar(title: "Wishlisted"),
        body: AppUIComponents.getBackGroundBordersRounded(child: getMainWidget(), context: context),
      ),
    );
  }

  Widget getMainWidget() {
    return ChangeNotifierProvider<CatalogProvider>.value(
      value: catalogProvider,
      child: Consumer<CatalogProvider>(
        builder: (BuildContext context, CatalogProvider myLearningProvider, Widget? child) {
          return getCatalogContentsListView();
        },
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        // getSearchTextFormField(),
        // SizedBox(height: 10 ,),
        Expanded(child: getCatalogContentsListView()),
      ],
    );
  }

  Widget getCatalogContentsListView() {
    return getContentsPageWithSearchbar(
      scrollController: catalogContentScrollController,
      catalogProvider: catalogProvider,
      onRefresh: () async {
        getCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getCatalogContentsList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getContentsPageWithSearchbar({
    required CatalogProvider catalogProvider,
    required ScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    PaginationModel paginationModel = catalogProvider.wishlistContentsPaginationModel.get();
    List<CatalogCourseDTOModel> list = catalogProvider.wishlistContents.getList(isNewInstance: false);

    if (paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    }

    if (!paginationModel.isLoading && list.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child:Center(
          child: AppConfigurations.commonNoDataView(),
        )
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && list.isEmpty) || index == list.length) {
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

          if (index > (list.length - paginationModel.refreshLimit)) {
            if (paginationModel.hasMore && !paginationModel.isLoading) {
              onPagination();
            }
          }

          CatalogCourseDTOModel model = list[index];

          return getCatalogContentWidget(model: model);
        },
      ),
    );
  }

  Widget getCatalogContentWidget({required CatalogCourseDTOModel model}) {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(
      appProvider: appProvider,
    );
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController.getCatalogScreenPrimaryActions(
      catalogCourseDTOModel: model,
      localStr: localStr,
      catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
        model: model,
        isSecondaryAction: false,
      ),
      isWishlistMode: true,
    ).toList();

    // MyPrint.printOnConsole("options:$options");

    InstancyUIActionModel? primaryAction = options.firstElement;
    // MyPrint.printOnConsole("primaryAction in Page:$primaryAction");
    // MyPrint.printOnConsole("primaryAction in Page:${primaryAction?.actionsEnum}");
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: CatalogContentListComponent(
        model: model,
        primaryAction: primaryAction,
        onPrimaryActionTap: () async {
          MyPrint.printOnConsole("primaryAction:$primaryActionEnum");

          if(primaryAction?.onTap != null) {
            primaryAction!.onTap!();
          }
        },
        onMoreButtonTap: () {
          showMoreAction(model: model, primaryAction: primaryActionEnum);
        },
      ),
    );
  }
}

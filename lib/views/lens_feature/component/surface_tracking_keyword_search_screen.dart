import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_controller.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/navigation/navigation_response.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import '../../../backend/ui_actions/catalog/catalog_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'lens_screen_content_card.dart';

class SurfaceTrackingKeywordSearchScreen extends StatefulWidget {
  static const String routeName = "/SurfaceTrackingKeywordSearchScreen";

  final SurfaceTrackingKeywordSearchScreenNavigationArguments arguments;

  const SurfaceTrackingKeywordSearchScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<SurfaceTrackingKeywordSearchScreen> createState() => _SurfaceTrackingKeywordSearchScreenState();
}

class _SurfaceTrackingKeywordSearchScreenState extends State<SurfaceTrackingKeywordSearchScreen> with MySafeState {
  bool isLoading = false;

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  int componentId = -1;
  int componentInstanceId = -1;

  late AppProvider appProvider;
  late LensProvider lensProvider;
  late LensController lensController;
  late CatalogController catalogController;

  Future<void> getData({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true}) async {
    await lensController.getCatalogContentsListFromApi(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
    );
  }

  CatalogUIActionCallbackModel getCatalogUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return CatalogUIActionCallbackModel(
      onAddToMyLearningTap: primaryAction == InstancyContentActionsEnum.AddToMyLearning
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);
              addContentToMyLearning(model: model);
            },
      onBuyTap: primaryAction == InstancyContentActionsEnum.Buy
          ? null
          : () {
        if (isSecondaryAction) Navigator.pop(context);

        catalogController.buyCourse(context: context);
      },
      onEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(model: model);
      },
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await onDetailsTap(model: model);
      },
      onContactTap: () async {
        if (model.startpage.isNotEmpty) {
          MyUtils.launchUrl(url: MyUtils.getSecureUrl(model.startpage));
        }
      },
      onAddToWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);

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
          model.AddtoWishList = "";
          model.RemoveFromWishList = "Y";
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
        if (isSecondaryAction) Navigator.pop(context);
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
          model.AddtoWishList = "Y";
          model.RemoveFromWishList = "";
        }

        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        MyPrint.printOnConsole("Content id: ${model.ContentID}");
        // isLoading = true;
        // mySetState();
        // AddToWaitListResponseModel addToWaitListResponseModel = await catalogController.addContentToWaitList(
        //   contentId: model.ContentID,
        //   componentId: componentId,
        //   componentInstanceId: componentInstanceId,
        // );
        // MyPrint.printOnConsole("isSuccess: ${addToWaitListResponseModel.isSuccess}");
        // isLoading = false;
        // mySetState();
        //
        // if (addToWaitListResponseModel.isSuccess) {
        //   getCatalogContentsList(
        //     isRefresh: true,
        //     isGetFromCache: false,
        //     isNotify: true,
        //   );
        // }
        //
        // if (pageMounted && context.mounted) {
        //   if (addToWaitListResponseModel.isSuccess) {
        //     MyToast.showSuccess(context: context, msg: addToWaitListResponseModel.message);
        //   } else {
        //     MyToast.showError(context: context, msg: 'Failed');
        //   }
        // }
        //TODO: Implement onAddToWaitListTap
      },
      onRecommendToTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToRecommendToScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: RecommendToScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            componentId: componentId,
          ),
        );
      },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

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
        if (isSecondaryAction) Navigator.pop(context);

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
        if (isSecondaryAction) Navigator.pop(context);

        MyUtils.shareContent(content: model.Sharelink);
      },
      onDownloadTap: () {},
    );
  }

  Future<void> showMoreAction({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(appProvider: appProvider);
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController
        .getCatalogScreenSecondaryActions(
          catalogCourseDTOModel: model,
          localStr: localStr,
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
          ),
          isWishlistMode: false,
        )
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDetailsTap({required CourseDTOModel model}) async {
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
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {}
  }

  Future<void> addContentToMyLearning({required CourseDTOModel model, bool isShowToast = true}) async {
    if (model.AddLink == ContentAddLinkOperations.redirecttodetails) {
      onDetailsTap(model: model);
      return;
    }

    isLoading = true;
    mySetState();

    String contentId = model.ContentID;

    bool isSuccess = await catalogController.addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: contentId,
        multiInstanceParentId: model.InstanceParentContentID,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: "",
        ComponentID: componentId,
        ComponentInsID: componentInstanceId,
      ),
      context: context,
      onPrerequisiteDialogShowEnd: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowEnd called");

        isLoading = true;
        mySetState();
      },
      onPrerequisiteDialogShowStarted: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowStarted called");
        isLoading = false;
        mySetState();
      },
      hasPrerequisites: model.hasPrerequisiteContents(),
      isShowToast: isShowToast,
      isWaitForOtherProcesses: true,
    );
    MyPrint.printOnConsole("isSuccess $isSuccess");

    isLoading = false;
    mySetState();

    if (isSuccess) {
      model.AddLink = "";
      model.ViewLink = "Y";
      model.isContentEnrolled = "true";
    }
  }

  @override
  void initState() {
    super.initState();

    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInsId;

    appProvider = context.read<AppProvider>();
    lensProvider = widget.arguments.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);
    catalogController = CatalogController(provider: null);

    searchController.text = lensProvider.searchString.get();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LensProvider>.value(value: lensProvider),
      ],
      child: Consumer<LensProvider>(
        builder: (BuildContext context, LensProvider lensProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              body: ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            backButton(),
                            const SizedBox(width: 20),
                            Expanded(child: getSearchTextFormField()),
                          ],
                        ),
                      ),
                      const Divider(thickness: 2),
                      Expanded(
                        child: getContentsListViewWidget(
                          scrollController: scrollController,
                          contentsLength: lensProvider.contentsList.length,
                          paginationModel: lensProvider.contentsPaginationModel.get(),
                          onRefresh: () async {
                            getData(
                              isRefresh: true,
                              isGetFromCache: false,
                              isNotify: true,
                            );
                          },
                          onPagination: () async {
                            getData(
                              isRefresh: false,
                              isGetFromCache: false,
                              isNotify: false,
                            );
                          },
                        ),
                      ),
                      /*Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return CourseComponent(
                        model: CourseDTOModel(
                          name: "New Ar content",
                        ),
                      );
                    },
                  ),
                ),*/
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: themeData.colorScheme.onBackground),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white70,
              Colors.white.withOpacity(0),
            ],
          ),
        ),
        child: Icon(
          Icons.arrow_back,
          color: themeData.colorScheme.onBackground,
          size: 20,
        ),
      ),
    );
  }

  Widget getSearchTextFormField() {
    return CommonTextFormField(
      autoFocus: true,
      hintStyle: themeData.textTheme.labelMedium?.copyWith(
        fontStyle: FontStyle.italic,
        // color: themeData.colorScheme.onb,
      ),
      controller: searchController,
      hintText: "Search Keywords...",
      onSubmitted: (String text) {
        if (lensProvider.searchString.get() != text.trim()) {
          lensProvider.searchString.set(value: text.trim(), isNotify: false);
          getData(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
    );
  }

  Widget getContentsListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    if (paginationModel.isFirstTimeLoading) {
      return const CommonLoader(
        isCenter: true,
      );
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: constraints.maxHeight / 5),
                AppConfigurations.commonNoDataView(),
              ],
            ),
          );
        },
      );
    }

    List<CourseDTOModel> list = lensProvider.contentsList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
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

          if (index > (contentsLength - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
            onPagination();
          }

          CourseDTOModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: getContentCardWidget(model: model),
          );
        },
      ),
    );
  }

  Widget getContentCardWidget({required CourseDTOModel model}) {
    return LensScreenContentCard(
      model: model,
      onMoreButtonTap: (CourseDTOModel model) {
        showMoreAction(model: model);
      },
      onLaunchARTap: (CourseDTOModel model) {
        Navigator.pop(
          context,
          SurfaceTrackingKeywordSearchScreenNavigationResponse(
            courseModel: model,
            arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInAR,
          ),
        );
      },
      onLaunchVRTap: (CourseDTOModel model) {
        Navigator.pop(
          context,
          SurfaceTrackingKeywordSearchScreenNavigationResponse(
            courseModel: model,
            arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInVR,
          ),
        );
      },
      isShowARVRLaunch: true,
    );
  }
}

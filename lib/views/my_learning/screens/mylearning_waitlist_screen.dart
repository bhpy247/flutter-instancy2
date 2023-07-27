import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../backend/my_learning/my_learning_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/ui_actions/my_learning/my_learning_ui_action_callback_model.dart';
import '../../../backend/ui_actions/my_learning/my_learning_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/my_learning/data_model/my_learning_course_dto_model.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../component/my_learning_card.dart';

class MyLearningWaitlistScreen extends StatefulWidget {
  static const String routeName = "/MyLearningWaitlistScreen";

  final MyLearningWaitlistScreenNavigationArguments arguments;

  const MyLearningWaitlistScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<MyLearningWaitlistScreen> createState() => _MyLearningWaitlistScreenState();
}

class _MyLearningWaitlistScreenState extends State<MyLearningWaitlistScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  late MyLearningProvider myLearningProvider;
  late MyLearningController myLearningController;
  late AppProvider appProvider;
  late ProfileProvider profileProvider;

  int componentId = 0, componentInstanceId = 0;

  void initializations() {
    myLearningProvider = widget.arguments.myLearningProvider ?? MyLearningProvider();
    myLearningController = MyLearningController(provider: myLearningProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    profileProvider = context.read<ProfileProvider>();

    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;

    NativeMenuComponentModel? componentModel = widget.arguments.componentModel ?? appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      myLearningController.initializeMyLearningConfigurationsFromComponentConfigurationsModel(
          componentConfigurationsModel: componentModel.componentConfigurationsModel);
    }

    if (myLearningProvider.myLearningWaitlistContentsLength == 0) {
      getMyLearningWaitlistContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    }
  }

  Future<void> getMyLearningWaitlistContentsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    myLearningController.getMyLearningWaitlistContentsListFromApi(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
  }

  MyLearningUIActionCallbackModel getMyLearningUIActionCallbackModel({
    required MyLearningCourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return MyLearningUIActionCallbackModel(
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

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
            screenType: InstancyContentScreenType.MyLearning,
            myLearningProvider: myLearningProvider,
          ),
        );

        if (value == true) {
          getMyLearningWaitlistContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onJoinTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        String joinUrl = model.JoinURL;

        MyPrint.printOnConsole("joinUrl:$joinUrl");

        if (joinUrl.isNotEmpty) {
          MyUtils.launchUrl(url: joinUrl, launchMode: LaunchMode.inAppWebView);
        } else {
          MyToast.showError(context: context, msg: "No url found");
        }
      },
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () {
              if (isSecondaryAction) Navigator.pop(context);
              //TODO: Implement onViewTap
            },
    );
  }

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole('MyLearningWaitlistScreen init called');
    initializations();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyLearningProvider>.value(value: myLearningProvider),
      ],
      child: Consumer<MyLearningProvider>(
        builder: (BuildContext context, MyLearningProvider myLearningProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: getAppBar(),
              body: getMyLearningContentsListView(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? getAppBar() {
    return AppBar(
      title: const Text("Waitlist"),
    );
  }

  Widget getMyLearningContentsListView() {
    PaginationModel paginationModel = myLearningProvider.myLearningWaitlistPaginationModel.get();
    int contentsLength = myLearningProvider.myLearningWaitlistContentsLength;

    if (paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          getMyLearningWaitlistContentsList(
            isRefresh: true,
            isGetFromCache: false,
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

    List<MyLearningCourseDTOModel> contents = myLearningProvider.myLearningWaitlistContents.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: () async {
        getMyLearningWaitlistContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: contents.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && contents.isEmpty) || index == contents.length) {
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

          if (index > (contentsLength - paginationModel.refreshLimit)) {
            if (paginationModel.hasMore && !paginationModel.isLoading) {
              getMyLearningWaitlistContentsList(
                isRefresh: false,
                isGetFromCache: false,
                isNotify: false,
              );
            }
          }

          MyLearningCourseDTOModel model = contents[index];

          return getMyLearningContentWidget(model: model);
        },
      ),
    );
  }

  Widget getMyLearningContentWidget({required MyLearningCourseDTOModel model}) {
    LocalStr localStr = appProvider.localStr;

    MyLearningUIActionsController myLearningUIActionsController = MyLearningUIActionsController(
      appProvider: appProvider,
      myLearningProvider: myLearningProvider,
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = myLearningUIActionsController
        .getMyLearningScreenPrimaryActions(
          myLearningCourseDTOModel: model,
          localStr: localStr,
          myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
            model: model,
            isSecondaryAction: false,
          ),
        )
        .toList();

    InstancyUIActionModel? primaryAction = options.firstElement;
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    return MyLearningCard(
      myLearningCourseDTOModel: model,
      primaryAction: primaryAction,
      isShowMoreOption: false,
      onPrimaryActionTap: () {
        MyPrint.printOnConsole("primaryActionsEnum:$primaryActionEnum");

        if (primaryActionEnum == InstancyContentActionsEnum.View) {
        } else if (primaryActionEnum == InstancyContentActionsEnum.ViewResources) {
        } else if (primaryActionEnum == InstancyContentActionsEnum.Join) {}
      },
    );
  }
}

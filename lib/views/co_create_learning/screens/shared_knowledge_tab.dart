import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalogContentListComponent.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:provider/provider.dart';

import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../component/size_utils.dart';

class SharedKnowledgeTab extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const SharedKnowledgeTab({
    super.key,
    required this.componentId,
    required this.componentInstanceId,
  });

  @override
  State<SharedKnowledgeTab> createState() => _SharedKnowledgeTabState();
}

class _SharedKnowledgeTabState extends State<SharedKnowledgeTab> with MySafeState {
  late AppProvider appProvider;

  late CoCreateKnowledgeController _controller;
  late CoCreateKnowledgeProvider _provider;
  late CourseLaunchController courseLaunchController;

  late Future future;

  Future<void> getFutureData({bool isRefresh = true}) async {
    if (!isRefresh && _provider.sharedKnowledgeList.length > 0) {
      return;
    }

    await _controller.getSharedKnowledgeList();
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "View",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () {
            Navigator.pop(context);

            onViewTap(model: model);
          },
          iconData: InstancyIcons.view,
        ),
      InstancyUIActionModel(
        text: "Details",
        actionsEnum: InstancyContentActionsEnum.Details,
        onTap: () {
          Navigator.pop(context);

          onDetailsTap(model: model);
        },
        iconData: InstancyIcons.details,
      ),
    ];

    return actions;
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0}) async {
    List<InstancyUIActionModel> actions = getActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
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
        componentId: widget.componentId,
        componentInstanceId: widget.componentInstanceId,
        userId: model.SiteUserID,
        screenType: InstancyContentScreenType.Catalog,
        courseDtoModel: model,
      ),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {
      /*getContentData = getCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );*/
    }
  }

  Future<void> onViewTap({required CourseDTOModel model}) async {
    await courseLaunchController.viewCoCreateKnowledgeContent(context: context, model: model);
  }

  Future<void> onShareTap({required CourseDTOModel model}) async {
    model.IsShared = true;
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();

    _provider = context.read<CoCreateKnowledgeProvider>();
    _controller = CoCreateKnowledgeController(coCreateKnowledgeProvider: _provider);

    courseLaunchController = CourseLaunchController(
      appProvider: appProvider,
      componentId: widget.componentId,
      componentInstanceId: widget.componentInstanceId,
    );

    future = getFutureData(isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: mainWidget(),
        );
      },
    );
  }

  Widget mainWidget() {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) return const Center(child: CommonLoader());

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CoCreateKnowledgeProvider>.value(value: _provider),
          ],
          child: Consumer<CoCreateKnowledgeProvider>(
            builder: (context, CoCreateKnowledgeProvider provider, _) {
              return Column(
                children: [
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 15, bottom: 10),
                    child: const CustomSearchView(),
                  ),*/
                  const SizedBox(height: 10),
                  getSearchTextFormField(),
                  const SizedBox(height: 5),
                  Expanded(
                    child: getCoursesListView(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget getSearchTextFormField() {
    int selectedFiltersCount = 0;

    Widget filterSuffixIcon = Stack(
      children: [
        Container(
          margin: selectedFiltersCount > 0 ? const EdgeInsets.only(top: 5, right: 5) : null,
          child: InkWell(
            onTap: () async {
              // navigateToFilterScreen();
            },
            child: const Icon(
              Icons.tune,
            ),
          ),
        ),
        if (selectedFiltersCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeData.primaryColor,
              ),
              child: Text(
                selectedFiltersCount.toString(),
                style: themeData.textTheme.labelSmall?.copyWith(
                  color: themeData.colorScheme.onPrimary,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );

    List<Widget> actions = <Widget>[];
    // if (filterSuffixIcon != null) actions.add(filterSuffixIcon);
    actions.add(filterSuffixIcon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: CommonTextFormField(
          borderRadius: 50,
          boxConstraints: const BoxConstraints(minWidth: 55),
          prefixWidget: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: "Search",
          isOutlineInputBorder: true,
          onChanged: (String text) {
            mySetState();
          },
          suffixWidget: actions.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                )
              : null,
        ),
      ),
    );
  }

  Widget getCoursesListView() {
    CoCreateKnowledgeProvider provider = _provider;

    if (provider.isLoadingSharedKnowledge.get()) return const CommonLoader();
    List<CourseDTOModel> list = provider.sharedKnowledgeList.getList();

    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          future = getFutureData(isRefresh: true);
          mySetState();
        },
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

    return RefreshIndicator(
      onRefresh: () async {
        future = getFutureData(isRefresh: true);
        mySetState();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
        itemBuilder: (BuildContext listContext, int index) {
          CourseDTOModel model = list[index];

          return getCatalogContentWidget(model: model, index: index);

          /*return MyKnowledgeItemWidget(
            model: model,
            onMoreTap: () {
              showMoreActions(model: model);
            },
            onCardTap: () {
              onViewTap(model: model);
            },
          );*/
        },
      ),
    );
  }

  Widget getCatalogContentWidget({required CourseDTOModel model, int index = 0}) {
    LocalStr localStr = appProvider.localStr;

    InstancyUIActionModel primaryAction = InstancyUIActionModel(
      onTap: () {
        onViewTap(model: model);
      },
      text: localStr.catalogActionsheetViewoption,
      actionsEnum: InstancyContentActionsEnum.View,
      iconData: InstancyIcons.view,
    );
    if (model.ContentTypeId == InstancyObjectTypes.events) {
      primaryAction = InstancyUIActionModel(
        onTap: () {
          onDetailsTap(model: model);
        },
        text: localStr.catalogActionsheetDetailsoption,
        actionsEnum: InstancyContentActionsEnum.Details,
        iconData: InstancyIcons.details,
      );
    }

    // MyPrint.printOnConsole("model content final image url:${model.ThumbnailImagePath}");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: CatalogContentListComponent(
        model: model,
        primaryAction: primaryAction,
        onPrimaryActionTap: () async {
          MyPrint.printOnConsole("primaryAction:$primaryAction");

          if (primaryAction.onTap != null) {
            primaryAction.onTap!();
          }
        },
        onMoreButtonTap: () {
          showMoreActions(model: model, index: index);
        },
      ),
    );
  }
}

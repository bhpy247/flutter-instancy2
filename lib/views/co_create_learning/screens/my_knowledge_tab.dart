import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalogContentListComponent.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/course_launch/course_launch_controller.dart';
import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../models/course_launch/data_model/course_launch_model.dart';
import '../component/add_content_dialog.dart';
import '../component/size_utils.dart';

class MyKnowledgeTab extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;
  final bool isHandleChatBotSpaceMargin;

  const MyKnowledgeTab({
    super.key,
    required this.componentId,
    required this.componentInstanceId,
    this.isHandleChatBotSpaceMargin = false,
  });

  @override
  State<MyKnowledgeTab> createState() => _MyKnowledgeTabState();
}

class _MyKnowledgeTabState extends State<MyKnowledgeTab> with MySafeState {
  late AppProvider appProvider;

  late CoCreateKnowledgeController _controller;
  late CoCreateKnowledgeProvider _provider;
  late MyLearningController myLearningController;

  late Future future;
  bool isLoading = false;

  Future<void> getFutureData({bool isRefresh = true}) async {
    if (!isRefresh && _provider.myKnowledgeList.length > 0) {
      return;
    }

    await _controller.getMyKnowledgeList();
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "View",
          actionsEnum: InstancyContentActionsEnum.View,
          onTap: () async {
            Navigator.pop(context);

            if (model.ContentTypeId == InstancyObjectTypes.courseBot) {
              await onContentLaunchTap(model: model, isArchived: false);
            } else {
              onViewTap(model: model);
            }
          },
          iconData: InstancyIcons.view,
        ),
      if (!(model.ContentTypeId == InstancyObjectTypes.mediaResource && [InstancyMediaTypes.audio, InstancyMediaTypes.video].contains(model.MediaTypeID)))
        InstancyUIActionModel(
          text: "Edit",
          actionsEnum: InstancyContentActionsEnum.Edit,
          onTap: () {
            Navigator.pop(context);

            onEditTap(model: model, index: index);
          },
          iconData: InstancyIcons.edit,
        ),
      if (![InstancyObjectTypes.document].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Edit Metadata",
          actionsEnum: InstancyContentActionsEnum.EditMetadata,
          onTap: () {
            Navigator.pop(context);

            onEditMetadataTap(model: model, index: index);
          },
          iconData: InstancyIcons.editMetadata,
          iconSize: 26,
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
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);

          _provider.myKnowledgeList.removeItems(items: [model], isNotify: true);
        },
        iconData: InstancyIcons.delete,
      ),
      InstancyUIActionModel(
        text: "Share",
        actionsEnum: InstancyContentActionsEnum.Share,
        onTap: () {
          Navigator.pop(context);

          onShareTap(model: model);
        },
        iconData: InstancyIcons.share,
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

  Future<void> onContentLaunchTap({
    required CourseDTOModel model,
    required bool isArchived,
  }) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningController.myLearningRepository.apiController.apiDataProvider;

    isLoading = true;
    mySetState();
    await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: 0,
      componentInstanceId: 0,
    ).viewCourse(
      context: context,
      model: CourseLaunchModel(
        ContentTypeId: model.ContentTypeId,
        MediaTypeId: model.MediaTypeID,
        ScoID: model.ScoID,
        SiteUserID: model.SiteUserID,
        SiteId: model.SiteId,
        ContentID: model.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: model.ActivityId,
        ActualStatus: model.ActualStatus,
        ContentName: model.ContentName,
        FolderPath: model.FolderPath,
        JWVideoKey: model.JWVideoKey,
        jwstartpage: model.jwstartpage,
        startPage: model.startpage,
        courseDTOModel: model,
      ),
    );

    isLoading = false;
    mySetState();

    // if (isLaunched) {
    //   getMyLearningContentsList(
    //     isRefresh: true,
    //     isNotify: true,
    //     isGetFromCache: false,
    //     isArchive: isArchived,
    //   );
    // }
  }

  Future<void> onViewTap({required CourseDTOModel model}) async {
    int objectType = model.ContentTypeId;
    int mediaType = model.MediaTypeID;
    MyPrint.printOnConsole("objectType:$objectType, mediaType:$mediaType");

    if (objectType == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToFlashCardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: FlashCardScreenNavigationArguments(courseDTOModel: model),
      );
    } else if (objectType == InstancyObjectTypes.rolePlay) {
      NavigationController.navigateToRolePlayLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: RolePlayLaunchScreenNavigationArguments(
          courseDTOModel: model,
        ),
      );
    } else if (objectType == InstancyObjectTypes.mediaResource && mediaType == InstancyMediaTypes.audio) {
      NavigationController.navigateToPodcastEpisodeScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.reference && mediaType == InstancyMediaTypes.url) {
      NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/",
        ),
      );
    } else if (objectType == InstancyObjectTypes.document && mediaType == InstancyMediaTypes.pDF) {
      NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: PDFLaunchScreenNavigationArguments(
          contntName: model.ContentName,
          isNetworkPDF: true,
          pdfUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fdocuments%2Fai%20for%20biotechnology.pdf?alt=media&token=ab06fadc-ba08-4114-88e1-529213d117bf",
        ),
      );
    } else if (objectType == InstancyObjectTypes.mediaResource && mediaType == InstancyMediaTypes.video) {
      NavigationController.navigateToVideoScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
      );
    } else if (objectType == InstancyObjectTypes.assessment && mediaType == InstancyMediaTypes.test) {
      NavigationController.navigateToQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: QuizScreenNavigationArguments(courseDTOModel: model),
      );
    } else if (objectType == InstancyObjectTypes.webPage) {
      NavigationController.navigateToArticleScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: ArticleScreenNavigationArguments(courseDTOModel: model),
      );
      /*NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://enterprisedemo.instancy.com/content/publishfiles/1539fc5c-7bde-4d82-a0f6-9612f9e6c426/ins_content.html?fromNativeapp=true",
        ),
      );*/
    } else if (objectType == InstancyObjectTypes.track) {
      NavigationController.navigateToLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: LearningPathScreenNavigationArgument(
          model: model,
          componentId: widget.componentId,
          componentInstanceId: widget.componentInstanceId,
        ),
      );
    } else if (objectType == InstancyObjectTypes.contentObject && mediaType == InstancyMediaTypes.microLearning) {
      NavigationController.navigateToMicroLearningScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: MicroLearningScreenNavigationArgument(
          model: model,
          componentId: widget.componentId,
          componentInstanceId: widget.componentInstanceId,
        ),
      );
    }
  }

  Future<void> onShareTap({required CourseDTOModel model}) async {
    model.IsShared = true;
    _provider.shareKnowledgeList.setList(list: [model], isClear: false, isNotify: true);
    mySetState();
  }

  Future<void> onEditTap({required CourseDTOModel model, int index = 0}) async {
    int objectTypeId = model.ContentTypeId;
    int mediaTypeId = model.MediaTypeID;

    CoCreateContentAuthoringModel coCreateContentAuthoringModel = CoCreateContentAuthoringModel(
      coCreateAuthoringType: CoCreateAuthoringType.Edit,
      contentTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      isEdit: true,
      courseDTOModel: model,
    );

    CoCreateKnowledgeController(coCreateKnowledgeProvider: null).initializeCoCreateContentAuthoringModelFromCourseDTOModel(
      courseDTOModel: model,
      coCreateContentAuthoringModel: coCreateContentAuthoringModel,
    );

    bool? isEdited;

    if (objectTypeId == InstancyObjectTypes.flashCard) {
      dynamic value = await NavigationController.navigateToGenerateWithAiFlashCardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: GenerateWithAiFlashCardScreenNavigationArguments(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.reference && mediaTypeId == InstancyMediaTypes.url) {
      dynamic value = await NavigationController.navigateToCreateUrlScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: CreateUrlScreenNavigationArguments(
          componentId: widget.componentId,
          componentInsId: widget.componentInstanceId,
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.document) {
      dynamic value = await NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: AddEditDocumentScreenArguments(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.assessment && mediaTypeId == InstancyMediaTypes.test) {
      /*QuizContentModel quizContentModel = QuizContentModel();
      quizContentModel.questionCount = 3;
      quizContentModel.difficultyLevel = "Hard";
      quizContentModel.questions = AppConstants().quizModelList;
      quizContentModel.questionType = "Multiple Choice";*/
      // coCreateContentAuthoringModel.quizContentModel = quizContentModel;

      dynamic value = await NavigationController.navigateToGeneratedQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: GeneratedQuizScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.webPage) {
      dynamic value = await NavigationController.navigateToArticleEditorScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: ArticleEditorScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.events) {
      dynamic value = await NavigationController.navigateToAddEditEventScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditEventScreenArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        Navigator.pop(context, true);
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      dynamic value = await NavigationController.navigateToAddEditRoleplayScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditRolePlayScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.track) {
      dynamic value = await NavigationController.navigateToAddEditLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: AddEditLearningPathScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else if (objectTypeId == InstancyObjectTypes.contentObject && mediaTypeId == InstancyMediaTypes.microLearning) {
      dynamic value = await NavigationController.navigateToMicroLearningEditorScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: MicroLearningEditorScreenNavigationArgument(
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        isEdited = true;
      }
    } else {}

    if (isEdited == true) {
      mySetState();
    }
  }

  Future<void> onEditMetadataTap({required CourseDTOModel model, int index = 0}) async {
    dynamic value = await NavigationController.navigateCommonCreateAuthoringToolScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      argument: CommonCreateAuthoringToolScreenArgument(
        coCreateAuthoringType: CoCreateAuthoringType.EditMetadata,
        courseDtoModel: model,
        objectTypeId: model.ContentTypeId,
        mediaTypeId: model.MediaTypeID,
        componentId: widget.componentId,
        componentInsId: widget.componentInstanceId,
      ),
    );

    if (value != true) {
      return;
    }

    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    myLearningController = MyLearningController(provider: context.read<MyLearningProvider>());

    _provider = context.read<CoCreateKnowledgeProvider>();
    _controller = CoCreateKnowledgeController(coCreateKnowledgeProvider: _provider);
    future = getFutureData(isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return RefreshIndicator(
          onRefresh: () async {
            future = getFutureData();
            mySetState();
          },
          child: Scaffold(
            body: mainWidget(),
            floatingActionButton: getAddContentButton(),
          ),
        );
      },
    );
  }

  Widget getAddContentButton() {
    return Consumer<MainScreenProvider>(
      builder: (BuildContext context, MainScreenProvider mainScreenProvider, Widget? child) {
        return Container(
          margin: EdgeInsets.only(
            bottom: mainScreenProvider.isChatBotButtonEnabled.get() && widget.isHandleChatBotSpaceMargin && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0.0,
          ),
          child: PopUpDialog(
            provider: _provider,
            componentId: widget.componentId,
            componentInsId: widget.componentInstanceId,
            onContentCreated: () {
              future = getFutureData(isRefresh: true);
              mySetState();
            },
          ),
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
              return ModalProgressHUD(
                inAsyncCall: isLoading,
                progressIndicator: const CommonLoader(),
                child: Column(
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
                ),
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

    if (provider.isLoading.get()) return const CommonLoader();
    List<CourseDTOModel> list = provider.myKnowledgeList.getList();

    return ListView.builder(
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
    );
  }

  Widget getCatalogContentWidget({required CourseDTOModel model, int index = 0}) {
    LocalStr localStr = appProvider.localStr;

    InstancyUIActionModel primaryAction = InstancyUIActionModel(
      onTap: () async {
        // onViewTap(model: model);
        if (model.ContentTypeId == InstancyObjectTypes.courseBot) {
          await onContentLaunchTap(model: model, isArchived: false);
        } else {
          onViewTap(model: model);
        }
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

class PopUpDialog extends StatefulWidget {
  final int componentId;
  final int componentInsId;
  final CoCreateKnowledgeProvider provider;
  final void Function()? onContentCreated;

  const PopUpDialog({
    super.key,
    required this.provider,
    required this.componentId,
    required this.componentInsId,
    this.onContentCreated,
  });

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> with MySafeState {
  final List<KnowledgeTypeModel> knowledgeTypeList = [
    KnowledgeTypeModel(
      name: "Microlearning",
      iconUrl: "assets/cocreate/microLearning.png",
      objectTypeId: InstancyObjectTypes.contentObject,
      mediaTypeId: InstancyMediaTypes.microLearning,
    ),
    KnowledgeTypeModel(
      name: "Learning Path",
      iconUrl: "assets/cocreate/Business Hierarchy.png",
      objectTypeId: InstancyObjectTypes.track,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "Roleplay",
      iconUrl: "assets/cocreate/video.png",
      objectTypeId: InstancyObjectTypes.rolePlay,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "Event",
      iconUrl: "assets/cocreate/Vector-3.png",
      objectTypeId: InstancyObjectTypes.events,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "Documents",
      iconUrl: "assets/cocreate/Vector.png",
      objectTypeId: InstancyObjectTypes.document,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "Reference Link",
      iconUrl: "assets/cocreate/Vector-1.png",
      objectTypeId: InstancyObjectTypes.reference,
      mediaTypeId: InstancyMediaTypes.url,
    ),
    KnowledgeTypeModel(
      name: "Video",
      iconUrl: "assets/cocreate/video.png",
      objectTypeId: InstancyObjectTypes.mediaResource,
      mediaTypeId: InstancyMediaTypes.video,
    ),
    KnowledgeTypeModel(
      name: "Article",
      iconUrl: "assets/cocreate/Vector-2.png",
      objectTypeId: InstancyObjectTypes.webPage,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "Podcast Episode",
      iconUrl: "assets/cocreate/Vector-4.png",
      objectTypeId: InstancyObjectTypes.mediaResource,
      mediaTypeId: InstancyMediaTypes.audio,
    ),
    KnowledgeTypeModel(
      name: "Quiz",
      iconUrl: "assets/cocreate/Chat Question.png",
      objectTypeId: InstancyObjectTypes.assessment,
      mediaTypeId: InstancyMediaTypes.test,
    ),
    KnowledgeTypeModel(
      name: "Flashcards",
      iconUrl: "assets/cocreate/Card.png",
      objectTypeId: InstancyObjectTypes.flashCard,
      mediaTypeId: InstancyMediaTypes.none,
    ),
    KnowledgeTypeModel(
      name: "AI Agents",
      iconUrl: "assets/cocreate/Ai.png",
      objectTypeId: InstancyObjectTypes.courseBot,
      mediaTypeId: InstancyMediaTypes.none,
    ),
  ];

  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  Future<void> onCardTapCallBack({required int objectType, required int mediaType}) async {
    MyPrint.printOnConsole("onCardTapCallBack called with objectType:$objectType");

    List<String> commonAuthoringContentTypes = [
      "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.rolePlay}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.audio}",
      "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.video}",
      "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}",
      "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.track}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.events}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.courseBot}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.contentObject}_${InstancyMediaTypes.microLearning}",
    ];

    if (commonAuthoringContentTypes.contains("${objectType}_$mediaType")) {
      dynamic value = await NavigationController.navigateCommonCreateAuthoringToolScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: CommonCreateAuthoringToolScreenArgument(
          coCreateAuthoringType: CoCreateAuthoringType.Create,
          componentInsId: 0,
          componentId: 0,
          objectTypeId: objectType,
          mediaTypeId: mediaType,
        ),
      );

      MyPrint.printOnConsole("Value from CommonCreateAuthoringToolScreen:$value");

      if (value == true) {
        widget.onContentCreated?.call();
      }
    } else if (objectType == InstancyObjectTypes.document) {
      NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditDocumentScreenArguments(coCreateContentAuthoringModel: null),
      );
    } else if (objectType == InstancyObjectTypes.reference && mediaType == InstancyMediaTypes.url) {
      NavigationController.navigateToCreateUrlScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: CreateUrlScreenNavigationArguments(
          componentId: widget.componentId,
          componentInsId: widget.componentInsId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      overlayColor: Colors.black,
      overlayOpacity: .7,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 1,
      buttonSize: const Size(56.0, 56.0),
      // it's the SpeedDial size which defaults to 56 itself
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: const Size(50, 50),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,

      /// If true user is forced to close dial manually
      closeManually: true,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: true,
      // onOpen: () {
      //   debugPrint('OPENING DIAL');
      //   // setState(() {});
      // },
      // onClose: () {
      //   debugPrint('DIAL CLOSED');
      //   // isDialOpen.value = false;
      // },
      useRotationAnimation: true,
      tooltip: 'Open Speed Dial',
      elevation: 1.0,
      // animationDuration: Duration(seconds: 0),
      animationCurve: Curves.easeIn,
      isOpenOnStart: false,
      children: List.generate(
        knowledgeTypeList.length,
        (index) => SpeedDialChild(
          onTap: () async {
            // Navigator.pop(context);
            isDialOpen.value = false;
            mySetState();
            MyPrint.printOnConsole("Index: ${knowledgeTypeList[index].objectTypeId}");

            await Future.delayed(const Duration(milliseconds: 200));

            onCardTapCallBack(
              objectType: knowledgeTypeList[index].objectTypeId,
              mediaType: knowledgeTypeList[index].mediaTypeId,
            );
          },
          label: knowledgeTypeList[index].name,
          labelStyle: TextStyle(
            color: themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.transparent,
          backgroundColor: themeData.colorScheme.onPrimary,
          elevation: 0,
          labelShadow: [],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: Image.asset(
            knowledgeTypeList[index].iconUrl,
            height: 20,
            width: 20,
            color: themeData.primaryColor,
          ),
        ),
      ),
    );
  }
}

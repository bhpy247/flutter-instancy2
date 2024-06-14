import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/learning_path/data_model/learning_path_content_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_controller.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../catalog/components/catalogContentListComponent.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class LearningPathScreen extends StatefulWidget {
  static const String routeName = "/learningPath";
  final LearningPathScreenNavigationArgument arguments;

  const LearningPathScreen({super.key, required this.arguments});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> with MySafeState {
  String title = "";
  late AppProvider appProvider;

  late CoCreateKnowledgeProvider _provider;

  LearningPathContentModel learningPathList = LearningPathContentModel(blockListModel: [
    BlockListModel(blockName: "Intelligent Agents: The Future of Autonomous Systems", blockContentList: [
      CourseDTOModel(
        Title: "Generative AI and its Transformative Potential",
        TitleName: "Generative AI and its Transformative Potential",
        ContentName: "Generative AI and its Transformative Potential",
        AuthorName: "Richard Parker",
        AuthorDisplayName: "Richard Parker",
        UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        ContentTypeId: InstancyObjectTypes.reference,
        MediaTypeID: InstancyMediaTypes.url,
        ContentType: "Reference Link",
        ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FGenerative%20AI%20(1).jpg?alt=media&token=42d9004b-9dd8-4d30-a889-982996d6cd6d",
        ShortDescription: "Uncover the revolutionary capabilities of Generative AI, poised to reshape industries and creative expression with its innovative potential.",
      ),
      CourseDTOModel(
        Title: "AI Agents Memory and Personalize Learning",
        TitleName: "AI Agents Memory and Personalize Learning",
        ContentName: "AI Agents Memory and Personalize Learning",
        AuthorName: "Richard Parker",
        AuthorDisplayName: "Richard Parker",
        UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        ContentTypeId: InstancyObjectTypes.mediaResource,
        MediaTypeID: InstancyMediaTypes.video,
        ContentType: "Video",
        ThumbnailImagePath:
            "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMastering%20Communication%20(1).jpg?alt=media&token=a5031b2e-2f73-4270-b710-6373ede36b4e",
        ShortDescription:
            "Unlock the power of AI agents in personalized learning! This course explores the intricacies of memory systems in AI, guiding you through techniques to tailor learning experiences for individual students. Learn how AI agents adapt content delivery based on learner preferences, track progress, and create personalized pathways. Perfect for educators, AI enthusiasts, and developers looking to revolutionize education with AI.",
      ),
      CourseDTOModel(
        Title: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
        TitleName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
        ContentName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
        AuthorName: "Richard Parker",
        AuthorDisplayName: "Richard Parker",
        UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        ContentTypeId: InstancyObjectTypes.document,
        MediaTypeID: InstancyMediaTypes.pDF,
        ViewLink: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
        ContentType: "Documents",
        ThumbnailImagePath:
            "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3",
        ShortDescription: "Delve into the dynamic synergy between AI and biotech, uncovering how cutting-edge technology revolutionizes healthcare, agriculture, and beyond.",
      ),
    ]),
    BlockListModel(blockName: "Exploring the Capabilities and Challenges of AI Agents in Modern Applications", blockContentList: [
      CourseDTOModel(
        Title: "Artificial Intelligence (AI)",
        TitleName: "Artificial Intelligence (AI)",
        ContentName: "Artificial Intelligence (AI)",
        AuthorName: "Richard Parker",
        AuthorDisplayName: "Richard Parker",
        UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        ContentTypeId: InstancyObjectTypes.flashCard,
        MediaTypeID: InstancyMediaTypes.none,
        ContentType: "Flashcards",
        ThumbnailImagePath:
            "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FArtificial%20Intelligence%20(1).jpg?alt=media&token=eea140e2-20ec-4077-b42a-ccebd8046624",
        ShortDescription: "Delve into the realm of Artificial Intelligence, where machine learning and cognitive computing converge to redefine the boundaries of human innovation.",
      ),
      CourseDTOModel(
        Title: "Office Ergonomics",
        TitleName: "Office Ergonomics",
        ContentName: "Office Ergonomics",
        AuthorName: "Richard Parker",
        AuthorDisplayName: "Richard Parker",
        UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
        ContentTypeId: InstancyObjectTypes.assessment,
        MediaTypeID: InstancyMediaTypes.test,
        ContentType: "Quiz",
        ThumbnailImagePath:
            "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FOffice%20Ergonomics%20(1).jpg?alt=media&token=e8b61e56-79d8-4257-bd6e-fdad51d0b9f9",
        ShortDescription: "Discover the science of workplace comfort and efficiency, optimizing your workspace to enhance productivity and well-being through ergonomic principles.",
      ),
    ]),
  ]);

  Future<void> onDetailsTap({required CourseDTOModel model}) async {
    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: model.ContentID,
        componentId: widget.arguments.componentId,
        componentInstanceId: widget.arguments.componentInstanceId,
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
    int objectType = model.ContentTypeId;
    int mediaType = model.MediaTypeID;
    MyPrint.printOnConsole("objectType:$objectType");
    MyPrint.printOnConsole("mediaType:$mediaType");

    if (objectType == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToFlashCardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: FlashCardScreenNavigationArguments(courseDTOModel: model),
      );
    } else if (objectType == InstancyObjectTypes.rolePlay) {
      await NavigationController.navigateToRolePlayLaunchScreen(
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
    } else if (objectType == InstancyObjectTypes.document) {
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
      // NavigationController.navigateToArticleScreen(
      //   navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      //   arguments: ArticleScreenNavigationArguments(courseDTOModel: model),
      // );
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
        argument: LearningPathScreenNavigationArgument(model: model),
      );
    }
  }

  Future<void> onShareTap({required CourseDTOModel model}) async {
    model.IsShared = true;
    _provider.shareKnowledgeList.setList(list: [model], isClear: false, isNotify: true);
    mySetState();
  }

  Future<void> onEditTap({required CourseDTOModel model, int index = 0}) async {
    int objectType = model.ContentTypeId;
    int mediaType = model.MediaTypeID;

    if (objectType == InstancyObjectTypes.document) {
      NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditDocumentScreenArguments(coCreateContentAuthoringModel: null),
      );
    } else if (objectType == InstancyObjectTypes.reference && mediaType == InstancyMediaTypes.url) {
      CoCreateContentAuthoringModel coCreateContentAuthoringModel = CoCreateContentAuthoringModel(coCreateAuthoringType: CoCreateAuthoringType.Edit);
      CoCreateKnowledgeController(coCreateKnowledgeProvider: null).initializeCoCreateContentAuthoringModelFromCourseDTOModel(
        courseDTOModel: model,
        coCreateContentAuthoringModel: coCreateContentAuthoringModel,
      );

      NavigationController.navigateToCreateUrlScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: CreateUrlScreenNavigationArguments(
          componentId: widget.arguments.componentId,
          componentInsId: widget.arguments.componentInstanceId,
          coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        ),
      );
    } else {
      NavigationController.navigateCommonCreateAuthoringToolScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: CommonCreateAuthoringToolScreenArgument(
          coCreateAuthoringType: CoCreateAuthoringType.Edit,
          courseDtoModel: model,
          objectTypeId: objectType,
          mediaTypeId: 0,
          componentId: widget.arguments.componentId,
          componentInsId: widget.arguments.componentInstanceId,
        ),
      );
    }
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0}) async {
    List<InstancyUIActionModel> actions = getActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
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
        text: "Edit",
        actionsEnum: InstancyContentActionsEnum.Edit,
        onTap: () {
          Navigator.pop(context);

          onEditTap(model: model, index: index);
        },
        iconData: InstancyIcons.edit,
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

  void initializeData() {
    title = widget.arguments.model.ContentName;
    if (title.isEmpty) title = "Technology in sustainable urban planning";
    LearningPathContentModel? learningPathModel = widget.arguments.model.learningPathContentModel;
    //
    if (learningPathModel != null) {
      learningPathList = learningPathModel;
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    _provider = context.read<CoCreateKnowledgeProvider>();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: title,
    );
  }

  Widget getMainBody() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: List.generate(learningPathList.blockListModel?.length ?? 0, (index) {
          String keys = learningPathList.blockListModel?[index].blockName ?? "";
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Set the color of the divider here
            ),
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
              initiallyExpanded: index == 0 ? true : false,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                keys,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: (learningPathList.blockListModel?[index].blockContentList ?? []).map(
                (CourseDTOModel model) {
                  return getCatalogContentWidget(model: model);
                },
              ).toList(),
            ),
          );
        }),
        // children: List.g
        //   children: learningPathList.keys.map((e) {
        // return Theme(
        //   data: Theme.of(context).copyWith(
        //     dividerColor: Colors.transparent, // Set the color of the divider here
        //   ),
        //   child: ExpansionTile(
        //     childrenPadding: EdgeInsets.symmetric(horizontal: 20),
        //     initiallyExpanded: true,
        //     controlAffinity: ListTileControlAffinity.leading,
        //     title: Text(e,style: const TextStyle(fontWeight: FontWeight.bold),),
        //     children: learningPathList[e]!.map(
        //       (CourseDTOModel model) {
        //         return getCatalogContentWidget(model: model);
        //       },
        //     ).toList(),
        //   ),
        // );
        // }).toList()),
      ),
    ));
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

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/learning_path/data_model/learning_path_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalogContentListComponent.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddEditLearningPathScreen extends StatefulWidget {
  static const String routeName = "/AddEditLearningPathScreen";

  final AddEditLearningPathScreenNavigationArgument arguments;

  const AddEditLearningPathScreen({super.key, required this.arguments});

  @override
  State<AddEditLearningPathScreen> createState() => _AddEditLearningPathScreenState();
}

class _AddEditLearningPathScreenState extends State<AddEditLearningPathScreen> with MySafeState {
  String title = "";
  late AppProvider appProvider;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

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

  // Map<String, List<CourseDTOModel>> learningPathList = <String, List<CourseDTOModel>>{
  //   "Block 1": [
  //     CourseDTOModel(
  //       Title: "Generative AI and its Transformative Potential",
  //       TitleName: "Generative AI and its Transformative Potential",
  //       ContentName: "Generative AI and its Transformative Potential",
  //       AuthorName: "Richard Parker",
  //       AuthorDisplayName: "Richard Parker",
  //       UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
  //       ContentTypeId: InstancyObjectTypes.referenceUrl,
  //       MediaTypeID: InstancyMediaTypes.none,
  //       ContentType: "Reference Link",
  //       ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FGenerative%20AI%20(1).jpg?alt=media&token=42d9004b-9dd8-4d30-a889-982996d6cd6d",
  //       ShortDescription: "Uncover the revolutionary capabilities of Generative AI, poised to reshape industries and creative expression with its innovative potential.",
  //     ),
  //     CourseDTOModel(
  //       Title: "AI Agents Memory and Personalize Learning",
  //       TitleName: "AI Agents Memory and Personalize Learning",
  //       ContentName: "AI Agents Memory and Personalize Learning",
  //       AuthorName: "Richard Parker",
  //       AuthorDisplayName: "Richard Parker",
  //       UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
  //       ContentTypeId: InstancyObjectTypes.videos,
  //       MediaTypeID: InstancyMediaTypes.none,
  //       ContentType: "Video",
  //       ThumbnailImagePath:
  //       "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMastering%20Communication%20(1).jpg?alt=media&token=a5031b2e-2f73-4270-b710-6373ede36b4e",
  //       ShortDescription:
  //       "Unlock the power of AI agents in personalized learning! This course explores the intricacies of memory systems in AI, guiding you through techniques to tailor learning experiences for individual students. Learn how AI agents adapt content delivery based on learner preferences, track progress, and create personalized pathways. Perfect for educators, AI enthusiasts, and developers looking to revolutionize education with AI.",
  //     ),
  //     CourseDTOModel(
  //       Title: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
  //       TitleName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
  //       ContentName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
  //       AuthorName: "Richard Parker",
  //       AuthorDisplayName: "Richard Parker",
  //       UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
  //       ContentTypeId: InstancyObjectTypes.document,
  //       MediaTypeID: InstancyMediaTypes.none,
  //       ViewLink: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
  //       ContentType: "Documents",
  //       ThumbnailImagePath:
  //       "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3",
  //       ShortDescription: "Delve into the dynamic synergy between AI and biotech, uncovering how cutting-edge technology revolutionizes healthcare, agriculture, and beyond.",
  //     ),
  //   ],
  //   "Block 2": [
  //     CourseDTOModel(
  //       Title: "Artificial Intelligence (AI)",
  //       TitleName: "Artificial Intelligence (AI)",
  //       ContentName: "Artificial Intelligence (AI)",
  //       AuthorName: "Richard Parker",
  //       AuthorDisplayName: "Richard Parker",
  //       UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
  //       ContentTypeId: InstancyObjectTypes.flashCard,
  //       MediaTypeID: InstancyMediaTypes.none,
  //       ContentType: "Flashcards",
  //       ThumbnailImagePath:
  //       "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FArtificial%20Intelligence%20(1).jpg?alt=media&token=eea140e2-20ec-4077-b42a-ccebd8046624",
  //       ShortDescription: "Delve into the realm of Artificial Intelligence, where machine learning and cognitive computing converge to redefine the boundaries of human innovation.",
  //     ),
  //     CourseDTOModel(
  //       Title: "Office Ergonomics",
  //       TitleName: "Office Ergonomics",
  //       ContentName: "Office Ergonomics",
  //       AuthorName: "Richard Parker",
  //       AuthorDisplayName: "Richard Parker",
  //       UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
  //       ContentTypeId: InstancyObjectTypes.quiz,
  //       MediaTypeID: InstancyMediaTypes.none,
  //       ContentType: "Quiz",
  //       ThumbnailImagePath:
  //       "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FOffice%20Ergonomics%20(1).jpg?alt=media&token=e8b61e56-79d8-4257-bd6e-fdad51d0b9f9",
  //       ShortDescription: "Discover the science of workplace comfort and efficiency, optimizing your workspace to enhance productivity and well-being through ergonomic principles.",
  //     ),
  //   ]
  // };

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
          argument: PodcastScreenNavigationArguments(courseDTOModel: model));
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
      NavigationController.navigateToVideoWithTranscriptLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: VideoWithTranscriptLaunchScreenNavigationArgument(title: model.ContentName),
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

  Future<void> onEditBlockTap({required CourseDTOModel model}) async {}

  Future<void> onAddContentItemTap({required CourseDTOModel model, int index = 0}) async {
    var val = await NavigationController.navigateToAddContentItemScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      argument: AddContentItemScreenNavigationArgument(
        coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
      ),
    );

    if (val == null) return;
    if (val is List<CourseDTOModel>) {
      learningPathList.blockListModel?[index].blockContentList = val;
      mySetState();
    }
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0, List<InstancyUIActionModel> actions = const []}) async {
    // List<InstancyUIActionModel> actions = getActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  Future<void> showMoreCommonActions({
    required CourseDTOModel model,
    int index = 0,
  }) async {
    List<InstancyUIActionModel> actions = getCommonActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  List<InstancyUIActionModel> getCommonActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
          text: "Add Block",
          actionsEnum: InstancyContentActionsEnum.AddBlock,
          onTap: () {
            Navigator.pop(context);
            showAddBlockDialog();
          },
          assetIconUrl: InstancyAssetIcons.addBlockIcon),
    ];

    return actions;
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
          text: "Add Block",
          actionsEnum: InstancyContentActionsEnum.AddBlock,
          onTap: () {
            Navigator.pop(context);
            // onAddBlockTap(model: model);
          },
          assetIconUrl: InstancyAssetIcons.addBlockIcon),
    ];

    return actions;
  }

  List<InstancyUIActionModel> getBlockActionsList({required CourseDTOModel model, int index = 0, String blockName = ""}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Add Content Item",
        actionsEnum: InstancyContentActionsEnum.AddContentItem,
        onTap: () async {
          Navigator.pop(context);
          await onAddContentItemTap(model: model, index: index);
          // onAddBlockTap(model: model);
        },
        iconData: FontAwesomeIcons.fileLines,
      ),
      InstancyUIActionModel(
        text: "Edit Block",
        actionsEnum: InstancyContentActionsEnum.Edit,
        onTap: () {
          Navigator.pop(context);
          showAddBlockDialog(index: index, isEdit: true, blockName: blockName);
          // onAddBlockTap(model: model);
        },
        iconData: InstancyIcons.edit,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);
          learningPathList.blockListModel?.removeAt(index);
          mySetState();
          // onAddBlockTap(model: model);
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  Future<void> showAddBlockDialog({bool isEdit = false, String? blockName, int index = 0}) async {
    var val = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBlockDialogScreen(
          isEdit: isEdit,
          name: blockName ?? "",
        );
      },
    );
    if (val == null) return;

    if (isEdit) {
      learningPathList.blockListModel?[index].blockName = val;
    } else {
      learningPathList.blockListModel?.add(BlockListModel(blockName: val));
    }
    mySetState();
  }

  Future<CourseDTOModel?> saveFlashcard() async {
    LearningPathContentModel learningPathModel = coCreateContentAuthoringModel.learningPathContentModel ?? LearningPathContentModel();
    learningPathModel.blockListModel = learningPathList.blockListModel;
    coCreateContentAuthoringModel.learningPathContentModel = learningPathModel;

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    if (courseDTOModel != null) {
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;

      courseDTOModel.ContentSkills = coCreateContentAuthoringModel.skills
          .map((e) => ContentFilterCategoryTreeModel(
                categoryId: "0",
                categoryName: e,
              ))
          .toList();

      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      courseDTOModel.learningPathContentModel = learningPathModel;

      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveFlashcard();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);

    NavigationController.navigateToLearningPathScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: LearningPathScreenNavigationArgument(
        model: courseDTOModel,
      ),
    );
  }

  void initializeData() {
    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;
    title = widget.arguments.model?.ContentName ?? "";
    if (title.isEmpty) title = "Technology in sustainable urban planning";
    LearningPathContentModel? learningPathModel = widget.arguments.model?.learningPathContentModel;
    if (learningPathModel != null) {
      learningPathList = learningPathModel;
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      backgroundColor: themeData.colorScheme.onPrimary,
      appBar: getAppBar(),
      bottomNavigationBar: Container(
        color: themeData.colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: commonAddButton(),
        ),
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(title: "Create Learning Path", actions: [
      InkWell(
        onTap: () {
          showMoreCommonActions(model: CourseDTOModel());
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.more_vert),
        ),
      ),
    ]);
  }

  Widget getMainBody() {
    if (learningPathList.blockListModel.checkEmpty) {
      return const Center(
        child: Text("No Block Available"),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          learningPathList.blockListModel?.length ?? 0,
          (index) {
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
                trailing: InkWell(
                  onTap: () {
                    showMoreActions(
                      model: CourseDTOModel(),
                      actions: getBlockActionsList(model: CourseDTOModel(), index: index, blockName: keys),
                    );
                  },
                  child: const Icon(
                    Icons.more_vert,
                    size: 25,
                  ),
                ),
                children: (learningPathList.blockListModel?[index].blockContentList ?? []).map(
                  (CourseDTOModel model) {
                    return getCatalogContentWidget(model: model);
                  },
                ).toList(),
              ),
            );
          },
        ),
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
          // showMoreActions(model: model, index: index);
        },
      ),
    );
  }

  Widget commonAddButton() {
    return CommonSaveExitButtonRow(
      onSaveAndExitPressed: onSaveAndExitTap,
      onSaveAndViewPressed: onSaveAndViewTap,
    );
  }
}

class AddBlockDialogScreen extends StatefulWidget {
  final bool isEdit;
  final String name;

  const AddBlockDialogScreen({super.key, this.isEdit = false, this.name = ""});

  @override
  State<AddBlockDialogScreen> createState() => _AddBlockDialogScreenState();
}

class _AddBlockDialogScreenState extends State<AddBlockDialogScreen> with MySafeState {
  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      nameController.text = widget.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Dialog(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 5),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0).copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Add Block",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonTextFormFieldWithLabel(
                    controller: nameController,
                    isHintText: true,
                    labelText: "Name of Block",
                    isOutlineInputBorder: true,
                    validator: (val) {
                      if (val == null || val.checkEmpty) {
                        return "Please enter the name of block";
                      }
                      return null;
                    },
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CommonTextFormFieldWithLabel(
                    controller: descriptionController,
                    isHintText: true,
                    labelText: "Description",
                    validator: (val) {
                      if (val == null || val.checkEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                    isOutlineInputBorder: true,
                    maxLines: 5,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      if (key.currentState?.validate() ?? false) {
                        Navigator.pop(context, nameController.text.trim());
                      }
                    },
                    text: "Add",
                    fontColor: themeData.colorScheme.onPrimary,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../catalog/components/catalogContentListComponent.dart';
import '../../common/components/app_ui_components.dart';

class AddContentItemScreen extends StatefulWidget {
  static const String routeName = "/AddContentItemScreen";
  final AddContentItemScreenNavigationArgument arguments;

  const AddContentItemScreen({super.key, required this.arguments});

  @override
  State<AddContentItemScreen> createState() => _AddContentItemScreenState();
}

class _AddContentItemScreenState extends State<AddContentItemScreen> with MySafeState {
  late AppProvider appProvider;

  List<CourseDTOModel> selectedContentList = [];

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
      MyPrint.printOnConsole("InstancyObjectTypes.learningPath : ${InstancyObjectTypes.track} objectType == InstancyObjectTypes.learningPath ${objectType == InstancyObjectTypes.track}");
      NavigationController.navigateToLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: LearningPathScreenNavigationArgument(
          model: model,
          componentId: widget.arguments.componentId,
          componentInstanceId: widget.arguments.componentInstanceId,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
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
    return AppConfigurations().commonAppBar(
      title: "Add Content Item",
    );
  }

  Widget getMainBody() {
    return Consumer<CoCreateKnowledgeProvider>(builder: (context, CoCreateKnowledgeProvider provider, _) {
      List<CourseDTOModel> contentList = provider.myKnowledgeList.getList();
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          getSearchTextFormField(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contentList.length,
              padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
              itemBuilder: (BuildContext listContext, int index) {
                CourseDTOModel model = contentList[index];

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
          ),
        ],
      );
    });
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

  Widget getCatalogContentWidget({required CourseDTOModel model, int index = 0}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          if (selectedContentList.checkContains(model)) {
            selectedContentList.remove(model);
          } else {
            selectedContentList.add(model);
          }
          mySetState();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selectedContentList.checkContains(model) ? Icons.check_box : Icons.check_box_outline_blank,
              color: selectedContentList.checkContains(model) ? themeData.primaryColor : Colors.grey,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: CatalogContentListComponent(
                model: model,

                // primaryAction: primaryAction,
                // onPrimaryActionTap: () async {
                //   MyPrint.printOnConsole("primaryAction:$primaryAction");
                //
                //   if (primaryAction.onTap != null) {
                //     primaryAction.onTap!();
                //   }
                // },
                // onMoreButtonTap: () {
                //   // showMoreActions(model: model, index: index);
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonAddButton() {
    return CommonButton(
      minWidth: double.infinity,
      onPressed: () {
        Navigator.pop(context, selectedContentList);
      },
      text: "Add",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }
}

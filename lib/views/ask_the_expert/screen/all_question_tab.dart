import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/ui_actions/ask_the_expert/questions/question_ui_action_controller.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/common/navigatingBackFromGlobalSearchModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/ask_the_expert/component/questionAnswerCard.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../backend/main_screen/main_screen_provider.dart';
import '../../../backend/profile/profile_controller.dart';
import '../../../backend/profile/profile_provider.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/ask_the_expert/questions/question_ui_action_callback_model.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';

class AllQuestionsTab extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  final bool isShowSearchTextField;
  final String searchString;
  final ApiController? apiController;

  const AllQuestionsTab({super.key, required this.componentId, required this.componentInstanceId, this.isShowSearchTextField = true, this.searchString = "", this.apiController});

  @override
  State<AllQuestionsTab> createState() => _AllQuestionsTabState();
}

class _AllQuestionsTabState extends State<AllQuestionsTab> with MySafeState {
  late ThemeData themeData;
  late AppProvider appProvider;
  int componentId = 0, componentInstanceId = 0;
  bool isLoading = false;
  bool isShowAddForumFloatingButton = false;
  TextEditingController textEditingController = TextEditingController();

  late AskTheExpertProvider askTheExpertProvider;
  late AskTheExpertController askTheExpertController;
  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> showSortingBottomSheet() async {
    bool? isValue = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const SortingScreen();
        });
    if (isValue == null) return;

    if (isValue) {
      getQuestionList(isRefresh: true, isGetFromCache: false, isNotify: false);
    }
  }

  Future<void> getQuestionList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      askTheExpertController.getQuestionsList(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
    ]);
  }

  QuestionsUIActionCallbackModel getQuestionsUIActionCallbackModel({
    required UserQuestionListDto model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return QuestionsUIActionCallbackModel(
      onAddAnswer: () async {
        if (isSecondaryAction) Navigator.pop(context);
        await NavigationController.navigateToAddEditAnswerScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: AddEditAnswerScreenNavigationArguments(
            questionId: model.questionID,
            isEdit: false,
          ),
        );
        getQuestionList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
      onDelete: () async {
        if (isSecondaryAction) Navigator.pop(context);
        //
        askTheExpertProvider.isLoading.set(value: true);

        bool isSuccess = await askTheExpertController.deleteQuestion(
          context: context,
          model: model,
        );

        askTheExpertProvider.isLoading.set(value: false, isNotify: !isSuccess);
        if (isSuccess) {
          getQuestionList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
        }
      },
      onEdit: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await NavigationController.navigateToCreateAddEditQuestionScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: CreateEditQuestionNavigationArguments(
            isEdit: true,
            userQuestionListDto: model,
            componentId: componentId,
            componentInsId: componentInstanceId,
          ),
        );
        getQuestionList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: false,
        );
      },
      // onAddCommentTap: () {
      //   if (isSecondaryAction) Navigator.pop(context);
      //
      //   isCommentTextFormFieldVisible = true;
      //   isReplyTextFormFieldVisible = false;
      //   selectedAnswerForComment = model;
      //   selectedCommentModelForReply = null;
      //   commentFocusNode = FocusNode();
      //   commentFocusNode.requestFocus();
      //
      //   mySetState();
      // },
      // onEditTap: () {
      //   if (isSecondaryAction) Navigator.pop(context);
      //
      //   editTopic(forumModel: forumModel ?? ForumModel(), topicModel: model);
      // },
      // onDeleteTap: () async {
      //   if (isSecondaryAction) Navigator.pop(context);
      //
      //   if (forumModel != null) {
      //     await discussionController.deleteTopic(
      //       context: context,
      //       forumModel: forumModel!,
      //       topicModel: model,
      //       mySetState: mySetState,
      //     );
      //   }
      // },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(shareContentType: ShareContentType.askTheExpertQuestion, shareProvider: context.read<ShareProvider>(), questionId: model.questionID),
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
            shareContentType: ShareContentType.askTheExpertQuestion,
            questionId: model.questionID,
          ),
        );
      },
    );
  }

  Future<void> showMoreActionsForQuestion({
    required UserQuestionListDto model,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    QuestionsUiActionController questionsUiActionController = QuestionsUiActionController(appProvider: appProvider);

    List<InstancyUIActionModel> options = questionsUiActionController
        .getDiscussionForumScreenSecondaryActions(
            forumModel: model,
            localStr: localStr,
            discussionForumUIActionCallbackModel: getQuestionsUIActionCallbackModel(
              model: model,
              primaryAction: primaryAction,
            ))
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> addTopic() async {
    /*dynamic value = await NavigationController.navigateToCreateEditTopicScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      arguments: CreateEditTopicScreenNavigationArguments(
        componentId: widget.componentId,
        componentInsId: widget.componentInstanceId,
        forumModel: model,
      ),
    );*/

    // if (value != true) return;

    // discussionController.getForumsList(
    //   isRefresh: true,
    //   isGetFromCache: false,
    //   isNotify: false,
    // );
    // discussionController.getMyDiscussionForumsList(
    //   isRefresh: true,
    //   isGetFromCache: false,
    //   isNotify: true,
    // );
  }

  void initializations({
    bool isNotify = false,
  }) {
    ProfileController profileController = ProfileController(profileProvider: context.read<ProfileProvider>());
    isShowAddForumFloatingButton = profileController.isShowAddForumButton();

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    // NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    // if (componentModel != null) {
    //   // askTheExpertController.initializeConfigurationsFromComponentConfigurationsModel(
    //   //   componentConfigurationsModel: componentModel.componentConfigurationsModel,
    //   // );
    // }

    PaginationModel paginationModel = askTheExpertProvider.questionListPaginationModel.get();
    if (!paginationModel.isFirstTimeLoading && !paginationModel.isLoading && paginationModel.hasMore && askTheExpertProvider.questionList.length == 0) {
      askTheExpertProvider.filterCategoriesIds.set(value: "-1", isNotify: false);
      getQuestionList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: isNotify,
        // componentId: componentId,
        // componentInstanceId: componentInstanceId,
      );
    }
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider, apiController: widget.apiController);
    if (widget.searchString.checkNotEmpty) {
      askTheExpertProvider.questionListSearchString.set(value: widget.searchString);
    }
    initializations();
    textEditingController.text = askTheExpertProvider.questionListSearchString.get();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AskTheExpertProvider>.value(value: askTheExpertProvider),
      ],
      child: Consumer2<AskTheExpertProvider, MainScreenProvider>(
        builder: (context, AskTheExpertProvider discussionProvider, MainScreenProvider mainScreenProvider, _) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: mainScreenProvider.isChatBotButtonEnabled.get() && !mainScreenProvider.isChatBotButtonCenterDocked.get() ? 70 : 0,
                ),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    dynamic value = await NavigationController.navigateToCreateAddEditQuestionScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      arguments: CreateEditQuestionNavigationArguments(
                        isEdit: false,
                        componentId: componentId,
                        componentInsId: componentInstanceId,
                      ),
                    );
                    if (value != true) return;
                    getQuestionList(
                      isRefresh: true,
                      isGetFromCache: false,
                      isNotify: true,
                    );
                    // askTheExpertController.getForumsList(
                    //   isRefresh: true,
                    //   isGetFromCache: false,
                    //   isNotify: false,
                    //   componentId: componentId,
                    //   componentInstanceId: componentInstanceId,
                    // );
                    // askTheExpertController.getMyDiscussionForumsList(
                    //   isRefresh: true,
                    //   isGetFromCache: false,
                    //   isNotify: true,
                    // );
                  },
                ),
              ),
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
          child: getQuestionListView(),
        )
      ],
    );
  }

  Widget getSearchTextFromField() {
    if (!widget.isShowSearchTextField) return SizedBox();
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CommonTextFormField(
              isOutlineInputBorder: true,
              borderRadius: 30,
              onTap: () async {
                NavigatingBackFromGlobalSearchModel? val = await NavigationController.navigateToGlobalSearchScreen(
                  navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                  arguments: GlobalSearchScreenNavigationArguments(
                      componentId: componentId,
                      componentInsId: componentInstanceId,
                      filterProvider: context.read<FilterProvider>(),
                      componentConfigurationsModel: ComponentConfigurationsModel(),
                      componentName: "Ask the expert"),
                );
                if (val == null || val.isSuccess == false) return;
                askTheExpertProvider.questionListSearchString.set(value: val.searchString);
                textEditingController.text = val.searchString;
                getQuestionList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: true,
                );
              },
              onChanged: (val) {
                mySetState();
              },
              controller: textEditingController,
              contentPadding: EdgeInsets.zero,
              hintText: "Search",
              suffixWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textEditingController.text.checkNotEmpty)
                    InkWell(
                      onTap: () {
                        textEditingController.clear();
                        askTheExpertProvider.questionListSearchString.set(value: "");
                        getQuestionList(
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
                  const SizedBox(
                    width: 10,
                  ),
                  getCategoriesFilterIcon(provider: askTheExpertProvider),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              prefixWidget: const Icon(Icons.search),
              onSubmitted: (String? val) {
                askTheExpertProvider.questionListSearchString.set(value: val ?? "");
                getQuestionList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: false,
                );
                mySetState();
              },
            ),
          ),
        ),
        InkWell(
            onTap: () {
              showSortingBottomSheet();
            },
            child: const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.filter_list),
            ))
      ],
    );
  }

  Widget getCategoriesFilterIcon({required AskTheExpertProvider provider}) {
    return InkWell(
      onTap: () async {
        bool? isTrue = await NavigationController.navigateToFilterSkillsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: const FilterSkillsScreenNavigationArguments(isMyQuestion: false),
        );
        if (isTrue == null) return;
        if (isTrue) {
          getQuestionList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Column(
                children: [
                  Icon(Icons.category),
                ],
              ),
              if (ParsingHelper.parseIntMethod(provider.filterCategoriesIds.get()) > 0)
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget getQuestionListView() {
    return getQuestionListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: askTheExpertProvider.questionList.length,
      paginationModel: askTheExpertProvider.questionListPaginationModel.get(),
      // contentsLength: 10,
      // paginationModel: PaginationModel(pageSize: 1,hasMore: false,isFirstTimeLoading: false,isLoading: false,pageIndex: 10,refreshLimit: 2),
      onRefresh: () async {
        getQuestionList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getQuestionList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getQuestionListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ItemScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    if (paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!paginationModel.isLoading && contentsLength == 0) {
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

    List<UserQuestionListDto> questionList = askTheExpertProvider.questionList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: questionList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && questionList.isEmpty) || index == questionList.length) {
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

          UserQuestionListDto model = questionList[index];

          return getQuestionsContentWidget(model: model);
        },
      ),
    );
  }

  Widget getQuestionsContentWidget({required UserQuestionListDto model}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: QuestionAnswerCard(
        userQuestionListDto: model,
        onAnswerButtonTap: () async {
          await NavigationController.navigateToAddEditAnswerScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            arguments: AddEditAnswerScreenNavigationArguments(questionId: model.questionID, isEdit: false, userQuestionListDto: model),
          );
          getQuestionList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
        },
        onMoreTap: () {
          showMoreActionsForQuestion(model: model);
        },
        onCardTap: () async {
          askTheExpertController.askTheExpertRepositoryRepository.setTheUserQuestionView(questionId: model.questionID).then((value) {
            if (value.data == "1") {
              model.views++;
            }
          });
          await NavigationController.navigateToQuestionAndAnswerDetailScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: QuestionAndAnswerDetailsScreenArguments(
              componentId: componentId,
              componentInsId: componentInstanceId,
              questionId: model.questionID,
              userQuestionListDto: model,
            ),
          );
          getQuestionList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: false,
          );
        },
      ),
    );
  }
}

class SortingScreen extends StatefulWidget {
  const SortingScreen({super.key});

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> with MySafeState {
  String selectedSort = "";
  List<String> sortingList = ["Recently Added", "Most Answers", "Most Views", "Title A-Z", "Title Z-A"];
  List<String> setSortStringList = ["LastActiveDate Desc", "Answers Desc", "Views Desc", "UserQuestion asc", "UserQuestion Desc"];

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Consumer<AskTheExpertProvider>(
      builder: (context, AskTheExpertProvider provider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const BottomSheetDragger(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sortingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(
                      provider.sortingData.get() == setSortStringList[index] ? Icons.check_box : Icons.square_outlined,
                      color: themeData.primaryColor,
                    ),
                    onTap: () {
                      if (selectedSort == setSortStringList[index]) {
                        selectedSort = "CreatedDate Desc";
                        provider.sortingData.set(value: setSortStringList[index]);
                      } else {
                        selectedSort = setSortStringList[index];
                        provider.sortingData.set(value: setSortStringList[index]);
                      }
                      Navigator.pop(context, true);
                    },
                    title: Text(sortingList[index]),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: CommonButton(
                  onPressed: () {
                    selectedSort = "CreatedDate Desc";
                    provider.sortingData.set(value: selectedSort);
                    Navigator.pop(context, true);
                  },
                  text: "Clear",
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

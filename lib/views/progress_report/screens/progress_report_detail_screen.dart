import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/content_review_ratings/content_review_ratings_controller.dart';
import 'package:flutter_instancy_2/backend/content_review_ratings/content_review_ratings_provider.dart';
import 'package:flutter_instancy_2/backend/course_details/course_details_controller.dart';
import 'package:flutter_instancy_2/backend/progress_report/progress_report_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/ui_configurations.dart';
import 'package:flutter_instancy_2/models/content_details/request_model/course_details_request_model.dart';
import 'package:flutter_instancy_2/models/content_review_ratings/data_model/content_user_rating_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/content_review_ratings/components/content_user_review_card.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/progress_report/progress_report_controller.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/progress_report/data_model/content_progress_details_question_data_model.dart';
import '../../../models/progress_report/data_model/content_progress_summary_data_model.dart.dart';
import '../../../models/progress_report/request_model/content_progress_details_data_request_model.dart';
import '../../../models/progress_report/request_model/mylearning_content_progress_summary_data_request_model.dart';
import '../../../utils/my_print.dart';
import '../../common/components/common_rating_bar_widget.dart';
import '../../common/components/common_svg_network_image.dart';

class ProgressReportDetailScreen extends StatefulWidget {
  static const String routeName = "/ProgressReportDetailScreen";

  final MyLearningContentProgressScreenNavigationArguments arguments;

  const ProgressReportDetailScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<ProgressReportDetailScreen> createState() => _ProgressReportDetailScreenState();
}

class _ProgressReportDetailScreenState extends State<ProgressReportDetailScreen> with MySafeState, SingleTickerProviderStateMixin {
  bool isLoading = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  DateTime _selectedFromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _selectedToDate = DateTime.now();

  String contentId = "";
  int userId = 0;
  int contentTypeId = 0;
  int componentId = 0;
  ProgressReportContentModel? progressReportContentModel;

  // MyLearningCourseDTOModel? myLearningCourseDTOModel;

  late AppProvider appProvider;
  late ProgressReportProvider progressReportProvider;
  late ProgressReportController progressReportController;
  late ContentReviewRatingsProvider contentReviewRatingsProvider;
  late ContentReviewRatingsController contentReviewRatingsController;

  Future<void>? futureGetData;

  // String contentThumbnailImageUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

  late TabController tabController;
  int selectedTabMenuForReviewAndReport = 0;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _selectedFromDate = picked;
          _fromDateController.text = "${picked.toLocal()}".split(' ')[0];
        } else {
          _selectedToDate = picked;
          _toDateController.text = "${picked.toLocal()}".split(' ')[0];
        }
      });
    }
  }

  Future<void> getContentProgressData() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("_MyLearningContentProgressScreenState().getContentProgressData() called", tag: tag);

    contentReviewRatingsController.getReviewsList(
      contentId: contentId,
      componentId: componentId,
    );

    progressReportController.getContentProgressDetailsData(
      requestModel: ContentProgressDetailsDataRequestModel(
        userID: userId,
        contentId: contentId,
        trackID: widget.arguments.trackId,
        eventID: widget.arguments.eventId,
        sequenceId: widget.arguments.seqId,
        objectTypeId: contentTypeId,
        startDate: _selectedFromDate,
        endDate: _selectedToDate,
      ),
    );

    await Future.wait([
      progressReportController.getMyLearningContentProgressSummaryData(
        requestModel: MyLearningContentProgressSummaryDataRequestModel(
          userID: userId,
          contentId: contentId,
          objectTypeId: contentTypeId,
          trackID: widget.arguments.trackId,
          eventID: widget.arguments.eventId,
          sequenceId: widget.arguments.seqId,
          startDate: _selectedFromDate,
          endDate: _selectedToDate,
        ),
      ),
      getCourseDetailsModelFromId(),
    ]);

    MyPrint.printOnConsole('mylearningSummaryDataModel:${progressReportProvider.contentMyLearningSummaryData.get()}', tag: tag);
    MyPrint.printOnConsole('progressDetails:${progressReportProvider.contentProgressDetailsQuestionsData.getList(isNewInstance: false)}', tag: tag);
  }

  void initializeData() {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("initializeData called", tag: tag);

    _fromDateController.text = "${_selectedFromDate.toLocal()}".split(' ')[0];
    _toDateController.text = "${_selectedToDate.toLocal()}".split(' ')[0];

    if (widget.arguments.courseDTOModel != null) {
      CourseDTOModel model = widget.arguments.courseDTOModel!;
      progressReportContentModel = ProgressReportContentModel(
        name: model.ContentName,
        author: model.ContentTypeId == InstancyObjectTypes.events ? model.PresenterDisplayName : model.AuthorDisplayName,
        thumbnailImageUrl: MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.ThumbnailImagePath)),
        createdDate: ParsingHelper.parseDateTimeMethod(model.CreatedOn, dateFormat: "MM/dd/yyyy"),
        ratingId: model.RatingID,
        contentTypeId: model.ContentTypeId,
      );
      /*contentThumbnailImageUrl = myLearningCourseDTOModel!.ThumbnailImagePath.startsWith('http')
        ? myLearningCourseDTOModel!.ThumbnailImagePath
        : ApiController().apiDataProvider.getCurrentSiteUrl() + myLearningCourseDTOModel!.ThumbnailImagePath;
      contentThumbnailImageUrl = MyUtils.getSecureUrl(contentThumbnailImageUrl);
      MyPrint.printOnConsole('contentImageUrl:$contentThumbnailImageUrl', tag: tag);*/
    }
  }

  Future<void> getCourseDetailsModelFromId() async {
    CourseDTOModel? model = await CourseDetailsController(courseDetailsProvider: null).getCourseDetailsData(
      requestModel: CourseDetailsRequestModel(
        ContentID: contentId,
        intUserID: userId,
        metadata: 1,
        ComponentID: componentId,
        DetailsCompID: InstancyComponents.Details,
        DetailsCompInsID: InstancyComponents.DetailsComponentInsId,
      ),
    );

    if (model != null) {
      progressReportContentModel = ProgressReportContentModel(
        name: model.ContentName,
        author: model.ContentTypeId == InstancyObjectTypes.events ? model.PresenterDisplayName : model.AuthorDisplayName,
        thumbnailImageUrl: MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.ThumbnailImagePath)),
        createdDate: ParsingHelper.parseDateTimeMethod(model.CreatedOn, dateFormat: "MM/dd/yyyy"),
        ratingId: model.RatingID,
        contentTypeId: model.ContentTypeId,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    contentId = widget.arguments.contentId;
    userId = widget.arguments.userId;
    contentTypeId = widget.arguments.contentTypeId;
    componentId = widget.arguments.componentId;

    appProvider = context.read<AppProvider>();
    progressReportProvider = ProgressReportProvider();
    progressReportController = ProgressReportController(progressReportProvider: progressReportProvider);
    contentReviewRatingsProvider = ContentReviewRatingsProvider();
    contentReviewRatingsController = ContentReviewRatingsController(contentReviewRatingsProvider: contentReviewRatingsProvider);

    tabController = TabController(length: 2, vsync: this);

    initializeData();

    futureGetData = getContentProgressData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProgressReportProvider>.value(value: progressReportProvider),
        ChangeNotifierProvider<ContentReviewRatingsProvider>.value(value: contentReviewRatingsProvider),
      ],
      child: Consumer2<ProgressReportProvider, ContentReviewRatingsProvider>(
        builder: (BuildContext context, ProgressReportProvider progressReportProvider, ContentReviewRatingsProvider contentReviewRatingsProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(appProvider.localStr.mylearningHeaderReporttitlelabel),
              ),
              body: futureGetData != null
                  ? FutureBuilder(
                      future: futureGetData!,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return getMainBody();
                        } else {
                          return const CommonLoader();
                        }
                      },
                    )
                  : getMainBody(),
            ),
          );
        },
      ),
    );
  }

  Widget getMainBody() {
    ContentProgressSummaryDataModel? mylearningSummaryDataModel = progressReportProvider.contentMyLearningSummaryData.get();

    return RefreshIndicator(
      onRefresh: () async {
        futureGetData = getContentProgressData();
        mySetState();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            getTheDateFilter(),
            // getContentDetailsCardWidget(
            //   contentModel: progressReportContentModel,
            //   mylearningSummaryDataModel: mylearningSummaryDataModel,
            // ),
            // const Divider(color: InstancyColors.border, height: 0, thickness: 1),
            getStatisticsMainWidget(mylearningSummaryDataModel: mylearningSummaryDataModel),
            getProgressTimingMainWidget(
                dateStarted: mylearningSummaryDataModel?.dateStarted ?? "",
                timeSpent: mylearningSummaryDataModel?.totalTimeSpent ?? "",
                dateCompleted: mylearningSummaryDataModel?.dateCompleted ?? "",
                status: mylearningSummaryDataModel?.result ?? "",
                mediaTypeId: mylearningSummaryDataModel?.mediaTypeId ?? 0,
                jwVideoKey: mylearningSummaryDataModel?.jwVideo ?? ""),
            getReportAndReviewMainSectionWidget(),
            // Expanded(child: getReviewReportTabBarWidget()),
          ],
        ),
      ),
    );
  }

  //region Content Details Card
  Widget getContentDetailsCardWidget({
    required ProgressReportContentModel? contentModel,
    required ContentProgressSummaryDataModel? mylearningSummaryDataModel,
  }) {
    if (contentModel == null) {
      return const SizedBox();
    }

    double spacing = 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getContentDetailImageWidget(thumbnailImageUrl: contentModel.thumbnailImageUrl),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contentModel.name,
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: spacing,
                ),
                getContentDetailAuthorNameWidget(authorName: contentModel.author),
                SizedBox(
                  height: spacing,
                ),
                getContentDetailRatingWidget(rating: contentModel.ratingId),
                SizedBox(
                  height: spacing,
                ),
                getContentDetailProgressBarWidget(
                    progressPercentage: ParsingHelper.parseDoubleMethod(mylearningSummaryDataModel?.percentageCompleted),
                    color: AppConfigurations.getContentStatusColorFromActualStatus(status: mylearningSummaryDataModel?.status ?? ""),
                    contentStatus: mylearningSummaryDataModel?.result ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getContentDetailImageWidget({required String thumbnailImageUrl}) {
    Widget imageWidget;
    if (thumbnailImageUrl.endsWith(".svg")) {
      imageWidget = CommonSVGNetworkImage(
        imageUrl: thumbnailImageUrl,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      imageWidget = CommonCachedNetworkImage(
        imageUrl: thumbnailImageUrl,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(InstancyUIConfigurations.thumbnailBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(InstancyUIConfigurations.thumbnailBorderRadius),
        child: imageWidget,
      ),
    );
  }

  Widget getContentDetailAuthorNameWidget({required String authorName}) {
    if (authorName.isEmpty) {
      return const SizedBox();
    }

    return Text(
      "By $authorName",
      style: themeData.textTheme.bodySmall?.copyWith(
        color: const Color(0xff9AA0A6),
      ),
    );
  }

  Widget getContentDetailRatingWidget({required double rating}) {
    return CommonRatingBarWidget(
      rating: rating,
    );
  }

  Widget getContentDetailProgressBarWidget({required double progressPercentage, required Color color, required String contentStatus}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progressPercentage / 100,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Colors.grey,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "${progressPercentage.toInt()}% $contentStatus",
          style: themeData.textTheme.labelSmall,
        )
      ],
    );
  }

  //endregion

  //region Progress Statistics
  Widget getStatisticsMainWidget({required ContentProgressSummaryDataModel? mylearningSummaryDataModel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Statistics",
            style: themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          getStatisticsScoreWidget(
            mylearningSummaryDataModel: mylearningSummaryDataModel,
          ),
        ],
      ),
    );
  }

  Widget getStatisticsScoreWidget({required ContentProgressSummaryDataModel? mylearningSummaryDataModel}) {
    double score = ParsingHelper.parseDoubleMethod(mylearningSummaryDataModel?.score);
    if (score < 0) {
      score = 0;
    } else if (score > 100) {
      score = 100;
    }
    return Row(
      children: [
        if (mylearningSummaryDataModel?.score.checkNotEmpty ?? false)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 120,
                  child: CircularStepProgressIndicator(
                    totalSteps: 10,
                    currentStep: (score / 10).round(),
                    selectedStepSize: 20.0,
                    unselectedStepSize: 20.0,
                    selectedColor: InstancyColors.green,
                    unselectedColor: InstancyColors.grey.withAlpha(150),
                    padding: 0.04,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${score.round()}%",
                          style: themeData.textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          appProvider.localStr.myprogressreportLabelScorelabel,
                          style: themeData.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                getStatisticsScoreItemWidget(
                    title: "Accessed",
                    value: mylearningSummaryDataModel?.numberOfTimesAccessedInThisPeriod.toString() ?? "0",
                    isScoreAvailable: mylearningSummaryDataModel?.score.checkNotEmpty ?? false),
                getStatisticsScoreItemWidget(
                    title: "Attempts", value: (mylearningSummaryDataModel?.numberOfAttemptsInThisPeriod) ?? "0", isScoreAvailable: mylearningSummaryDataModel?.score.checkNotEmpty ?? false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getStatisticsScoreItemWidget({required String title, required String value, bool isScoreAvailable = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: themeData.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value.checkEmpty ? "0" : value,
            style: themeData.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
          Expanded(
              flex: isScoreAvailable ? 0 : 2,
              child: const SizedBox(
                width: 30,
              )),
        ],
      ),
    );
  }

  //endregion

  //region Progress Timings
  Widget getProgressTimingMainWidget(
      {required String dateStarted, required String timeSpent, required String dateCompleted, required String status, required int mediaTypeId, String jwVideoKey = ""}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          if (dateStarted.checkNotEmpty)
            Expanded(
              child: getProgressTimingItemWidget(
                title: "Started",
                value: dateStarted,
              ),
            ),
          Expanded(
            child: getProgressTimingItemWidget(title: status, value: dateStarted, valueIsStatus: true),
          ),
          if (!MyLearningUIActionConfigs.checkNonTrackableContentForMediaType(mediaTypeId: mediaTypeId) || jwVideoKey.checkNotEmpty)
            Expanded(
              child: getProgressTimingItemWidget(
                title: "Time Spent",
                value: timeSpent,
              ),
            ),
        ],
      ),
    );
  }

  Widget getProgressTimingItemWidget({required String title, required String value, bool valueIsStatus = false}) {
    return Container(
      height: MediaQuery.of(context).size.height * .17,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: themeData.colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: themeData.textTheme.bodySmall?.color?.withAlpha(100) ?? Colors.grey,
            blurRadius: 1.5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.checkEmpty ? "${valueIsStatus ? "" : "N/A"}" : value,
            textAlign: TextAlign.center,
            style: themeData.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: InstancyColors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: themeData.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //endregion

  //region Report And Review Section
  Widget getReportAndReviewMainSectionWidget() {
    MyPrint.printOnConsole("tabController:${tabController.index}");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getReviewReportTabBarWidget(),
        getSelectedTabPageForReviewAndReportWidget(index: tabController.index),
      ],
    );
  }

  Widget getReviewReportTabBarWidget() {
    MyPrint.printOnConsole("tabController:${tabController.index}");

    return Container(
      decoration: BoxDecoration(
        // color: Colors.red,
        color: themeData.colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: themeData.textTheme.bodySmall?.color?.withAlpha(100) ?? Colors.grey,
            blurRadius: 1.5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        padding: const EdgeInsets.symmetric(vertical: 10),
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.only(top: 20, bottom: -10),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: themeData.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: (int index) {
          MyPrint.printOnConsole("onTap called for index:$index");
          selectedTabMenuForReviewAndReport = index;
          mySetState();
        },
        tabs: [
          if (![
            InstancyObjectTypes.dictionaryGlossary,
            InstancyObjectTypes.html,
            InstancyObjectTypes.webPage,
            InstancyObjectTypes.document,
            InstancyObjectTypes.mediaResource,
            InstancyObjectTypes.aICC,
            InstancyObjectTypes.htmlModules,
            InstancyObjectTypes.reference,
          ].contains(progressReportContentModel?.contentTypeId))
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Report",
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Review",
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectedTabPageForReviewAndReportWidget({required int index}) {
    if (index == 0) {
      if ([
        InstancyObjectTypes.dictionaryGlossary,
        InstancyObjectTypes.html,
        InstancyObjectTypes.webPage,
        InstancyObjectTypes.document,
        InstancyObjectTypes.mediaResource,
        InstancyObjectTypes.aICC,
        InstancyObjectTypes.htmlModules,
        InstancyObjectTypes.reference
      ].contains(progressReportContentModel?.contentTypeId)) {
        return getReviewListWidget(
          userReviewsList: contentReviewRatingsProvider.userReviewsList.getList(isNewInstance: false),
          isLoadingReviewData: contentReviewRatingsProvider.paginationModel.get().isLoading,
        );
      }

      return getReportQuestionsListWidget(
        progressDetails: progressReportProvider.contentProgressDetailsQuestionsData.getList(isNewInstance: false),
        isLoadingProgressDetails: progressReportProvider.isLoadingContentProgressDetailsQuestionsData.get(),
        objectTypeId: progressReportContentModel?.contentTypeId ?? 0,
      );
    } else if (index == 1) {
      return getReviewListWidget(
        userReviewsList: contentReviewRatingsProvider.userReviewsList.getList(isNewInstance: false),
        isLoadingReviewData: contentReviewRatingsProvider.paginationModel.get().isLoading,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getReviewListWidget({
    required List<ContentUserRatingModel> userReviewsList,
    required bool isLoadingReviewData,
  }) {
    if (isLoadingReviewData) {
      return const SizedBox(
        height: 150,
        child: CommonLoader(isCenter: true),
      );
    }

    if (userReviewsList.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(child: Image.asset("assets/myLearning/reportNotDataView.png", height: 155, width: 155)),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: userReviewsList.map((ContentUserRatingModel ratingModel) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: ContentUserReviewCard(ratingModel: ratingModel),
        );
      }).toList(),
    );
  }

  Widget getReportQuestionsListWidget({
    required List<ContentProgressDetailsQuestionDataModel> progressDetails,
    required bool isLoadingProgressDetails,
    required int objectTypeId,
  }) {
    MyPrint.printOnConsole("progressReportProvider.contentProgressDetailsQuestionsData :${progressReportProvider.contentProgressDetailsQuestionsData.getList().length}");
    if (isLoadingProgressDetails) {
      return const SizedBox(
        height: 150,
        child: CommonLoader(isCenter: true),
      );
    }

    if (progressDetails.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(child: Image.asset("assets/myLearning/reportNotDataView.png", height: 155, width: 155)),
        ],
      );
    }

    List<Widget> children = [];
    if (objectTypeId == InstancyObjectTypes.track) {
      children.addAll(progressDetails.map((ContentProgressDetailsQuestionDataModel questionDataModel) {
        return getReportTrackContentListItemWidget(questionDataModel: questionDataModel);
      }).toList());
    } else {
      children.addAll([
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Page/Question Title",
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "Status",
                style: themeData.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...progressDetails.map((ContentProgressDetailsQuestionDataModel questionDataModel) {
          return getReportQuestionsListItemWidget(questionDataModel: questionDataModel);
        }).toList(),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget getReportTrackContentListItemWidget({required ContentProgressDetailsQuestionDataModel questionDataModel}) {
    return ExpansionTile(
      title: Text(
        questionDataModel.contentItemTitle,
        style: themeData.textTheme.bodyMedium?.copyWith(
          color: themeData.primaryColor,
        ),
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Type :- ${questionDataModel.type}",
                ),
                Text("Progress :- ${questionDataModel.progress}"),
                Text(
                  "Status :- ${questionDataModel.status}",
                ),
                Text(
                  "Score :- ${questionDataModel.score}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getReportQuestionsListItemWidget({required ContentProgressDetailsQuestionDataModel questionDataModel}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              MyUtils.parseHtmlString(questionDataModel.pageQuestionTitle),
              style: themeData.textTheme.bodySmall,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            questionDataModel.status,
            style: themeData.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget getTheDateFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: getStartDateTextFromField()),
          const SizedBox(
            width: 20,
          ),
          Expanded(child: getToDateTextFromField()),
          const SizedBox(
            width: 20,
          ),
          datApplyButton()
        ],
      ),
    );
  }

  Widget getStartDateTextFromField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "From Date:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: () => _selectDate(context, true),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _fromDateController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                isDense: true,
                hintText: 'Select Date',
              ),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget getToDateTextFromField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "To Date:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: () => _selectDate(context, false),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _toDateController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                isDense: true,
                hintText: 'Select Date',
              ),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget datApplyButton() {
    return CommonButton(
      onPressed: () {
        futureGetData = getContentProgressData();
        mySetState();
      },
      text: "Apply",
      fontColor: themeData.cardColor,
    );
  }
//endregion
}

class ProgressReportContentModel {
  String thumbnailImageUrl;
  String name;
  String author;
  DateTime? createdDate;
  double ratingId;
  int contentTypeId;

  ProgressReportContentModel({
    this.thumbnailImageUrl = "",
    this.name = "",
    this.author = "",
    this.createdDate,
    this.ratingId = 0,
    this.contentTypeId = 0,
  });
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_controller.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_response.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../models/course/data_model/mobile_lms_course_model.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
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
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  late LensProvider lensProvider;
  late LensController lensController;

  Future<void> getData({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true}) async {
    await lensController.getCatalogContentsListFromApi(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
    );
  }

  @override
  void initState() {
    super.initState();

    lensProvider = widget.arguments.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);

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
          return Scaffold(
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
                      model: MobileLmsCourseModel(
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

    List<MobileLmsCourseModel> list = lensProvider.contentsList.getList(isNewInstance: false);

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

          MobileLmsCourseModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: LensScreenContentCard(
              model: model,
              onLaunchVRTap: (MobileLmsCourseModel model) {
                Navigator.pop(
                  context,
                  SurfaceTrackingKeywordSearchScreenNavigationResponse(
                    courseModel: model,
                    arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInVR,
                  ),
                );
              },
              onLaunchARTap: (MobileLmsCourseModel model) {
                Navigator.pop(
                  context,
                  SurfaceTrackingKeywordSearchScreenNavigationResponse(
                    courseModel: model,
                    arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInAR,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

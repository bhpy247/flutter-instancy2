import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/filter/filter_controller.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../../models/filter/data_model/filter_duration_value_model.dart';
import '../../../models/filter/data_model/instructor_user_model.dart';
import '../../../models/filter/data_model/learning_provider_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/common_text_form_field.dart';

class FiltersScreen extends StatefulWidget {
  static const String routeName = "/FiltersScreen";

  final FiltersScreenNavigationArguments arguments;

  const FiltersScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> with MySafeState {
  late AppProvider appProvider;
  late LocalStr localStr;

  late int componentId;

  late FilterProvider filterProvider;
  late FilterController filterController;

  late ComponentConfigurationsModel componentConfigurationsModel;

  List<double> ratingsList = [];
  List<EventDateModel> eventDatesList = [];

  bool isCategoriesExpanded = false,
      isSkillsExpanded = false,
      isContentTypeExpanded = false,
      isJobRolesExpanded = false,
      isSolutionsExpanded = false,
      isLearningProviderExpanded = false,
      isInstructorsExpanded = false,
      isEcommercePriceExpanded = false,
      isEventDateExpanded = false,
      isCreditPointsExpanded = false,
      isEventRatingsExpanded = false;

  List<ContentFilterCategoryTreeModel> selectedCategories = <ContentFilterCategoryTreeModel>[];
  List<ContentFilterCategoryTreeModel> selectedSkills = <ContentFilterCategoryTreeModel>[];
  List<ContentFilterCategoryTreeModel> selectedContentTypes = <ContentFilterCategoryTreeModel>[];
  List<ContentFilterCategoryTreeModel> selectedJobRoles = <ContentFilterCategoryTreeModel>[];
  List<ContentFilterCategoryTreeModel> selectedSolutions = <ContentFilterCategoryTreeModel>[];
  List<LearningProviderModel> selectedLearningProviders = <LearningProviderModel>[];
  List<InstructorUserModel> selectedInstructors = <InstructorUserModel>[];
  int? minPrice, maxPrice;
  FilterDurationValueModel? selectedFilterCredits;
  double? selectedRating;
  EventDateModel? selectedEventDateType;
  DateTime? startEventDate, endEventDate;

  TextEditingController minPriceTextController = TextEditingController();
  TextEditingController maxPriceTextController = TextEditingController();

  void initializeInitialExpansionPanelOpen() {
    String? contentFilterByTypes = widget.arguments.contentFilterByTypes;
    MyPrint.printOnConsole("initializeInitialExpansionPanelOpen called with contentFilterByTypes:$contentFilterByTypes");

    if (contentFilterByTypes != null) {
      resetExpansionPanelList();
      switch (contentFilterByTypes) {
        case ContentFilterByTypes.categories:
          {
            isCategoriesExpanded = true;
            break;
          }
        case ContentFilterByTypes.skills:
          {
            isSkillsExpanded = true;
            break;
          }
        case ContentFilterByTypes.objecttypeid:
          {
            isContentTypeExpanded = true;
            break;
          }
        case ContentFilterByTypes.job:
        case ContentFilterByTypes.jobroles:
          isJobRolesExpanded = true;
          break;
        case ContentFilterByTypes.solutions:
          {
            isSolutionsExpanded = true;
            break;
          }
        case ContentFilterByTypes.learningprovider:
          {
            isLearningProviderExpanded = true;
            break;
          }
        case ContentFilterByTypes.instructor:
          {
            isInstructorsExpanded = true;
            break;
          }
        case ContentFilterByTypes.ecommerceprice:
          {
            isEcommercePriceExpanded = true;
            break;
          }
        case ContentFilterByTypes.eventdates:
          {
            isEventDateExpanded = true;
            break;
          }
        case ContentFilterByTypes.creditpoints:
          {
            isCreditPointsExpanded = true;
            break;
          }
        case ContentFilterByTypes.rating:
          {
            isEventRatingsExpanded = true;
            break;
          }
      }

      mySetState();
    }
  }

  void resetExpansionPanelList() {
    isCategoriesExpanded = false;
    isSkillsExpanded = false;
    isContentTypeExpanded = false;
    isJobRolesExpanded = false;
    isSolutionsExpanded = false;
    isLearningProviderExpanded = false;
    isInstructorsExpanded = false;
    isEcommercePriceExpanded = false;
    isEventDateExpanded = false;
    isCreditPointsExpanded = false;
    mySetState();
  }

  void initializeSelectedFilterValuesFromProvider() {
    FilterProvider provider = filterProvider;

    selectedCategories = provider.selectedCategories.getList();
    selectedSkills = provider.selectedSkills.getList();
    selectedContentTypes = provider.selectedContentTypes.getList();
    selectedJobRoles = provider.selectedJobRoles.getList();
    selectedSolutions = provider.selectedSolutions.getList();
    selectedLearningProviders = provider.selectedLearningProviders.getList();
    selectedInstructors = provider.selectedInstructor.getList();
    minPrice = provider.minPrice.get();
    if (minPrice != null) minPriceTextController.text = "$minPrice";
    maxPrice = provider.maxPrice.get();
    if (maxPrice != null) maxPriceTextController.text = "$maxPrice";
    selectedFilterCredits = provider.selectedFilterCredit.get();
    selectedRating = provider.selectedRating.get();
    selectedEventDateType = provider.selectedEventDateType.get();
    startEventDate = provider.selectedStartEventDateTime.get();
    endEventDate = provider.selectedEndEventDateTime.get();
    MyPrint.printOnConsole("Final Selected Filter Credit in Filter Screen:$selectedFilterCredits");

    mySetState();
  }

  void applyFilterData() {
    MyPrint.printOnConsole("minPrice:$minPrice");
    MyPrint.printOnConsole("maxPrice:$maxPrice");

    if ((minPrice != null || maxPrice != null) && (minPrice == null || maxPrice == null)) {
      MyToast.showError(context: context, msg: "Please give minimum and maximum price");
      return;
    } else if (minPrice != null && maxPrice != null && minPrice! > maxPrice!) {
      MyToast.showError(context: context, msg: "Please give maximum price greater than minimum price");
      return;
    }

    MyPrint.printOnConsole("selectedEventDateType:$selectedEventDateType");
    MyPrint.printOnConsole("startEventDate:$startEventDate");
    if (selectedEventDateType?.type == EventDateTypes.choosedate) {
      if (startEventDate == null) {
        MyToast.showError(context: context, msg: "Please select start date");
        return;
      }
    }

    filterController.applyFilterData(
      selectedCategories: selectedCategories,
      selectedSkills: selectedSkills,
      selectedContentTypes: selectedContentTypes,
      selectedJobRoles: selectedJobRoles,
      selectedSolutions: selectedSolutions,
      selectedLearningProviders: selectedLearningProviders,
      selectedInstructors: selectedInstructors,
      minPrice: minPrice,
      maxPrice: maxPrice,
      selectedFilterCredit: selectedFilterCredits,
      selectedRating: selectedRating,
      selectedEventDateType: selectedEventDateType,
      startEventDate: startEventDate,
      endEventDate: endEventDate,
    );

    Navigator.pop(context, true);
  }

  void resetFilterData() {
    filterController.resetFilterData();
    initializeSelectedFilterValuesFromProvider();
    Navigator.pop(context, true);
  }

  int getSelectedChildrenCount({required List<ContentFilterCategoryTreeModel> children, required List<String> selectedChildren}) {
    int count = 0;

    for (ContentFilterCategoryTreeModel model in children) {
      if (selectedChildren.contains(model.categoryId)) count++;
      count += getSelectedChildrenCount(children: model.children, selectedChildren: selectedChildren);
    }

    return count;
  }

  void closeAllChildExpansionPanel({required List<ContentFilterCategoryTreeModel> children}) {
    for (ContentFilterCategoryTreeModel model in children) {
      model.isExpansionPanelExpanded = false;
      closeAllChildExpansionPanel(children: model.children);
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    localStr = appProvider.localStr;

    componentId = widget.arguments.componentId;
    filterProvider = widget.arguments.filterProvider;
    componentConfigurationsModel = widget.arguments.componentConfigurationsModel;

    ratingsList = [
      4.5,
      3.5,
      2.5,
      1.5,
    ];

    eventDatesList = [
      EventDateModel(
        title: localStr.filterLblEventdatetoday,
        type: EventDateTypes.today,
      ),
      EventDateModel(
        title: localStr.filterLblEventdatetomorrow,
        type: EventDateTypes.tomorrow,
      ),
      EventDateModel(
        title: localStr.filterLblEventdatethisweek,
        type: EventDateTypes.thisweek,
      ),
      EventDateModel(
        title: localStr.filterLblEventdatenextweek,
        type: EventDateTypes.nextweek,
      ),
      EventDateModel(
        title: localStr.filterLblEventdatethismonth,
        type: EventDateTypes.thismonth,
      ),
      EventDateModel(
        title: localStr.filterLblEventdatenextmonth,
        type: EventDateTypes.nextmonth,
      ),
      EventDateModel(
        title: localStr.filterLblEentdatechoosedate,
        type: EventDateTypes.choosedate,
      ),
    ];

    filterController = FilterController(filterProvider: filterProvider);

    filterController.initializeMainFiltersList(
      componentConfigurationsModel: componentConfigurationsModel,
    );

    filterController.getAllFilterData(isRefresh: false, componentId: componentId).then((value) {
      initializeSelectedFilterValuesFromProvider();
      initializeInitialExpansionPanelOpen();
    });
    initializeSelectedFilterValuesFromProvider();
    initializeInitialExpansionPanelOpen();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return ChangeNotifierProvider<FilterProvider>.value(
      value: filterProvider,
      builder: (BuildContext context, Widget? child) {
        return Consumer<FilterProvider>(
          builder: (BuildContext context, FilterProvider filterProvider, Widget? child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: getAppBarWidget(),
              body: getMainWidget(filterProvider: filterProvider),
              bottomNavigationBar: getApplyAndResetButton(),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget getAppBarWidget() {
    return AppBar(
      title: const Text("Filters"),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.clear,
        ),
      ),
    );

    /*return PreferredSize(
      preferredSize: const Size(double.infinity, 90),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(color: Colors.white, offset: Offset(0, 4.0), blurRadius: 4.0, spreadRadius: 1),
            BoxShadow(color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 4.0), blurRadius: 4.0, spreadRadius: 1)
          ],
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 40),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.clear,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                    "Filters",
                    style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ))),
                  Expanded(
                    child: Container(
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );*/
  }

  //region getMainWidget
  Widget getMainWidget({required FilterProvider filterProvider}) {
    if (filterProvider.isLoadingFilterData.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    MyPrint.printOnConsole("componentConfigurationsModel.contentFilterBy:${componentConfigurationsModel.contentFilterBy}");

    return RefreshIndicator(
      onRefresh: () async {
        filterController.getAllFilterData(isRefresh: true, componentId: componentId).then((value) {
          initializeSelectedFilterValuesFromProvider();
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            /*...(List<String>.from(componentConfigurationsModel.contentFilterBy)..addAll([
              ContentFilterByTypes.instructor,
              ContentFilterByTypes.skills,
              ContentFilterByTypes.rating,
              ContentFilterByTypes.eventduration,
              ContentFilterByTypes.ecommerceprice,
              ContentFilterByTypes.eventdates,
              ContentFilterByTypes.creditpoints,
            ])).toSet().map((String contentFilterByType) {*/
            ...componentConfigurationsModel.contentFilterBy.toSet().map((String contentFilterByType) {
              return getContentFilterByMainWidget(
                contentFilterByType: contentFilterByType,
                filterProvider: filterProvider,
              );
            }),
          ],
        ),
      ),
    );
  }

  //endregion

  Widget getContentFilterByMainWidget({required String contentFilterByType, required FilterProvider filterProvider}) {
    if ([
      ContentFilterByTypes.categories,
      ContentFilterByTypes.skills,
      ContentFilterByTypes.objecttypeid,
      ContentFilterByTypes.job,
      ContentFilterByTypes.jobroles,
      ContentFilterByTypes.solutions,
    ].contains(contentFilterByType)) {
      return getCategoryTreeMainWidget(
        contentFilterByType: contentFilterByType,
        filterProvider: filterProvider,
      );
    } else if (contentFilterByType == ContentFilterByTypes.learningprovider) {
      return getLearningProviderMainWidget(filterProvider: filterProvider);
    } else if (contentFilterByType == ContentFilterByTypes.instructor) {
      return getInstructorsMainWidget(filterProvider: filterProvider);
    } else if (contentFilterByType == ContentFilterByTypes.ecommerceprice) {
      return getPriceRangeMainWidget();
    } else if (contentFilterByType == ContentFilterByTypes.eventdates) {
      return getEventDateMainWidget();
    } else if (contentFilterByType == ContentFilterByTypes.creditpoints) {
      return getCreditPointsMainWidget(filterProvider: filterProvider);
    } else if (contentFilterByType == ContentFilterByTypes.rating) {
      return getRatingsMainWidget();
    } else {
      return const SizedBox();
    }
  }

  //region Category Tree
  Widget getCategoryTreeMainWidget({required String contentFilterByType, required FilterProvider filterProvider}) {
    String title = "";
    bool isExpanded = false;
    void Function(bool)? onExpanded;
    List<ContentFilterCategoryTreeModel> categoryTreeModelList = [];
    List<ContentFilterCategoryTreeModel> selectedCategoryTreeModelList = [];

    if (contentFilterByType == ContentFilterByTypes.categories) {
      categoryTreeModelList = filterProvider.categories.getList(isNewInstance: false);
      selectedCategoryTreeModelList = selectedCategories;

      title = localStr.filterLblCaegoriestitlelabel.isNotEmpty ? localStr.filterLblCaegoriestitlelabel : "Categories";
      isExpanded = isCategoriesExpanded;
      onExpanded = (bool? isValue) {
        isCategoriesExpanded = isValue ?? false;
        if (!isCategoriesExpanded) closeAllChildExpansionPanel(children: categoryTreeModelList);
        mySetState();
      };
    } else if (contentFilterByType == ContentFilterByTypes.skills) {
      categoryTreeModelList = filterProvider.skills.getList(isNewInstance: false);
      selectedCategoryTreeModelList = selectedSkills;

      title = localStr.filterLblByskills.isNotEmpty ? localStr.filterLblByskills : "Skills";
      isExpanded = isSkillsExpanded;
      onExpanded = (bool? isValue) {
        isSkillsExpanded = isValue ?? false;
        if (!isSkillsExpanded) closeAllChildExpansionPanel(children: categoryTreeModelList);
        mySetState();
      };
    } else if (contentFilterByType == ContentFilterByTypes.objecttypeid) {
      categoryTreeModelList = filterProvider.contentTypes.getList(isNewInstance: false);
      selectedCategoryTreeModelList = selectedContentTypes;

      title = localStr.filterLblContenttype.isNotEmpty ? localStr.filterLblContenttype : "Content Types";
      isExpanded = isContentTypeExpanded;
      onExpanded = (bool? isValue) {
        isContentTypeExpanded = isValue ?? false;
        if (!isContentTypeExpanded) closeAllChildExpansionPanel(children: categoryTreeModelList);
        mySetState();
      };
    } else if ([ContentFilterByTypes.jobroles, ContentFilterByTypes.job].contains(contentFilterByType)) {
      title = "Job Roles";
      categoryTreeModelList = filterProvider.jobRoles.getList(isNewInstance: false);
      selectedCategoryTreeModelList = selectedJobRoles;

      title = localStr.filterLblJobrolesHeader.isNotEmpty ? localStr.filterLblJobrolesHeader : "Job Roles";
      isExpanded = isJobRolesExpanded;
      onExpanded = (bool? isValue) {
        isJobRolesExpanded = isValue ?? false;
        if (!isJobRolesExpanded) closeAllChildExpansionPanel(children: categoryTreeModelList);
        mySetState();
      };
    } else if (contentFilterByType == ContentFilterByTypes.solutions) {
      categoryTreeModelList = filterProvider.solutions.getList(isNewInstance: false);
      selectedCategoryTreeModelList = selectedSolutions;

      title = localStr.filterLblTag.isNotEmpty ? localStr.filterLblTag : "Marketplace Categories";
      isExpanded = isSolutionsExpanded;
      onExpanded = (bool? isValue) {
        isSolutionsExpanded = isValue ?? false;
        if (!isSolutionsExpanded) closeAllChildExpansionPanel(children: categoryTreeModelList);
        mySetState();
      };
    }

    if (categoryTreeModelList.isNotEmpty) {
      List<String> selectedCategoryIdsList = selectedCategoryTreeModelList.map((e) => e.categoryId).toList();

      MyPrint.printOnConsole("selectedCategoryIdsList length for $title:${selectedCategoryIdsList.length}");

      return getCommonExpansionTile(
        title: title,
        isExpanded: isExpanded,
        onExpanded: onExpanded,
        childrenCount: selectedCategoryIdsList.length,
        children: categoryTreeModelList.map((e) {
          return getCategoryTreeWidget(
            contentFilterCategoryTreeModel: e,
            hasChild: e.children.isNotEmpty,
            selectedCategoryIdsList: selectedCategoryIdsList,
            selectedCategoryTreeModelList: selectedCategoryTreeModelList,
          );
        }).toList(),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getCategoryTreeWidget({
    required ContentFilterCategoryTreeModel contentFilterCategoryTreeModel,
    bool hasChild = false,
    required List<String> selectedCategoryIdsList,
    required List<ContentFilterCategoryTreeModel> selectedCategoryTreeModelList,
  }) {
    if (hasChild) {
      int selectedCount = 0;

      List<Widget> children = <Widget>[];
      for (ContentFilterCategoryTreeModel e in contentFilterCategoryTreeModel.children) {
        if (selectedCategoryIdsList.contains(e.categoryId)) selectedCount++;

        selectedCount += getSelectedChildrenCount(children: e.children, selectedChildren: selectedCategoryIdsList);

        children.add(getCategoryTreeWidget(
          contentFilterCategoryTreeModel: e,
          hasChild: e.children.isNotEmpty,
          selectedCategoryIdsList: selectedCategoryIdsList,
          selectedCategoryTreeModelList: selectedCategoryTreeModelList,
        ));
      }

      return Theme(
        data: themeData.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ListTileTheme(
          // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          dense: false,
          horizontalTitleGap: 0.0,
          minLeadingWidth: 0,
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            // tilePadding: const EdgeInsets.symmetric(horizontal: 10),
            childrenPadding: const EdgeInsets.only(left: 30),
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            initiallyExpanded: contentFilterCategoryTreeModel.isExpansionPanelExpanded,
            onExpansionChanged: (bool? val) {
              contentFilterCategoryTreeModel.isExpansionPanelExpanded = val ?? false;
              mySetState();
            },
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (!selectedCategoryTreeModelList.map((e) => e.categoryId).contains(contentFilterCategoryTreeModel.categoryId)) {
                        selectedCategoryTreeModelList.add(contentFilterCategoryTreeModel);
                      } else {
                        selectedCategoryTreeModelList.removeWhere((element) => element.categoryId == contentFilterCategoryTreeModel.categoryId);
                      }
                      mySetState();
                    },
                    child: Icon(
                      selectedCategoryTreeModelList.contains(contentFilterCategoryTreeModel) ? Icons.check_box : Icons.check_box_outline_blank,
                      color: selectedCategoryTreeModelList.contains(contentFilterCategoryTreeModel) ? themeData.primaryColor : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      contentFilterCategoryTreeModel.categoryName,
                      style: themeData.textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 11.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedCount > 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeData.primaryColor,
                      ),
                      child: Text(
                        "$selectedCount",
                        style: themeData.textTheme.labelSmall?.copyWith(
                          color: themeData.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 350),
                    turns: contentFilterCategoryTreeModel.isExpansionPanelExpanded ? .5 : 0,
                    child: const Icon(Icons.arrow_drop_down_outlined),
                  ),
                ],
              ),
            ),
            children: children,
          ),
        ),
      );
    } else {
      bool isSelected = selectedCategoryIdsList.contains(contentFilterCategoryTreeModel.categoryId);

      return getFilterItemWidget(
        categoryId: contentFilterCategoryTreeModel.categoryId,
        categoryName: contentFilterCategoryTreeModel.categoryName,
        isSelected: isSelected,
        onTap: (String categoryId) {
          if (!isSelected) {
            selectedCategoryTreeModelList.add(contentFilterCategoryTreeModel);
          } else {
            selectedCategoryTreeModelList.removeWhere((element) => element.categoryId == contentFilterCategoryTreeModel.categoryId);
          }
          mySetState();
        },
      );
    }
  }

  //endregion

  Widget getLearningProviderMainWidget({required FilterProvider filterProvider}) {
    List<int> selectedLearningProviderIdsList = selectedLearningProviders.map((e) => e.SiteID).toList();

    return getCommonExpansionTile(
      title: "Learning Provider",
      isExpanded: isLearningProviderExpanded,
      onExpanded: (bool? isValue) {
        isLearningProviderExpanded = isValue ?? false;
        mySetState();
      },
      childrenCount: selectedLearningProviders.length,
      children: filterProvider.learningProviders.getList(isNewInstance: false).map((LearningProviderModel e) {
        bool isSelected = selectedLearningProviderIdsList.contains(e.SiteID);

        return getFilterItemWidget(
          categoryId: e.SiteID.toString(),
          categoryName: e.LearningProviderName,
          isSelected: isSelected,
          onTap: (String categoryId) {
            if (!isSelected) {
              selectedLearningProviders.add(e);
            } else {
              selectedLearningProviders.removeWhere((element) => element.SiteID == e.SiteID);
            }
            mySetState();
          },
        );
      }).toList(),
    );
  }

  Widget getInstructorsMainWidget({required FilterProvider filterProvider}) {
    List<String> selectedInstructorsIdsList = selectedInstructors.map((e) => e.UserID).toList();

    return getCommonExpansionTile(
      title: localStr.filterLblInstructor,
      isExpanded: isInstructorsExpanded,
      onExpanded: (bool? isValue) {
        isInstructorsExpanded = isValue ?? false;
        mySetState();
      },
      childrenCount: selectedInstructors.length,
      children: filterProvider.instructors.getList(isNewInstance: false).map((InstructorUserModel e) {
        bool isSelected = selectedInstructorsIdsList.contains(e.UserID);

        return getFilterItemWidget(
          categoryId: e.UserID,
          categoryName: e.UserName,
          isSelected: isSelected,
          onTap: (String categoryId) {
            if (!isSelected) {
              selectedInstructors.add(e);
            } else {
              selectedInstructors.removeWhere((element) => element.UserID == e.UserID);
            }
            mySetState();
          },
        );
      }).toList(),
    );
  }

  //region Ecommerce Price
  Widget getPriceRangeMainWidget() {
    return getCommonExpansionTile(
      title: localStr.filterLblPricerange,
      isExpanded: isEcommercePriceExpanded,
      onExpanded: (bool? isValue) {
        isEcommercePriceExpanded = isValue ?? false;
        mySetState();
      },
      // childrenCount: ,
      hasData: minPriceTextController.text.isNotEmpty || maxPriceTextController.text.isNotEmpty,
      children: [
        Row(
          children: [
            Expanded(
              child: getPriceTextField(
                controller: minPriceTextController,
                hint: "Min Value",
                onChanged: (String value) {
                  MyPrint.printOnConsole("onChanged called for Min Value:$value");
                  if (value.isEmpty) {
                    minPrice = null;
                  } else {
                    minPrice = ParsingHelper.parseIntMethod(value);
                  }
                  mySetState();
                },
              ),
            ),
            Expanded(
              child: getPriceTextField(
                controller: maxPriceTextController,
                hint: "Max Value",
                onChanged: (String value) {
                  MyPrint.printOnConsole("onChanged called for Max Value:$value");

                  if (value.isEmpty) {
                    maxPrice = null;
                  } else {
                    maxPrice = ParsingHelper.parseIntMethod(value);
                  }
                  mySetState();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getPriceTextField({
    required TextEditingController controller,
    required String hint,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: CommonTextFormFieldWithLabel(
        onChanged: onChanged,
        controller: controller,
        isOutlineInputBorder: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        borderRadius: 25,
        labelText: hint,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  //endregion

  //region Event Date
  Widget getEventDateMainWidget() {
    return getCommonExpansionTile(
      title: localStr.filterLblEventdateheader,
      isExpanded: isEventDateExpanded,
      onExpanded: (bool? isValue) {
        isEventDateExpanded = isValue ?? false;
        mySetState();
      },
      hasData: selectedEventDateType != null,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: themeData.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                onChanged: (String? type) {
                  EventDateModel? model = type.checkNotEmpty ? eventDatesList
                      .where((element) => element.type == type)
                      .firstElement : null;
                  selectedEventDateType = model;
                  mySetState();
                },
                value: selectedEventDateType?.type,
                isExpanded: true,
                isDense: true,
                underline: const SizedBox(),
                hint: Text(
                  localStr.filterLblEventdatedate,
                  style: themeData.textTheme.labelMedium?.copyWith(),
                ),
                dropdownColor: Colors.white,
                items: eventDatesList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.type,
                    child: Text(
                      e.title,
                      style: themeData.textTheme.labelLarge?.copyWith(
                        // color: themeData.colorScheme.onPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (selectedEventDateType?.type == EventDateTypes.choosedate)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    getDateSelectionWidget(
                      hint: "Start Date",
                      dateTime: startEventDate,
                      onDateTimeSelected: (DateTime dateTime) {
                        startEventDate = dateTime;
                        mySetState();
                      },
                      onDateTimeDeleted: () {
                        startEventDate = null;
                        mySetState();
                      },
                    ),
                    getDateSelectionWidget(
                      hint: "End Date(Optional)",
                      dateTime: endEventDate,
                      onDateTimeSelected: (DateTime dateTime) {
                        endEventDate = dateTime;
                        mySetState();
                      },
                      onDateTimeDeleted: () {
                        endEventDate = null;
                        mySetState();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget getDateSelectionWidget({
    required String hint,
    required DateTime? dateTime,
    required void Function(DateTime) onDateTimeSelected,
    required void Function() onDateTimeDeleted,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1957),
            lastDate: DateTime(2030, 12, 31),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.lightGreen,
                  //selection color
                  dialogBackgroundColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightGreen), //Background color
                ),
                child: child ?? const SizedBox(),
              );
            },
          );
          MyPrint.printOnConsole("Selected date for @hint:$date");

          if (date != null) {
            onDateTimeSelected(date);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: themeData.colorScheme.onBackground),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dateTime != null ? DateFormat("MMM dd, yyyy").format(dateTime) : hint,
                ),
              ),
              if (dateTime != null)
                GestureDetector(
                  onTap: () {
                    onDateTimeDeleted();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  ),
                ),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
      ),
    );
  }

  //endregion

  Widget getCreditPointsMainWidget({required FilterProvider filterProvider}) {
    return getCommonExpansionTile(
      title: localStr.filterLblCredits,
      isExpanded: isCreditPointsExpanded,
      onExpanded: (bool? isValue) {
        isCreditPointsExpanded = isValue ?? false;
        mySetState();
      },
      // hasData: selectedFilterCredits != null,
      children: [
        Column(
          children: filterProvider.filterDurationValues.getList(isNewInstance: false).map((FilterDurationValueModel e) {
            return RadioListTile<FilterDurationValueModel>(
              onChanged: (FilterDurationValueModel? value) {
                selectedFilterCredits = value;
                mySetState();
              },
              groupValue: selectedFilterCredits,
              value: e,
              title: Text(e.Displayvalue),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget getRatingsMainWidget() {
    return getCommonExpansionTile(
      title: localStr.filterLblRating,
      isExpanded: isEventRatingsExpanded,
      onExpanded: (bool? isValue) {
        isEventRatingsExpanded = isValue ?? false;
        mySetState();
      },
      hasData: selectedRating != null,
      children: [
        Column(
          children: ratingsList.map((e) {
            return RadioListTile<double>(
              onChanged: (double? value) {
                selectedRating = value;
                mySetState();
              },
              dense: true,
              groupValue: selectedRating,
              value: e,
              title: Row(
                children: [
                  RatingBar.builder(
                    initialRating: e,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    updateOnDrag: false,
                    tapOnlyMode: true,
                    itemCount: 5,
                    itemSize: 25,
                    glow: false,
                    ignoreGestures: true,
                    itemBuilder: (context, _) =>
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      MyPrint.printOnConsole("onRatingUpdate called:$rating");
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "$e and Up",
                      style: themeData.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  //region getCommonExpansionTileView
  Widget getCommonExpansionTile({
    String title = "",
    List<Widget> children = const [],
    bool isExpanded = false,
    void Function(bool)? onExpanded,
    int childrenCount = 0,
    bool hasData = false,
  }) {
    return Theme(
      data: themeData.copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.black12, blurRadius: 3)]),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          onExpansionChanged: onExpanded,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (childrenCount > 0)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeData.primaryColor,
                  ),
                  child: Text(
                    "$childrenCount",
                    style: themeData.textTheme.labelSmall?.copyWith(
                      color: themeData.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (hasData)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeData.primaryColor,
                  ),
                ),
              AnimatedRotation(
                turns: isExpanded ? .5 : 0,
                duration: const Duration(microseconds: 300),
                child: const Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 27,
                ),
              ),
            ],
          ),
          title: Text(
            title,
            style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.4),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget getFilterItemWidget({
    required String categoryId,
    required String categoryName,
    bool isSelected = false,
    void Function(String id)? onTap,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(categoryId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? themeData.primaryColor : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                categoryName,
                style: themeData.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //endregion

  //region Apply and reset button
  Widget getApplyAndResetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                resetFilterData();
              },
              backGroundColor: themeData.colorScheme.onPrimary,
              borderColor: themeData.primaryColor,
              fontColor: themeData.primaryColor,
              fontWeight: FontWeight.w600,
              // isPrimary: false,
              text: "Reset",
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                applyFilterData();
              },
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              fontColor: themeData.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              // isPrimary: true,
              text: "Apply",
            ),
          ),
        ],
      ),
    );
  }
//endregion
}

class EventDateModel {
  final String title, type;

  const EventDateModel({
    this.title = "",
    this.type = "",
  });
}

class EventDateTypes {
  static const String today = "today";
  static const String tomorrow = "tomorrow";
  static const String thisweek = "thisweek";
  static const String nextweek = "nextweek";
  static const String thismonth = "thismonth";
  static const String nextmonth = "nextmonth";
  static const String choosedate = "choosedate";
}

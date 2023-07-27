import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/filter/data_model/filter_duration_value_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/instructor_user_model.dart';
import 'package:flutter_instancy_2/views/filter/screens/filters_screen.dart';

import '../../models/filter/data_model/component_sort_model.dart';
import '../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/filter/data_model/learning_provider_model.dart';

class FilterProvider extends CommonProvider {
  FilterProvider() {
    //region Filter Data
    categories = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    skills = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
      newInstancialization: (ContentFilterCategoryTreeModel value) {
        return ContentFilterCategoryTreeModel.fromJson(value.toJson());
      },
    );

    contentTypes = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    jobRoles = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    solutions = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    learningProviders = CommonProviderListParameter<LearningProviderModel>(
      list: <LearningProviderModel>[],
      notify: notify,
    );

    instructors = CommonProviderListParameter<InstructorUserModel>(
      list: <InstructorUserModel>[],
      notify: notify,
    );

    filterDurationValues = CommonProviderListParameter<FilterDurationValueModel>(
      list: <FilterDurationValueModel>[],
      notify: notify,
    );

    defaultFilterCredit = CommonProviderPrimitiveParameter<FilterDurationValueModel?>(
      value: null,
      notify: notify,
    );

    isLoadingFilterData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    sortOptions = CommonProviderListParameter<ComponentSortModel>(
      list: <ComponentSortModel>[],
      notify: notify,
    );

    isLoadingSortData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    defaultSort = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    //endregion

    //region Selected Filter Data
    selectedCategories = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    selectedSkills = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    selectedContentTypes = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    selectedJobRoles = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    selectedSolutions = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    selectedLearningProviders = CommonProviderListParameter<LearningProviderModel>(
      list: <LearningProviderModel>[],
      notify: notify,
    );

    selectedInstructor = CommonProviderListParameter<InstructorUserModel>(
      list: <InstructorUserModel>[],
      notify: notify,
    );

    minPrice = CommonProviderPrimitiveParameter<int?>(
      value: null,
      notify: notify,
    );

    maxPrice = CommonProviderPrimitiveParameter<int?>(
      value: null,
      notify: notify,
    );

    selectedFilterCredit = CommonProviderPrimitiveParameter<FilterDurationValueModel?>(
      value: null,
      notify: notify,
    );

    selectedRating = CommonProviderPrimitiveParameter<double?>(
      value: null,
      notify: notify,
    );

    selectedEventDateType = CommonProviderPrimitiveParameter<EventDateModel?>(
      value: null,
      notify: notify,
    );

    selectedStartEventDateTime = CommonProviderPrimitiveParameter<DateTime?>(
      value: null,
      notify: notify,
    );

    selectedEndEventDateTime = CommonProviderPrimitiveParameter<DateTime?>(
      value: null,
      notify: notify,
    );

    selectedSort = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    //endregion
  }

  //region EnabledContentFilterByTypeModel
  final EnabledContentFilterByTypeModel _enabledContentFilterByTypeModel = EnabledContentFilterByTypeModel();

  EnabledContentFilterByTypeModel getEnabledContentFilterByTypeModel({bool isNewInstance = true}) {
    if(isNewInstance) {
      return EnabledContentFilterByTypeModel.copyFrom(_enabledContentFilterByTypeModel);
    }
    else {
      return _enabledContentFilterByTypeModel;
    }
  }

  void setEnabledContentFilterByTypeModelFromList({required List<String> filterByList, bool isNotify = true}) {
    _enabledContentFilterByTypeModel.updateFromList(filterByList);
    notify(isNotify: isNotify);
  }
  //endregion

  //region Filter Data
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> categories;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> skills;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> contentTypes;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> jobRoles;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> solutions;
  late CommonProviderListParameter<LearningProviderModel> learningProviders;
  late CommonProviderListParameter<InstructorUserModel> instructors;
  late CommonProviderListParameter<FilterDurationValueModel> filterDurationValues;
  late CommonProviderPrimitiveParameter<FilterDurationValueModel?> defaultFilterCredit;
  late CommonProviderPrimitiveParameter<bool> isLoadingFilterData;

  late CommonProviderListParameter<ComponentSortModel> sortOptions;
  late CommonProviderPrimitiveParameter<bool> isLoadingSortData;
  late CommonProviderPrimitiveParameter<String> defaultSort;
  //endregion

  //region Selected Filter Data
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> selectedCategories;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> selectedSkills;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> selectedContentTypes;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> selectedJobRoles;
  late CommonProviderListParameter<ContentFilterCategoryTreeModel> selectedSolutions;
  late CommonProviderListParameter<LearningProviderModel> selectedLearningProviders;
  late CommonProviderListParameter<InstructorUserModel> selectedInstructor;
  late CommonProviderPrimitiveParameter<int?> minPrice;
  late CommonProviderPrimitiveParameter<int?> maxPrice;
  late CommonProviderPrimitiveParameter<FilterDurationValueModel?> selectedFilterCredit;
  late CommonProviderPrimitiveParameter<double?> selectedRating;
  late CommonProviderPrimitiveParameter<EventDateModel?> selectedEventDateType;
  late CommonProviderPrimitiveParameter<DateTime?> selectedStartEventDateTime;
  late CommonProviderPrimitiveParameter<DateTime?> selectedEndEventDateTime;
  late CommonProviderPrimitiveParameter<String> selectedSort;

  int selectedFiltersCount() {
    int count = 0;
    if(selectedCategories.length > 0) count++;
    if(selectedSkills.length > 0) count++;
    if(selectedContentTypes.length > 0) count++;
    if(selectedJobRoles.length > 0) count++;
    if(selectedSolutions.length > 0) count++;
    if(selectedLearningProviders.length > 0) count++;
    if(selectedInstructor.length > 0) count++;
    if(minPrice.get() != null) count++;
    if(maxPrice.get() != null) count++;
    // if(selectedFilterCredit.get() != null) count++;
    if(selectedRating.get() != null) count++;
    if(selectedEventDateType.get() != null) count++;
    if(selectedStartEventDateTime.get() != null) count++;
    if(selectedEndEventDateTime.get() != null) count++;

    return count;
  }
  //endregion

  void resetData() {
    setEnabledContentFilterByTypeModelFromList(filterByList: [], isNotify: false);
    categories.setList(list: [], isNotify: false);
    skills.setList(list: [], isNotify: false);
    contentTypes.setList(list: [], isNotify: false);
    jobRoles.setList(list: [], isNotify: false);
    solutions.setList(list: [], isNotify: false);
    learningProviders.setList(list: [], isNotify: false);
    instructors.setList(list: [], isNotify: false);
    filterDurationValues.setList(list: [], isNotify: false);
    defaultFilterCredit.set(value: null, isNotify: false);
    isLoadingFilterData.set(value: false, isNotify: false);
    sortOptions.setList(list: [], isNotify: false);
    isLoadingSortData.set(value: false, isNotify: false);

    selectedCategories.setList(list: [], isNotify: false);
    selectedSkills.setList(list: [], isNotify: false);
    selectedContentTypes.setList(list: [], isNotify: false);
    selectedJobRoles.setList(list: [], isNotify: false);
    selectedSolutions.setList(list: [], isNotify: false);
    selectedLearningProviders.setList(list: [], isNotify: false);
    selectedInstructor.setList(list: [], isNotify: false);
    minPrice.set(value: null, isNotify: false);
    maxPrice.set(value: null, isNotify: false);
    selectedFilterCredit.set(value: null, isNotify: false);
    selectedRating.set(value: null, isNotify: false);
    selectedEventDateType.set(value: null, isNotify: false);
    selectedStartEventDateTime.set(value: null, isNotify: false);
    selectedEndEventDateTime.set(value: null, isNotify: false);
    selectedSort.set(value: defaultSort.get(), isNotify: true);
  }
}

import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/models/filter/data_model/filter_duration_value_model.dart';
import 'package:flutter_instancy_2/models/filter/request_model/component_sort_params_model.dart';
import 'package:flutter_instancy_2/models/filter/response_model/filter_duration_values_response_model.dart';
import 'package:flutter_instancy_2/models/filter/response_model/instructor_list_filter_response_model.dart';
import 'package:flutter_instancy_2/models/filter/response_model/learning_provider_filter_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_controller.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/filter/data_model/component_sort_model.dart';
import '../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/filter/data_model/instructor_user_model.dart';
import '../../models/filter/data_model/learning_provider_model.dart';
import '../../models/filter/request_model/content_filter_params_model.dart';
import '../../models/filter/response_model/component_sort_options_response_model.dart';
import '../../views/filter/screens/filters_screen.dart';
import 'filter_repository.dart';

class FilterController {
  late FilterProvider _filterProvider;
  late FilterRepository _filterRepository;

  FilterController({required FilterProvider? filterProvider, FilterRepository? repository, ApiController? apiController}) {
    _filterProvider = filterProvider ?? FilterProvider();
    _filterRepository = repository ?? FilterRepository(apiController: apiController ?? ApiController());
  }

  FilterProvider get filterProvider => _filterProvider;

  FilterRepository get filterRepository => _filterRepository;

  void initializeMainFiltersList({required ComponentConfigurationsModel componentConfigurationsModel}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FilterController().initializeMainFiltersList() called", tag: tag);

    MyPrint.printOnConsole("componentConfigurationsModel.contentFilterBy:${componentConfigurationsModel.contentFilterBy}", tag: tag);

    filterProvider.setEnabledContentFilterByTypeModelFromList(
      filterByList: componentConfigurationsModel.contentFilterBy,
      /*filterByList: List<String>.from(componentConfigurationsModel.contentFilterBy)..addAll([
        ContentFilterByTypes.instructor,
        ContentFilterByTypes.skills,
        ContentFilterByTypes.rating,
        ContentFilterByTypes.eventduration,
        ContentFilterByTypes.ecommerceprice,
        ContentFilterByTypes.eventdates,
        ContentFilterByTypes.creditpoints,
      ]),*/
      isNotify: false,
    );
  }

  Future<void> getAllFilterData({bool isRefresh = true, required int componentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FilterController().getAllFilterData() called with componentId:$componentId", tag: tag);

    FilterProvider provider = filterProvider;
    FilterRepository repository = filterRepository;

    provider.isLoadingFilterData.set(value: true);

    List<Future> futures = <Future>[];

    EnabledContentFilterByTypeModel enabledContentFilterByTypeModel = provider.getEnabledContentFilterByTypeModel(
      isNewInstance: false,
    );

    if (enabledContentFilterByTypeModel.categories && (isRefresh || provider.categories.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        getContentFilterCategoryTree(
          contentFilterParams: ContentFilterParamsModel(
            ComponentID: componentId,
            Type: "cat",
            ShowAllItems: true.toString(),
            IsCompetencypath: "false",
          ),
        ).then((List<ContentFilterCategoryTreeModel> list) {
          provider.categories.setList(list: list, isClear: true, isNotify: false);
        })
      );
    }

    if (enabledContentFilterByTypeModel.skills && (isRefresh || provider.skills.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        getContentFilterCategoryTree(
          contentFilterParams: ContentFilterParamsModel(
            ComponentID: componentId,
            Type: "skills",
            ShowAllItems: true.toString(),
            IsCompetencypath: "false",
          ),
        ).then((List<ContentFilterCategoryTreeModel> list) {
          provider.skills.setList(list: list, isClear: true, isNotify: false);
        })
      );
    }

    if (enabledContentFilterByTypeModel.objecttypeid && (isRefresh || provider.contentTypes.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        getContentFilterCategoryTree(
          contentFilterParams: ContentFilterParamsModel(
            ComponentID: componentId,
            Type: "bytype",
            ShowAllItems: true.toString(),
            IsCompetencypath: "false",
          ),
        ).then((List<ContentFilterCategoryTreeModel> list) {
          provider.contentTypes.setList(list: list, isClear: true, isNotify: false);
        })
      );
    }

    if (enabledContentFilterByTypeModel.jobroles && (isRefresh || provider.jobRoles.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        getContentFilterCategoryTree(
          contentFilterParams: ContentFilterParamsModel(
            ComponentID: componentId,
            Type: "jobroles",
            ShowAllItems: true.toString(),
            IsCompetencypath: "false",
          ),
        ).then((List<ContentFilterCategoryTreeModel> list) {
          provider.jobRoles.setList(list: list, isClear: true, isNotify: false);
        })
      );
    }

    if (enabledContentFilterByTypeModel.solutions && (isRefresh || provider.solutions.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        getContentFilterCategoryTree(
          contentFilterParams: ContentFilterParamsModel(
            ComponentID: componentId,
            Type: "tag",
            ShowAllItems: true.toString(),
            IsCompetencypath: "false",
          ),
        ).then((List<ContentFilterCategoryTreeModel> list) {
          provider.solutions.setList(list: list, isClear: true, isNotify: false);
        })
      );
    }

    if (enabledContentFilterByTypeModel.learningprovider && (isRefresh || provider.learningProviders.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        repository.getLearningProviders(privacyType: 'public').then((DataResponseModel<LearningProviderFilterResponseModel> responseModel) {
          if(responseModel.data != null) {
            provider.learningProviders.setList(list: responseModel.data!.Table, isClear: true, isNotify: false);
          }
        })
      );
    }

    if (enabledContentFilterByTypeModel.instructor && (isRefresh || provider.instructors.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        repository.getInstructorsListForFilter().then((DataResponseModel<InstructorListFilterResponseModel> responseModel) {
          if(responseModel.data != null) {
            provider.instructors.setList(list: responseModel.data!.Table, isClear: true, isNotify: false);
          }
        })
      );
    }

    if (enabledContentFilterByTypeModel.creditpoints && (isRefresh || provider.filterDurationValues.getList(isNewInstance: false).isEmpty)) {
      futures.add(
        repository.getFilterDurationValues().then((DataResponseModel<FilterDurationValuesResponseModel> responseModel) {
          if(responseModel.data != null) {
            List<FilterDurationValueModel> list = responseModel.data!.Table1;

            FilterDurationValueModel? defaultCreditValue;
            List<FilterDurationValueModel> defaultValues = list.where((element) => element.defaultvalue.isNotEmpty).toList();
            if(defaultValues.isNotEmpty) {
              FilterDurationValueModel filterDurationValueModel = defaultValues.first;
              defaultCreditValue = filterDurationValueModel;
              // defaultCreditValue = "${filterDurationValueModel.Minvalue},${filterDurationValueModel.Maxvalue}";
            }
            MyPrint.printOnConsole("defaultCreditValue:$defaultCreditValue");
            provider.defaultFilterCredit.set(value: defaultCreditValue, isNotify: false);

            FilterDurationValueModel? selectedCredit = provider.selectedFilterCredit.get();
            if(selectedCredit == null) {
              provider.selectedFilterCredit.set(value: defaultCreditValue, isNotify: false);
            }
            else {
              // List<String> creditsList = list.map((e) => "${e.Minvalue},${e.Maxvalue}").toList();
              List<FilterDurationValueModel> creditsList = list.where((element) => element.Displayvalue == selectedCredit.Displayvalue).toList();
              if(creditsList.isEmpty) {
                provider.selectedFilterCredit.set(value: defaultCreditValue, isNotify: false);
              }
            }
            MyPrint.printOnConsole("Final Selected Filter Credit:${provider.selectedFilterCredit.get()}");

            provider.filterDurationValues.setList(list: list, isClear: true, isNotify: false);
          }
        })
      );
    }

    MyPrint.printOnConsole("futures length:${futures.length}");
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }

    removeInvalidValuesFromSelectedFilterParameters();

    provider.isLoadingFilterData.set(value: false);

    MyPrint.printOnConsole("FilterController().getAllFilterData() Finished", tag: tag);
  }

  Future<List<ContentFilterCategoryTreeModel>> getContentFilterCategoryTree({required ContentFilterParamsModel contentFilterParams}) async {
    DataResponseModel<List<ContentFilterCategoryTreeModel>> dataResponseModel = await filterRepository.getContentFilterCategoryTree(
      contentFilterParams: contentFilterParams,
    );

    if(dataResponseModel.data != null) {
      List<ContentFilterCategoryTreeModel> list = dataResponseModel.data!;

      Map<String, ContentFilterCategoryTreeModel> map = <String, ContentFilterCategoryTreeModel>{};
      for (ContentFilterCategoryTreeModel element in list) {
        map[element.categoryId] = element;
      }

      map.forEach((String categoryId, ContentFilterCategoryTreeModel categoryTreeModel) {
        if(categoryTreeModel.parentId != "0") {
          map[categoryTreeModel.parentId]?.children.add(categoryTreeModel);
          list.remove(categoryTreeModel);
        }
      });

      return list;
    }
    else {
      return <ContentFilterCategoryTreeModel>[];
    }
  }

  Future<List<ComponentSortModel>> getSortOptionsList({bool isRefresh = true, required int componentId}) async {
    FilterProvider provider = filterProvider;

    List<ComponentSortModel> list = <ComponentSortModel>[];

    if(isRefresh || provider.sortOptions.getList(isNewInstance: false).isEmpty) {
      provider.isLoadingSortData.set(value: true, isNotify: true);

      DataResponseModel<ComponentSortResponseModel> dataResponseModel = await filterRepository.getComponentSortValues(
        requestParamsModel: ComponentSortParamsModel(
          ComponentID: componentId,
        ),
      );

      if(dataResponseModel.data != null) {
        list = dataResponseModel.data!.Table;
      }

      MyPrint.printOnConsole("Final SortOptions length:${list.length}");
      provider.sortOptions.setList(list: list, isClear: true, isNotify: false);
      if(provider.selectedSort.get().isEmpty && list.isNotEmpty) {
        provider.selectedSort.set(value: list.first.OptionValue, isNotify: false);
      }
      provider.isLoadingSortData.set(value: false, isNotify: true);
    }
    else {
      list = provider.sortOptions.getList(isNewInstance: false);
    }

    return list;
  }

  void removeInvalidValuesFromSelectedFilterParameters() {
    FilterProvider provider = filterProvider;

    {
      List<String> categories = <String>[];
      for (ContentFilterCategoryTreeModel model in provider.categories.getList(isNewInstance: false)) {
        categories.add(model.categoryId);
        categories.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model).map((e) => e.categoryId));
      }
      List<ContentFilterCategoryTreeModel> selectedCategories = provider.selectedCategories.getList();
      selectedCategories.removeWhere((element) => !categories.contains(element.categoryId));
      provider.selectedCategories.setList(list: selectedCategories, isClear: true, isNotify: false);
    }

    {
      List<String> skills = <String>[];
      for (ContentFilterCategoryTreeModel model in provider.skills.getList(isNewInstance: false)) {
        skills.add(model.categoryId);
        skills.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model).map((e) => e.categoryId));
      }

      List<ContentFilterCategoryTreeModel> selectedSkills = provider.selectedSkills.getList();
      selectedSkills.removeWhere((element) => !skills.contains(element.categoryId));
      provider.selectedSkills.setList(list: selectedSkills, isClear: true, isNotify: false);
    }

    {
      List<String> contentTypes = <String>[];
      for (ContentFilterCategoryTreeModel model in provider.contentTypes.getList(isNewInstance: false)) {
        contentTypes.add(model.categoryId);
        contentTypes.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model).map((e) => e.categoryId));
      }

      List<ContentFilterCategoryTreeModel> selectedContentTypes = provider.selectedContentTypes.getList();
      selectedContentTypes.removeWhere((element) => !contentTypes.contains(element.categoryId));
      provider.selectedContentTypes.setList(list: selectedContentTypes, isClear: true, isNotify: false);
    }

    {
      List<String> jobRoles = <String>[];
      for (ContentFilterCategoryTreeModel model in provider.jobRoles.getList(isNewInstance: false)) {
        jobRoles.add(model.categoryId);
        jobRoles.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model).map((e) => e.categoryId));
      }

      List<ContentFilterCategoryTreeModel> selectedJobRoles = provider.selectedJobRoles.getList();
      selectedJobRoles.removeWhere((element) => !jobRoles.contains(element.categoryId));
      provider.selectedJobRoles.setList(list: selectedJobRoles, isClear: true, isNotify: false);
    }

    {
      List<String> solutions = <String>[];
      for (ContentFilterCategoryTreeModel model in provider.solutions.getList(isNewInstance: false)) {
        solutions.add(model.categoryId);
        solutions.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model).map((e) => e.categoryId));
      }

      List<ContentFilterCategoryTreeModel> selectedSolutions = provider.selectedSolutions.getList();
      selectedSolutions.removeWhere((element) => !solutions.contains(element.categoryId));
      provider.selectedSolutions.setList(list: selectedSolutions, isClear: true, isNotify: false);
    }

    {
      List<int> learningProviders = provider.learningProviders.getList(isNewInstance: false).map((e) => e.SiteID).toList();
      List<LearningProviderModel> selectedLearningProviders = provider.selectedLearningProviders.getList();
      selectedLearningProviders.removeWhere((element) => !learningProviders.contains(element.SiteID));
      provider.selectedLearningProviders.setList(list: selectedLearningProviders, isClear: true, isNotify: false);
    }
  }

  List<ContentFilterCategoryTreeModel> getAllChildrenFromContentFilterCategoryTreeModel({required ContentFilterCategoryTreeModel model}) {
    List<ContentFilterCategoryTreeModel> list = <ContentFilterCategoryTreeModel>[];
    list.addAll(model.children);
    for (ContentFilterCategoryTreeModel model in model.children) {
      list.addAll(getAllChildrenFromContentFilterCategoryTreeModel(model: model));
    }
    return list;
  }

  void applyFilterData({
    List<ContentFilterCategoryTreeModel>? selectedCategories,
    List<ContentFilterCategoryTreeModel>? selectedSkills,
    List<ContentFilterCategoryTreeModel>? selectedContentTypes,
    List<ContentFilterCategoryTreeModel>? selectedJobRoles,
    List<ContentFilterCategoryTreeModel>? selectedSolutions,
    List<LearningProviderModel>? selectedLearningProviders,
    List<InstructorUserModel>? selectedInstructors,
    int? minPrice,
    int? maxPrice,
    FilterDurationValueModel? selectedFilterCredit,
    double? selectedRating,
    EventDateModel? selectedEventDateType,
    DateTime? startEventDate,
    DateTime? endEventDate,
  }) {
    FilterProvider provider = filterProvider;

    if(selectedCategories != null) provider.selectedCategories.setList(list: selectedCategories, isClear: true, isNotify: false);
    if(selectedSkills != null) provider.selectedSkills.setList(list: selectedSkills, isClear: true, isNotify: false);
    if(selectedContentTypes != null) provider.selectedContentTypes.setList(list: selectedContentTypes, isClear: true, isNotify: false);
    if(selectedJobRoles != null) provider.selectedJobRoles.setList(list: selectedJobRoles, isClear: true, isNotify: false);
    if(selectedSolutions != null) provider.selectedSolutions.setList(list: selectedSolutions, isClear: true, isNotify: false);
    if(selectedLearningProviders != null) provider.selectedLearningProviders.setList(list: selectedLearningProviders, isClear: true, isNotify: false);
    if(selectedInstructors != null) provider.selectedInstructor.setList(list: selectedInstructors, isClear: true, isNotify: false);

    provider.minPrice.set(value: minPrice, isNotify: false);
    provider.maxPrice.set(value: maxPrice, isNotify: false);

    provider.selectedFilterCredit.set(value: selectedFilterCredit ?? provider.defaultFilterCredit.get(), isNotify: false);

    if(selectedEventDateType != null) {
      provider.selectedEventDateType.set(value: selectedEventDateType, isNotify: false);
      provider.selectedStartEventDateTime.set(value: startEventDate, isNotify: false);
      provider.selectedEndEventDateTime.set(value: endEventDate, isNotify: false);
    }

    provider.selectedRating.set(value: selectedRating, isNotify: true);
  }

  void resetFilterData() {
    FilterProvider provider = filterProvider;

    provider.selectedCategories.setList(list: [], isClear: true, isNotify: false);
    provider.selectedSkills.setList(list: [], isClear: true, isNotify: false);
    provider.selectedContentTypes.setList(list: [], isClear: true, isNotify: false);
    provider.selectedJobRoles.setList(list: [], isClear: true, isNotify: false);
    provider.selectedSolutions.setList(list: [], isClear: true, isNotify: false);
    provider.selectedLearningProviders.setList(list: [], isClear: true, isNotify: false);
    provider.selectedInstructor.setList(list: [], isClear: true, isNotify: false);
    provider.minPrice.set(value: null, isNotify: false);
    provider.maxPrice.set(value: null, isNotify: false);
    provider.selectedFilterCredit.set(value: provider.defaultFilterCredit.get(), isNotify: false);
    provider.selectedRating.set(value: null, isNotify: false);
    provider.selectedEventDateType.set(value: null, isNotify: false);
    provider.selectedStartEventDateTime.set(value: null, isNotify: false);
    provider.selectedEndEventDateTime.set(value: null, isNotify: false);
    provider.selectedSort.set(value: provider.sortOptions.getList(isNewInstance: false).firstElement?.OptionValue ?? provider.defaultSort.get(), isNotify: true);
  }
}

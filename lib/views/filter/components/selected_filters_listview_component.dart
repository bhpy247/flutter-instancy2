import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';

import '../../../configs/app_constants.dart';
import '../../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../../models/filter/data_model/filter_duration_value_model.dart';
import '../../../models/filter/data_model/instructor_user_model.dart';
import '../../../models/filter/data_model/learning_provider_model.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_safe_state.dart';
import '../screens/filters_screen.dart';

class SelectedFiltersListviewComponent extends StatefulWidget {
  final FilterProvider filterProvider;
  final void Function()? onResetFilter;
  final void Function({required String contentFilterByTypes})? onFilterChipTap;

  const SelectedFiltersListviewComponent({
    super.key,
    required this.filterProvider,
    this.onResetFilter,
    this.onFilterChipTap,
  });

  @override
  State<SelectedFiltersListviewComponent> createState() => _SelectedFiltersListviewComponentState();
}

class _SelectedFiltersListviewComponentState extends State<SelectedFiltersListviewComponent> with MySafeState {
  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    List<Widget> selectedFilterWidget = getFilterChipsList(filterProvider: widget.filterProvider).toList();

    if (selectedFilterWidget.isNotEmpty) {
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
              child: SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: selectedFilterWidget,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if(widget.onResetFilter != null) {
                widget.onResetFilter!();
              }
            },
            child: Container(
              color: Colors.white,
              child: const Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Iterable<Widget> getFilterChipsList({required FilterProvider filterProvider}) sync* {
    if (filterProvider.selectedCategories.length > 0) {
      List<ContentFilterCategoryTreeModel> selectedModels = filterProvider.selectedCategories.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.categoryName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.categories);
        },
      );
    }
    if (filterProvider.selectedSkills.length > 0) {
      List<ContentFilterCategoryTreeModel> selectedModels = filterProvider.selectedSkills.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.categoryName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.skills);
        },
      );
    }
    if (filterProvider.selectedContentTypes.length > 0) {
      List<ContentFilterCategoryTreeModel> selectedModels = filterProvider.selectedContentTypes.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.categoryName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.objecttypeid);
        },
      );
    }
    if (filterProvider.selectedJobRoles.length > 0) {
      List<ContentFilterCategoryTreeModel> selectedModels = filterProvider.selectedJobRoles.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.categoryName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.job);
        },
      );
    }
    if (filterProvider.selectedSolutions.length > 0) {
      List<ContentFilterCategoryTreeModel> selectedModels = filterProvider.selectedSolutions.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.categoryName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.solutions);
        },
      );
    }
    if (filterProvider.selectedLearningProviders.length > 0) {
      List<LearningProviderModel> selectedModels = filterProvider.selectedLearningProviders.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.LearningProviderName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.learningprovider);
        },
      );
    }
    if (filterProvider.selectedInstructor.length > 0) {
      List<InstructorUserModel> selectedModels = filterProvider.selectedInstructor.getList();
      int length = selectedModels.length;

      yield getFilterChipWidget(
        name: "${selectedModels.first.UserName}${length > 1 ? " ($length)" : ""}",
        hasMoreValues: selectedModels.length > 1,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.instructor);
        },
      );
    }

    int? minPrice = filterProvider.minPrice.get();
    int? maxPrice = filterProvider.maxPrice.get();
    if (minPrice != null || maxPrice != null) {
      String priceString = "";
      if (minPrice != null && maxPrice != null) {
        priceString = "$minPrice - $maxPrice";
      } else if (minPrice != null) {
        priceString = "$minPrice";
      } else if (maxPrice != null) {
        priceString = "$maxPrice";
      }

      yield getFilterChipWidget(
        name: priceString,
        hasMoreValues: false,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.ecommerceprice);
        },
      );
    }

    FilterDurationValueModel? filterDurationValueModel = filterProvider.selectedFilterCredit.get();
    if (filterDurationValueModel != null) {
      yield getFilterChipWidget(
        name: filterDurationValueModel.Displayvalue,
        hasMoreValues: false,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.creditpoints);
        },
      );
    }

    double? ratingValue = filterProvider.selectedRating.get();
    if (ratingValue != null) {
      yield getFilterChipWidget(
        name: ratingValue.toStringAsFixed(1),
        hasMoreValues: false,
        onTap: () {
          if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.rating);
        },
      );
    }

    EventDateModel? selectedEventDateType = filterProvider.selectedEventDateType.get();
    if (selectedEventDateType != null) {
      String eventDateString = "";
      if (selectedEventDateType.type == EventDateTypes.choosedate) {
        DateTime? selectedStartEventDateTime = filterProvider.selectedStartEventDateTime.get();
        DateTime? selectedEndEventDateTime = filterProvider.selectedEndEventDateTime.get();

        if (selectedStartEventDateTime != null || selectedEndEventDateTime != null) {
          if (selectedStartEventDateTime != null && selectedEndEventDateTime != null) {
            eventDateString = "${DatePresentation.getFormattedDate(dateFormat: "MMM dd, yyyy", dateTime: selectedStartEventDateTime)} -"
                " ${DatePresentation.getFormattedDate(dateFormat: "MMM dd, yyyy", dateTime: selectedEndEventDateTime)}";
          } else if (selectedStartEventDateTime != null) {
            eventDateString = DatePresentation.getFormattedDate(dateFormat: "MMM dd, yyyy", dateTime: selectedStartEventDateTime) ?? "";
          } else if (selectedEndEventDateTime != null) {
            eventDateString = DatePresentation.getFormattedDate(dateFormat: "MMM dd, yyyy", dateTime: selectedEndEventDateTime) ?? "";
          }
        }
      } else {
        eventDateString = selectedEventDateType.title;
      }
      if (eventDateString.isNotEmpty) {
        yield getFilterChipWidget(
          name: eventDateString,
          hasMoreValues: false,
          onTap: () {
            if(widget.onFilterChipTap != null) widget.onFilterChipTap!(contentFilterByTypes: ContentFilterByTypes.eventdates);
          },
        );
      }
    }
  }

  Widget getFilterChipWidget({
    required String name,
    bool hasMoreValues = false,
    void Function()? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: themeData.primaryColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: themeData.textTheme.labelSmall?.copyWith(
                  color: themeData.primaryColor,
                ),
              ),
              if (hasMoreValues)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  height: 30,
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: themeData.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

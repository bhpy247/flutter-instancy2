import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_controller.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/CategoriesModel.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';

class CategoriesSearchScreen extends StatefulWidget {
  static const String routeName = "/categoriesSearchScreen";
  DiscussionForumCategoriesSearchScreenNavigationArguments arguments;

  CategoriesSearchScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<CategoriesSearchScreen> createState() => _CategoriesSearchScreenState();
}

class _CategoriesSearchScreenState extends State<CategoriesSearchScreen> with MySafeState {
  late DiscussionProvider discussionProvider;
  late DiscussionController discussionController;
  late ThemeData themeData;
  String selectedCategoriesString = "";
  List<CategoriesModel> selectedCategoriesList = [];

  void setSelectedCategoriesIds() {
    List<String> categoriesidsFromString = [];
    List<CategoriesModel> categoriesList = discussionProvider.categoriesList.getList();

    if (widget.arguments.isFromMyDiscussion) {
      categoriesidsFromString = discussionProvider.myFilterCategoriesIds.get().split(",").toList();
    } else {
      categoriesidsFromString = discussionProvider.filterCategoriesIds.get().split(",").toList();
    }
    selectedCategoriesList = categoriesList.where((element) => categoriesidsFromString.contains(element.categoryID.toString())).toList();
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    discussionProvider = context.read<DiscussionProvider>();
    discussionController = DiscussionController(discussionProvider: discussionProvider);
    setSelectedCategoriesIds();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();
    return Consumer<DiscussionProvider>(
      builder: (context, DiscussionProvider discussionProvider, _) {
        List<CategoriesModel> categoriesList = discussionProvider.categoriesList.getList();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Categories"),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: categoriesList.map((e) {
                    return Container(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          bool isChecked = !selectedCategoriesList.contains(e);
                          if (isChecked) {
                            selectedCategoriesList.add(e);
                          } else {
                            selectedCategoriesList.remove(e);
                          }
                          selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                            list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
                            separator: ", ",
                          );
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: themeData.primaryColor,
                              value: selectedCategoriesList.contains(e),
                              onChanged: (bool? value) {
                                bool isChecked = value ?? false;
                                if (isChecked) {
                                  selectedCategoriesList.add(e);
                                } else {
                                  selectedCategoriesList.remove(e);
                                }

                                selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                                  list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
                                  separator: ",",
                                );
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(e.CategoryName),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: CommonButton(
                          onPressed: () {
                            if (widget.arguments.isFromMyDiscussion) {
                              discussionProvider.myFilterCategoriesIds.set(value: "");
                            } else {
                              discussionProvider.filterCategoriesIds.set(value: "");
                            }
                            Navigator.pop(context, true);
                          },
                          text: "Clear",
                          backGroundColor: Colors.white,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: CommonButton(
                          onPressed: () {
                            List<int> categoryidsList = selectedCategoriesList.map((model) => model.id).toList();
                            String categoryIds = categoryidsList.join(",");
                            if (widget.arguments.isFromMyDiscussion) {
                              discussionProvider.myFilterCategoriesIds.set(value: categoryIds);
                            } else {
                              discussionProvider.filterCategoriesIds.set(value: categoryIds);
                            }
                            Navigator.pop(context, true);
                          },
                          text: "Apply",
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  PreferredSize? getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
            ),
            child: const Text("Categories")),
      ),
    );
  }
}

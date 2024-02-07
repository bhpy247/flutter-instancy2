import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/filter_user_skills_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';

class FilterSkillsScreen extends StatefulWidget {
  static const String routeName = "/FilterSkillsScreen";
  FilterSkillsScreenNavigationArguments arguments;

  FilterSkillsScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<FilterSkillsScreen> createState() => _FilterSkillsScreenState();
}

class _FilterSkillsScreenState extends State<FilterSkillsScreen> with MySafeState {
  late AskTheExpertProvider askTheExpertProvider;
  late AskTheExpertController askTheExpertController;
  late ThemeData themeData;
  String selectedCategoriesString = "";
  FilterSkills? selectedCategoriesList;

  // FilterSkills selectedFilterSkill = FilterSkills();

  void setSelectedCategoriesIds() {
    String categoriesidsFromString = "";
    List<FilterSkills> categoriesList = askTheExpertProvider.filterSkillsList.getList();

    // if (widget.arguments.isFromMyDiscussion) {
    //   categoriesidsFromString = askTheExpertProvider.myQuestionCategoriesIds.get().split(",").toList();
    // } else {
    categoriesidsFromString = askTheExpertProvider.filterCategoriesIds.get();
    // }
    List<FilterSkills> filterList = categoriesList.where((element) => categoriesidsFromString == element.skillID.toString()).toList();
    MyPrint.printOnConsole("filterList : ${filterList}");
    if (filterList.checkNotEmpty) {
      selectedCategoriesList = filterList.first;
    }
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider);
    setSelectedCategoriesIds();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();
    return Consumer<AskTheExpertProvider>(
      builder: (context, AskTheExpertProvider askTheExpertProvider, _) {
        List<FilterSkills> categoriesList = askTheExpertProvider.filterSkillsList.getList();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Skills"),
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
                          bool isChecked = !(selectedCategoriesList == e);
                          if (isChecked) {
                            selectedCategoriesString = e.skillID.toString();

                            selectedCategoriesList = e;
                          } else {
                            selectedCategoriesString = "-1";

                            selectedCategoriesList = null;
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: themeData.primaryColor,
                              value: selectedCategoriesList?.skillID == e.skillID,
                              onChanged: (bool? value) {
                                bool isChecked = value ?? false;
                                if (isChecked) {
                                  selectedCategoriesList = e;
                                  selectedCategoriesString = e.skillID.toString();
                                } else {
                                  selectedCategoriesString = "-1";
                                  selectedCategoriesList = null;
                                }
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(e.preferrenceTitle),
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
                            // if (widget.arguments.isFromMyDiscussion) {
                            //   askTheExpertProvider.myQuestionCategoriesIds.set(value: "");
                            // } else {
                            askTheExpertProvider.filterCategoriesIds.set(value: "-1");
                            // askTheExpertProvider.filterSkillsList.setList(list: []);
                            // }
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
                            String categoryIds = selectedCategoriesList?.skillID.toString() ?? "-1";
                            // if (widget.arguments.isFromMyDiscussion) {
                            //   askTheExpertProvider.myQuestionCategoriesIds.set(value: categoryIds);
                            // } else {
                            askTheExpertProvider.filterCategoriesIds.set(value: categoryIds);
                            // }
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

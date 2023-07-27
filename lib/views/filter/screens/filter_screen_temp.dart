import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/models/filter/data_model/all_filters_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:provider/provider.dart';

import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';

class FilterScreenTemp extends StatefulWidget {
  final FilterProvider filterProvider;
  final ComponentConfigurationsModel componentConfigurationsModel;

  const FilterScreenTemp({
    Key? key,
    required this.filterProvider,
    required this.componentConfigurationsModel,
  }) : super(key: key);

  @override
  State<FilterScreenTemp> createState() => _FilterScreenTempState();
}

class _FilterScreenTempState extends State<FilterScreenTemp> {
  late ThemeData themeData;

  late AppProvider appProvider;
  late FilterProvider filterProvider;
  late FilterController filterController;

  late ComponentConfigurationsModel componentConfigurationsModel;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    filterProvider = widget.filterProvider;
    componentConfigurationsModel = widget.componentConfigurationsModel;

    filterController = FilterController(filterProvider: filterProvider);

    filterController.initializeMainFiltersList(
      componentConfigurationsModel: componentConfigurationsModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return ChangeNotifierProvider<FilterProvider>.value(
      value: filterProvider,
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                appProvider.localStr.filterLblFiltertitlelabel,
              ),
            ),
            // body: SafeArea(child: getFilterItemsListView(list: filterProvider.getAllFiltersList())),
            body: SafeArea(child: getFilterItemsListView(list: [])),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    // child: CommonPrimarySecondaryButton(
                    child: CommonButton(
                      onPressed: (){
                        // myLearningBloc.add(ResetFilterEvent());
                        Navigator.pop(context);
                      },
                      // isPrimary: false,
                      text: appProvider.localStr.filterBtnResetbutton,
                    ),
                  ),
                  const SizedBox(width: 13,),
                  Expanded(
                    flex: 3,
                    // child: CommonPrimarySecondaryButton(
                    child: CommonButton(
                      onPressed: (){
                        // myLearningBloc.add(ApplyFilterEvent());
                        Navigator.pop(context);
                      },
                      // isPrimary: true,
                      text: appProvider.localStr.filterBtnApplybutton,
                    ),
                  ),
                  // Expanded(
                  //   child: OutlineButton(
                  //     border: Border.all(
                  //         color: Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                  //     child: Text(appBloc.localstr.filterBtnResetbutton,
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                  //     onPressed: () {
                  //       myLearningBloc.add(ResetFilterEvent());
                  //       /* Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) => ActBase()),
                  //         ModalRoute.withName('/'),
                  //       );*/
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
                  // Expanded(
                  //   child: MaterialButton(
                  //     disabledColor: Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                  //         .withOpacity(0.5),
                  //     color: Color(int.parse(
                  //         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  //     child: Text(appBloc.localstr.filterBtnApplybutton,
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                  //     onPressed: () {
                  //       myLearningBloc.add(ApplyFilterEvent());
                  //       /* Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) => ActBase()),
                  //         ModalRoute.withName('/'),
                  //       );*/
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getFilterItemsListView({required List<AllFilterModel> list}) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);

        AllFilterModel allFilterModel = list[index];

        return Theme(
          data: theme,
          child: InkWell(
            onTap: () {
              MyPrint.printOnConsole("Click menu ${allFilterModel.categoryName}");
              /*if (myLearningBloc.allFilterModelList[i].categoryName == "Group By") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SortScreen(
                        isGroupby: true, refresh: refresh)));
              }
              else if (myLearningBloc.allFilterModelList[i].categoryName == "Sort By") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SortScreen(
                        isGroupby: false, refresh: refresh)));
              }
              else if (myLearningBloc.allFilterModelList[i].categoryName == "Filter By") {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContentFilterByScreen(refresh: refresh, componentId: widget.componentId,)));
              }*/
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                      decoration: BoxDecoration(
                        // color: Color(int.parse("0xFF${appProvider.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        // border: Border.all(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")).withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            allFilterModel.categoryName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            // color: InsColor(appBloc).appIconColor,
                          ),
                        ],
                      ),
                    ),
                    // selectedWigets(myLearningBloc.allFilterModelList[i].categoryName)
                  ],
                ),
            ),
          ),
        );
      },
    );
  }
}

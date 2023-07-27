import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/filter/data_model/all_filters_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/filter/screens/sort_screen.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_configurations.dart';
import '../../../models/app_configuration_models/data_models/component_configurations_model.dart';

class GlobalSearchScreen extends StatefulWidget {
  static const String routeName = "/GlobalSearchScreen";

  final GlobalSearchScreenNavigationArguments arguments;

  const GlobalSearchScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  late ThemeData themeData;

  late AppProvider appProvider;
  late int componentId;
  late FilterProvider filterProvider;
  late FilterController filterController;

  late ComponentConfigurationsModel componentConfigurationsModel;

  TextEditingController searchTextController = TextEditingController();

  void sortBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context){
        return SortingScreen(
          arguments: SortingScreenNavigationArguments(
            componentId: componentId,
            filterProvider: filterProvider,
          ),
        );
      },
    );
  }

  void filterOnTap(){
    NavigationController.navigateToFiltersScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FiltersScreenNavigationArguments(
        componentId: componentId,
        filterProvider: filterProvider,
        componentConfigurationsModel: componentConfigurationsModel,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    componentId = widget.arguments.componentId;
    filterProvider = widget.arguments.filterProvider;
    componentConfigurationsModel = widget.arguments.componentConfigurationsModel;

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
            backgroundColor: Colors.white,
            appBar: getAppBarWithTextFormField(),
            body: getMainWidget(),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 13.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: <Widget>[
            //       Expanded(
            //         flex: 3,
            //         // child: CommonPrimarySecondaryButton(
            //         child: CommonButton(
            //           onPressed: (){
            //             // myLearningBloc.add(ResetFilterEvent());
            //             Navigator.pop(context);
            //           },
            //           // isPrimary: false,
            //           text: appProvider.localStr.filterBtnResetbutton,
            //         ),
            //       ),
            //       const SizedBox(width: 13,),
            //       Expanded(
            //         flex: 3,
            //         // child: CommonPrimarySecondaryButton(
            //         child: CommonButton(
            //           onPressed: (){
            //             // myLearningBloc.add(ApplyFilterEvent());
            //             Navigator.pop(context);
            //           },
            //           // isPrimary: true,
            //           text: appProvider.localStr.filterBtnApplybutton,
            //         ),
            //       ),
            //       // Expanded(
            //       //   child: OutlineButton(
            //       //     border: Border.all(
            //       //         color: Color(int.parse(
            //       //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
            //       //     child: Text(appBloc.localstr.filterBtnResetbutton,
            //       //         style: TextStyle(
            //       //             fontSize: 14,
            //       //             color: Color(int.parse(
            //       //                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
            //       //     onPressed: () {
            //       //       myLearningBloc.add(ResetFilterEvent());
            //       //       /* Navigator.pushAndRemoveUntil(
            //       //         context,
            //       //         MaterialPageRoute(
            //       //             builder: (BuildContext context) => ActBase()),
            //       //         ModalRoute.withName('/'),
            //       //       );*/
            //       //       Navigator.pop(context);
            //       //     },
            //       //   ),
            //       // ),
            //       // Expanded(
            //       //   child: MaterialButton(
            //       //     disabledColor: Color(int.parse(
            //       //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            //       //         .withOpacity(0.5),
            //       //     color: Color(int.parse(
            //       //         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            //       //     child: Text(appBloc.localstr.filterBtnApplybutton,
            //       //         style: TextStyle(
            //       //             fontSize: 14,
            //       //             color: Color(int.parse(
            //       //                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
            //       //     onPressed: () {
            //       //       myLearningBloc.add(ApplyFilterEvent());
            //       //       /* Navigator.pushAndRemoveUntil(
            //       //         context,
            //       //         MaterialPageRoute(
            //       //             builder: (BuildContext context) => ActBase()),
            //       //         ModalRoute.withName('/'),
            //       //       );*/
            //       //       Navigator.pop(context);
            //       //     },
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
          );
        },
      ),
    );
  }

  //region Main Widget
  Widget getMainWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          getRecentsViews(),
          getSuggestionView(),
          getCatalogView(),
          getMyLearningView()
        ],
      ),
    );
  }
  //endregion

  //region getSearchAbleTextAppBar
  AppBar getAppBarWithTextFormField(){
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1.5,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity,20),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_outlined,size: 22,),
            ),
            const SizedBox(width: 30,),
            Expanded(
              child: CommonTextFormField(
                controller: searchTextController,
                borderColor: Colors.transparent,
                hintText: "Search",
                focusedBorderColor: Colors.transparent,
              ),
            ),
            InkWell(
              onTap: (){
                sortBottomSheet();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: AppConfigurations().getImageView(url: "assets/orderList.png",width: 18, height: 18),
              ),
            ),
            InkWell(
              onTap: (){
                filterOnTap();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0).copyWith(right: 12),
                child: AppConfigurations().getImageView(url: "assets/filters.png",width: 18, height: 18),
              ),
            ),
          ],
        ),
      )
    );
  }
  //endregion

  //region getRecentViews
  Widget getRecentsViews(){
    return Column(
      children: [
        getBackgroundGreyText("Recents"),
        getRecentList()
      ],
    );
  }

  Widget getRecentList(){
    return ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
      return recentListComponent();
    });
  }

  Widget recentListComponent(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0,).copyWith(top: 10),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.grey,),
          const SizedBox(width: 15,),
          Expanded(child: Text("Web Development",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w600),)),
          AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
        ],
      ),
    );
  }
  //endregion

  //region getSuggestionView
  Widget getSuggestionView(){
    return Column(
      children: [
        getBackgroundGreyText("Suggestions"),
        getSuggestionList()
      ],
    );
  }

  Widget getSuggestionList(){
    return ListView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          return suggestionListComponent();
        });
  }

  Widget suggestionListComponent(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0,).copyWith(top: 10),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_alt, color: Colors.grey,),
          const SizedBox(width: 15,),
          Expanded(child: Text("Design",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w600),)),
          // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
        ],
      ),
    );
  }
  //endregion

  //region getBackgroundGreyText
  Widget getBackgroundGreyText(String text, {bool isIconVisible = false, String iconAsset = "assets/catalog.png"}){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        children: [
          Visibility(
              visible: isIconVisible,
              child: Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: AppConfigurations().getImageView(url:iconAsset, width: 18, height: 18),
              )),
          Text(text, style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600,fontSize: 16,letterSpacing: 0.25),),
        ],
      ),
    );
  }
  //endregion

  //region getCatalogContentView
  Widget getCatalogView(){
    return Column(
      children: [
        getBackgroundGreyText("Catalog",isIconVisible: true),
        getCatalogList()
      ],
    );
  }

  Widget getCatalogList(){
    return ListView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          return catalogListComponent();
        });
  }

  Widget catalogListComponent(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,).copyWith(top: 10,bottom: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(imageUrl: "https://picsum.photos/200/300", height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(width: 15,),
            Expanded(child: Text("Design",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w600),)),
            const Icon(Icons.more_vert, size: 20,)
            // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
          ],
        ),
      ),
    );
  }
  //endregion

  // region getMyLearningView
  Widget getMyLearningView(){
    return Column(
      children: [
        getBackgroundGreyText("My Learning",isIconVisible: true, iconAsset: "assets/myLearningText.png"),
        getMyLearningList()
      ],
    );
  }

  Widget getMyLearningList(){
    return ListView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          return myLearningListComponent();
        });
  }

  Widget myLearningListComponent(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,).copyWith(top: 10,bottom: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(imageUrl: "https://picsum.photos/300", height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(width: 15,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Design Classroom",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black,fontWeight: FontWeight.w600),),
                const SizedBox(height: 5,),
                Text("Manoj Kumar",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w400,fontSize: 11),),
              ],
            )),
            const Icon(Icons.more_vert, size: 20,)
            // AppConfigurations().getImageView(url: "assets/arrowUpLeft.png",height: 13,width: 13),
          ],
        ),
      ),
    );
  }
  //endregion

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

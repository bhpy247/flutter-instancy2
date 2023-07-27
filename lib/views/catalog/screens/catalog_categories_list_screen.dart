import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_controller.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/models/catalog/catalogCategoriesForBrowseModel.dart';
import 'package:flutter_instancy_2/models/wiki_component/response_model/fileUploadControlModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';
import '../components/catalog_category_widget.dart';

class CatalogCategoriesListScreen extends StatefulWidget {
  static const String routeName = "/CatalogCategoriesListScreen";
  final int componentId, componentInstanceId;
  final CatalogProvider? catalogProvider;
  final WikiProvider? wikiProvider;

  const CatalogCategoriesListScreen({
    Key? key,
    this.componentId = 0,
    this.componentInstanceId = 0,
    this.catalogProvider,
    this.wikiProvider,
  }) : super(key: key);

  @override
  State<CatalogCategoriesListScreen> createState() => _CatalogCategoriesListScreenState();
}

class _CatalogCategoriesListScreenState extends State<CatalogCategoriesListScreen> with TickerProviderStateMixin, MySafeState {
  late AppProvider appProvider;

  late CatalogProvider catalogProvider;
  late CatalogController catalogController;

  late WikiProvider wikiProvider;
  late WikiController wikiController;

  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;

  List<String> categoriesList = ["All", "Computer & It", "Design Content", "Design Content", "Design Content", "Design Content", "Design Content"];

  TextEditingController textEditingController = TextEditingController();
  int componentId = 0, componentInstanceId = 0;
  ApiUrlConfigurationProvider? apiUrlConfigurationProvider;

  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;

  // var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(60.0, 60.0);
  var selectedFABLocation = FloatingActionButtonLocation.endDocked;

  Future? getFileUploadControlFuture, getCategoriesFuture, getCatalogCategoriesBrowse;

  Future<void> getInitialWikiComponentData() async {
    await wikiController.getFileUploadControlsFromApi(componentId: componentId, componentInstanceId: componentInstanceId);
  }

  Future<void> getCategories() async {
    await catalogController.getCatalogCategoriesFromBrowseModel(componentId: componentId, componentInstanceId: componentInstanceId);
  }

  Future<void> clickOnWikiUploadAction({required String title, required int objectTypeId, required int mediaTypeId}) async {
    dynamic value = await NavigationController.navigateToAddWikiContentScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: AddWikiContentScreenNavigationArguments(
        title: title,
        objectTypeId: objectTypeId,
        mediaTypeId: mediaTypeId,
      ),
    );

    if (value == true) {
      //TODO: Refresh Catalog Data
    }

    /*switch (id) {
      case 'fabVideo':
        wikiFileUploadButtonClicked(*/ /*"ContentTypeID/11/MediaTypeID/3", */ /*FileType.video, 'Video');
        break;
      case 'fabAudio':
        wikiFileUploadButtonClicked(*/ /*"ContentTypeID/11/MediaTypeID/4", */ /*FileType.audio, 'Audio');
        break;
      case 'fabDocument':
        wikiFileUploadButtonClicked(*/ /*"ContentTypeID/14", */ /*FileType.custom, 'Document');
        break;
      case 'fabImage':
        wikiFileUploadButtonClicked(*/ /*"ContentTypeID/11/MediaTypeID/1", */ /*FileType.image, 'Image');
        break;
      case 'fabWebsiteURL':
        wikiFileUploadButtonClicked(*/ /*"ContentTypeID/11/MediaTypeID/1", */ /*FileType.any, 'Url');
        break;
    }*/
  }

  Future<void> onCategoryTap({required CatalogCategoriesForBrowseModel categoryModel}) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if(categoryModel.children.isNotEmpty) {
      NavigationController.navigateToCatalogSubcategoriesListScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CatalogSubcategoriesListScreenNavigationArguments(
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          subcategories: categoryModel.children,
          categoriesListForPath: [
            categoryModel,
          ],
        ),
      );
    }
    else {
      NavigationController.navigateToCatalogContentsListScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CatalogContentsListScreenNavigationArguments(
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          selectedCategory: categoryModel.categoryID != -1 ? ContentFilterCategoryTreeModel(
            categoryId: categoryModel.categoryID.toString(),
            categoryName: categoryModel.categoryName,
            parentId: categoryModel.parentID.toString(),
          ) : null,
          categoriesListForPath: categoryModel.categoryID != -1 ? [categoryModel] : null,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    catalogProvider = widget.catalogProvider ?? CatalogProvider();
    catalogController = CatalogController(provider: catalogProvider);

    wikiProvider = widget.wikiProvider ?? WikiProvider();
    wikiController = WikiController(wikiProvider: wikiProvider);

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      catalogController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );

      if(componentModel.componentConfigurationsModel.DefaultRepositoryID) {
        getFileUploadControlFuture = getInitialWikiComponentData();
      }
    }

    wikiController.getWikiCategoriesFromApi(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );

    getCategoriesFuture = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    apiUrlConfigurationProvider = ApiController().apiDataProvider;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
        ChangeNotifierProvider<WikiProvider>.value(value: wikiProvider),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: AppUIComponents.getBackGroundBordersRounded(child: getMainWidget(), context: context),
          floatingActionButton: getWikiUploadButton(),
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: getSearchTextFormField(),
        ),
        const SizedBox(height: 15),
        Expanded(child: getCategoriesView()),
      ],
    );
  }

  //region categoriesView
  Widget getCategoriesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Categories",
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  NavigationController.navigateToCatalogContentsListScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: CatalogContentsListScreenNavigationArguments(
                      componentId: componentId,
                      componentInstanceId: componentInstanceId,
                    ),
                  );
                },
                child: Text(
                  "Go to List",
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder(
            future: getCategoriesFuture,
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CommonLoader());
              }

              return Consumer<CatalogProvider>(
                builder: (BuildContext context, CatalogProvider provider, _) {
                  List<CatalogCategoriesForBrowseModel> categoriesList = provider.catalogCategoriesForBrowserList.getList(isNewInstance: true);

                  String searchText = searchController.text.trim();
                  if(searchController.text.trim().isNotEmpty) {
                    categoriesList.removeWhere((CatalogCategoriesForBrowseModel categoryModel) => !categoryModel.categoryName.toLowerCase().startsWith(searchText.toLowerCase()));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCategoriesListSliderWidget(categoriesList: categoriesList),
                      Expanded(
                        child: getAllTabCategoryList(categoriesList: categoriesList),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getCategoriesListSliderWidget({required List<CatalogCategoriesForBrowseModel> categoriesList}) {
    if(categoriesList.isEmpty) return const SizedBox();

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(left: 5),
        itemCount: 1 + categoriesList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return getCategorySliderChip(
              categoryModel: CatalogCategoriesForBrowseModel(
                categoryName: "All",
                categoryID: -1,
              ),
              isSelected: true,
            );
          }

          index--;
          CatalogCategoriesForBrowseModel categoryModel = categoriesList[index];

          return getCategorySliderChip(
            categoryModel: categoryModel,
            isSelected: false,
          );
        },
      ),

      //   DefaultTabController(
      //   length: provider.wikiCategoriesList.length,
      //   child: Scaffold(
      //     backgroundColor: Colors.transparent,
      //     appBar: PreferredSize(
      //       preferredSize: Size(double.infinity,40),
      //       child: AppBar(
      //         backgroundColor: Colors.transparent,
      //         elevation: 0,
      //         bottom: TabBar(
      //           controller: tabController,
      //         unselectedLabelColor: Colors.black,
      //         labelColor: Colors.white,
      //         indicatorPadding: EdgeInsets.zero,
      //         padding: EdgeInsets.zero,
      //         indicator: BoxDecoration(
      //           color: Styles.chipTextColor,
      //             border: Border.all(),
      //             borderRadius: BorderRadius.circular(25)
      //           ),
      //           labelPadding: EdgeInsets.symmetric(horizontal: 9),
      //           isScrollable: true,
      //           // onTap: (int index){
      //           //   selected = index;
      //           //   setState(() {});
      //           // },
      //           tabs: List.generate(provider.wikiCategoriesList.length, (listIndex) {
      //             return Container(
      //               // width: 70,
      //               // margin: const EdgeInsets.only(left: 10),
      //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: selected == listIndex ? 5 : 7),
      //               decoration: BoxDecoration(
      //                 // color: selected != index  ? Colors.transparent : Styles.chipTextColor,
      //                   border: Border.all(color: Styles.chipTextColor),
      //                   borderRadius: BorderRadius.circular(25)),
      //               child: Text(
      //                 provider.wikiCategoriesList[listIndex].name,
      //                 textAlign: TextAlign.center,
      //               ),
      //             );
      //           })
      //         ),
      //       ),
      //     ),
      //     body: TabBarView(
      //       controller: tabController,
      //       children: List.generate(provider.wikiCategoriesList.length, (index) {
      //         return getAllTabCategoryList();
      //       }),
      //     ),
      //   ),
      // );
    );
  }

  Widget getCategorySliderChip({
    required CatalogCategoriesForBrowseModel categoryModel,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: () {
        onCategoryTap(categoryModel: categoryModel);
      },
      child: Center(
        child: Container(
          // width: 70,
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: !isSelected ? Colors.white : Styles.chipTextColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            categoryModel.categoryName,
            textAlign: TextAlign.center,
            style: TextStyle(color: isSelected ? Colors.white : Styles.chipTextColor),
          ),
        ),
      ),
    );
  }

  //endregion

  //region allCategoriesListView
  Widget getAllTabCategoryList({required List<CatalogCategoriesForBrowseModel> categoriesList}) {
    if (categoriesList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          getCategoriesFuture = getCategories();
          setState(() {});
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            Center(
              child: Text(
                appProvider.localStr.commoncomponentLabelNodatalabel,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        getCategoriesFuture = getCategories();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categoriesList.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: CatalogCategoryWidget(
              categoryModel: categoriesList[index],
              onCategoryTap: onCategoryTap,
            ),
          );
        },
      ),
    );
  }

  Widget getImageView(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      height: 177,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  //endregion

  //region searchTextFormField
  Widget getSearchTextFormField() {
    return CommonTextFormField(
      controller: searchController,
      onChanged: (String text) {
        mySetState();
      },
      isOutlineInputBorder: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      borderRadius: 25,
      hintText: "Search",
      textInputAction: TextInputAction.search,
      prefixWidget: const Icon(Icons.search),
      suffixWidget: searchController.text.isNotEmpty ? IconButton(
        onPressed: () async {
          searchController.clear();
          mySetState();
        },
        icon: const Icon(
          Icons.close,
        ),
      ) : null,
    );
  }

  //endregion

  //region floating action button
  Widget? getWikiUploadButton() {
    if(getFileUploadControlFuture == null) {
      return null;
    }

    return FutureBuilder(
      future: getFileUploadControlFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }

        // MyPrint.printOnConsole("isDialOpen:${isDialOpen.value}");

        return Container(
          margin: EdgeInsets.only(bottom: appProvider.appSystemConfigurationModel.enableChatBot ? 70 : 0),
          child: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 3,
            mini: false,
            openCloseDial: isDialOpen,
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            /*dialRoot: customDialRoot
                ? (ctx, open, toggleChildren) {
                    return ElevatedButton(
                      onPressed: toggleChildren,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      ),
                      child: const Text(
                        "Custom Dial Root",
                        style: TextStyle(fontSize: 17),
                      ),
                    );
                  }
                : null,*/
            buttonSize: buttonSize,
            // it's the SpeedDial size which defaults to 56 itself
            /// The below button size defaults to 56 itself, its the SpeedDial childrens size
            childrenButtonSize: const Size(70, 70),
            visible: visible,
            direction: speedDialDirection,
            switchLabelPosition: switchLabelPosition,

            /// If true user is forced to close dial manually
            closeManually: false,

            /// If false, backgroundOverlay will not be rendered.
            renderOverlay: false,
            onOpen: () {
              debugPrint('OPENING DIAL');
              // setState(() {});
            },
            onClose: () {
              debugPrint('DIAL CLOSED');
              // isDialOpen.value = false;
            },
            useRotationAnimation: useRAnimation,
            tooltip: 'Open Speed Dial',
            // heroTag: 'speed-dial-hero-tag',
            elevation: 1.0,
            animationCurve: Curves.easeIn,
            isOpenOnStart: false,
            // shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
            // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: _getWikiOption(),
          ),
        );
      },
    );
  }

  List<SpeedDialChild> _getWikiOption() {
    List<SpeedDialChild> children = [];
    Iterable<FileUploadControlsModel> controls = wikiProvider.fileUploadControlsModelList.where((element) => element.status == true);
    for (FileUploadControlsModel element in controls) {
      WikiContentIconModel? wikiContentIconModel = getWikiContentIconModelFromObjectAndMediaType(
        objectTypeId: element.objectTypeID,
        mediaTypeId: element.mediaTypeID,
      );

      if (wikiContentIconModel != null) {
        children.add(_wikiOption(
          assetIconPath: wikiContentIconModel.assetPath,
          iconData: wikiContentIconModel.iconData,
          title: element.mediaTypeIdisplayName,
          objectTypeID: element.objectTypeID,
          mediaTypeID: element.mediaTypeID,
        ));
      }
    }

    return children;
  }

  WikiContentIconModel? getWikiContentIconModelFromObjectAndMediaType({required int objectTypeId, required int mediaTypeId}) {
    WikiContentIconModel? wikiContentIconModel;

    switch (mediaTypeId) {
      case InstancyMediaTypes.image:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_image.png",
          );
          break;
        }
      case InstancyMediaTypes.video:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_video.png",
          );
          break;
        }
      case InstancyMediaTypes.audio:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/wiki_audio.png",
          );
          break;
        }
      case InstancyMediaTypes.pDF:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/imageDescription.png",
          );
          break;
        }
      case InstancyMediaTypes.url:
        {
          wikiContentIconModel = const WikiContentIconModel(
            assetPath: "assets/catalog/website_url.png",
          );
          break;
        }
    }

    return wikiContentIconModel;
  }

  SpeedDialChild _wikiOption({
    IconData? iconData,
    required String assetIconPath,
    required String title,
    required int objectTypeID,
    required int mediaTypeID,
  }) {
    return SpeedDialChild(
      child: iconData == null
          ? Image.asset(
              assetIconPath,
              height: 18,
              width: 18,
              color: themeData.primaryColor,
            )
          : const Icon(Icons.accessibility),
      foregroundColor: themeData.primaryColor,
      backgroundColor: themeData.colorScheme.background.withOpacity(0.8),
      label: null,
      elevation: 2,
      onTap: () {
        MyPrint.printOnConsole(mediaTypeID);
        // isDialOpen.value = false;
        // isDialOpen.notifyListeners();
        clickOnWikiUploadAction(
          title: title,
          objectTypeId: objectTypeID,
          mediaTypeId: mediaTypeID,
        );
      },
      onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
    );
  }
//endregion
}

class WikiContentIconModel {
  final String assetPath;
  final IconData? iconData;

  const WikiContentIconModel({
    this.assetPath = "",
    this.iconData,
  });
}

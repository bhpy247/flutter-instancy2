import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/models/catalog/catalogCategoriesForBrowseModel.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/catalog/components/add_wiki_button_component.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation.dart';
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

  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;

  List<String> categoriesList = ["All", "Computer & It", "Design Content", "Design Content", "Design Content", "Design Content", "Design Content"];

  TextEditingController textEditingController = TextEditingController();
  int componentId = 0, componentInstanceId = 0;
  ApiUrlConfigurationProvider? apiUrlConfigurationProvider;

  bool isWikiButtonEnabled = false;
  Future? getCategoriesFuture, getCatalogCategoriesBrowse;

  Future<void> getCategories() async {
    await catalogController.getCatalogCategoriesFromBrowseModel(componentId: componentId, componentInstanceId: componentInstanceId);
  }

  Future<void> onCategoryTap({required CatalogCategoriesForBrowseModel categoryModel}) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (categoryModel.children.isNotEmpty) {
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
    } else {
      NavigationController.navigateToCatalogContentsListScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CatalogContentsListScreenNavigationArguments(
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          selectedCategory: categoryModel.categoryID != -1
              ? ContentFilterCategoryTreeModel(
                  categoryId: categoryModel.categoryID.toString(),
                  categoryName: categoryModel.categoryName,
                  parentId: categoryModel.parentID.toString(),
                )
              : null,
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

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      catalogController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );

      if (componentModel.componentConfigurationsModel.DefaultRepositoryID) {
        isWikiButtonEnabled = true;
      }
    }

    if (catalogProvider.catalogCategoriesForBrowserList.length == 0) {
      getCategoriesFuture = getCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    apiUrlConfigurationProvider = ApiController().apiDataProvider;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          floatingActionButton: isWikiButtonEnabled
              ? AddWikiButtonComponent(
                  componentId: componentId,
                  componentInstanceId: componentInstanceId,
                  wikiProvider: wikiProvider,
                  isHandleChatBotSpaceMargin: true,
                )
              : null,
          body: AppUIComponents.getBackGroundBordersRounded(
            context: context,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: getSearchTextFormField(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: getCategoriesView(),
                ),
              ],
            ),
          ),
        ),
      ),
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
          child: getCategoriesFuture != null
              ? FutureBuilder(
                  future: getCategoriesFuture,
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CommonLoader());
                    }

                    return getMainBody();
                  },
                )
              : getMainBody(),
        ),
      ],
    );
  }

  Widget getMainBody() {
    return Consumer<CatalogProvider>(
      builder: (BuildContext context, CatalogProvider provider, _) {
        List<CatalogCategoriesForBrowseModel> categoriesList = provider.catalogCategoriesForBrowserList.getList(isNewInstance: true);

        String searchText = searchController.text.trim();
        if (searchController.text.trim().isNotEmpty) {
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
  }

  Widget getCategoriesListSliderWidget({required List<CatalogCategoriesForBrowseModel> categoriesList}) {
    if (categoriesList.isEmpty) return const SizedBox();

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
      suffixWidget: searchController.text.isNotEmpty
          ? IconButton(
              onPressed: () async {
                searchController.clear();
                mySetState();
              },
              icon: const Icon(
                Icons.close,
              ),
            )
          : null,
    );
  }

  //endregion
}



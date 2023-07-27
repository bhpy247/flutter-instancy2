import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/catalog/components/catalog_category_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../models/catalog/catalogCategoriesForBrowseModel.dart';
import '../../../utils/my_print.dart';
import '../../common/components/app_ui_components.dart';

class CatalogSubcategoriesListScreen extends StatefulWidget {
  static const String routeName = "/CatalogSubcategoriesListScreen";

  final CatalogSubcategoriesListScreenNavigationArguments arguments;

  const CatalogSubcategoriesListScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<CatalogSubcategoriesListScreen> createState() => _CatalogSubcategoriesListScreenState();
}

class _CatalogSubcategoriesListScreenState extends State<CatalogSubcategoriesListScreen> with MySafeState {
  late ThemeData themeData;

  TextEditingController textEditingController = TextEditingController();

  Future? getContentData;
  late CatalogProvider catalogProvider;
  late CatalogController catalogController;
  late AppProvider appProvider;

  int componentId = 0, componentInstanceId = 0;

  late List<CatalogCategoriesForBrowseModel> subcategories;

  void initialization() {
    catalogProvider = widget.arguments.provider ?? CatalogProvider();
    catalogController = CatalogController(provider: catalogProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);

    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;
    MyPrint.printOnConsole("componentId: $componentId componentinstance $componentInstanceId");

    subcategories = widget.arguments.subcategories;
  }

  Future<void> onCategoryTap({required CatalogCategoriesForBrowseModel categoryModel}) async {
    if (categoryModel.children.isNotEmpty) {
      NavigationController.navigateToCatalogSubcategoriesListScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CatalogSubcategoriesListScreenNavigationArguments(
          componentId: componentId,
          componentInstanceId: componentInstanceId,
          categoriesListForPath: [
            ...widget.arguments.categoriesListForPath,
            categoryModel,
          ],
          subcategories: categoryModel.children,
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
          selectedCategory: categoryModel.categoryID != -1 ? ContentFilterCategoryTreeModel(
            categoryId: categoryModel.categoryID.toString(),
            categoryName: categoryModel.categoryName,
            parentId: categoryModel.parentID.toString(),
          ) : null,
          categoriesListForPath: [
            ...widget.arguments.categoriesListForPath,
            categoryModel,
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogProvider>.value(value: catalogProvider),
      ],
      child: Consumer<CatalogProvider>(
        builder: (BuildContext context, CatalogProvider catalogProvider, Widget? child) {
          return Scaffold(
            appBar: getAppBar(),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Catalog",
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  NavigationController.navigateToWishlist(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: WishListScreenNavigationArguments(
                      componentId: widget.arguments.componentId,
                      componentInstanceId: widget.arguments.componentInstanceId,
                      catalogProvider: catalogProvider,
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(FontAwesomeIcons.heart),
                    ),
                    if (catalogProvider.maxWishlistContentsCount.get() > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeData.primaryColor,
                          ),
                          child: Text(
                            "${catalogProvider.maxWishlistContentsCount.get()}",
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMainWidget() {
    return Column(
      children: [
        getBreadcrumbWidget(),
        Expanded(child: getAllSubCategoryList(subcategories: subcategories)),
      ],
    );
  }

  //region allCategoriesListView
  Widget getAllSubCategoryList({required List<CatalogCategoriesForBrowseModel> subcategories}) {
    if (subcategories.isEmpty) {
      return Center(
        child: Text(
          appProvider.localStr.commoncomponentLabelNodatalabel,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: subcategories.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: CatalogCategoryWidget(
            categoryModel: subcategories[index],
            onCategoryTap: onCategoryTap,
          ),
        );
      },
    );
  }

  //region breadCrumbWidget
  Widget getBreadcrumbWidget() {
    List<CatalogCategoriesForBrowseModel> pathList = widget.arguments.categoriesListForPath;

    if (pathList.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // height: 50,
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(
            //color: AppColors.getAppBGColor().withAlpha(200),
            ),
        alignment: Alignment.centerLeft,
        child: BreadCrumb.builder(
          itemCount: 1 + pathList.length,
          overflow: const WrapOverflow(
            spacing: 5,
            runSpacing: 5,
          ),
          builder: (int index) {
            if (index == 0) {
              return getBreadCrumbItem(
                text: "All",
                isClickable: true,
                onTap: () {
                  for (int i = 0; i < pathList.length; i++) {
                    Navigator.pop(context);
                  }
                },
              );
            }

            index--;

            CatalogCategoriesForBrowseModel categoryModel = pathList[index];

            bool isClickable = pathList.last != categoryModel;

            return getBreadCrumbItem(
              text: categoryModel.categoryName,
              isClickable: isClickable,
              onTap: () {
                MyPrint.printOnConsole("Breadcrumb clicked for ${categoryModel.categoryName}");

                for (CatalogCategoriesForBrowseModel categoriesForBrowseModel in pathList.reversed) {
                  if (categoriesForBrowseModel == categoryModel) {
                    break;
                  }
                  Navigator.pop(context);
                }
              },
            );
          },
          divider: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  BreadCrumbItem getBreadCrumbItem({
    required String text,
    bool isClickable = false,
    void Function()? onTap,
  }) {
    return BreadCrumbItem(
      onTap: isClickable ? onTap : null,
      content: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          //fontWeight: FontWeight.w600,
          decoration: isClickable ? TextDecoration.underline : null,
          color: isClickable ? const Color(0xff4167BD) : const Color(0xff1D293F),
        ),
      ),
    );
  }
//endregion
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';

import '../../../api/api_controller.dart';
import '../../../models/catalog/catalogCategoriesForBrowseModel.dart';

class CatalogCategoryWidget extends StatelessWidget {
  final CatalogCategoriesForBrowseModel categoryModel;
  final void Function({required CatalogCategoriesForBrowseModel categoryModel})? onCategoryTap;

  const CatalogCategoryWidget({
    Key? key,
    required this.categoryModel,
    this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    // MyPrint.printOnConsole("adasda:${apiUrlConfigurationProvider!.getCurrentSiteUrl()}${catalogCategories.categoryIcon}");
    return InkWell(
      onTap: () {
        if(onCategoryTap != null) onCategoryTap!(categoryModel: categoryModel);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: const Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              // child: getImageView("${apiUrlConfigurationProvider!.getCurrentSiteUrl()}${categoryModel.categoryIcon}"),
              child: CommonCachedNetworkImage(
                imageUrl: "${ApiController().apiDataProvider.getCurrentSiteUrl()}${categoryModel.categoryIcon}",
                height: 177,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Image.asset(
                      "assets/allContent.png",
                      height: 11,
                      width: 11,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryModel.categoryName,
                        style: themeData.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      /*const SizedBox(height: 2),
                      Text(
                        "25 Content",
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.textTheme.labelLarge?.color?.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

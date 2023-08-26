import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/models/filter/data_model/component_sort_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_loader.dart';

class SortingScreen extends StatefulWidget {
  static const String routeName = "/SortingScreen";

  final SortingScreenNavigationArguments arguments;

  const SortingScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> with MySafeState {
  late ThemeData themeData;
  late int componentId;
  late FilterProvider filterProvider;
  late FilterController filterController;

  @override
  void initState() {
    super.initState();
    componentId = widget.arguments.componentId;
    filterProvider = widget.arguments.filterProvider;
    filterController = FilterController(filterProvider: filterProvider);
    filterController.getSortOptionsList(
      isRefresh: false,
      componentId: componentId,
    );
  }

  @override
  void dispose() {
    super.pageDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    themeData = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterProvider>.value(value: filterProvider),
      ],
      child: Consumer<FilterProvider>(
        builder: (BuildContext context, FilterProvider filterProvider, Widget? child) {
          return Scaffold(
            appBar: getAppbar(),
            body: getSortOptionsListView(filterProvider: filterProvider),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppbar() {
    return AppBar(
      title: const Text("Sort By"),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.clear,
        ),
      ),
    );
  }

  Widget getSortOptionsListView({required FilterProvider filterProvider}) {
    if(filterProvider.isLoadingSortData.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    List<ComponentSortModel> sortOptions = filterProvider.sortOptions.getList(isNewInstance: false);
    if (sortOptions.isEmpty) {
      return const Center(
        child: Text("No Sort Options"),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        filterController.getSortOptionsList(
          isRefresh: true,
          componentId: componentId,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sortOptions.length,
        itemBuilder: (BuildContext context, int index) {
          ComponentSortModel componentSortModel = sortOptions[index];

          return getIconWithTitle(
            componentSortModel: componentSortModel,
            iconAsset: "assets/sortIcons/atoz.png",
            isIconVisible: false,
          );
        },
      ),
    );

    /*return ListView(
      children: [
        const SizedBox(height: 20,),
        getIconWithTitle("Title A-Z", iconAsset: "assets/sortIcons/atoz.png", isIconVisible: true),
        getIconWithTitle("Title Z-A", iconAsset: "assets/sortIcons/ztoa.png", isIconVisible: true),
        getIconWithTitle("Recently Added", iconAsset: "assets/sortIcons/recent.png", isIconVisible: true),
        getIconWithTitle("Most Views", iconAsset: "assets/sortIcons/mostViews.png", isIconVisible: true),
        getIconWithTitle("Most Answers", iconAsset: "assets/sortIcons/mostAnswers.png", isIconVisible: true),
      ],
    );*/
  }

  //region getBackgroundGreyText
  Widget getIconWithTitle({
    required ComponentSortModel componentSortModel,
    bool isIconVisible = false,
    String iconAsset = "assets/catalog.png",
  }){
    return InkWell(
      onTap: () {
        filterProvider.selectedSort.set(value: componentSortModel.OptionValue);
        Navigator.pop(context, true);
      },
      child: Container(
        width: double.infinity,
        // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        child: Row(
          children: [
            Visibility(
              visible: isIconVisible,
              child: Padding(
                padding: const EdgeInsets.only(right:15.0,left: 10),
                child: AppConfigurations().getImageView(url:iconAsset, width: 18, height: 18),
              ),
            ),
            Text(
              componentSortModel.OptionText,
              style: themeData.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

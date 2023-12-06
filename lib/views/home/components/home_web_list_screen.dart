import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_utils.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../backend/home/home_controller.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/home/response_model/banner_web_list_model.dart';
import '../../../utils/my_print.dart';

class HomeWebListScreen extends StatefulWidget {
  final NativeMenuComponentModel nativeMenuComponentModel;
  final HomeProvider homeProvider;

  const HomeWebListScreen({
    Key? key,
    required this.nativeMenuComponentModel,
    required this.homeProvider,
  }) : super(key: key);

  @override
  State<HomeWebListScreen> createState() => _HomeWebListScreenState();
}

class _HomeWebListScreenState extends State<HomeWebListScreen> with MySafeState {
  late NativeMenuComponentModel nativeMenuComponentModel;
  late HomeProvider homeProvider;
  late HomeController homeController;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  Future? getWebListPageData;

  Future<void> getData() async {
    MyPrint.printOnConsole("getData");

    await homeController.getWebListWebPage(
      componentId: nativeMenuComponentModel.componentid,
      componentInstanceId: nativeMenuComponentModel.repositoryid,
    );
  }

  @override
  void initState() {
    super.initState();
    homeProvider = context.read<HomeProvider>();
    homeController = HomeController(homeProvider: homeProvider);

    nativeMenuComponentModel = widget.nativeMenuComponentModel;

    getWebListPageData = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Consumer(
      builder: (BuildContext context, HomeProvider homeProvider, _) {
        List<WebListDTO>? webList = homeProvider.webListDataDto.get()?.webList ?? [];
        return CarouselSlider(
          items: webList.map((e) => Container(child: getWebItemWidget(webListDTO: e))).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            // height: 250,
            aspectRatio: 1.8,
            viewportFraction: .7,
            onPageChanged: (index, reason) {
              _current = index;
              mySetState();
            },
          ),
        );
      },
    );
  }

  Widget getWebItemWidget({required WebListDTO webListDTO}) {
    String imageUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: webListDTO.thumbnailImagePath ?? "");
    return InkWell(
      onTap: () {
        if (ParsingHelper.parseIntMethod(webListDTO.objectTypeID) == InstancyObjectTypes.webPage) {
          String previewUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: webListDTO.previewPath ?? "");
          NavigationController.navigateToWebViewScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            arguments: WebViewScreenNavigationArguments(
              title: webListDTO.webpageTitle,
              url: previewUrl,
            ),
          );
        } else if (ParsingHelper.parseIntMethod(webListDTO.objectTypeID) == InstancyObjectTypes.reference) {
          String imageUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: webListDTO.imageWithLink ?? "");
          MyUtils.launchWebUrl(url: imageUrl);
        } else {
          NavigationController.navigateToCourseDetailScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            arguments: CourseDetailScreenNavigationArguments(
              contentId: webListDTO.contentID,
              componentId: widget.nativeMenuComponentModel.repositoryid,
              componentInstanceId: ParsingHelper.parseIntMethod(webListDTO.compInsID),
              userId: ParsingHelper.parseIntMethod(webListDTO.siteUserID),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CommonCachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

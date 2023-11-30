import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
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

class _HomeWebListScreenState extends State<HomeWebListScreen> {
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
    getWebListPageData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, HomeProvider homeProvider, _) {
      List<WebListDTO>? webList = homeProvider.webListDataDto.get()?.webList ?? [];
      return CarouselSlider(
        items: ["https://picsum.photos/300", "https://picsum.photos/300"]
            .map(
              (e) => InkWell(
                onTap: () {
                  NavigationController.navigateToWebViewScreen(
                    navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                    arguments: WebViewScreenNavigationArguments(
                      title: e,
                      url: e,
                    ),
                  );
                },
                child: const CommonCachedNetworkImage(
                  imageUrl: "https://picsum.photos/300",
                  fit: BoxFit.cover,
                ),
              ),
            )
            .toList(),
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      );
      return CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: false,
          initialPage: 0,
          viewportFraction: 1,
          aspectRatio: 1,
          padEnds: false,
          // initialPage: 2,
        ),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index, int pageViewIndex) {
          return const CommonCachedNetworkImage(
            imageUrl: "https://picsum.photos/300",
            fit: BoxFit.cover,
          );
        },
      );
    });
  }

// Widget dotIndicator() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: imgList
//         .asMap()
//         .entries
//         .map((entry) {
//       return GestureDetector(
//         onTap: () => _controller.animateToPage(entry.key),
//         child: Container(
//           width: 12.0,
//           height: 12.0,
//           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: (Theme
//                   .of(context)
//                   .brightness == Brightness.dark
//                   ? Colors.white
//                   : Colors.black)
//                   .withOpacity(_current == entry.key ? 0.9 : 0.4)),
//         ),
//       );
//     }).toList(),
//   )
//   ,
// }
}

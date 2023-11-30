import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/home/home_controller.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:webviewx/webviewx.dart';

import '../../../utils/my_print.dart';

class StaticWebpageWidget extends StatefulWidget {
  final NativeMenuComponentModel nativeMenuComponentModel;
  final HomeProvider homeProvider;

  const StaticWebpageWidget({
    Key? key,
    required this.nativeMenuComponentModel,
    required this.homeProvider,
  }) : super(key: key);

  @override
  State<StaticWebpageWidget> createState() => _StaticWebpageWidgetState();
}

class _StaticWebpageWidgetState extends State<StaticWebpageWidget> {
  late NativeMenuComponentModel nativeMenuComponentModel;
  late HomeProvider homeProvider;
  late HomeController homeController;

  Future? getStaticWebPageData;

  Future<void> getData() async {
    MyPrint.printOnConsole("getData");

    await homeController.getStaticWebPage(
      componentId: nativeMenuComponentModel.componentid,
      componentInstanceId: nativeMenuComponentModel.repositoryid,
    );
  }

  @override
  void initState() {
    super.initState();
    nativeMenuComponentModel = widget.nativeMenuComponentModel;
    homeProvider = widget.homeProvider;
    homeController = HomeController(homeProvider: homeProvider);

    getStaticWebPageData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStaticWebPageData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Size size = MediaQuery.of(context).size;
            if (homeProvider.staticWebPageModel.webpageHTML.checkEmpty) return SizedBox();
            return WebViewX(
              width: size.width,
              height: size.height,
              initialContent: homeProvider.staticWebPageModel.webpageHTML,
              initialSourceType: SourceType.html,
            );
          } else {
            return const Center(
              child: CommonLoader(),
            );
          }
        });
  }
}

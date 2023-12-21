import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/home/home_controller.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await homeController.getStaticWebPage(
      isGetFromCache: true,
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
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CommonLoader(),
          );
        }

        if (homeProvider.staticWebPageModel.webpageHTML.checkEmpty) return const SizedBox();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Html(
            data: homeProvider.staticWebPageModel.webpageHTML,
            onLinkTap: (
              url,
              _,
              __,
            ) async {
              if (await canLaunch(url!)) {
                await launch(url);
              } else {
                // Handle invalid URL or other scenarios
              }
            },
          ),
        );
      },
    );
  }
}

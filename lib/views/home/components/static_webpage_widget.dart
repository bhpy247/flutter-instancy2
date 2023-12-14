import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/backend/home/home_controller.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:url_launcher/url_launcher.dart';

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
  InAppWebViewController? _webViewController;

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
              // child: AspectRatio(
              //   aspectRatio: 16 / 20,
              //   // child: Html(
              //   //   data: homeProvider.staticWebPageModel.webpageHTML,
              //   // ),
              //
              //   child: InAppWebView(
              //     initialUrlRequest: URLRequest(
              //       url: WebUri.uri(
              //         Uri.dataFromString(
              //           homeProvider.staticWebPageModel.webpageHTML,
              //           mimeType: "text/html",
              //           encoding: Encoding.getByName("utf-8"),
              //         ),
              //       ),
              //     ),
              //     initialSettings: InAppWebViewSettings(
              //       preferredContentMode: UserPreferredContentMode.MOBILE,
              //     ),
              //     onWebViewCreated: (InAppWebViewController controller) {
              //       _webViewController = controller;
              //       _webViewController?.injectCSSCode(source: AppStrings.cssCode);
              //     },
              //     // width: size.width,
              //     // height: size.height,
              //     // initialContent: homeProvider.staticWebPageModel.webpageHTML,
              //     // initialSourceType: SourceType.html,
              //   ),
              // ),
            );
          } else {
            return const Center(
              child: CommonLoader(),
            );
          }
        });
  }
}

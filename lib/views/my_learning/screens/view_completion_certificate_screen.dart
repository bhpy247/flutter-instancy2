import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/backend/Catalog/content_launch_controller.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/get_completion_certificate_params_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';

import '../../../backend/my_learning/my_learning_controller.dart';
import '../../../backend/navigation/navigation.dart';

class ViewCompletionCertificateScreen extends StatefulWidget {
  static const String routeName = "/ViewCompletionCertificateScreen";

  final ViewCompletionCertificateScreenNavigationArguments arguments;

  const ViewCompletionCertificateScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<ViewCompletionCertificateScreen> createState() => _ViewCompletionCertificateScreenState();
}

class _ViewCompletionCertificateScreenState extends State<ViewCompletionCertificateScreen> with MySafeState {
  late MyLearningController myLearningController;

  late Future<void> futureGet;

  String certificateUrl = "", certificateViewUrl = "", certificateDownloadUrl = "";

  InAppWebViewController? webViewController;

  Future<void> getData() async {
    DataResponseModel<String> dataResponseModel = await myLearningController.myLearningRepository.getCompletionCertificatePath(
      paramsModel: GetCompletionCertificateParamsModel(
        Content_ID: widget.arguments.contentId,
        CertificateID: widget.arguments.certificateId,
        CertificatePage: widget.arguments.certificatePage,
      ),
    );

    MyPrint.printOnConsole("getCompletionCertificatePath dataResponseModel:$dataResponseModel");

    certificateUrl = ContentLaunchController().getCertificateMainUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );
    certificateViewUrl = ContentLaunchController().getCertificateViewUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );
    certificateDownloadUrl = ContentLaunchController().getCertificateDownloadUrlFromCertificatePath(
      certificatePath: (dataResponseModel.data ?? ""),
      siteUrl: myLearningController.myLearningRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    myLearningController = MyLearningController(provider: null);
    futureGet = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    MyPrint.printOnConsole("certificateUrl:$certificateUrl");
    MyPrint.printOnConsole("certificateViewUrl:$certificateViewUrl");
    MyPrint.printOnConsole("certificateDownloadUrl:$certificateDownloadUrl");

    return Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<void>(
        future: futureGet,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getMainBody(certificatePath: certificateViewUrl);
          } else {
            return const CommonLoader();
          }
        },
      ),
    );
  }

  Widget getMainBody({required String certificatePath}) {
    if (certificatePath.isEmpty) {
      return const Center(
        child: Text("Certificate Couldn't loaded"),
      );
    }

    if (certificatePath.startsWith("www")) {
      certificatePath = 'https://$certificatePath';
    } else if (certificatePath.startsWith("http://")) {
      certificatePath = certificatePath.replaceFirst("http://", "https://");
    }

    return Column(
      children: [
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(certificatePath),
            ),
            onWebViewCreated: (InAppWebViewController webViewController) {
              MyPrint.printOnConsole("onWebViewCreated called with webViewController:$webViewController");

              this.webViewController = webViewController;
            },
            onLoadStart: (InAppWebViewController webViewController, WebUri? webUri) {
              MyPrint.printOnConsole("onLoadStart called with webViewController:$webViewController, webUri:$webUri");
              // this.webViewController = webViewController;
            },
            onProgressChanged: (InAppWebViewController webViewController, int progress) {
              MyPrint.printOnConsole("onProgressChanged called with webViewController:$webViewController, progress:$progress");
              // this.webViewController = webViewController;
            },
            onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
              MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
              // this.webViewController = webViewController;
            },
          ),
        ),
        getDownloadButton(),
      ],
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: const Text(
        "Certificate",
        style: TextStyle(
          fontSize: 18,
          // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(certificateViewUrl)));
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ],
    );
  }

  Widget getDownloadButton() {
    if (certificateDownloadUrl.isEmpty) {
      return const SizedBox();
    }

    return CommonButton(
      padding: const EdgeInsets.symmetric(vertical: 15),
      onPressed: () {
        //TODO: Implement Certificate Download Feature
      },
      text: "Download",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }
}

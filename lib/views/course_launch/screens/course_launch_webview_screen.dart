import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';

import '../../../../backend/navigation/navigation.dart';

class CourseLaunchWebViewScreen extends StatefulWidget {
  static const String routeName = "/CourseLaunchWebViewScreen";

  final CourseLaunchWebViewScreenNavigationArguments arguments;

  const CourseLaunchWebViewScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<CourseLaunchWebViewScreen> createState() => _CourseLaunchWebViewScreenState();
}

class _CourseLaunchWebViewScreenState extends State<CourseLaunchWebViewScreen> {
  InAppWebViewController? webViewController;

  bool isPageLoaded = false;

  bool isFullScreen() {
    if ([InstancyObjectTypes.contentObject, InstancyObjectTypes.assessment, InstancyObjectTypes.track].contains(widget.arguments.contentTypeId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("CourseLaunchWebViewScreen init called for courseUrl:'${widget.arguments.courseUrl}'");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isFullScreen()) {
          Navigator.pop(context, true);
        }

        return false;
        // return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: !isPageLoaded,
        child: Scaffold(
          appBar: getAppBar(),
          body: SafeArea(
            child: getMainBody(courseUrl: widget.arguments.courseUrl),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? getAppBar() {
    if (isFullScreen()) {
      return null;
    }

    return AppBar(
      title: Text(
        widget.arguments.courseName.isNotEmpty ? widget.arguments.courseName : "Course",
      ),
    );
  }

  Widget getMainBody({required String courseUrl}) {
    if (courseUrl.isEmpty) {
      return const Center(
        child: Text("Certificate Couldn't loaded"),
      );
    }

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(
          courseUrl.startsWith('www') ? 'https://$courseUrl' : courseUrl,
        ),
      ),
      initialSettings: InAppWebViewSettings(
        allowFileAccess: true,
        allowContentAccess: true,
        domStorageEnabled: true,
        layoutAlgorithm: LayoutAlgorithm.NORMAL,
        databaseEnabled: true,
        saveFormData: true,
        useShouldInterceptRequest: true,
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

        if (!isPageLoaded && progress == 100) {
          isPageLoaded = true;
          setState(() {});
        }
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
      onReceivedError: (InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
        MyPrint.printOnConsole("InAppWebView onReceivedError called for:${request.url}, Type:${error.type}, Message:${error.description}");
      },
      onLoadResource: (InAppWebViewController controller, LoadedResource resource) {
        MyPrint.printOnConsole("InAppWebView onLoadResource called for:${resource.url?.path}");

        if ((resource.url?.path.toLowerCase().contains("coursetracking/savecontenttrackeddata1") ?? false) || (resource.url?.path.toLowerCase().contains("blank.html?ioscourseclose=true") ?? false)) {
          Navigator.of(context).pop(true);
        }
      },
      shouldOverrideUrlLoading: (InAppWebViewController controller, NavigationAction navigationAction) async {
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}

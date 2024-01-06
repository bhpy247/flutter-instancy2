import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
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

class _CourseLaunchWebViewScreenState extends State<CourseLaunchWebViewScreen> with MySafeState {
  InAppWebViewController? webViewController;

  bool isPageLoaded = false;

  bool isFullScreen() {
    MyPrint.printOnConsole("contentTypeId:${widget.arguments.contentTypeId}");
    if (kIsWeb) {
      return false;
    }
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
    super.pageBuild();

    String courseUrl = widget.arguments.courseUrl;

    if (courseUrl.startsWith("www")) {
      courseUrl = 'https://$courseUrl';
    } else if (courseUrl.startsWith("http://")) {
      courseUrl = courseUrl.replaceFirst("http://", "https://");
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        MyPrint.printOnConsole("onPopInvoked called with didPop:$didPop");
        if (didPop) return;

        bool isFS = isFullScreen();
        MyPrint.printOnConsole("isFS:$isFS");
        if (!isFS) {
          Navigator.pop(context, true);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: !isPageLoaded,
        child: Scaffold(
          appBar: getAppBar(courseUrl: courseUrl),
          body: SafeArea(
            child: getMainBody(courseUrl: courseUrl),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? getAppBar({required String courseUrl}) {
    if (isFullScreen()) {
      return null;
    }

    return AppBar(
      title: Text(
        widget.arguments.courseName.isNotEmpty ? widget.arguments.courseName : "Course",
      ),
      /*actions: [
        if (courseUrl.isNotEmpty && webViewController != null)
          IconButton(
            onPressed: () {
              webViewController?.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(courseUrl),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
      ],*/
    );
  }

  Widget getMainBody({required String courseUrl}) {
    if (courseUrl.isEmpty) {
      return const Center(
        child: Text("Certificate Couldn't loaded"),
      );
    }

    if (courseUrl.startsWith("www")) {
      courseUrl = 'https://$courseUrl';
    } else if (courseUrl.startsWith("http://")) {
      courseUrl = courseUrl.replaceFirst("http://", "https://");
    }

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(courseUrl),
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

        //Because onProgressChanged not implemented for Web
        if (kIsWeb) {
          isPageLoaded = true;
          mySetState();
        }
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
          mySetState();
        }
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
      onReceivedServerTrustAuthRequest: (controller, URLAuthenticationChallenge challenge) async {
        // MyPrint.printOnConsole("onReceivedServerTrustAuthRequest called with webViewController:$webViewController, challenge:$challenge");
        //Do some checks here to decide if CANCELS or PROCEEDS
        return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
      },
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        MyPrint.printOnConsole("onConsoleMessage called with consoleMessage:${consoleMessage.message}, messageLevel:${consoleMessage.messageLevel}");
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
      onPermissionRequest: (InAppWebViewController controller, PermissionRequest request) async {
        MyPrint.printOnConsole("onPermissionRequest called for Request:${request.resources}");

        return PermissionResponse(
          action: PermissionResponseAction.PROMPT,
          resources: [
            PermissionResourceType.CAMERA_AND_MICROPHONE,
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_provider.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/successful_user_login_model.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:provider/provider.dart';

import '../../backend/instabot/instabot_controller.dart';
import '../../utils/my_print.dart';
import '../common/components/modal_progress_hud.dart';

class InstaBotScreen extends StatefulWidget {
  static const String routeName = "/InstaBotScreen";

  const InstaBotScreen({Key? key}) : super(key: key);

  @override
  State<InstaBotScreen> createState() => _InstaBotScreenState();
}

class _InstaBotScreenState extends State<InstaBotScreen> {
  late ThemeData themeData;

  late InstabotController instabotController;
  Future<String>? getInstabotUrlFuture;

  InAppWebViewController? webViewController;

  bool isPageLoaded = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    AppProvider appProvider = context.read<AppProvider>();
    instabotController = InstabotController(provider: context.read<InstaBotProvider>());

    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    SuccessfulUserLoginModel? successfulUserLoginModel = authenticationProvider.getSuccessfulUserLoginModel();
    if(successfulUserLoginModel != null) {
      getInstabotUrlFuture = instabotController.getInstabotUrl(
        appProvider: appProvider,
        successfulUserLoginModel: successfulUserLoginModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "InstaBot",
        ),
      ),
      body: SafeArea(
        child: getInstabotUrlFuture != null ? FutureBuilder<String>(
          future: getInstabotUrlFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            MyPrint.printOnConsole("snapshot.connectionState:${snapshot.connectionState}");
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data?.isNotEmpty ?? false) {
                // return AdvancedWebCourseLaunch(snapshot.data!, "InstaBot");
                String url = snapshot.data!;

                return ModalProgressHUD(
                  inAsyncCall: isLoading || !isPageLoaded,
                  opacity: 0,
                  child: getWebview(url),
                );
              }
              else {
                return const Center(
                  child: Text(
                    "Error in Loading Instabot",
                  ),
                );
              }
            }
            else {
              return const Center(child: CommonLoader(),);
            }
          },
       ) : const Center(
          child: Text("Something Went Wrong"),
        ),
      ),
    );
  }

  Widget getWebview(String url) {
    /*if(kIsWeb) {
      return WebViewX(
        initialContent: url.startsWith('www') ? 'https://${url}' : url,
        initialSourceType: SourceType.url,
        width: double.maxFinite,
        onPageStarted: (String url){
          print("start  : $url");
        },
        onPageFinished: (String url) {
          print("end  : $url");
          setState(() {
            isLoading = false;
          });
        },
        userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
        navigationDelegate: (url)async{
          print("url : $url");
          return NavigationDecision.navigate;
        },
        height: double.maxFinite,
      );
    }*/
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(url),
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

        if(!isPageLoaded && progress == 100) {
          isPageLoaded = true;
          setState(() {});
        }
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
    );
  }
}

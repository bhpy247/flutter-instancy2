import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

import '../../../backend/navigation/navigation.dart';

class WebViewScreen extends StatefulWidget {
  static const String routeName = "/WebViewScreen";

  final WebViewScreenNavigationArguments arguments;

  const WebViewScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String url = "";

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.arguments.url;
  }

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("WebView Screen url:$url");

    return Scaffold(
      appBar: getAppBar(),
      body: getMainBody(url: url),
    );
  }

  Widget getMainBody({required String url}) {
    if (url.isEmpty) {
      return const Center(
        child: Text("Couldn't loaded"),
      );
    }

    if (url.startsWith("www")) {
      url = 'https://$url';
    } else if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "https://");
    }

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
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: Text(
        widget.arguments.title,
        style: const TextStyle(
          fontSize: 18,
          // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ],
    );
  }
}

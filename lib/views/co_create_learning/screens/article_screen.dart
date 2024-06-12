import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';

class ArticleScreen extends StatefulWidget {
  static const String routeName = "/ArticleScreen";

  final ArticleScreenNavigationArguments arguments;

  const ArticleScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> with MySafeState {
  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: widget.arguments.courseDTOModel?.ContentName ?? "",
    );
  }

  Widget getMainBody() {
    String htmlCode = widget.arguments.courseDTOModel?.articleContentModel?.articleHtmlCode ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5),
      ),
      child: htmlCode.isNotEmpty ? getWebviewWidget(htmlCode: htmlCode) : getDummyArticleWidget(),
    );
  }

  Widget getWebviewWidget({required String htmlCode}) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: htmlCode,
      ),
      onWebViewCreated: (InAppWebViewController webViewController) {
        MyPrint.printOnConsole("onWebViewCreated called with webViewController:$webViewController");

        // this.webViewController = webViewController;
      },
      onLoadStart: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStart called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
      onProgressChanged: (InAppWebViewController webViewController, int progress) {
        MyPrint.printOnConsole("onProgressChanged called with webViewController:$webViewController, progress:$progress");
        // this.webViewController = webViewController;

        /*if(!isPageLoaded && progress == 100) {
              isPageLoaded = true;
              setState(() {});
            }*/
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
        // this.webViewController = webViewController;
      },
    );
  }

  Widget getDummyArticleWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "In the realm of artificial intelligence (AI), large language models have emerged as groundbreaking innovations, revolutionizing the way machines understand and generate human language. These models, powered by deep learning techniques, have garnered immense attention for their remarkable capabilities in natural language processing (NLP), text generation, and various other language-related tasks. But what exactly are large language models, and how do they work?",
          ),
          const SizedBox(height: 10),
          Image.asset("assets/demo/articleContentImage1.png"),
          const SizedBox(height: 10),
          const Text(
            "Click here for Ethical and Societal Implications",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              decorationColor: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Understanding Large Language Models:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "At their core, large language models are sophisticated neural network architectures designed to process and generate human-like text. They are trained on massive amounts of text data sourced from diverse linguistic sources such as books, articles, websites, and other textual corpora. The training process involves exposing the model to vast quantities of text, allowing it to learn intricate patterns, structures, and nuances of language.",
          ),
          const SizedBox(height: 20),
          const Text(
            "Key Components and Architectures:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Large language models typically consist of multiple layers of artificial neurons organized into deep neural networks. These networks utilize attention mechanisms, recurrent neural networks (RNNs), transformers, or combinations thereof to capture and encode the contextual information of input text. Transformers, in particular, have gained prominence for their ability to handle long-range dependencies efficiently, enabling the model to understand and generate coherent and contextually relevant text.",
          ),
        ],
      ),
    );
  }
}

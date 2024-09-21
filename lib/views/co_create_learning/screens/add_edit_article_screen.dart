import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as flutter_inappwebview;
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_operation_parameters.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_type.dart' as navigation_type;
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/data_model/article_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/request_model/generate_whole_article_content_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/common/request_model/native_authoring_get_resources_request_model.dart';
import '../../common/components/app_ui_components.dart';
import '../component/generate_text_dialog.dart';

class AddEditArticleScreen extends StatefulWidget {
  static const String routeName = "/AddEditArticleScreen";
  final AddEditArticleScreenNavigationArgument arguments;

  const AddEditArticleScreen({super.key, required this.arguments});

  @override
  State<AddEditArticleScreen> createState() => _AddEditArticleScreenState();
}

class _AddEditArticleScreenState extends State<AddEditArticleScreen> with MySafeState {
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  String? selectedSourceType;

  Map<String, String> sourceTypesList = <String, String>{};

  TextEditingController youtubeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  bool isSearchingInternetUrls = false;
  List<String> internetSearchUrlsList = <String>[];
  String? selectedInternetSearchUrl;

  bool isSearchingYoutubeUrls = false;
  List<String> youtubeSearchUrlsList = <String>[];
  String? selectedYoutubeSearchUrl;
  String nextPageToken = "";

  void initialize() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    sourceTypesList = <String, String>{
      "Large Language Model (LLM)": MicroLearningSourceSelectionTypes.LLM,
      "Youtube": MicroLearningSourceSelectionTypes.Youtube,
      "Website": MicroLearningSourceSelectionTypes.Website,
      "Youtube Search": MicroLearningSourceSelectionTypes.YoutubeSearch,
      "Internet Search": MicroLearningSourceSelectionTypes.InternetSearch,
    };
    selectedSourceType = sourceTypesList.entries.firstElement?.key;

    ArticleContentModel articleContentModel = coCreateContentAuthoringModel.articleContentModel ??= ArticleContentModel();

    selectedSourceType = sourceTypesList.entries.where((element) => element.value == articleContentModel.selectedArticleSourceType).firstElement?.key ?? selectedSourceType;

    if (selectedSourceType == MicroLearningSourceSelectionTypes.Youtube) {
      youtubeController.text = articleContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.Website) {
      websiteController.text = articleContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.InternetSearch) {
      selectedInternetSearchUrl = articleContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.YoutubeSearch) {
      selectedYoutubeSearchUrl = articleContentModel.contentUrl;
    }
  }

  Future<void> onGenerateInternetSearchUrls() async {
    if (isSearchingInternetUrls) return;

    isSearchingInternetUrls = true;
    mySetState();

    List<String> urls = await coCreateKnowledgeController.getInternetSearchUrls(
      requestModel: NativeAuthoringGetResourcesRequestModel(
        learning_objective: coCreateContentAuthoringModel.title,
        from_internet: true,
      ),
    );

    internetSearchUrlsList = urls;

    MyPrint.printOnConsole("Final internetSearchUrlsList:$internetSearchUrlsList");
    if (internetSearchUrlsList.isEmpty || !internetSearchUrlsList.contains(selectedInternetSearchUrl)) {
      selectedInternetSearchUrl = null;
    }

    isSearchingInternetUrls = false;
    mySetState();
  }

  Future<void> onGenerateYoutubeSearchUrls() async {
    if (isSearchingYoutubeUrls) return;

    isSearchingYoutubeUrls = true;
    mySetState();

    ({String nextPageToken, List<String> urls}) response = await coCreateKnowledgeController.getYoutubeSearchUrls(
      requestModel: NativeAuthoringGetResourcesRequestModel(
        learning_objective: coCreateContentAuthoringModel.title,
        from_youtube: true,
        next_page_token: nextPageToken,
      ),
    );

    nextPageToken = response.nextPageToken;
    youtubeSearchUrlsList = response.urls;

    MyPrint.printOnConsole("Final youtubeSearchUrlsList:$youtubeSearchUrlsList");
    if (youtubeSearchUrlsList.isEmpty || !youtubeSearchUrlsList.contains(selectedYoutubeSearchUrl)) {
      selectedYoutubeSearchUrl = null;
    }

    isSearchingYoutubeUrls = false;
    mySetState();
  }

  void onPreviousButtonTap() {
    Navigator.pop(context);
  }

  Future<void> onNextButtonTap() async {
    ArticleContentModel articleContentModel = coCreateContentAuthoringModel.articleContentModel ??= ArticleContentModel();

    articleContentModel.selectedArticleSourceType = sourceTypesList.keys.contains(selectedSourceType) ? sourceTypesList[selectedSourceType]! : sourceTypesList.entries.first.value;
    articleContentModel.contentUrl = switch (articleContentModel.selectedArticleSourceType) {
      MicroLearningSourceSelectionTypes.Youtube => youtubeController.text,
      MicroLearningSourceSelectionTypes.Website => websiteController.text,
      MicroLearningSourceSelectionTypes.InternetSearch => selectedInternetSearchUrl ?? "",
      MicroLearningSourceSelectionTypes.YoutubeSearch => selectedYoutubeSearchUrl ?? "",
      _ => "",
    };

    MyPrint.printOnConsole("Article.selectedArticleSourceType : ${articleContentModel.selectedArticleSourceType}");

    dynamic value = await NavigationController.navigateToArticleEditorScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: navigation_type.NavigationType.pushNamed,
      ),
      argument: ArticleEditorScreenNavigationArgument(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
    );

    if (value == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();

    initialize();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: getBottomButtonsWidget(),
        appBar: AppConfigurations().commonAppBar(
          title: coCreateContentAuthoringModel.isEdit ? "Edit Article" : "Create Article",
        ),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: getMainBody(),
        ),
      ),
    );
  }

  Widget getBottomButtonsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                onNextButtonTap();
              },
              text: "Next",
              fontColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getMainBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Styles.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sourceTypesList.entries.map((e) {
              return getCommonRadioButton(
                value: e.key,
                onChanged: (val) {
                  selectedSourceType = val ?? "";
                  mySetState();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget getCommonRadioButton({required String value, ValueChanged<String?>? onChanged, bool isSubtitleTrue = false, TextEditingController? controller}) {
    Widget? subtitle;

    if (["Youtube", "Website"].contains(value) && selectedSourceType == value) {
      subtitle = Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: value == "Youtube" ? youtubeController : websiteController,
          decoration: const InputDecoration(
            hintText: "Enter url",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
        ),
      );
    } else if (["Internet Search", "Youtube Search"].contains(value) && selectedSourceType == value) {
      if (value == "Internet Search") {
        subtitle = getSearchUrlsWidget(
          isUrlsLoading: isSearchingInternetUrls,
          urlsList: internetSearchUrlsList,
          selectedUrl: selectedInternetSearchUrl,
          onSearchTap: () {
            onGenerateInternetSearchUrls();
          },
          onSearchAgainTap: () {
            onGenerateInternetSearchUrls();
          },
        );
      } else {
        subtitle = getSearchUrlsWidget(
          isUrlsLoading: isSearchingYoutubeUrls,
          urlsList: youtubeSearchUrlsList,
          selectedUrl: selectedYoutubeSearchUrl,
          onSearchTap: () {
            onGenerateYoutubeSearchUrls();
          },
          onSearchAgainTap: () {
            onGenerateYoutubeSearchUrls();
          },
        );
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            MyPrint.printOnConsole("value : $value");
            selectedSourceType = value;
            mySetState();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Radio(
                  value: value,
                  groupValue: selectedSourceType,
                  onChanged: (val) {
                    MyPrint.printOnConsole("value : $val");
                    selectedSourceType = val;
                    mySetState();
                  },
                ),
                Expanded(
                  child: Text(
                    value,
                    style: themeData.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (subtitle != null)
          Container(
            padding: const EdgeInsets.only(left: 30),
            child: subtitle,
          ),
      ],
    );
  }

  Widget getSearchUrlsWidget({
    required bool isUrlsLoading,
    required List<String> urlsList,
    required String? selectedUrl,
    void Function()? onSearchTap,
    void Function()? onSearchAgainTap,
  }) {
    if (isUrlsLoading) {
      return const Row(
        children: [
          CommonLoader(
            size: 40,
          ),
        ],
      );
    } else if (urlsList.isEmpty) {
      return Row(
        children: [
          Flexible(
            child: CommonButton(
              onPressed: () {
                onSearchTap?.call();
              },
              text: "Search",
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              fontColor: themeData.colorScheme.onPrimary,
            ),
          ),
        ],
      );
    } else {
      if (selectedUrl.checkNotEmpty && !urlsList.contains(selectedUrl)) {
        selectedUrl = null;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...urlsList.map((e) {
            return GestureDetector(
              onTap: () {
                MyPrint.printOnConsole("value : $e");
                selectedInternetSearchUrl = e;
                mySetState();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    Radio(
                      value: e,
                      groupValue: selectedInternetSearchUrl,
                      onChanged: (val) {
                        MyPrint.printOnConsole("value : $val");
                        selectedInternetSearchUrl = val;
                        mySetState();
                      },
                    ),
                    Expanded(
                      child: Text(
                        e,
                        style: themeData.textTheme.labelMedium?.copyWith(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          CommonButton(
            onPressed: () {
              onSearchAgainTap?.call();
            },
            text: "Search Again",
            margin: const EdgeInsets.only(left: 16, top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            fontColor: themeData.colorScheme.onPrimary,
          ),
        ],
      );
    }
  }
}

class ArticleEditorScreen extends StatefulWidget {
  static const String routeName = "/ArticleEditorScreen";

  final ArticleEditorScreenNavigationArgument arguments;

  const ArticleEditorScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> with MySafeState {
  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  final HtmlEditorController controller = HtmlEditorController();

  String initialHtmlString = "";

  double? maxHeight;

//   String defaultArticleScreen = """<!DOCTYPE html>
// <html lang="en-IN">
// 	<head>
// <meta name="viewport" content="width=device-width, initial-scale=1.0">
// 		<meta charset="utf-8" />
// 		<title>
// 		</title>
// 		<style>
// 			body { line-height:116%; font-family:Aptos; font-size:12pt }
// 			h1, h2, h3, h4, h5, h6, p { margin:0pt 0pt 8pt }
// 			li { margin-top:0pt; margin-bottom:8pt }
// 			h1 { margin-top:18pt; margin-bottom:4pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:'Aptos Display'; font-size:20pt; font-weight:normal; color:#0f4761 }
// 			h2 { margin-top:8pt; margin-bottom:4pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:'Aptos Display'; font-size:16pt; font-weight:normal; color:#0f4761 }
// 			h3 { margin-top:8pt; margin-bottom:4pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:14pt; font-weight:normal; color:#0f4761 }
// 			h4 { margin-top:4pt; margin-bottom:2pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; font-style:italic; color:#0f4761 }
// 			h5 { margin-top:4pt; margin-bottom:2pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; color:#0f4761 }
// 			h6 { margin-top:2pt; margin-bottom:0pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; font-style:italic; color:#595959 }
// 			.Heading7 { margin-top:2pt; margin-bottom:0pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; font-style:normal; color:#595959 }
// 			.Heading8 { margin-bottom:0pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; font-style:italic; color:#272727 }
// 			.Heading9 { margin-bottom:0pt; page-break-inside:avoid; page-break-after:avoid; line-height:116%; font-family:Aptos; font-size:12pt; font-weight:normal; font-style:normal; color:#272727 }
// 			.IntenseQuote { margin:18pt 43.2pt; text-align:center; line-height:116%; border-top:0.75pt solid #0f4761; border-bottom:0.75pt solid #0f4761; padding-top:10pt; padding-bottom:10pt; font-size:12pt; font-style:italic; color:#0f4761 }
// 			.ListParagraph { margin-left:36pt; margin-bottom:8pt; line-height:116%; font-size:12pt }
// 			.Quote { margin-top:8pt; margin-bottom:8pt; text-align:center; line-height:116%; font-size:12pt; font-style:italic; color:#404040 }
// 			.Subtitle { margin-bottom:8pt; line-height:116%; font-size:14pt; letter-spacing:0.75pt; color:#595959 }
// 			.Title { margin-bottom:4pt; line-height:normal; font-family:'Aptos Display'; font-size:28pt; letter-spacing:-0.5pt }
// 			span.Heading1Char { font-family:'Aptos Display'; font-size:20pt; color:#0f4761 }
// 			span.Heading2Char { font-family:'Aptos Display'; font-size:16pt; color:#0f4761 }
// 			span.Heading3Char { font-size:14pt; color:#0f4761 }
// 			span.Heading4Char { font-style:italic; color:#0f4761 }
// 			span.Heading5Char { color:#0f4761 }
// 			span.Heading6Char { font-style:italic; color:#595959 }
// 			span.Heading7Char { color:#595959 }
// 			span.Heading8Char { font-style:italic; color:#272727 }
// 			span.Heading9Char { color:#272727 }
// 			span.IntenseEmphasis { font-style:italic; color:#0f4761 }
// 			span.IntenseQuoteChar { font-style:italic; color:#0f4761 }
// 			span.IntenseReference { font-weight:bold; font-variant:small-caps; letter-spacing:0.25pt; color:#0f4761 }
// 			span.QuoteChar { font-style:italic; color:#404040 }
// 			span.SubtitleChar { font-size:14pt; letter-spacing:0.75pt; color:#595959 }
// 			span.TitleChar { font-family:'Aptos Display'; font-size:28pt; letter-spacing:-0.5pt }
// 		</style>
// 	</head>
// 	<body>
// 			<p style="text-align:center">
// 				<strong>Biotechnology and Genetic Engineering using AI: A Review</strong>
// 			</p>
// 			<p style="text-align:left">
// 				<strong>&#xa0;</strong>
// 			</p>
// 			<ol style="margin:0pt; padding-left:0pt">
// 				<li class="ListParagraph" style="margin-left:33.01pt; text-align:left; padding-left:2.99pt">
// 					<strong>Introduction</strong>:
// 				</li>
// 			</ol>
// 			<p style="margin-left:18pt; text-align:left">
// 				The rapid growth of biotechnology (BT), genetic engineering (GE), and artificial intelligence (AI) have been key in solving many complex problems faced by our society. The intersection of these three dynamic fields opens up new frontiers for innovation, promising transformative solutions in healthcare, agriculture, environmental conservation, and more [1]. The seeds for this convergence were sown over the past few decades. The areas of BT and GE have had notable advancements since their origins in the early and mid-20th century, respectively [2]. During a same period, the topic of AI emerged as an area of academic inquiry aimed atdeveloping robots that had the ability to replicate human intellect [3]. These disciplines have undergone separate evolutionary processes, resulting in notable advancements and substantial milestones. Over the course of the last 10 years, there has been an increasing convergence between these two entities, effectively using their mutual strengths to amplify their respective capabilities [4]. The integration of AI within the fields of biotechnology and genetic engineering holds significant promise. The processing power and pattern recognition capabilities of AI allow researchers to efficiently analyse and comprehend large quantities of biological data with remarkable speed and precision [5]. In contrast, the fields of biotechnology and genetic engineering provide a wide range of intricate challenges that may be addressed by AI, hence creating an advantageous environment for the development of increasingly advanced AI models [6]. The primary aim of this work is to conduct a comprehensive analysis of the current state of convergence between AI, BT, and GE. This encompasses an examination of the technology and methodologies used, the challenges faced, and the potential future directions. The present review employs a methodical methodology, whereby a careful selection and analysis of scholarly articles, research papers, and case studies published during the last ten years in the respective domains is undertaken. The study has considerable importance due to its ability to provide academics, policymakers, and industry practitioners a complete comprehension of the interplay between AI, BT, and GE. The comprehension of this concept is crucial in order to effectively use the capabilities of various disciplines, direct forthcoming investigations and policy choices, and provide insights for industrial implementation [7]. The structure of the paper is as follows: Section 2 provides an overview of the contextual framework and AI Techniques in Biotechnology shown in Section 3. Challenges and limitations explained in Section 4 and mathematical &amp; computational models in Section 5, which is followed by conclusion.
// 			</p>
// 			<ol start="2" style="margin:0pt; padding-left:0pt">
// 				<li class="ListParagraph" style="margin-left:33.01pt; text-align:left; padding-left:2.99pt; font-weight:bold">
// 					Background:
// 				</li>
// 			</ol>
// 			<p style="margin-left:18pt; text-align:left">
// 				Understanding the merger of AI, biotechnology, and genetic engineering necessitates a clear comprehension of each individual concept.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● BT involves the use of biological processes, creatures, or systems for the purpose of producing goods with the aim of enhancing the overall wellbeing of the human population [1]. The origins of traditional biotechnology may be traced back to ancient civilizations, when early practises such as the production of beer and the fermentation of food were prevalent. The field of modern BT has seen significant growth, including a diverse array of applications. These applications span from the development of medical medicines and diagnostic instruments to the implementation of effective methods for the remediation of hazardous waste [2] [8-12].
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● GE refers to the deliberate alteration of an organism's genetic material via the use of biotechnological techniques. The ability to manipulate DNA via molecular cloning and gene sequencing methods has only been achievable since the discovery of the DNA structure in 1953 [3]. The field of genetic engineering enables scientists to manipulate the genetic composition of an organism with precision, hence facilitating the addition, removal, or modification of genes in order to attain certain traits [13-20]. The field of genetic engineering has significant implications in the domains of health, agriculture, and environmental research [4] AI encompasses a wide range of applications and disciplines. At a broad level, the concept entails the development of computers that possess the ability to imitate human intellect, acquire knowledge from experiences, comprehend intricate information, participate in many types of social engagement, and perhaps demonstrate creative capabilities [5]. AI comprises a range of techniques and subfields, such as ML, DL, and NNs, each with their own methodologies and applications [6].
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				&#xa0;● Intersection of AI, BT, and GE is a novel and pioneering area of scholarly investigation. The use of AI and its computing capabilities, together with its aptitude for pattern recognition in extensive datasets, has expedited several procedures in the fields of biotechnology and genetic engineering. This has resulted in the generation of rapid, efficient, and accurate outcomes [7]. The integration of these disciplines has created novel opportunities in the fields of pharmaceutical research, genetic manipulation, individualised healthcare, and several other areas [8]. Table 1 presents the foundational principles. Understanding these fundamental concepts lays the groundwork for exploring the ways AI can enhance biotechnology and genetic engineering. It is through this knowledge that we can begin to appreciate the breadth and depth of opportunities available at this intersection
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				Intersection of AI, Biotechnology, and Genetic Engineering
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Segoe UI Symbol'">✔</span> Emergence of the Intersection: The intersection of AI, biotechnology, and genetic engineering is a relatively recent development that gained momentum in the 21st century [21]. Technological advancements and the burgeoning availability of biological data have driven this intersection, as AI's analytical capabilities became invaluable in managing, processing, and interpreting this data [22].
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Segoe UI Symbol'">✔</span> AI's Role in Biotechnology and Genetic Engineering: AI technologies, primarily machine learning, have shown significant promise in dealing with complex biological systems. Machine learning algorithms excel at finding patterns in large datasets, a feature that's particularly useful in interpreting genetic data and predicting biological outcomes [3], [23-30]. AI can contribute to both these fields in several ways, such as accelerating the drug discovery process, optimizing bioprocesses, predicting gene functions, and designing genetic modifications [4]. Table 2 shows the comparison of the techniques.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Segoe UI Symbol'">✔</span>How Biotechnology and Genetic Engineering Fuel AI: Conversely, biotechnology and genetic engineering also offer substantial opportunities for the advancement of AI [31]. Biological systems are incredibly complex and dynamic, presenting a rich source of problems that push the boundaries of current AI technologies. Tackling these problems could lead to more sophisticated AI models [32-38]. Additionally, insights from genetic algorithms, neural networks, and biological learning processes could inspire new AI techniques [5].
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Segoe UI Symbol'">✔</span>Challenges in the Intersection: Despite the potential benefits, the convergence of AI, biotechnology, and genetic engineering also presents several challenges [39-42]. These challenges include data privacy and security concerns, ethical issues around genetic modifications, regulatory hurdles, and technical issues, like the difficulty of integrating AI with complex biological systems [6].
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Segoe UI Symbol'">✔</span>Potential and Future Directions: The intersection of AI, biotechnology, and genetic engineering is a rapidly expanding field with tremendous potential [43-49]. Future directions might involve more personalized medical treatments, efficient biomanufacturing processes, sustainable agricultural practices, and many other applications yet to be imagined [7]
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<strong>AI Techniques in Biotechnology </strong>
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● Machine Learning (ML) in Biotechnology: Machine Learning has been pivotal in processing and analyzing large-scale biological datasets [1]. Supervised learning techniques, such as SVM and RF, have been used in the categorization of gene expression and the prediction of protein structure [50-56]. Unsupervised learning methods, including as clustering and dimensionality reduction approaches, are often used in the context of data visualisation and genetic data interpretation [3]
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				Equation for the concept of Machine Learning Equation 1 demonstrating a basic supervised learning algorithm could be used:
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				<span style="font-family:'Cambria Math'">𝑌</span> = <span style="font-family:'Cambria Math'">𝑓</span>(<span style="font-family:'Cambria Math'">𝑋</span>) + <span style="font-family:'Cambria Math'">𝜀</span> (1) Where:
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● Y represents the dependent variable or output.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● f(X) represents the systematic information that X provides about Y.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● X represents the independent variable or input.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● ε represents the error term. Equation for Gradient Descent Equation 2 illustrates the use of the Gradient Descent method, a widely employed methodology in several ML algorithms. <span style="font-family:'Cambria Math'">𝜃</span> = <span style="font-family:'Cambria Math'">𝜃</span> − <span style="font-family:'Cambria Math'">𝛼</span> <span style="font-family:'Cambria Math'">𝛻𝐽</span>(<span style="font-family:'Cambria Math'">𝜃</span>) (2) Where:
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● θ is a parameter vector.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● α is the learning rate.
// 			</p>
// 			<p style="margin-left:18pt; text-align:left">
// 				● <span style="font-family:'Cambria Math'">∇</span>J(θ) is the gradient of the loss function J at θ.
// 			</p>
// 	<p style="bottom: 10px; right: 10px; position: absolute;"><a href="https://wordtohtml.net" target="_blank" style="font-size:11px; color: #d0d0d0">Converted to HTML with WordToHTML.net</a></p>
// </body>
// </html>
// """;

  Future? future;
  bool isFirstTime = true;

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;
    MyPrint.printOnConsole("coCreateContentAuthoringModelcoCreateContentAuthoringModel : ${coCreateContentAuthoringModel.articleContentModel?.toMap()}");
    // initialHtmlString = coCreateContentAuthoringModel.articleContentModel?.articleHtmlCode;
    // if (!coCreateContentAuthoringModel.isEdit) initialHtmlString = defaultArticleScreen;
    if (!coCreateContentAuthoringModel.isEdit) {
      future = getGeneratedData();
    }
  }

  Future<void> getGeneratedData() async {
    GenerateWholeArticleContentRequestModel requestModel = GenerateWholeArticleContentRequestModel(
      title: coCreateContentAuthoringModel.title,
      numberOfTopics: 3,
      source: coCreateContentAuthoringModel.articleContentModel?.selectedArticleSourceType == MicroLearningSourceSelectionTypes.InternetSearch
          ? "internet"
          : coCreateContentAuthoringModel.articleContentModel?.selectedArticleSourceType.toLowerCase() ?? "",
      wordsCount: 200,
    );
    initialHtmlString = await coCreateKnowledgeController.generateWholeArticleContent(requestModel: requestModel);
    MyPrint.printOnConsole("initialHtmlString: $initialHtmlString");
  }

  Future<void> showMoreActions({CourseDTOModel? model, int index = 0}) async {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Generate Text",
        actionsEnum: InstancyContentActionsEnum.GenerateText,
        onTap: () {
          Navigator.pop(context);

          showActionsDialog();
        },
        iconData: InstancyIcons.generateText,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);

          controller.clear();
        },
        iconData: InstancyIcons.delete,
      ),
      InstancyUIActionModel(
        text: "Regenerate",
        actionsEnum: InstancyContentActionsEnum.Regenerate,
        onTap: () {
          Navigator.pop(context);
          future = getGeneratedData();
          mySetState();
        },
        iconData: InstancyIcons.regenerate,
      ),
    ];

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  Future<void> showActionsDialog() async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GenerateTextDialog();
      },
    );

    if (value == null || value is! int || ![1, 2].contains(value)) {
      return;
    }

    String generatedText = "";

    if (value == 1) {
      dynamic value = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InternetSearchDialog(
            generateWholeArticleContentRequestModel: GenerateWholeArticleContentRequestModel(
              title: coCreateContentAuthoringModel.title,
              numberOfTopics: 3,
              source: "internet",
              wordsCount: 200,
            ),
          );
        },
      );
      MyPrint.printOnConsole("value from InternetSearchDialog: $value");

      if (value is! String || value.isEmpty) {
        return;
      }
      generatedText = value;
      String appendedString = "$initialHtmlString<br>$generatedText";

      if (generatedText.checkNotEmpty) {
        if (isFirstTime) {
          controller.insertHtml(appendedString);
          controller.insertHtml(appendedString);
          isFirstTime = false;
        } else {
          controller.insertHtml(appendedString);
        }
        if (kIsWeb) controller.reloadWeb();
        mySetState();
      }
    } else {
      dynamic value = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const GenerateTextWithAIDialog();
        },
      );

      if (value is! String || value.isEmpty) {
        return;
      }

      generatedText = value;
      String appendedString = "$initialHtmlString<br>$generatedText";

      if (generatedText.checkNotEmpty) {
        if (isFirstTime) {
          controller.insertHtml(appendedString);
          controller.insertHtml(appendedString);
          isFirstTime = false;
        } else {
          controller.insertHtml(appendedString);
        }
        if (kIsWeb) controller.reloadWeb();
        mySetState();
      }
    }
  }

  Future<String> exportHtmlString() async {
    String htmlCode = await controller.getText();

    MyPrint.logOnConsole("htmlCode:'$htmlCode'");

    return htmlCode;
  }

  Future<CourseDTOModel?> saveContent() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ArticleEditorScreen().saveContent() called", tag: tag);

    String htmlString = await exportHtmlString();

    if (htmlString.isEmpty) {
      MyToast.showError(context: context, msg: "Please Enter Content");
      return null;
    }

    coCreateContentAuthoringModel.articleContentModel?.articleHtmlCode = htmlString;

    isLoading = true;
    mySetState();

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from AddEditArticleScreen().saveEvent() because contentId is null or empty", tag: tag);
      MyToast.showError(context: context, msg: coCreateContentAuthoringModel.isEdit ? "Couldn't Update Content" : "Couldn't Create Content");
      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    String text = await controller.getText();
    if (text.trim().checkEmpty) {
      MyToast.showError(context: context, msg: "Please enter the text");
      return;
    }

    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    String text = await controller.getText();
    if (text.trim().checkEmpty) {
      MyToast.showError(context: context, msg: "Please enter the text");
      return;
    }
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    await NavigationController.navigateToArticlePreviewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: navigation_type.NavigationType.pushNamed,
      ),
      argument: ArticlePreviewScreenNavigationArgument(
        model: courseDTOModel,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();

    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            // appBar: AppConfigurations().commonAppBar(
            //   title: "Article",
            // ),
            appBar: AppBar(
              // leadingWidth: 30,
              title: getSelectedSourceTextWidget(),
              actions: [
                IconButton(
                  onPressed: () {
                    showMoreActions(model: widget.arguments.coCreateContentAuthoringModel.courseDTOModel);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                ),
              ],
            ),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: future == null
                  ? getMainBody()
                  : FutureBuilder(
                      future: future,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState == ConnectionState.done) {
                          return getMainBody();
                        } else {
                          return const CommonLoader();
                        }
                      }),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          // getSelectedSourceTextWidget(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: getHtmlEditorWidget(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: CommonSaveExitButtonRow(
              onSaveAndViewPressed: onSaveAndViewTap,
              onSaveAndExitPressed: onSaveAndExitTap,
            ),
          )
        ],
      ),
    );
  }

  Widget getSelectedSourceTextWidget() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.arguments.coCreateContentAuthoringModel.title,
            maxLines: 1,
            // style: themeData.textTheme.bodyMedium?.copyWith(
            //   decoration: TextDecoration.underline,
            //   fontWeight: FontWeight.bold,
            // ),
          ),
        ),
      ],
    );
  }

  Widget getHtmlEditorWidget() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        maxHeight ??= constraints.maxHeight;

        String? articleHtmlCode = widget.arguments.coCreateContentAuthoringModel.articleContentModel?.articleHtmlCode;

        return HtmlEditor(
          controller: controller,
          htmlEditorOptions: HtmlEditorOptions(
            hint: 'Your text here...',

            shouldEnsureVisible: true,
            initialText: articleHtmlCode.checkNotEmpty ? articleHtmlCode : initialHtmlString,
          ),
          htmlToolbarOptions: HtmlToolbarOptions(

              textStyle: themeData.textTheme.labelMedium,
              dropdownIconSize: 20,
              toolbarPosition: ToolbarPosition.aboveEditor,
              toolbarType: ToolbarType.nativeScrollable,
              onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                print("button '${type.name}' pressed, the current selected status is $status");
                return true;
              },
              onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                print("dropdown '${type.name}' changed to $changed");
                return true;
              },
              mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                print(url);
                return true;
              },
              audioExtensions: ["audio"]
              /*mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
          print(file.name); //filename
          print(file.size); //size in bytes
          print(file.extension); //file extension (eg jpeg or mp4)
          return true;
        },*/
              ),
          otherOptions: OtherOptions(
            height: maxHeight!,
          ),
          callbacks: Callbacks(
            onBeforeCommand: (String? currentHtml) {
              print('html before change is $currentHtml');
            },
            onChangeContent: (String? changed) {
              print('content changed to $changed');
            },
            onChangeCodeview: (String? changed) {
              print('code changed to $changed');
            },
            onChangeSelection: (EditorSettings settings) {
              print('parent element is ${settings.parentElement}');
              print('font name is ${settings.fontName}');
            },
            onDialogShown: () {
              print('dialog shown');
            },
            onEnter: () {
              print('enter/return pressed');
            },
            onFocus: () {
              print('editor focused');
            },
            onBlur: () {
              print('editor unfocused');
            },
            onBlurCodeview: () {
              print('codeview either focused or unfocused');
            },
            onInit: () {
              print('onInit : init');
            },
            //this is commented because it overrides the default Summernote handlers
            /*onImageLinkInsert: (String? url) {
          print(url ?? "unknown url");
        },
        onImageUpload: (FileUpload file) async {
          print(file.name);
          print(file.size);
          print(file.type);
          print(file.base64);
        },*/
            onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
              print(error.name);
              print(base64Str ?? '');
              if (file != null) {
                print(file.name);
                print(file.size);
                print(file.type);
              }
            },
            onKeyDown: (int? keyCode) {
              print('$keyCode key downed');
              print('current character count: ${controller.characterCount}');
            },
            onKeyUp: (int? keyCode) {
              print('$keyCode key released');
            },
            onMouseDown: () {
              print('mouse downed');
            },
            onMouseUp: () {
              print('mouse released');
            },
            onNavigationRequestMobile: (String url) {
              print(url);
              return NavigationActionPolicy.ALLOW;
            },
            onPaste: () {
              print('pasted into editor');
            },
            onScroll: () {
              print('editor scrolled');
            },
          ),
          plugins: [
            SummernoteAtMention(
              getSuggestionsMobile: (String value) {
                var mentions = <String>['test1', 'test2', 'test3'];
                return mentions.where((element) => element.contains(value)).toList();
              },
              mentionsWeb: ['test1', 'test2', 'test3'],
              onSelect: (String value) {
                print(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget getActionButtonsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                onSaveAndExitTap();
              },
              text: "Save and Exit",
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.primary,
              fontWeight: FontWeight.w600,
              backGroundColor: Colors.transparent,
              borderColor: themeData.primaryColor,
              borderWidth: 1.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CommonButton(
              onPressed: () {
                onSaveAndViewTap();
              },
              text: "Save and View",
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class InternetSearchDialog extends StatefulWidget {
  final GenerateWholeArticleContentRequestModel? generateWholeArticleContentRequestModel;

  const InternetSearchDialog({super.key, this.generateWholeArticleContentRequestModel});

  @override
  State<InternetSearchDialog> createState() => _InternetSearchDialogState();
}

class _InternetSearchDialogState extends State<InternetSearchDialog> with MySafeState {
  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;

  String generatedText = "";
  late Future future;
  TextEditingController searchController = TextEditingController();

  Future<void> getInternetSearchData() async {
    if (widget.generateWholeArticleContentRequestModel == null) return;
    generatedText = await coCreateKnowledgeController.generateWholeArticleContent(
      requestModel: widget.generateWholeArticleContentRequestModel!,
    );
    MyPrint.logOnConsole("generatedTextgeneratedTextgeneratedText: $generatedText");
  }

  @override
  void initState() {
    super.initState();
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
    future = getInternetSearchData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    "Internet Search",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      FontAwesomeIcons.xmark,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            // getSearchTextField(),
            // const SizedBox(height: 10),
            Expanded(
              child: getDummySearchResult(),
            ),
            getBottomButton()
          ],
        ),
      ),
    );
  }

  Widget getSearchTextField() {
    return SizedBox(
      height: 40,
      child: CommonTextFormField(
        controller: searchController,
        borderRadius: 50,
        boxConstraints: const BoxConstraints(minWidth: 55),
        prefixWidget: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        hintText: "Search",
        isOutlineInputBorder: true,
      ),
    );
  }

  Widget getBottomButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                future = getInternetSearchData();
                mySetState();
              },
              backGroundColor: themeData.colorScheme.onPrimary,
              text: "Regenerate",
              fontColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: CommonButton(
              onPressed: () {
                Navigator.pop(context, generatedText);
              },
              text: "Add Text",
              fontColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getDummySearchResult() {
    return FutureBuilder(
        future: future,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectionArea(
                    child: Html(
                      data: generatedText,
                    ),
                  )
                ],
              ),
            );
          } else {
            return const CommonLoader();
          }
        });
  }
}

class GenerateTextWithAIDialog extends StatefulWidget {
  const GenerateTextWithAIDialog({super.key});

  @override
  State<GenerateTextWithAIDialog> createState() => _GenerateTextWithAIDialogState();
}

class _GenerateTextWithAIDialogState extends State<GenerateTextWithAIDialog> with MySafeState {
  TextEditingController promptController = TextEditingController();

  bool isSearchingForResult = false;
  bool isSearchedForResult = false;

  String generatedText = "";

  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;

  late Future future;
  TextEditingController searchController = TextEditingController();

  Future<void> getInternetSearchData() async {
    generatedText = await coCreateKnowledgeController.chatCompletion(promptText: promptController.text.trim());
  }

  @override
  void initState() {
    super.initState();
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
  }

  Future<void> onGenerateTap() async {
    if (isSearchedForResult || isSearchingForResult) return;

    isSearchingForResult = true;
    mySetState();

    future = getInternetSearchData();

    isSearchingForResult = false;
    isSearchedForResult = true;
    mySetState();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ModalProgressHUD(
        inAsyncCall: isSearchingForResult,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      "Generate with AI",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                        FontAwesomeIcons.xmark,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: getMainBody(),
              ),
              const SizedBox(height: 10),
              getBottomButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainBody() {
    if (!isSearchedForResult) {
      return getSearchTextField();
    }

    return getDummySearchResult();
  }

  final _formKey = GlobalKey<FormState>();

  Widget getSearchTextField() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: CommonTextFormField(
              controller: promptController,
              borderRadius: 5,
              boxConstraints: const BoxConstraints(minWidth: 55),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              hintText: "Write Prompt...",
              isOutlineInputBorder: true,
              minLines: 40,
              validator: (String? val) {
                if (val == null || val.trim().checkEmpty) {
                  return "Please enter the prompt";
                }
                return null;
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onTap: () {
                if (promptController.text.isEmpty) {
                  promptController.text = "What is AI Note Taking?";
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      onGenerateTap();
                    }
                  },
                  text: "Generate",
                  minWidth: double.infinity,
                  fontColor: themeData.colorScheme.onPrimary,
                  borderColor: Colors.transparent,
                  fontWeight: FontWeight.w600,
                  borderWidth: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget getBottomButton() {
    if (!isSearchedForResult) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                future = getInternetSearchData();
                mySetState();
              },
              backGroundColor: themeData.colorScheme.onPrimary,
              text: "Regenerate",
              fontColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: CommonButton(
              onPressed: () {
                Navigator.pop(context, generatedText);
              },
              text: "Add Text",
              fontColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getDummySearchResult() {
    return FutureBuilder(
        future: future,
        builder: (context, asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    generatedText,
                  )
                ],
              ),
            );
          } else {
            return const CommonLoader();
          }
        });
  }
}

class ArticlePreviewScreen extends StatefulWidget {
  static const String routeName = "/ArticlePreviewScreen";

  final ArticlePreviewScreenNavigationArgument arguments;

  const ArticlePreviewScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<ArticlePreviewScreen> createState() => _ArticlePreviewScreenState();
}

class _ArticlePreviewScreenState extends State<ArticlePreviewScreen> with MySafeState {
  final HtmlEditorController controller = HtmlEditorController();
  double? maxHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppConfigurations().commonAppBar(
          title: widget.arguments.model.ContentName,
        ),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: getMainBody(htmlCode: widget.arguments.model.articleContentModel?.articleHtmlCode ?? ""),
        ),
      ),
    );
  }

  Widget getMainBody({required String htmlCode}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        maxHeight ??= constraints.maxHeight;

        return Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: flutter_inappwebview.InAppWebView(
            initialData: flutter_inappwebview.InAppWebViewInitialData(
              data: widget.arguments.model.articleContentModel?.articleHtmlCode ?? "",
            ),
            initialSettings: flutter_inappwebview.InAppWebViewSettings(displayZoomControls: true, supportZoom: true),
            onWebViewCreated: (flutter_inappwebview.InAppWebViewController webViewController) {
              MyPrint.printOnConsole("onWebViewCreated called with webViewController:$webViewController");

              // this.webViewController = webViewController;
            },
            onLoadStart: (flutter_inappwebview.InAppWebViewController webViewController, flutter_inappwebview.WebUri? webUri) {
              MyPrint.printOnConsole("onLoadStart called with webViewController:$webViewController, webUri:$webUri");
              // this.webViewController = webViewController;
            },
            onProgressChanged: (flutter_inappwebview.InAppWebViewController webViewController, int progress) {
              MyPrint.printOnConsole("onProgressChanged called with webViewController:$webViewController, progress:$progress");
              // this.webViewController = webViewController;

              /*if(!isPageLoaded && progress == 100) {
                isPageLoaded = true;
                setState(() {});
              }*/
            },
            onLoadStop: (flutter_inappwebview.InAppWebViewController webViewController, flutter_inappwebview.WebUri? webUri) {
              MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");
              // this.webViewController = webViewController;
            },
          ),
        );
      },
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (kIsWeb) {
                  controller.reloadWeb();
                } else {
                  controller.editorController!.reload();
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.toggleCodeView();
          },
          child: const Text(r'<\>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Your text here...',
                  shouldEnsureVisible: true,
                  //initialText: "<p>text content initial, if any</p>",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  //by default
                  toolbarType: ToolbarType.nativeScrollable,
                  //by default
                  onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                    print("button '${type.name}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                    print("dropdown '${type.name}' changed to $changed");
                    return true;
                  },
                  mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  /*mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                    print(file.name); //filename
                    print(file.size); //size in bytes
                    print(file.extension); //file extension (eg jpeg or mp4)
                    return true;
                  },*/
                ),
                otherOptions: const OtherOptions(height: 550),
                callbacks: Callbacks(
                  onBeforeCommand: (String? currentHtml) {
                    print('html before change is $currentHtml');
                  },
                  onChangeContent: (String? changed) {
                    print('content changed to $changed');
                  },
                  onChangeCodeview: (String? changed) {
                    print('code changed to $changed');
                  },
                  onChangeSelection: (EditorSettings settings) {
                    print('parent element is ${settings.parentElement}');
                    print('font name is ${settings.fontName}');
                  },
                  onDialogShown: () {
                    print('dialog shown');
                  },
                  onEnter: () {
                    print('enter/return pressed');
                  },
                  onFocus: () {
                    print('editor focused');
                  },
                  onBlur: () {
                    print('editor unfocused');
                  },
                  onBlurCodeview: () {
                    print('codeview either focused or unfocused');
                  },
                  onInit: () {
                    print('init');
                  },
                  //this is commented because it overrides the default Summernote handlers
                  /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                  onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                    print(error.name);
                    print(base64Str ?? '');
                    if (file != null) {
                      print(file.name);
                      print(file.size);
                      print(file.type);
                    }
                  },
                  onKeyDown: (int? keyCode) {
                    print('$keyCode key downed');
                    print('current character count: ${controller.characterCount}');
                  },
                  onKeyUp: (int? keyCode) {
                    print('$keyCode key released');
                  },
                  onMouseDown: () {
                    print('mouse downed');
                  },
                  onMouseUp: () {
                    print('mouse released');
                  },
                  onNavigationRequestMobile: (String url) {
                    print(url);
                    return NavigationActionPolicy.ALLOW;
                  },
                  onPaste: () {
                    print('pasted into editor');
                  },
                  onScroll: () {
                    print('editor scrolled');
                  },
                ),
                plugins: [
                  SummernoteAtMention(
                    getSuggestionsMobile: (String value) {
                      var mentions = <String>['test1', 'test2', 'test3'];
                      return mentions.where((element) => element.contains(value)).toList();
                    },
                    mentionsWeb: ['test1', 'test2', 'test3'],
                    onSelect: (String value) {
                      print(value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

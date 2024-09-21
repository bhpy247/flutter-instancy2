import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_module_names_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_resources_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/co_create_knowledge/co_create_knowledge_provider.dart';
import '../../../backend/navigation/navigation_type.dart' as navigationType;
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class AddEditMicroLearningScreen extends StatefulWidget {
  static const String routeName = "/AddEditMicroLearningScreen";

  final AddEditMicroLearningScreenNavigationArgument arguments;

  const AddEditMicroLearningScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddEditMicroLearningScreen> createState() => _AddEditMicroLearningScreenState();
}

class _AddEditMicroLearningScreenState extends State<AddEditMicroLearningScreen> with MySafeState {
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pagesController = TextEditingController();
  TextEditingController wordsPerPageController = TextEditingController();

  bool isTextEnabled = true;
  bool isImageEnabled = true;
  bool isAudioEnabled = true;
  bool isVideoEnabled = true;
  bool isQuestionEnabled = true;

  void initialize() {
    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel(
      pageCount: 3,
      wordsPerPageCount: 300,
      isGenerateTextEnabled: true,
      isGenerateImageEnabled: true,
      isGenerateAudioEnabled: true,
      isGenerateVideoEnabled: true,
      isGenerateQuizEnabled: true,
    );

    pagesController.text = microLearningContentModel.pageCount.toString();
    wordsPerPageController.text = microLearningContentModel.wordsPerPageCount.toString();

    isTextEnabled = microLearningContentModel.isGenerateTextEnabled;
    isImageEnabled = microLearningContentModel.isGenerateImageEnabled;
    isAudioEnabled = microLearningContentModel.isGenerateAudioEnabled;
    isVideoEnabled = microLearningContentModel.isGenerateVideoEnabled;
    isQuestionEnabled = microLearningContentModel.isGenerateQuizEnabled;
  }

  void onPreviousButtonTap() {
    Navigator.pop(context);
  }

  bool validateData() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (!isTextEnabled && !isImageEnabled && !isAudioEnabled && !isVideoEnabled && !isQuestionEnabled) {
      MyToast.showError(context: context, msg: "Enable at least one element");
      return false;
    }

    return true;
  }

  Future<void> onNextButtonTap() async {
    if (!validateData()) {
      return;
    }

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel();

    microLearningContentModel.pageCount = ParsingHelper.parseIntMethod(pagesController.text);
    microLearningContentModel.wordsPerPageCount = ParsingHelper.parseIntMethod(wordsPerPageController.text);

    microLearningContentModel.isGenerateTextEnabled = isTextEnabled;
    microLearningContentModel.isGenerateImageEnabled = isImageEnabled;
    microLearningContentModel.isGenerateAudioEnabled = isAudioEnabled;
    microLearningContentModel.isGenerateVideoEnabled = isVideoEnabled;
    microLearningContentModel.isGenerateQuizEnabled = isQuestionEnabled;

    dynamic value = await NavigationController.navigateToMicroLearningSourceSelectionScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: navigationType.NavigationType.pushNamed,
      ),
      argument: MicroLearningSourceSelectionScreenNavigationArgument(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
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
          title: coCreateContentAuthoringModel.isEdit ? "Edit Microlearning" : "Create Microlearning",
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
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CommonButton(
                onPressed: () {
                  onPreviousButtonTap();
                },
                text: "Previous",
                fontColor: themeData.primaryColor,
                backGroundColor: themeData.colorScheme.onPrimary,
                borderColor: themeData.primaryColor,
              ),
            ),
          ),
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              const SizedBox(
                height: 17,
              ),
              getPageTextField(),
              const SizedBox(
                height: 17,
              ),
              getWordsPerPageTextField(),
              const SizedBox(
                height: 17,
              ),
              getCommonSwitchWithTextWidget(
                text: "Text",
                isTrue: isTextEnabled,
                onChanged: (bool? val) {
                  isTextEnabled = val ?? false;
                  mySetState();
                },
              ),
              const SizedBox(
                height: 17,
              ),
              getCommonSwitchWithTextWidget(
                text: "Image",
                isTrue: isImageEnabled,
                onChanged: (bool? val) {
                  isImageEnabled = val ?? false;
                  mySetState();
                },
              ),
              const SizedBox(
                height: 17,
              ),
              getCommonSwitchWithTextWidget(
                text: "Audio",
                isTrue: isAudioEnabled,
                onChanged: (bool? val) {
                  isAudioEnabled = val ?? false;
                  mySetState();
                },
              ),
              const SizedBox(
                height: 17,
              ),
              getCommonSwitchWithTextWidget(
                text: "Video",
                isTrue: isVideoEnabled,
                onChanged: (bool? val) {
                  isVideoEnabled = val ?? false;
                  mySetState();
                },
              ),
              const SizedBox(
                height: 17,
              ),
              getCommonSwitchWithTextWidget(
                text: "Question",
                isTrue: isQuestionEnabled,
                onChanged: (bool? val) {
                  isQuestionEnabled = val ?? false;
                  mySetState();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPageTextField() {
    return Row(
      children: [
        Expanded(
          child: getTexFormField(
            controller: pagesController,
            keyBoardType: TextInputType.number,
            isMandatory: false,
            labelText: "#Pages",
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return "Please Enter a count";
              }

              int? number = int.tryParse(text);
              if (number == null || number < 0) {
                return "Please Enter a valid number";
              }

              return null;
            },
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget getWordsPerPageTextField() {
    return Row(
      children: [
        Expanded(
          child: getTexFormField(
            controller: wordsPerPageController,
            keyBoardType: TextInputType.number,
            isMandatory: false,
            labelText: "#Words Per Page",
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return "Please Enter a count";
              }

              int? number = int.tryParse(text);
              if (number == null || number < 0) {
                return "Please Enter a valid number";
              }

              return null;
            },
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  Widget getCommonSwitchWithTextWidget({required String text, required bool isTrue, ValueChanged<bool?>? onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text),
                  const SizedBox(width: 30),
                  SizedBox(
                    height: 15,
                    width: 35,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: CupertinoSwitch(
                        activeColor: themeData.primaryColor,
                        value: isTrue,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  //region textFieldView
  Widget getTexFormField({
    TextEditingController? controller,
    String iconUrl = "",
    String? Function(String?)? validator,
    String labelText = "Label",
    Widget? suffixWidget,
    required bool isMandatory,
    int? minLines,
    int? maxLines,
    TextInputType? keyBoardType,
    double iconHeight = 15,
    double iconWidth = 15,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      // prefixWidget: iconUrl.isNotEmpty
      //     ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
      //     : const Icon(
      //   FontAwesomeIcons.globe,
      //   size: 15,
      //   color: Colors.grey,
      // ),
      suffixWidget: suffixWidget,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
//endregion
}

class MicroLearningSourceSelectionScreen extends StatefulWidget {
  static const String routeName = "/MicroLearningSourceSelectionScreen";

  final MicroLearningSourceSelectionScreenNavigationArgument arguments;

  const MicroLearningSourceSelectionScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<MicroLearningSourceSelectionScreen> createState() => _MicroLearningSourceSelectionScreenState();
}

class _MicroLearningSourceSelectionScreenState extends State<MicroLearningSourceSelectionScreen> with MySafeState {
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  String? selectedSourceType;

  Map<String, String> sourceTypesList = <String, String>{};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  bool isSearchingInternetUrls = false;
  List<String> internetSearchUrlsList = <String>[];
  String? selectedInternetSearchUrl;

  bool isSearchingYoutubeUrls = false;
  String nextPageToken = "";
  List<String> youtubeSearchUrlsList = <String>[];
  String? selectedYoutubeSearchUrl;

  void initialize() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    sourceTypesList = <String, String>{
      "Large Language Model (LLM)": MicroLearningSourceSelectionTypes.LLM,
      "Youtube": MicroLearningSourceSelectionTypes.Youtube,
      "Website": MicroLearningSourceSelectionTypes.Website,
      "Internet Search": MicroLearningSourceSelectionTypes.InternetSearch,
      "Youtube Search": MicroLearningSourceSelectionTypes.YoutubeSearch,
    };
    selectedSourceType = sourceTypesList.entries.firstElement?.key;

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel(
      pageCount: 3,
      wordsPerPageCount: 300,
      isGenerateTextEnabled: true,
      isGenerateImageEnabled: true,
      isGenerateAudioEnabled: true,
      isGenerateVideoEnabled: true,
      isGenerateQuizEnabled: true,
    );

    selectedSourceType = sourceTypesList.entries.where((element) => element.value == microLearningContentModel.selectedSourceType).firstElement?.key ?? selectedSourceType;

    if (selectedSourceType == MicroLearningSourceSelectionTypes.Youtube) {
      youtubeController.text = microLearningContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.Website) {
      websiteController.text = microLearningContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.InternetSearch) {
      selectedInternetSearchUrl = microLearningContentModel.contentUrl;
    } else if (selectedSourceType == MicroLearningSourceSelectionTypes.YoutubeSearch) {
      selectedYoutubeSearchUrl = microLearningContentModel.contentUrl;
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

  bool validateData() {
    if (selectedSourceType == null) {
      MyToast.showError(context: context, msg: "Invalid source type");
      return false;
    }
    if (!sourceTypesList.keys.contains(selectedSourceType)) {
      MyToast.showError(context: context, msg: "Please select a source type");
      return false;
    }

    String sourceType = sourceTypesList[selectedSourceType]!;

    if (sourceType == MicroLearningSourceSelectionTypes.LLM) {
      return true;
    }

    if ([MicroLearningSourceSelectionTypes.Youtube, MicroLearningSourceSelectionTypes.Website].contains(sourceType)) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return false;
      }
    } else if (sourceType == MicroLearningSourceSelectionTypes.InternetSearch) {
      if (selectedInternetSearchUrl.checkEmpty) {
        MyToast.showError(context: context, msg: "Please select a Internet Search Url");
        return false;
      }
    } else if (sourceType == MicroLearningSourceSelectionTypes.YoutubeSearch) {
      if (selectedYoutubeSearchUrl.checkEmpty) {
        MyToast.showError(context: context, msg: "Please select a Youtube Search Url");
        return false;
      }
    }

    return true;
  }

  Future<void> onGeneratePageTitlesButtonTap() async {
    if (!validateData()) {
      return;
    }

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel();

    microLearningContentModel.selectedSourceType = sourceTypesList.keys.contains(selectedSourceType) ? sourceTypesList[selectedSourceType]! : sourceTypesList.entries.first.value;
    microLearningContentModel.contentUrl = switch (microLearningContentModel.selectedSourceType) {
      MicroLearningSourceSelectionTypes.Youtube => youtubeController.text,
      MicroLearningSourceSelectionTypes.Website => websiteController.text,
      MicroLearningSourceSelectionTypes.InternetSearch => selectedInternetSearchUrl ?? "",
      MicroLearningSourceSelectionTypes.YoutubeSearch => selectedYoutubeSearchUrl ?? "",
      _ => "",
    };

    dynamic value = await NavigationController.navigateToMicroLearningTopicSelectionScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: navigationType.NavigationType.pushNamed,
      ),
      argument: MicroLearningTopicSelectionScreenNavigationArgument(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
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
          title: coCreateContentAuthoringModel.isEdit ? "Edit Microlearning" : "Create Microlearning",
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
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CommonButton(
                onPressed: () {
                  onPreviousButtonTap();
                },
                text: "Previous",
                fontColor: themeData.primaryColor,
                backGroundColor: themeData.colorScheme.onPrimary,
                borderColor: themeData.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: CommonButton(
              onPressed: () {
                onGeneratePageTitlesButtonTap();
              },
              text: "Generate Page Titles",
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
          child: Form(
            key: _formKey,
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
      ),
    );
  }

  Widget getCommonRadioButton({required String value, ValueChanged<String?>? onChanged, bool isSubtitleTrue = false, TextEditingController? controller}) {
    Widget? subtitle;

    if (["Youtube", "Website"].contains(value) && selectedSourceType == value) {
      subtitle = Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: value == "Youtube" ? youtubeController : websiteController,
          decoration: const InputDecoration(
            hintText: "Enter url",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
          validator: (String? value) {
            if (value.checkEmpty) {
              return "Enter url";
            }

            Uri? uri = Uri.tryParse(value!);
            MyPrint.printOnConsole("uri:$uri");
            if (uri == null) {
              return "Invalid url";
            }

            return null;
          },
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
                        style: themeData.textTheme.labelMedium?.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline
                        ),
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

class MicroLearningTopicSelectionScreen extends StatefulWidget {
  static const String routeName = "/MicroLearningTopicSelectionScreen";

  final MicroLearningTopicSelectionScreenNavigationArgument arguments;

  const MicroLearningTopicSelectionScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<MicroLearningTopicSelectionScreen> createState() => _MicroLearningTopicSelectionScreenState();
}

class _MicroLearningTopicSelectionScreenState extends State<MicroLearningTopicSelectionScreen> with MySafeState {
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  bool isGeneratingTopics = false;
  List<String> topicsList = <String>[];

  /*List<String> microLearningList = [
    "Technology in Sustainable Urban Planning",
    "Components of Eco-Conscious Cities",
    "Challenges in Urban Sustainability",
    "Harmonious : Sustainable Environments",
    "Inspiring Action for Resilient Cities",
  ];*/

  void initialize() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    // MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel();

    generateTopicsList();
  }

  Future<void> generateTopicsList() async {
    if (isGeneratingTopics) return;

    isGeneratingTopics = true;
    mySetState();

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel();

    topicsList = await coCreateKnowledgeController.getMicroLearningTopicsListing(
      requestModel: NativeAuthoringGetModuleNamesRequestModel(
        learning_objective: coCreateContentAuthoringModel.title,
        llmContent: microLearningContentModel.selectedSourceType == MicroLearningSourceSelectionTypes.LLM,
        sourceType: switch (microLearningContentModel.selectedSourceType) {
          MicroLearningSourceSelectionTypes.YoutubeSearch => MicroLearningGenerationSourceType.youtube,
          MicroLearningSourceSelectionTypes.Youtube => MicroLearningGenerationSourceType.youtube,
          MicroLearningSourceSelectionTypes.Website => MicroLearningGenerationSourceType.web,
          MicroLearningSourceSelectionTypes.InternetSearch => MicroLearningGenerationSourceType.web,
          _ => "",
        },
        pages_in_content: microLearningContentModel.pageCount,
        sources: [
          if (microLearningContentModel.contentUrl.isNotEmpty) microLearningContentModel.contentUrl,
        ],
      ),
    );
    topicsList = topicsList.toSet().toList();

    MyPrint.printOnConsole("Final topicsList:$topicsList");

    isGeneratingTopics = false;
    mySetState();
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0, List<InstancyUIActionModel>? actions}) async {
    InstancyUIActions().showAction(
      context: context,
      actions: actions ?? getActionsList(model: model, index: index),
    );
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Add Page Title",
        actionsEnum: InstancyContentActionsEnum.AddTitle,
        onTap: () {
          Navigator.pop(context);
        },
        assetIconUrl: "assets/cocreate/commonText.png",
        // iconData: InstancyIcons.,
      ),
    ];

    return actions;
  }

  List<InstancyUIActionModel> getSingleItemActionsList({required String topic, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      InstancyUIActionModel(
        text: "Edit",
        actionsEnum: InstancyContentActionsEnum.AddTitle,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.edit,
      ),
      InstancyUIActionModel(
        text: "Delete",
        actionsEnum: InstancyContentActionsEnum.Delete,
        onTap: () {
          Navigator.pop(context);

          topicsList.remove(topic);
          mySetState();
        },
        iconData: InstancyIcons.delete,
      ),
    ];

    return actions;
  }

  void onPreviousButtonTap() {
    Navigator.pop(context);
  }

  bool validateData() {
    topicsList = topicsList.toSet().toList();
    return topicsList.isNotEmpty;
  }

  Future<void> onGenerateWithAIButtonTap() async {
    MyPrint.printOnConsole("topicsList : $topicsList");

    if (!validateData()) return;

    MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel ??= MicroLearningContentModel(
      pageCount: 3,
      wordsPerPageCount: 300,
      isGenerateTextEnabled: true,
      isGenerateImageEnabled: true,
      isGenerateAudioEnabled: true,
      isGenerateVideoEnabled: true,
      isGenerateQuizEnabled: true,
    );
    microLearningContentModel.selectedTopics = topicsList;

    /*MicroLearningContentModel model = MicroLearningContentModel(
      selectedTopics: [
        "Topic 1",
        "Topic 2",
      ],
      pages: [
        MicroLearningPageModel(
          title: "Page 1",
          elements: [
            MicroLearningPageElementModel(
              htmlContentCode: "<p>Hello</p>",
              elementType: MicroLearningElementType.Text,
            ),
            MicroLearningPageElementModel(
              elementType: MicroLearningElementType.Image,
            ),
            MicroLearningPageElementModel(
              elementType: MicroLearningElementType.Video,
            ),
            MicroLearningPageElementModel(
              elementType: MicroLearningElementType.Audio,
            ),
            MicroLearningPageElementModel(
              quizQuestionModels: [
                QuizQuestionModel(),
              ],
              elementType: MicroLearningElementType.Quiz,
            ),
          ],
        ),
      ],
    );
    MyPrint.logOnConsole("microLearningContentModel:$model");
    return;*/

    dynamic value = await NavigationController.navigateToMicroLearningEditorScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: navigationType.NavigationType.pushNamed,
      ),
      argument: MicroLearningEditorScreenNavigationArgument(
        coCreateContentAuthoringModel: coCreateContentAuthoringModel,
      ),
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
          title: coCreateContentAuthoringModel.isEdit ? "Edit Microlearning" : "Create Microlearning",
          actions: [
            InkWell(
              onTap: () {
                showMoreActions(model: CourseDTOModel());
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        body: getMainBody(),
      ),
    );
  }

  Widget getBottomButtonsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CommonButton(
                onPressed: () {
                  onPreviousButtonTap();
                },
                text: "Previous",
                fontColor: themeData.primaryColor,
                backGroundColor: themeData.colorScheme.onPrimary,
                borderColor: themeData.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: CommonButton(
              onPressed: () {
                onGenerateWithAIButtonTap();
              },
              text: "Generate with AI",
              fontColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getMainBody() {
    if (isGeneratingTopics) {
      return const CommonLoader();
    }
    if (topicsList.isEmpty) {
      return const Center(
        child: Text(
          "No Topics",
        ),
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      shrinkWrap: true,
      key: GlobalKey(),
      children: List.generate(
        topicsList.length,
        (index) {
          String topic = topicsList[index];

          return Container(
            key: Key("$index"),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}.",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    topic,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    showMoreActions(
                      model: CourseDTOModel(),
                      actions: getSingleItemActionsList(topic: topic),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = topicsList.removeAt(oldIndex);
          topicsList.insert(newIndex, item);
        });
      },
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/data_model/podcast_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/language_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/language_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/speaking_style_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class TextToAudioScreen extends StatefulWidget {
  static const String routeName = "/TextToAudioScreen";
  final TextToAudioScreenNavigationArgument argument;

  const TextToAudioScreen({super.key, required this.argument});

  @override
  State<TextToAudioScreen> createState() => _TextToAudioScreenState();
}

class _TextToAudioScreenState extends State<TextToAudioScreen> with MySafeState {
  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController promptEditingController = TextEditingController();

  bool isRegenerateTap = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showBottomSheetDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetDragger(),
              ListTile(
                onTap: () {
                  Navigator.pop(context);

                  textEditingController.clear();
                  mySetState();
                },
                leading: const Icon(
                  Icons.delete,
                  size: 20,
                ),
                title: const Text("Delete"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  isRegenerateTap = true;
                  mySetState();
                },
                leading: const Icon(
                  FontAwesomeIcons.repeat,
                  size: 20,
                ),
                title: const Text("Regenerate"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> generateScriptedText({required String text}) async {
    isLoading = true;
    mySetState();

    String generatedText = await coCreateKnowledgeController.chatCompletion(promptText: text);
    if (generatedText.checkNotEmpty) {
      textEditingController.text = generatedText;
    }

    isLoading = false;
    mySetState();
  }

  Future<void> onNextTap() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    CoCreateContentAuthoringModel coCreateContentAuthoringModel = widget.argument.coCreateContentAuthoringModel;
    PodcastContentModel podcastContentModel = coCreateContentAuthoringModel.podcastContentModel ??= PodcastContentModel();

    podcastContentModel.audioTranscript = textEditingController.text.trim();
    podcastContentModel.promptText = promptEditingController.text.trim();

    dynamic value = await NavigationController.navigateToTextToAudioGenerateWithAIScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: TextToAudioGenerateWithAIScreenNavigationArgument(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
    );

    if (value == true) {
      Navigator.pop(context, true);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
    generateScriptedText(text: widget.argument.coCreateContentAuthoringModel.title);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppConfigurations().commonAppBar(
        title: "Text to Audio",
        actions: [
          InkWell(
            onTap: () {
              showBottomSheetDialog();
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          getTitleTextFormField(),
                        ],
                      ),
                      const SizedBox(height: 10),

                      isRegenerateTap
                          ? Stack(
                              children: [
                                getPromptTextFormField(),
                                Positioned(
                                  bottom: promptEditingController.text.trim().checkEmpty ? 20 : 0.0, // Adjust positioning as needed
                                  right: promptEditingController.text.trim().checkEmpty ? 0 : 0.0,
                                  child: InkWell(
                                    onTap: () async {
                                      if (!(_formKey.currentState?.validate() ?? false)) return;

                                      await generateScriptedText(text: promptEditingController.text.trim());
                                      promptEditingController.clear();
                                      isRegenerateTap = false;
                                      mySetState();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: themeData.primaryColor, shape: BoxShape.circle),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
                                        child: Icon(
                                          Icons.send,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                      // const SizedBox(height: 10,),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  onNextTap();
                },
                text: "Next",
                fontColor: themeData.colorScheme.onPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  //region getTitleTextFormField
  Widget getTitleTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter script text";
        }
        return null;
      },
      isMandatory: false,
      minLines: 20,
      maxLines: 20,
      isShowIcon: false,
      controller: textEditingController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Enter Script Text..",
    );
  }

  //endregion
  //
  // region getPromptTextFormField
  Widget getPromptTextFormField() {
    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Styles.borderColor)),
      child: getTexFormField(
        validator: (String? val) {
          if (val == null || val.isEmpty) {
            return "Please enter prompt";
          }
          return null;
        },
        isMandatory: false,
        minLines: 5,
        maxLines: 5,
        isShowIcon: false,
        controller: promptEditingController,
        iconUrl: "assets/catalog/title.png",
        labelText: "Write prompt here....",
        // borderColor: Colors.transparent,
      ),
    );
  }

  //endregion

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  //Supporting Widgets
  //region textFieldView
  Widget getTexFormField({
    TextEditingController? controller,
    String iconUrl = "",
    String? Function(String?)? validator,
    String labelText = "Label",
    Widget? suffixWidget,
    required bool isMandatory,
    bool isShowIcon = true,
    int? minLines,
    int? maxLines,
    double iconHeight = 15,
    double iconWidth = 15,
    Color? borderColor,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      borderColor: borderColor,
      enabledBorderColor: borderColor,
      focusColor: borderColor,
      isHintText: false,
      prefixWidget: isShowIcon
          ? iconUrl.isNotEmpty
              ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
              : const Icon(
                  FontAwesomeIcons.globe,
                  size: 15,
                  color: Colors.grey,
                )
          : null,
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

class TextToAudioGenerateWithAIScreen extends StatefulWidget {
  static const String routeName = "/TextToAudioGenerateWithAIScreen";

  final TextToAudioGenerateWithAIScreenNavigationArgument argument;

  const TextToAudioGenerateWithAIScreen({
    super.key,
    required this.argument,
  });

  @override
  State<TextToAudioGenerateWithAIScreen> createState() => _TextToAudioGenerateWithAIScreenState();
}

class _TextToAudioGenerateWithAIScreenState extends State<TextToAudioGenerateWithAIScreen> with MySafeState {
  double selectedVoiceSpeed = 1;
  String? selectedTone, selectedGender;
  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  LanguageModel? selectedLanguage;
  LanguageVoiceModel? selectedVoiceModel;
  SpeakingStyleModel? speakingStyleModel;
  bool isLoading = false;
  TextEditingController languageSearchController = TextEditingController();

  List<LanguageModel> languageList = [];
  List<LanguageVoiceModel> languageVoiceList = [], filteredVoiceList = [];
  List<String> toneList = [];
  late Future? future;

  List<AudioModel> genderAudioList = [
    AudioModel(name: "Rose Marriot", gender: "Female", language: "British"),
    AudioModel(name: "Sara", gender: "Female", language: "American"),
    AudioModel(name: "Ariana", gender: "Female", language: "British"),
    AudioModel(name: "Modelyn", gender: "Female", language: "American"),
    AudioModel(name: "Sarge", gender: "Female", language: "British"),
    AudioModel(name: "Amelia", gender: "Female", language: "British"),
    AudioModel(name: "Robert", gender: "Male", language: "British"),
    AudioModel(name: "Michale", gender: "Male", language: "British"),
    AudioModel(name: "John", gender: "Male", language: "British"),
  ];

  Future<void> initializeData() async {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);
    if (widget.argument.isEdit) {
      PodcastContentModel podcastContentModel = widget.argument.coCreateContentAuthoringModel.podcastContentModel!;
      languageList = coCreateKnowledgeProvider.languageList.getList();
      selectedLanguage = languageList.where((element) => podcastContentModel.selectedLanguage?.languageCode == element.languageCode).toList().first;
      await getLanguageVoiceList();
      await getSpeakingStyleList();
      languageVoiceList = coCreateKnowledgeProvider.languageVoiceList.getList();
      // element.voiceName == podcastContentModel.selectedVoiceModel?.voiceName)
      MyPrint.printOnConsole("languageVoiceList: ${languageVoiceList.length}");

      List<LanguageVoiceModel> lagModel = languageVoiceList.where((element) {
        MyPrint.printOnConsole("podcastContentModel.selectedVoiceModel?.voiceName: ${podcastContentModel.selectedVoiceModel?.toMap()} : element.voiceName ${element.voiceName}");
        return podcastContentModel.selectedVoiceModel?.voiceName == element.voiceName;
      }).toList();
      // MyPrint.printOnConsole("podcastContentModel.selectedVoiceModel:${languageVoiceList.length} ${languageVoiceList.where((element) {
      //   return true;
      // })}");
      selectedGender = podcastContentModel.selectedGender;
      selectedLanguage = languageList.where((element) => podcastContentModel.selectedLanguage?.languageCode == element.languageCode).toList().first;
      selectedVoiceModel = languageVoiceList.where((element) => podcastContentModel.selectedVoiceModel?.voiceName == element.voiceName).toList().first;
      filteredVoiceList = languageVoiceList.where((element) => element.gender == selectedGender).toList();
      speakingStyleModel = podcastContentModel.speakingStyleModel;
      toneList = speakingStyleModel?.voiceStyle ?? [];
      selectedTone = podcastContentModel.voiceTone;

      // await getLanguageVoiceList();
      // await getSpeakingStyleList();
      mySetState();
    } else {
      future = getData();
    }
  }

  Future<void> getData() async {
    isLoading = true;
    mySetState();
    bool isSuccess = await coCreateKnowledgeController.getLanguageList();
    if (isSuccess) {
      languageList = coCreateKnowledgeProvider.languageList.getList();
    }
    isLoading = false;
    mySetState();
  }

  Future<void> getLanguageVoiceList() async {
    if (selectedLanguage == null) return;
    isLoading = true;
    mySetState();
    bool isSuccess = await coCreateKnowledgeController.getLanguageVoiceList(selectedLanguage!.languageCode);
    if (isSuccess) {
      languageVoiceList = coCreateKnowledgeProvider.languageVoiceList.getList();
    }

    isLoading = false;
    mySetState();
  }

  Future<void> getSpeakingStyleList() async {
    if (selectedVoiceModel == null) return;
    isLoading = true;
    mySetState();
    bool isSuccess = await coCreateKnowledgeController.getSpeakingStyle(selectedVoiceModel!.voiceName);
    if (isSuccess) {
      speakingStyleModel = coCreateKnowledgeProvider.speakingStyleModel.get();
      toneList = speakingStyleModel?.voiceStyle ?? [];
      mySetState();
    }
    isLoading = false;
    mySetState();
  }

  Future<void> onGenerateWithAITap() async {
    CoCreateContentAuthoringModel coCreateContentAuthoringModel = widget.argument.coCreateContentAuthoringModel;
    PodcastContentModel podcastContentModel = coCreateContentAuthoringModel.podcastContentModel ??= PodcastContentModel();

    podcastContentModel.voiceSpeed = selectedVoiceSpeed;
    podcastContentModel.voiceTone = selectedTone ?? "";
    podcastContentModel.voiceName = selectedVoiceModel?.voiceName ?? "";
    podcastContentModel.voiceLanguage = selectedLanguage?.languageCode ?? "";
    podcastContentModel.selectedGender = selectedGender ?? "";
    podcastContentModel.selectedLanguage = selectedLanguage;
    podcastContentModel.selectedVoiceModel = selectedVoiceModel;
    podcastContentModel.speakingStyleModel = speakingStyleModel;

    coCreateContentAuthoringModel.podcastContentModel = podcastContentModel;
    dynamic value = await NavigationController.navigateToPodcastPreviewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: PodcastPreviewScreenNavigationArgument(coCreateContentAuthoringModel: coCreateContentAuthoringModel, isRetakeRequired: false, isFromTextToAudio: true),
    );

    if (value == true) {
      Navigator.pop(context, true);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: "Text to Audio",
      ),
      body: widget.argument.isEdit
          ? getMainBody()
          : FutureBuilder(
              future: future,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.done) {
                  return getMainBody();
                } else {
                  return CommonLoader();
                }
              }),
    );
  }

  Widget getMainBody() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            getVoiceSpeedSlider(),
            const SizedBox(
              height: 20,
            ),
            getLanguageListDropDown(),
            const SizedBox(
              height: 20,
            ),
            CommonBorderDropdown2<String?>(
              isExpanded: true,
              items: const ["Male", "Female"],
              onChanged: (String? val) {
                selectedGender = val;
                filteredVoiceList = languageVoiceList.where((element) => element.gender == selectedGender).toList();
                mySetState();
              },
              value: selectedGender,
              hintText: "Select gender",
            ),
            const SizedBox(
              height: 20,
            ),
            getLanguageVoiceListDropDown(),
            const SizedBox(
              height: 20,
            ),
            if (toneList.checkNotEmpty)
              CommonBorderDropdown2<String?>(
                isExpanded: true,
                items: toneList,
                onChanged: (String? val) {
                  selectedTone = val;
                  mySetState();
                },
                value: selectedTone,
                hintText: "Tone",
              ),
            const SizedBox(
              height: 20,
            ),
            // getGenderAudioList(),
            // SizedBox()
            const Spacer(),
            CommonButton(
              minWidth: double.infinity,
              onPressed: () {
                onGenerateWithAITap();
              },
              text: "Generate with AI",
              fontColor: themeData.colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }

  Widget getVoiceSpeedSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Voice speed",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 20,
          child: Slider(
            min: 0,
            max: 3,
            value: selectedVoiceSpeed,
            divisions: 3,
            inactiveColor: Colors.grey,
            label: "",
            onChanged: (double? value) {
              selectedVoiceSpeed = value ?? 0;
              mySetState();
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0x",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                "1x",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                "2x",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                "3x",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getLanguageListDropDown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<LanguageModel>(
          value: selectedLanguage,
          isExpanded: true,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              languageSearchController.clear();
            }
          },
          dropdownSearchData: DropdownSearchData(
              searchController: languageSearchController,
              searchInnerWidget: Container(
                height: 50,
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: languageSearchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for an language...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchInnerWidgetHeight: 50,
              searchMatchFn: (DropdownMenuItem<LanguageModel> avatar, String val) {
                return avatar.value?.language.toLowerCase().contains(val.toLowerCase()) ?? false;
              }),
          onChanged: (LanguageModel? language) async {
            if (language == null) return;
            selectedLanguage = language;

            await getLanguageVoiceList();
            selectedGender = null;
            selectedVoiceModel = null;
            selectedTone = null;
            speakingStyleModel = null;
            mySetState();
          },
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: const Text(
            "Select Language",
          ),
          items: languageList.map<DropdownMenuItem<LanguageModel>>(
            (LanguageModel value) {
              return DropdownMenuItem<LanguageModel>(
                value: value,
                child: Text(
                  value.language,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget getLanguageVoiceListDropDown() {
    if (filteredVoiceList.checkEmpty) return SizedBox();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<LanguageVoiceModel>(
          value: selectedVoiceModel,
          isExpanded: true,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              languageSearchController.clear();
            }
          },
          dropdownSearchData: DropdownSearchData(
              searchController: languageSearchController,
              searchInnerWidget: Container(
                height: 50,
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: languageSearchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for an voiceName...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchInnerWidgetHeight: 50,
              searchMatchFn: (DropdownMenuItem<LanguageVoiceModel> avatar, String val) {
                return avatar.value?.voiceName.toLowerCase().contains(val.toLowerCase()) ?? false;
              }),
          onChanged: (LanguageVoiceModel? avatar) async {
            if (avatar == null) return;
            selectedVoiceModel = avatar;
            await getSpeakingStyleList();
            mySetState();
          },
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: const Text(
            "Select Voice",
          ),
          items: filteredVoiceList.map<DropdownMenuItem<LanguageVoiceModel>>(
            (LanguageVoiceModel value) {
              return DropdownMenuItem<LanguageVoiceModel>(
                value: value,
                child: Text(
                  value.displayName,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

// Widget getGenderAudioList() {
//   if (selectedVoice == null) return const SizedBox();
//   List<AudioModel> list = [];
//   if (selectedVoice == "Male") {
//     list = genderAudioList.where((element) => element.gender == selectedVoice).toList();
//   } else {
//     list = genderAudioList.where((element) => element.gender == selectedVoice).toList();
//   }
//
//   return Container(
//     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Styles.borderColor)),
//     child: ListView.builder(
//       shrinkWrap: true,
//       itemCount: list.length,
//       itemBuilder: (BuildContext context, int index) {
//         AudioModel audioModel = list[index];
//
//         return InkWell(
//           onTap: () {
//             audioModel.isPlay = !audioModel.isPlay;
//             mySetState();
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(color: !audioModel.isPlay ? Colors.grey[300] : themeData.primaryColor, shape: BoxShape.circle),
//                   child: Icon(
//                     audioModel.isPlay ? Icons.pause : Icons.play_arrow,
//                     color: audioModel.isPlay ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                     child: Text(
//                   audioModel.name,
//                   textAlign: TextAlign.start,
//                 )),
//                 Expanded(child: Text(audioModel.language, textAlign: TextAlign.center)),
//                 const Expanded(child: Text("English", textAlign: TextAlign.center)),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
}

class CommonBorderDropdown2<T> extends StatefulWidget {
  final List<T> items;
  final T value;
  final ValueChanged<T?> onChanged;
  final IconData trailingIcon;
  final String? hintText;
  final bool isExpanded;

  const CommonBorderDropdown2({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.isExpanded = false,
    this.trailingIcon = Icons.arrow_drop_down,
  });

  @override
  _CommonBorderDropdown2State<T> createState() => _CommonBorderDropdown2State<T>();
}

class _CommonBorderDropdown2State<T> extends State<CommonBorderDropdown2<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.borderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0).copyWith(left: 17),
          value: widget.value,
          isExpanded: widget.isExpanded,
          isDense: true,
          icon: Icon(widget.trailingIcon),
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: widget.hintText == null
              ? null
              : Text(
                  widget.hintText ?? "",
                ),
          items: widget.items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$value',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AudioModel {
  final String name;
  final String language;
  final String gender;
  bool isPlay;

  AudioModel({this.name = "", this.language = "", this.gender = "Male", this.isPlay = false});
}

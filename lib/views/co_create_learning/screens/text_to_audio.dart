import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  TextEditingController textEditingController = TextEditingController();
  TextEditingController promptEditingController = TextEditingController();

  bool isRegenerateTap = false, onNextTap = false;

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
      body: onNextTap ? TextToAudioGenerateWithAIScreen() : mainWidget(),
    );
  }

  Widget mainWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      getTitleTextFormField(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  isRegenerateTap ? getPromptTextFormField() : const SizedBox(),
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
              onNextTap = true;
              mySetState();
            },
            text: "Next",
            fontColor: themeData.colorScheme.onPrimary,
          )
        ],
      ),
    );
  }

  //region getTitleTextFormField
  Widget getTitleTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      isMandatory: false,
      minLines: 20,
      maxLines: 20,
      isShowIcon: false,
      controller: textEditingController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Enter text...",
    );
  }

  //endregion
  //
  // region getPromptTextFormField
  Widget getPromptTextFormField() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Styles.borderColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
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
                borderColor: Colors.transparent),
          ),
          InkWell(
            onTap: () {
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
          )
        ],
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
      isHintText: true,
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
  const TextToAudioGenerateWithAIScreen({super.key});

  @override
  State<TextToAudioGenerateWithAIScreen> createState() => _TextToAudioGenerateWithAIScreenState();
}

class _TextToAudioGenerateWithAIScreenState extends State<TextToAudioGenerateWithAIScreen> with MySafeState {
  String? selectedVoiceSpeed, selectedTone, selectedVoice;

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

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      body: getMainBody(),
    );
  }

  Widget getMainBody() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          CommonBorderDropdown2<String?>(
            isExpanded: true,
            items: const ["1x", "2x", "3x"],
            onChanged: (String? val) {
              selectedVoiceSpeed = val;
              mySetState();
            },
            value: selectedVoiceSpeed,
            hintText: "Voice Speed",
          ),
          SizedBox(
            height: 20,
          ),
          CommonBorderDropdown2<String?>(
            isExpanded: true,
            items: const [
              "Neutral Tone",
              "Confident Tone",
              "Friendly Tone",
              "Mysterious Tone",
              "Dramatic Tone",
              "Energetic Tone",
              "Relaxing Tone",
            ],
            onChanged: (String? val) {
              selectedTone = val;
              mySetState();
            },
            value: selectedTone,
            hintText: "Tone",
          ),
          SizedBox(
            height: 20,
          ),
          CommonBorderDropdown2<String?>(
            isExpanded: true,
            items: const ["Male", "Female"],
            onChanged: (String? val) {
              selectedVoice = val;
              mySetState();
            },
            value: selectedVoice,
            hintText: "Voice",
          ),
          getGenderAudioList(),
          // SizedBox()
          Spacer(),
          CommonButton(
            minWidth: double.infinity,
            onPressed: () {
              NavigationController.navigateToPodcastPreviewScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                  argument: PodcastPreviewScreenNavigationArgument(model: CourseDTOModel(), isRetakeRequired: false));
            },
            text: "Generate with AI",
            fontColor: themeData.colorScheme.onPrimary,
          )
        ],
      ),
    );
  }

  Widget getGenderAudioList() {
    if (selectedVoice == null) return SizedBox();
    List<AudioModel> list = [];
    if (selectedVoice == "Male") {
      list = genderAudioList.where((element) => element.gender == selectedVoice).toList();
    } else {
      list = genderAudioList.where((element) => element.gender == selectedVoice).toList();
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Styles.borderColor)),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          AudioModel audioModel = list[index];

          return InkWell(
            onTap: () {
              audioModel.isPlay = !audioModel.isPlay;
              mySetState();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: !audioModel.isPlay ? Colors.grey[300] : themeData.primaryColor, shape: BoxShape.circle),
                    child: Icon(
                      audioModel.isPlay ? Icons.pause : Icons.play_arrow,
                      color: audioModel.isPlay ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    audioModel.name,
                    textAlign: TextAlign.start,
                  )),
                  Expanded(child: Text(audioModel.language, textAlign: TextAlign.center)),
                  Expanded(child: Text("English", textAlign: TextAlign.center)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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
    this.trailingIcon = Icons.keyboard_arrow_down_outlined,
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
          value: widget.value,
          isExpanded: widget.isExpanded,
          isDense: true,
          icon: Icon(widget.trailingIcon),
          onChanged: widget.onChanged,
          style: TextStyle(
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
                    style: TextStyle(color: Colors.black),
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

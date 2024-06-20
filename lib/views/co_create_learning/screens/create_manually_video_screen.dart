import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_border_dropdown.dart';

class CreateManuallyVideoScreen extends StatefulWidget {
  static const String routeName = "/createManuallyVideoScreen";

  final CreateManuallyVideoScreenNavigationArgument arguments;

  const CreateManuallyVideoScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<CreateManuallyVideoScreen> createState() => _CreateManuallyVideoScreenState();
}

class _CreateManuallyVideoScreenState extends State<CreateManuallyVideoScreen> with MySafeState {
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  late CoCreateKnowledgeController coCreateKnowledgeController;
  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  bool isLoading = false;
  late Future future;

  List<String> avatarList = ["Select Avatar", "Alex", "Bridget", "Christina", "Jack"];
  List<String> videoBackground = ["off_white", "warm_white", "light_pink", "soft_pink", "light_blue"];
  List<String> avatarSpeech = ["Afrikaans", "Amharic", "Amharic", "Arabic (AE)", "English"];
  List<String> avatarType = ["FullBody", "Circle"];
  List<String> avatarPosition = ["Left", "Center", "Right"];

  List<Avatars> avatarsList = [];
  List<BackgroundColorModel> backgroundColorModelList = [];
  List<AvtarVoiceModel> avatarVoiceList = [];

  String? selectedAvatar, selectedVideoBackground, selectedAvatarSpeech, selectedAvatarType, selectedAvatarPosition;

  Avatars? selectedAvatara;
  BackgroundColorModel? selectedBackgroundColorModel;
  AvtarVoiceModel? selectedAvtarVoiceModel;

  TextEditingController avatarSearchController = TextEditingController();
  TextEditingController backGroundSearchController = TextEditingController();
  TextEditingController avatarVoiceSearchController = TextEditingController();

  Future<void> getData() async {
    List<Future> futures = [
      coCreateKnowledgeController.getAllAvtarList(),
      coCreateKnowledgeController.getBackgroundColorList(),
      coCreateKnowledgeController.getAvatarVoiceList(),
    ];
    await Future.wait(futures);
  }

  Future<void> onGenerateTap() async {
    VideoContentModel videoContentModel = VideoContentModel(
        avatarId: selectedAvatara?.actorID ?? "",
        voice: selectedAvtarVoiceModel?.voiceID ?? "",
        background: selectedBackgroundColorModel?.backgrounds.first ?? "",
        horizontalAlign: selectedAvatarType ?? "",
        style: selectedAvatarPosition ?? "");
    widget.arguments.coCreateContentAuthoringModel.videoContentModel = videoContentModel;

    dynamic value = await NavigationController.navigateToGenerateWithAiVideoScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: GenerateWithAiVideoScreenNavigationArgument(
        coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
      ),
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
    future = getData();
    MyPrint.printOnConsole("Hello 2222");
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: AppStrings.generateWithAI,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CommonButton(
          minWidth: double.infinity,
          onPressed: () {
            onGenerateTap();
          },
          text: AppStrings.generateWithAI,
          fontColor: themeData.colorScheme.onPrimary,
        ),
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getMainBody();
            } else {
              return const CommonLoader();
            }
          },
        ),
      ),
    );
  }

  Widget getMainBody() {
    return Consumer<CoCreateKnowledgeProvider>(
      builder: (context, CoCreateKnowledgeProvider provider, _) {
        avatarsList = provider.avatarList.getList();
        backgroundColorModelList = provider.backgroundColorList.getList();
        avatarVoiceList = provider.avatarVoiceList.getList();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getAvtarDropDown(),
                    const SizedBox(height: 20),
                    getVideoBackgroundDropDown(),
                    const SizedBox(height: 20),
                    getAvatarSpeechDropdown(),
                    const SizedBox(height: 20),
                    getAvatarTypeDropdown(),
                    const SizedBox(height: 20),
                    getAvatarPosition(),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getAvtarDropDown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Avatars>(
          // padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 13),
          value: selectedAvatara,
          isExpanded: true,
          // icon: const Icon(
          //   Icons.keyboard_arrow_down_outlined,
          // ),

          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              avatarSearchController.clear();
            }
          },

          dropdownSearchData: DropdownSearchData(
              searchController: avatarSearchController,
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
                  controller: avatarSearchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for an avatar...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchInnerWidgetHeight: 50,
              searchMatchFn: (DropdownMenuItem<Avatars> avatar, String val) {
                return avatar.value?.name.contains(val) ?? false;
              }),
          onChanged: (Avatars? avatar) {
            if (avatar == null) return;
            selectedAvatara = avatar;
            mySetState();
          },
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: const Text(
            "Select Avatar",
          ),
          items: avatarsList.map<DropdownMenuItem<Avatars>>(
            (Avatars value) {
              return DropdownMenuItem<Avatars>(
                value: value,
                child: Text(
                  value.name,
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

  Widget getVideoBackgroundDropDown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<BackgroundColorModel>(
          // padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 13),
          value: selectedBackgroundColorModel,
          isExpanded: true,
          // icon: const Icon(
          //   Icons.keyboard_arrow_down_outlined,
          // ),
          onChanged: (BackgroundColorModel? avatar) {
            if (avatar == null) return;
            selectedBackgroundColorModel = avatar;
            mySetState();
          },
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: const Text(
            "Select Background",
          ),
          items: backgroundColorModelList.map<DropdownMenuItem<BackgroundColorModel>>(
            (BackgroundColorModel value) {
              return DropdownMenuItem<BackgroundColorModel>(
                value: value,
                child: Text(
                  value.bgGroup,
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

  Widget getAvatarSpeechDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<AvtarVoiceModel>(
          // padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 13),
          value: selectedAvtarVoiceModel,
          isExpanded: true,
          // icon: const Icon(
          //   Icons.keyboard_arrow_down_outlined,
          // ),

          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              avatarVoiceSearchController.clear();
            }
          },

          dropdownSearchData: DropdownSearchData(
              searchController: avatarVoiceSearchController,
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
                  controller: avatarVoiceSearchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for an avatar voice...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchInnerWidgetHeight: 50,
              searchMatchFn: (DropdownMenuItem<AvtarVoiceModel> avatar, String val) {
                return avatar.value?.language.contains(val) ?? false;
              }),
          onChanged: (AvtarVoiceModel? avatar) {
            if (avatar == null) return;
            selectedAvtarVoiceModel = avatar;
            mySetState();
          },
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: const Text(
            "Select Avatar Speech",
          ),
          items: avatarVoiceList.map<DropdownMenuItem<AvtarVoiceModel>>(
            (AvtarVoiceModel value) {
              return DropdownMenuItem<AvtarVoiceModel>(
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

  Widget getAvatarTypeDropdown() {
    return getCommonDropDown(
      list: avatarType,
      value: selectedAvatarType,
      hintText: "Avatar Type",
      onChanged: (val) {
        selectedAvatarType = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getAvatarPosition() {
    return getCommonDropDown(
      list: avatarPosition,
      value: selectedAvatarPosition,
      hintText: "Avatar Position",
      onChanged: (val) {
        selectedAvatarPosition = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getCommonDropDown({
    required String? value,
    required List<String> list,
    required ValueChanged<String?> onChanged,
    required String hintText,
    double iconHeight = 15,
    double iconWidth = 15,
    String iconUrl = "",
  }) {
    return CommonBorderDropdown<String>(
      isExpanded: true,
      isDense: false,
      items: list,
      value: value,
      hintText: hintText,
      onChanged: onChanged,
    );
  }
}

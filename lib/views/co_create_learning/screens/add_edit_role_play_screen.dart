import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_border_dropdown.dart';
import '../../common/components/common_text_form_field.dart';

class AddEditRolePlayScreen extends StatefulWidget {
  static const String routeName = "/AddEditRolePlayScreen";

  final AddEditRolePlayScreenNavigationArgument arguments;

  const AddEditRolePlayScreen({super.key, required this.arguments});

  @override
  State<AddEditRolePlayScreen> createState() => _AddEditRolePlayScreenState();
}

class _AddEditRolePlayScreenState extends State<AddEditRolePlayScreen> with MySafeState {
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  TextEditingController learningObjective = TextEditingController();
  TextEditingController simulatedParticipantRoleDescriptionController = TextEditingController();
  TextEditingController learnerRoleDescriptionController = TextEditingController();
  TextEditingController scenarioDescriptionController = TextEditingController();
  TextEditingController numberOfMessagesController = TextEditingController();
  TextEditingController evaluatorDescriptionController = TextEditingController();
  TextEditingController evaluationCriteriaDescriptionController = TextEditingController();
  TextEditingController eolePlayCompletionMessageController = TextEditingController();
  String? selectedSimulateTone, selectedEvaluationFeedback;
  bool isSimulatedParticipantAvatar = false, isScore = false;
  String thumbNailName = "";
  Uint8List? thumbNailBytes;

  void initialize() {
    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    RoleplayContentModel? roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel;
    if (roleplayContentModel != null) {
      learningObjective.text = roleplayContentModel.learningObjective;
      simulatedParticipantRoleDescriptionController.text = roleplayContentModel.participantRoleDescription;
      selectedSimulateTone = roleplayContentModel.participantTone.isNotEmpty ? roleplayContentModel.participantTone : null;
      isSimulatedParticipantAvatar = false;
      thumbNailBytes = null;
      learnerRoleDescriptionController.text = roleplayContentModel.learnerRoleDescription;
      scenarioDescriptionController.text = roleplayContentModel.scenarioDescription;
      numberOfMessagesController.text = roleplayContentModel.messageCount.toString();
      evaluatorDescriptionController.text = roleplayContentModel.evaluatorDescription;
      evaluationCriteriaDescriptionController.text = roleplayContentModel.evaluationCriteriaDescription;
      selectedEvaluationFeedback = roleplayContentModel.evaluationFeedbackMechanism.isNotEmpty ? roleplayContentModel.evaluationFeedbackMechanism : null;
      eolePlayCompletionMessageController.text = roleplayContentModel.roleplayCompletionMessage;
      isScore = roleplayContentModel.isScore;
    }

    if (!coCreateContentAuthoringModel.isEdit) initializeDataForNewContent();
  }

  void initializeDataForNewContent() {
    learningObjective.text =
        "The objective of this role play is to develop and enhance the learner's skills in effectively resolving customer queries. Learners will practice active listening, clear communication, problem-solving, empathy, and professionalism in handling various customer issues.";
    simulatedParticipantRoleDescriptionController.text =
        "The participant will observe the role play to assess the evaluator's performance. The participant should have experience in customer service and be familiar with the company's policies and procedures.";
    selectedSimulateTone = "Neutral Tone";
    isSimulatedParticipantAvatar = false;
    thumbNailBytes = null;
    learnerRoleDescriptionController.text =
        "The participant will observe the role play to assess the evaluator's performance. The participant should have experience in customer service and be familiar with the company's policies and procedures.";
    scenarioDescriptionController.text =
        "Jamie Roberts, a loyal customer, contacts Alex Parker, the customer service representative, to resolve an issue with a damaged product. Jamie is frustrated as this is their second attempt to resolve the issue. Alex needs to handle the situation delicately, ensuring Jamie leaves the interaction satisfied and confident in the company's customer service.";
    numberOfMessagesController.text = "";
    evaluatorDescriptionController.text =
        "The evaluator will observe the role play to assess the learner's performance. The evaluator should have experience in customer service and be familiar with the company's policies and procedures.";
    evaluationCriteriaDescriptionController.text =
        "The evaluator will assess the learner based on the following criteria:Greeting and Introduction, Active Listening, Empathy and Apology, Clarification and Information Gathering etc";
    selectedEvaluationFeedback = "After each learner's response";
    eolePlayCompletionMessageController.text = "Thank you for your assistance in resolving the issue with my order";
    isScore = false;
  }

  MaterialStateProperty<Color> getThumbColor() {
    return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Color when the switch is disabled
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.white; // Color when the switch is selected (on)
      }
      return Colors.white; // Default color
    });
  }

  Future<String> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      thumbNailBytes = file.bytes;
    } else {
      fileName = "";
      thumbNailBytes = null;
    }
    return fileName;
  }

  void onGenerateTap() {
    RoleplayContentModel roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel ?? RoleplayContentModel();

    roleplayContentModel.learningObjective = learningObjective.text;
    roleplayContentModel.participantRoleDescription = simulatedParticipantRoleDescriptionController.text;
    roleplayContentModel.participantTone = selectedSimulateTone ?? "";
    roleplayContentModel.learnerRoleDescription = learnerRoleDescriptionController.text;
    roleplayContentModel.scenarioDescription = scenarioDescriptionController.text;
    roleplayContentModel.messageCount = int.tryParse(numberOfMessagesController.text) ?? 0;
    roleplayContentModel.evaluatorDescription = evaluatorDescriptionController.text;
    roleplayContentModel.evaluationCriteriaDescription = evaluationCriteriaDescriptionController.text;
    roleplayContentModel.evaluationFeedbackMechanism = selectedEvaluationFeedback ?? "";
    roleplayContentModel.roleplayCompletionMessage = eolePlayCompletionMessageController.text;
    roleplayContentModel.isScore = isScore;

    coCreateContentAuthoringModel.roleplayContentModel = roleplayContentModel;

    NavigationController.navigateToRolePlayPreviewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: RolePlayPreviewScreenNavigationArguments(coCreateContentAuthoringModel: coCreateContentAuthoringModel),
    );
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
        appBar: AppConfigurations().commonAppBar(
          title: "Generate Roleplay",
        ),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: getMainBody(),
        ),
      ),
    );
  }

  Widget getMainBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            getLearningObjectiveTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getSimulatedParticipantRoleDescriptionTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getSimulateToneTypeDropDown(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: getCommonSwitch(
                    value: isSimulatedParticipantAvatar,
                    label: "Simulated Participant Avatar",
                    onChanged: (bool val) {
                      isSimulatedParticipantAvatar = val;
                      mySetState();
                    },
                  ),
                ),
                getAvatarWidget()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            getLearnerRoleDescriptionControllerTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getScenarioDescriptionTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getNumberOfMessagesTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getEvaluatorDescriptionTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getEvaluationCriteriaDescriptionTextFormField(),
            const SizedBox(
              height: 20,
            ),
            getEvaluationFeedbackMechanismsDropDown(),
            const SizedBox(
              height: 20,
            ),
            getRolePlayCompletionMessageTextFormField(),
            const SizedBox(
              height: 10,
            ),
            getCommonSwitch(
              value: isScore,
              label: "Score",
              onChanged: (bool val) {
                isScore = val;
                mySetState();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CommonButton(
              onPressed: () {
                onGenerateTap();
              },
              text: "Generate With AI",
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget getLearningObjectiveTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: learningObjective,
      labelText: "Learning Objective",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getSimulatedParticipantRoleDescriptionTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: simulatedParticipantRoleDescriptionController,
      labelText: "Simulated Participant Role Description",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getLearnerRoleDescriptionControllerTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: learnerRoleDescriptionController,
      labelText: "Learner Role Description",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getScenarioDescriptionTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: scenarioDescriptionController,
      labelText: "Scenario Description",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getNumberOfMessagesTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: numberOfMessagesController,
      labelText: "Number of Messages",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/cocreate/commonText.png",
      maxLines: 1,
      minLines: 1,
    );
  }

  Widget getEvaluatorDescriptionTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: evaluatorDescriptionController,
      labelText: "Evaluator Description",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getEvaluationCriteriaDescriptionTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: evaluationCriteriaDescriptionController,
      labelText: "Evaluation Criteria Description",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getRolePlayCompletionMessageTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: eolePlayCompletionMessageController,
      labelText: "Role Play Completion Message",
      keyBoardType: TextInputType.multiline,
      iconUrl: "assets/catalog/imageDescription.png",
      maxLines: 5,
      minLines: 5,
    );
  }

  Widget getSimulateToneTypeDropDown() {
    return getCommonDropDown(
      list: const ["Neutral Tone", "Confident Tone", "Friendly Tone", "Mysterious Tone"],
      value: selectedSimulateTone,
      hintText: "Simulated Participant Tone",
      onChanged: (val) {
        selectedSimulateTone = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getEvaluationFeedbackMechanismsDropDown() {
    return getCommonDropDown(
      list: const ["After each learner's response", "After the dialog finishes"],
      value: selectedEvaluationFeedback,
      hintText: "Evaluation Feedback Mechanisms",
      onChanged: (val) {
        selectedEvaluationFeedback = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getAvatarWidget() {
    if (thumbNailBytes != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(
                thumbNailBytes!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              thumbNailBytes = null;
              thumbNailName = "";
              mySetState();
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  spreadRadius: 2,
                  blurRadius: 2,
                )
              ]),
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.clear,
                size: 10,
              ),
            ),
          )
        ],
      );
    }

    return InkWell(
      onTap: () async {
        await openFileExplorer(FileType.image, false);
        mySetState();
      },
      child: Row(
        children: [
          Icon(
            Icons.add,
            size: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Avatar")
        ],
      ),
    );
  }

  //region commonWidget
  Widget getCommonSwitch({final bool value = false, required ValueChanged<bool> onChanged, final String? label}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform.scale(
          scale: .75,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            applyTheme: true,
          ),
        ),
        if (label.checkNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(label ?? ""),
          ),
      ],
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
    return Container(
      padding: EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: getImageView(url: iconUrl, height: iconHeight, width: iconWidth),
          ),
          Expanded(
            child: CommonBorderDropdown<String>(
              isExpanded: true,
              items: list,
              value: value,
              hintText: hintText,
              onChanged: onChanged,
              borderColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget getTexFormField(
      {TextEditingController? controller,
      String iconUrl = "",
      String? Function(String?)? validator,
      String labelText = "Label",
      Widget? suffixWidget,
      required bool isMandatory,
      int? minLines,
      int? maxLines,
      bool showPrefixIcon = false,
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: getImageView(url: iconUrl, height: iconHeight, width: iconWidth),
          ),
          Expanded(
            child: CommonTextFormFieldWithLabel(
              controller: controller,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              label: isMandatory ? labelWithStar(labelText) : null,
              isHintText: true,
              labelText: isMandatory ? null : labelText,
              validator: validator,
              floatingLabelColor: Colors.black.withOpacity(.6),
              minLines: minLines,
              maxLines: maxLines,
              borderColor: Colors.transparent,
              enabledBorderColor: Colors.transparent,
              focusColor: Colors.transparent,
              borderWidth: 1,
              isOutlineInputBorder: true,
              keyboardType: keyBoardType,
              prefixWidget: showPrefixIcon
                  ? iconUrl.isNotEmpty
                      ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
                      : const Icon(
                          FontAwesomeIcons.globe,
                          size: 15,
                          color: Colors.grey,
                        )
                  : null,
              suffixWidget: suffixWidget,
            ),
          ),
        ],
      ),
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

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

//endregion
}

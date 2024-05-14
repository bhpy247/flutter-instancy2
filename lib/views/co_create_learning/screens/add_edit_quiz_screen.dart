import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_border_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditQuizScreen extends StatefulWidget {
  static const String routeName = "/AddEditQuizScreen";
  final AddEditQuizScreenArgument arguments;

  const AddEditQuizScreen({super.key, required this.arguments});

  @override
  State<AddEditQuizScreen> createState() => _AddEditQuizScreenState();
}

class _AddEditQuizScreenState extends State<AddEditQuizScreen> with MySafeState {
  bool isLoading = false;
  TextEditingController countController = TextEditingController();
  TextEditingController promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            appBar: AppConfigurations().commonAppBar(
              title: widget.arguments.courseDtoModel != null ? "Edit Quiz" : "Generate Quiz",
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 17,
                    ),
                    getPromptTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getCardCountTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getQuestionTypeDropDown(),
                    const SizedBox(
                      height: 17,
                    ),
                    getDifficultyLevelDropDown(),
                    const SizedBox(
                      height: 17,
                    ),
                    CommonButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        NavigationController.navigateToQuizScreen(
                          navigationOperationParameters: NavigationOperationParameters(
                            context: context,
                            navigationType: NavigationType.pushNamed,
                          ),
                        );
                      },
                      text: "Generate With AI",
                      fontColor: theme.colorScheme.onPrimary,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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

  Widget getCardCountTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: countController,
      labelText: "Question Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getPromptTextFormField() {
    return getTexFormField(
        isMandatory: false,
        showPrefixIcon: false,
        controller: promptController,
        labelText: "Write Prompt...",
        keyBoardType: TextInputType.text,
        iconUrl: "assets/catalog/imageDescription.png",
        maxLines: 7,
        minLines: 7);
  }

  String? selectedQuestionType, selectedDifficultyLevel;

  Widget getQuestionTypeDropDown() {
    return CommonBorderDropdown(
      isExpanded: true,
      items: const ["Multiple Choice", "True/False", "Both"],
      value: selectedQuestionType,
      hintText: "Question Type",
      onChanged: (val) {
        selectedQuestionType = val;
        mySetState();
      },
    );
  }

  Widget getDifficultyLevelDropDown() {
    return CommonBorderDropdown(
      isExpanded: true,
      items: const ["Hard", "Medium", "Easy"],
      value: selectedDifficultyLevel,
      hintText: "Difficulty Level",
      onChanged: (val) {
        selectedDifficultyLevel = val;
        mySetState();
      },
    );
  }

  //region textFieldView
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
    return CommonTextFormFieldWithLabel(
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.textFieldBorderColor,
      enabledBorderColor: Styles.textFieldBorderColor,
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

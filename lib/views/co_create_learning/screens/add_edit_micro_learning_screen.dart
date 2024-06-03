import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';

import '../../../configs/app_configurations.dart';
import '../../../configs/app_strings.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditMicroLearningScreen extends StatefulWidget {
  static const String routeName = "/AddEditMicroLearningScreen";

  final AddEditMicrolearningScreenNavigationArgument arguments;

  const AddEditMicroLearningScreen({super.key, required this.arguments});

  @override
  State<AddEditMicroLearningScreen> createState() => _AddEditMicroLearningScreenState();
}

class _AddEditMicroLearningScreenState extends State<AddEditMicroLearningScreen> with MySafeState {
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  TextEditingController pagesController = TextEditingController();
  TextEditingController wordsPerPageController = TextEditingController();
  bool isTextEnabled = true, isImageEnabled = true, isQuestionEnabled = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    coCreateContentAuthoringModel = CoCreateContentAuthoringModel();
  }

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
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  // onGenerateTap();
                },
                text: AppStrings.generateWithAI,
                fontColor: themeData.colorScheme.onPrimary,
              ),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: coCreateContentAuthoringModel.isEdit ? "Edit Microlearning" : "Create Microlearning",
            ),
            body: AppUIComponents.getBackGroundBordersRounded(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            getPageTextField(),

                            // getCardCountTextFormField(),
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
                              onChanged: (bool? val) => isTextEnabled = val ?? false,
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            getCommonSwitchWithTextWidget(
                              text: "Image",
                              isTrue: isImageEnabled,
                              onChanged: (bool? val) => isImageEnabled = val ?? false,
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            getCommonSwitchWithTextWidget(
                              text: "Question",
                              isTrue: isQuestionEnabled,
                              onChanged: (bool? val) => isQuestionEnabled = val ?? false,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPageTextField() {
    return getTexFormField(
      controller: pagesController,
      keyBoardType: TextInputType.number,
      isMandatory: false,
      labelText: "#Pages",
    );
  }

  Widget getWordsPerPageTextField() {
    return getTexFormField(
      controller: pagesController,
      keyBoardType: TextInputType.number,
      isMandatory: false,
      labelText: "#Words Per Page",
    );
  }

  Widget getCommonSwitchWithTextWidget({required String text, required bool isTrue, ValueChanged<bool?>? onChanged}) {
    return Row(
      children: [
        Text(text),
        SizedBox(
          width: 30,
        ),
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
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
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

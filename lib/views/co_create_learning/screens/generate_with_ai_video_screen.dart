import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_text_form_field.dart';

class GenerateWithAiVideoScreen extends StatefulWidget {
  static const String routeName = "/GenerateWithAiVideoScreen";

  const GenerateWithAiVideoScreen({super.key});

  @override
  State<GenerateWithAiVideoScreen> createState() => _GenerateWithAiVideoScreenState();
}

class _GenerateWithAiVideoScreenState extends State<GenerateWithAiVideoScreen> with MySafeState {
  TextEditingController promptController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController avatarController = TextEditingController();
  TextEditingController musicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: "Generate With AI",
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    return Container(
      child: Column(
        children: [
          getPromptTextFormField(),
          SizedBox(
            height: 10,
          ),
          getLengthTextFormField(),
          SizedBox(
            height: 10,
          ),
          getAvatarTextFormField(),
          SizedBox(
            height: 10,
          ),
          getMusicTextFormField(),
          SizedBox(
            height: 10,
          ),
          CommonButton(
            minWidth: double.infinity,
            onPressed: () {},
            text: "Generate With AI",
            fontColor: themeData.colorScheme.onPrimary,
          )
        ],
      ),
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
      minLines: 7,
    );
  }

  Widget getLengthTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: lengthController,
      labelText: "Length",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getAvatarTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: avatarController,
      labelText: "Avatar",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getMusicTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: musicController,
      labelText: "Music",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
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

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

//endregion
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/navigation/navigation_arguments.dart';
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
                    getCardCountTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    CommonButton(
                      minWidth: double.infinity,
                      onPressed: () {},
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
      prefixWidget: iconUrl.isNotEmpty
          ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
          : const Icon(
              FontAwesomeIcons.globe,
              size: 15,
              color: Colors.grey,
            ),
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

  Widget getCardCountTextFormField() {
    return getTexFormField(
      isMandatory: false,
      controller: countController,
      labelText: "Card Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }
}

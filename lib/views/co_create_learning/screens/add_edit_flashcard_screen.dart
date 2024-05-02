import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/flash_card_screen.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/components/common_text_form_field.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  static const String routeName = "/AddEditFlashcardScreen";

  final AddEditFlashcardScreenNavigationArguments arguments;

  const AddEditFlashcardScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> with MySafeState {
  bool isLoading = false;

  int cardCount = 0;
  Color? selectedColor;

  TextEditingController countController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController promptController = TextEditingController();
  List<String> skills = <String>[];
  String thumbnailImageUrl = "";

  List<QuestionAnswerModel> questionList = [];

  // Future<>
  static const Color guidePrimary = Color(0xFF6200EE);
  final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
  };

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: Colors.green,
      onColorChanged: (Color color) => setState(() => selectedColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        // ColorPickerType.both: false,
        // ColorPickerType.primary: true,
        // ColorPickerType.accent: true,
        // ColorPickerType.bw: false,
        // ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  void showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ColorPicker(
            // Use the screenPickerColor as start color.
            color: Colors.green,

            // Update the screenPickerColor using the callback.
            onColorChanged: (Color color) => setState(() => selectedColor = color),
            width: 44,
            height: 44,
            borderRadius: 22,
            heading: Text(
              'Select color',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subheading: Text(
              'Select color shade',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
            appBar: AppConfigurations().commonAppBar(
              title: widget.arguments.courseDTOModel != null ? "Edit Flashcard" : "Add Flashcard",
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
                    getDropDownViewTypeTile(text: selectedColor == null ? "Background Color" : "$selectedColor"),
                    const SizedBox(
                      height: 17,
                    ),
                    getUrlTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getPromptTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    CommonButton(
                      minWidth: double.infinity,
                      onPressed: () {},
                      text: "Generate With AI",
                      fontColor: themeData.colorScheme.onPrimary,
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

  Widget getDropDownViewTypeTile({
    required String text,
    void Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
      child: Theme(
        data: themeData.copyWith(dividerColor: Colors.transparent),
        child: ListTile(
          onTap: () {
            colorPickerDialog();
          },
          // key: expansionTile,
          // backgroundColor: const Color(0xffF8F8F8),
          // initiallyExpanded: isExpanded,
          // tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          title: Row(
            children: [
              getImageView(url: "assets/catalog/categories.png", height: 15, width: 15),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  text,
                  style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
                ),
              ),
            ],
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
      controller: countController,
      labelText: "Card Count",
      keyBoardType: TextInputType.number,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getUrlTextFormField() {
    return getTexFormField(
      isMandatory: false,
      controller: urlController,
      labelText: "Add Url",
    );
  }

  Widget getPromptTextFormField() {
    return getTexFormField(
      isMandatory: false,
      controller: promptController,
      labelText: "Write a prompt",
      minLines: 1,
      maxLines: 5,
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
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../common/components/common_border_dropdown.dart';
import '../../common/components/common_text_form_field.dart';

class ThumbnailDialog extends StatefulWidget {
  const ThumbnailDialog({super.key});

  @override
  State<ThumbnailDialog> createState() => _ThumbnailDialogState();
}

class _ThumbnailDialogState extends State<ThumbnailDialog> with MySafeState {
  Future<void> showDialogForGenerateThumbnailImage() async {
    dynamic val = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const GenerateThumbnailImageDialog();
      },
    );

    if (val is! Uint8List) return;

    Navigator.pop(context, val);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: themeData.colorScheme.onPrimary,
      surfaceTintColor: themeData.colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.clear,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Thumbnail Image",
            style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          getCommonTextIconContainer(
            iconPath: "Vector.png",
            text: "Upload Image",
            height: 20,
            width: 20,
            onTap: () {
              Navigator.pop(context, 1);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          getCommonTextIconContainer(
            iconPath: "aiIcon.png",
            text: AppStrings.generateWithAI,
            onTap: () async {
              await showDialogForGenerateThumbnailImage();
            },
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget getCommonTextIconContainer({required String iconPath, required String text, double height = 30, double width = 30, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
              color: Styles.borderColor,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                getImageView(
                  url: "assets/cocreate/$iconPath",
                  height: height,
                  width: width,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  style: themeData.textTheme.bodyMedium,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135, BoxFit? fit}) {
    return Image.asset(
      url,
      height: height,
      width: width,
      fit: fit,
    );
  }
}

class GenerateThumbnailImageDialog extends StatefulWidget {
  const GenerateThumbnailImageDialog({super.key});

  @override
  State<GenerateThumbnailImageDialog> createState() => _GenerateThumbnailImageDialogState();
}

class _GenerateThumbnailImageDialogState extends State<GenerateThumbnailImageDialog> with MySafeState {
  TextEditingController imageDescriptionController = TextEditingController();
  String? selectedResolution, selectedType;
  Uint8List? generatedImageBytes;
  bool isShowThumbnailImage = false;
  bool isImageLoading = false;

  Future<void> generateImagesFromAi() async {
    if (selectedResolution.checkEmpty) {
      return;
    } else if (selectedType.checkEmpty) {
      return;
    } else if (imageDescriptionController.text.trim().isEmpty) {
      return;
    }

    isImageLoading = true;
    mySetState();

    List<Uint8List> images = await CoCreateKnowledgeController(coCreateKnowledgeProvider: null).generateImagesFromAi(
      requestModel: GenerateImagesRequestModel(
        topic: imageDescriptionController.text.trim(),
        count: 1,
        size: selectedResolution!,
      ),
    );

    MyPrint.printOnConsole("images length:${images.length}");

    isImageLoading = false;
    if (images.isEmpty) {
      isShowThumbnailImage = false;
      mySetState();
      MyToast.showError(context: context, msg: "Couldn't find any images");
      return;
    }

    generatedImageBytes = images.first;
    isShowThumbnailImage = true;
    mySetState();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: themeData.colorScheme.onPrimary,
      surfaceTintColor: themeData.colorScheme.onPrimary,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Generate Thumbnail Image",
              style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: getImageDescriptionTextFormField(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: getResolutionDropDown(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: getTypeDropDown(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  getGeneratedThumbnailImage(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            getButtonWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135, BoxFit? fit}) {
    return Image.asset(
      url,
      height: height,
      width: width,
      fit: fit,
    );
  }

  Widget getButtonWidget() {
    if (isShowThumbnailImage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () async {
                  generateImagesFromAi();
                },
                text: "Regenerate",
                fontColor: themeData.primaryColor,
                backGroundColor: themeData.colorScheme.onPrimary,
                borderColor: themeData.primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  Navigator.pop(context, generatedImageBytes);
                },
                text: "Next",
                fontColor: themeData.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CommonButton(
        minWidth: double.infinity,
        onPressed: () {
          generateImagesFromAi();
        },
        text: "Generate with AI",
        fontColor: themeData.colorScheme.onPrimary,
      ),
    );
  }

  Widget getGeneratedThumbnailImage() {
    if (isImageLoading) return const CommonLoader();
    if (!isShowThumbnailImage) return const SizedBox();
    if (generatedImageBytes.checkEmpty) return const SizedBox();

    return Image.memory(
      generatedImageBytes!,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
  }

  Widget getImageDescriptionTextFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: imageDescriptionController,
      labelText: "Image Description",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/cocreate/commonText.png",
      minLines: 5,
      maxLines: 5,
    );
  }

  Widget getResolutionDropDown() {
    return getCommonDropDown(
      list: const ["256x256", "512x512", "1024x1024"],
      value: selectedResolution,
      hintText: "Resolution",
      onChanged: (val) {
        selectedResolution = val;
        mySetState();
      },
      iconUrl: "assets/cocreate/commonText.png",
    );
  }

  Widget getTypeDropDown() {
    return getCommonDropDown(
      list: const ["Pop Art", "Felt", "Rococo", "Baroque", "Expressionism"],
      value: selectedType,
      hintText: "Type",
      onChanged: (val) {
        selectedType = val;
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
      items: list,
      value: value,
      hintText: hintText,
      onChanged: onChanged,
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
      isHintText: true,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.borderColor,
      enabledBorderColor: Styles.borderColor,
      focusColor: Styles.borderColor,
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
              ))
        ],
      ),
    );
  }
//endregion
}

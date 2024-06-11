import 'package:flutter/material.dart';

import '../../../common/components/common_text_form_field.dart';

class RegenerateAllPageDialog extends StatefulWidget {
  const RegenerateAllPageDialog({super.key});

  @override
  State<RegenerateAllPageDialog> createState() => _RegenerateAllPageDialogState();
}

class _RegenerateAllPageDialogState extends State<RegenerateAllPageDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController additionalPromptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Regenerate All Pages"),
          const SizedBox(
            height: 10,
          ),
          getTexFormField(
            isMandatory: false,
            controller: titleController,
            labelText: "Title",
          ),
          getTexFormField(isMandatory: false, controller: descriptionController, labelText: "Description", maxLines: 5, minLines: 5),
          getTexFormField(
            isMandatory: false,
            controller: additionalPromptController,
            labelText: "Additional Prompt",
          ),
        ],
      ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
}

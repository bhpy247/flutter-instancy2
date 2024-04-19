import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

class ExternalLearningGenerateUsingUrlConfirmationDialog extends StatefulWidget {
  const ExternalLearningGenerateUsingUrlConfirmationDialog({super.key});

  @override
  State<ExternalLearningGenerateUsingUrlConfirmationDialog> createState() => _ExternalLearningGenerateUsingUrlConfirmationDialogState();
}

class _ExternalLearningGenerateUsingUrlConfirmationDialogState extends State<ExternalLearningGenerateUsingUrlConfirmationDialog> with MySafeState {
  late AppProvider appProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: themeData.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "External Learning",
                      style: themeData.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeData.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getUrlTextFieldWidget(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              getSubmitButtonsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUrlTextFieldWidget() {
    return Column(
      children: [
        Row(
          children: [
            Radio.adaptive(
              value: 0,
              groupValue: 0,
              onChanged: (int? value) {},
              visualDensity: VisualDensity.compact,
            ),
            const Expanded(
              child: Text("URL"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommonTextFormField(
          hintText: "Enter URL",
          borderColor: themeData.primaryColor,
          isOutlineInputBorder: true,
          controller: urlController,
          validator: (String? text) {
            if ((text?.trim()).checkEmpty) {
              return "Url cannot be empty";
            }

            return null;
          },
          onTap: () {
            if (urlController.text.isEmpty) {
              urlController.text = "https://www.udemy.com/course/the-complete-web-development-bootcamp";
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }

  Widget getSubmitButtonsRow() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CommonButton(
            onPressed: () {
              Navigator.pop(context, "");
            },
            fontSize: 12,
            backGroundColor: themeData.colorScheme.onPrimary,
            borderColor: Colors.grey,
            fontColor: Colors.grey,
            fontWeight: FontWeight.w500,
            // isPrimary: false,
            text: "Skip",
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 1,
          child: CommonButton(
            onPressed: () {
              if (!(_formKey.currentState?.validate() ?? false)) {
                return;
              }

              Navigator.pop(context, urlController.text.trim());
            },
            fontSize: 12,
            backGroundColor: themeData.primaryColor,
            borderColor: themeData.primaryColor,
            fontColor: themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            // isPrimary: true,
            text: "Generate with AI",
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/splash/splash_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';

class ClientSelectionDialog extends StatefulWidget {
  final String clientUrl;
  final int clientUrlType;

  const ClientSelectionDialog({
    Key? key,
    required this.clientUrl,
    required this.clientUrlType,
  }) : super(key: key);

  @override
  State<ClientSelectionDialog> createState() => _ClientSelectionDialogState();
}

class _ClientSelectionDialogState extends State<ClientSelectionDialog> with MySafeState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController siteUrlController = TextEditingController();
  int? clientUrlType;

  void setClientConfiguration() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    } else if (!ClientUrlTypes.values.contains(clientUrlType)) {
      MyToast.showError(context: context, msg: "Select Client Url Type");
      return;
    }

    MyPrint.printOnConsole("clientUrlType:$clientUrlType");
    MyPrint.printOnConsole("Valid");

    ClientSelectionResponse response = (siteUrl: siteUrlController.text.trim(), clientUrlType: clientUrlType!);
    Navigator.pop(context, response);
  }

  void resetClientConfiguration() {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;

    ClientSelectionResponse response = (siteUrl: apiUrlConfigurationProvider.getMainSiteUrl(), clientUrlType: apiUrlConfigurationProvider.getMainClientUrlType());
    Navigator.pop(context, response);
  }

  @override
  void initState() {
    super.initState();

    siteUrlController.text = widget.clientUrl;
    clientUrlType = widget.clientUrlType;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Client Configuration",
              style: themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: themeData.primaryColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.close,
                size: 15,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getSiteUrlTextField(),
              const SizedBox(height: 20),
              getClientUrlTypeSelectionWidget(),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        MaterialButton(
          onPressed: () {
            resetClientConfiguration();
          },
          color: themeData.primaryColor,
          child: Text(
            "Reset",
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            setClientConfiguration();
          },
          color: themeData.primaryColor,
          child: Text(
            "Change",
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget getSiteUrlTextField() {
    return CommonTextFormFieldWithLabel(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      enabled: true,
      controller: siteUrlController,
      borderRadius: 5,
      borderWidth: 1,
      labelText: "Enter Client Url",
      isOutlineInputBorder: true,
      validator: (String? val) {
        if (val == null || val.trim().isEmpty) {
          return "Please enter Site Url";
        } else if (!val.startsWith("https://") && !val.startsWith("http://")) {
          return "Please enter a valid Site Url";
        }
        return null;
      },
      disabledColor: themeData.textTheme.labelMedium?.color,
    );
  }

  Widget getClientUrlTypeSelectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Environment Type",
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        getClientUrlTypeSelectionDropDownWidget()
        // getClientUrlTypeSelectionRadioTileWidget(text: "Staging", value: ClientUrlTypes.STAGING),
        // getClientUrlTypeSelectionRadioTileWidget(text: "QA", value: ClientUrlTypes.QA),
        // getClientUrlTypeSelectionRadioTileWidget(text: "Production", value: ClientUrlTypes.PRODUCTION),
      ],
    );
  }

  Widget getClientUrlTypeSelectionRadioTileWidget({required String text, required int value}) {
    return InkWell(
      onTap: () {
        clientUrlType = value;
        mySetState();
      },
      child: Container(
        child: Row(
          children: [
            Radio.adaptive(
              value: value,
              groupValue: clientUrlType,
              onChanged: (int? value) {
                clientUrlType = value;
                mySetState();
              },
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getClientUrlTypeSelectionDropDownWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10).copyWith(right: 5), // Adjust padding as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0), // Adjust border radius as needed
        border: Border.all(
          color: Colors.black,
          width: .8,
        ),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        padding: EdgeInsets.zero,
        isDense: true,
        value: getStringFromClientUrlType(clientUrlType ?? 0),
        onChanged: (String? newValue) {
          setState(() {
            setClientUrlTypeFromString(newValue!);
          });
        },
        items: <String>["Staging", "QA", "Production"]
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, letterSpacing: .5),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String getStringFromClientUrlType(int type) {
    if (type == ClientUrlTypes.STAGING) {
      return "Staging";
    } else if (type == ClientUrlTypes.QA) {
      return "QA";
    } else {
      return "Production";
    }
  }

  void setClientUrlTypeFromString(String value) {
    if (value == "Staging") {
      clientUrlType = ClientUrlTypes.STAGING;
    } else if (value == "QA") {
      clientUrlType = ClientUrlTypes.QA;
    } else {
      clientUrlType = ClientUrlTypes.PRODUCTION;
    }
    mySetState();
  }
}

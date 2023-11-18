import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../configs/app_constants.dart';
import '../../../models/authentication/data_model/profile_config_data_model.dart';
import '../../../models/authentication/data_model/profile_config_data_ui_control_model.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';

class SignUpView extends StatelessWidget {
  final List<ProfileConfigDataModel> profileConfigDataList;
  final void Function() setState;
  final void Function({required String email, required String password})? onSignUpSuccess;
  final GlobalKey<FormState> signUpFormKey;
  final bool isSignUpInProgress;
  final void Function() signUp;

  static ThemeData? themeData;

  const SignUpView({
    Key? key,
    this.profileConfigDataList = const [],
    required this.setState,
    required this.onSignUpSuccess,
    required this.signUpFormKey,
    this.isSignUpInProgress = false,
    required this.signUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        List<Widget> children = getFieldsWidgetsList(profileConfigDataList: profileConfigDataList, appProvider: appProvider).toList();

        if (children.isNotEmpty) {
          children.add(getSignUPButton());
        }

        return Form(
          key: signUpFormKey,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: children,
          ),
        );
      },
    );
  }

  //region Fields
  Iterable<Widget> getFieldsWidgetsList({required List<ProfileConfigDataModel> profileConfigDataList, required AppProvider appProvider}) sync* {
    for (ProfileConfigDataModel profileConfigData in profileConfigDataList) {
      Widget? fieldWidget = getFieldWidgetFromProfileConfigData(profileConfigData: profileConfigData, appProvider: appProvider);
      if (fieldWidget != null) {
        yield fieldWidget;
      }
    }

    yield const SizedBox(
      height: 20,
    );
  }

  Widget? getFieldWidgetFromProfileConfigData({required ProfileConfigDataModel profileConfigData, required AppProvider appProvider}) {
    // MyPrint.printOnConsole("datafieldname:${profileConfigData.datafieldname}, uicontroltypeid:${profileConfigData.uicontroltypeid}, attributeconfigid:${profileConfigData.attributeconfigid}");

    Widget? fieldWidget;

    int uiControlTypeId = profileConfigData.uicontroltypeid;
    if (UIControlTypes.textFieldTypeIds.contains(uiControlTypeId)) {
      fieldWidget = getTextFieldWidget(profileConfigData: profileConfigData, appProvider: appProvider);
    }

    return fieldWidget;
  }

  Widget? getTextFieldWidget({required ProfileConfigDataModel profileConfigData, required AppProvider appProvider}) {
    ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

    if (uiControlModel == null) {
      return null;
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          child: getTextFromFieldWithLabel(
            controller: uiControlModel.textEditingController,
            labelName: uiControlModel.displayText,
            obscureText: uiControlModel.isPassword && !uiControlModel.isPassVisible,
            enabled: !isSignUpInProgress,
            suffixWidget: uiControlModel.isPassword
                ? InkWell(
                    onTap: () {
                      uiControlModel.isPassVisible = !uiControlModel.isPassVisible;
                      setState();
                    },
                    child: Icon(
                      !uiControlModel.isPassVisible ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      size: 15,
                      color: Colors.grey,
                    ),
                  )
                : null,
            keyboardType: uiControlModel.keyboardType,
            validator: uiControlModel.validator,
            onChanged: (String text) {
              uiControlModel.value = text;
            },
            inputFormatters: uiControlModel.isPassword || uiControlModel.isEmail
                ? [
                    FilteringTextInputFormatter.deny(" "),
                  ]
                : null,
          ),
        ),
        if (uiControlModel.isPassword)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: getTextFromFieldWithLabel(
              controller: uiControlModel.confirmPasswordTextEditingController,
              labelName: "${appProvider.localStr.signupconfirmpasswordTitleConfirmpasswordtitle}${uiControlModel.isRequired ? " *" : ""}",
              obscureText: !uiControlModel.isConfPassVisible,
              enabled: !isSignUpInProgress,
              suffixWidget: InkWell(
                onTap: () {
                  uiControlModel.isConfPassVisible = !uiControlModel.isConfPassVisible;
                  setState();
                },
                child: Icon(
                  !uiControlModel.isConfPassVisible ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
              keyboardType: uiControlModel.keyboardType,
              validator: uiControlModel.confirmPasswordValidator,
              inputFormatters: [
                FilteringTextInputFormatter.deny(" "),
              ],
            ),
          ),
      ],
    );
  }

  //endregion

  Widget getSignUPButton() {
    return CommonButton(
      onPressed: () async {
        signUp();
      },
      height: 45,
      child: isSignUpInProgress
          ? CommonLoader(
              size: 22,
              color: themeData?.colorScheme.onPrimary,
              lineWidth: 2,
            )
          : Text(
        "Sign Up",
              style: themeData?.textTheme.titleSmall?.copyWith(
                color: themeData?.colorScheme.onPrimary,
              ),
            ),
    );
  }

  //Supporting Widgets
  Widget getTextFromFieldWithLabel({
    TextEditingController? controller,
    String labelName = "",
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixWidget,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      isOutlineInputBorder: true,
      borderRadius: 5,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      labelText: labelName,
      maxLength: TextField.noMaxLength,
      obscureText: obscureText,
      enabled: enabled,
      disabledColor: themeData?.textTheme.labelMedium?.color,
      suffixWidget: suffixWidget,
      keyboardType: keyboardType,
      validator: validator,
      borderWidth: 1,
      errorMaxLines: 2,
      prefixWidget: Icon(
        prefixWidget(labelName),
        size: 15,
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      // focusColor: ,
      // borderColor: Theme.of(NavigationController.mainNavigatorKey.currentContext!).primaryColor,
    );
  }

  IconData prefixWidget(String labelName) {
    if (labelName.contains("First Name")) {
      return FontAwesomeIcons.solidUser;
    } else if (labelName.contains("Last Name")) {
      return FontAwesomeIcons.solidUser;
    } else if (labelName.contains("Email")) {
      return FontAwesomeIcons.solidEnvelope;
    } else if (labelName.contains("Password") || labelName.contains("Confirm Password")) {
      return FontAwesomeIcons.lock;
    } else if (labelName.contains("About Me")) {
      return FontAwesomeIcons.circleInfo;
    } else {
      return FontAwesomeIcons.a;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';

class SignInView extends StatelessWidget {
  final GlobalKey<FormState> signInFormKey;
  final TextEditingController loginEmailController;
  final TextEditingController loginPassController;
  final bool isSignInPasswordVisible, isSignInProgress;
  final void Function()? isPasswordVisibilityChanged;
  final void Function({required String email, required String password}) signIn;

  const SignInView({
    Key? key,
    required this.signInFormKey,
    required this.loginEmailController,
    required this.loginPassController,
    this.isSignInPasswordVisible = false,
    this.isSignInProgress = false,
    this.isPasswordVisibilityChanged,
    required this.signIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    AppProvider appProvider = context.read<AppProvider>();

    return Form(
      key: signInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getTextFormField(
            controller: loginEmailController,
            themeData: themeData,
            hintText: appProvider.localStr.loginTextfieldUsernametextfieldplaceholder,
            prefixWidget: prefixIcon(Icons.email),
            enabled: !isSignInProgress,
            validator: (String? value) {
              if ((value?.trim()).checkEmpty) {
                return appProvider.localStr.loginAlertsubtitleUsernameorpasswordcannotbeempty;
              } else if (!AppConfigurationOperations.isValidEmailString(value!.trim())) {
                //else if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value ?? "")) {
                return appProvider.localStr.loginAlertsubtitleInvalidusernameorpassword;
              } else {
                return null;
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.deny(" "),
            ],
          ),
          const SizedBox(
            height: 17,
          ),
          getTextFormField(
            controller: loginPassController,
            themeData: themeData,
            hintText: appProvider.localStr.loginTextfieldPasswordtextfieldplaceholder,
            enabled: !isSignInProgress,
            suffixWidget: InkWell(
              onTap: () {
                if (isPasswordVisibilityChanged != null) {
                  isPasswordVisibilityChanged!();
                }
              },
              child: Icon(
                isSignInPasswordVisible ? FontAwesomeIcons.solidEye : FontAwesomeIcons.solidEyeSlash,
                size: 15,
                color: Colors.grey,
              ),
            ),
            isSuffix: true,
            obscureText: !isSignInPasswordVisible,
            prefixWidget: prefixIcon(Icons.lock),
            validator: (String? text) {
              if ((text?.trim()).checkNotEmpty) {
                if (text!.length <= 2) {
                  return "Passwords length should be greater than 3";
                }

                return null;
              } else {
                return appProvider.localStr.loginAlertsubtitleUsernameorpasswordcannotbeempty;
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.deny(" "),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getForgotPass(context),
          const SizedBox(
            height: 20,
          ),
          getSignInButton(themeData: themeData, context: context),
        ],
      ),
    );
  }

  Widget getTextFormField({
    required TextEditingController controller,
    required ThemeData themeData,
    String hintText = "",
    bool isSuffix = false,
    Widget? suffixWidget,
    bool obscureText = false,
    bool enabled = true,
    Widget? prefixWidget,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return CommonTextFormFieldWithLabel(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      suffixWidget: suffixWidget,
      borderRadius: 5,
      prefixWidget: prefixWidget,
      borderWidth: 1,
      labelText: hintText,
      isOutlineInputBorder: true,
      validator: validator,
      inputFormatters: inputFormatters,
      disabledColor: themeData.textTheme.labelMedium?.color,
    );
  }

  Widget prefixIcon(IconData icon) {
    return Icon(
      icon,
      // color: Colors.grey,
      size: 15,
    );
  }

  Widget getForgotPass(BuildContext context) {
    AppProvider appProvider = context.read<AppProvider>();

    return Container(
      alignment: Alignment.centerRight,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 2),
      child: InkWell(
        onTap: () {
          NavigationController.navigateToForgotPassword(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: ForgotPasswordNavigationArguments(email: loginEmailController.text.trim()),
          );
        },
        child: Text(
          '${appProvider.localStr.loginButtonForgotpasswordbutton}?',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget getSignInButton({required ThemeData themeData, required BuildContext context}) {
    AppProvider appProvider = context.read<AppProvider>();

    return CommonButton(
      onPressed: () {
        signIn(
          email: loginEmailController.text.trim(),
          password: loginPassController.text.trim(),
        );
      },
      height: 45,
      child: isSignInProgress
          ? CommonLoader(
              size: 22,
              color: themeData.colorScheme.onPrimary,
              lineWidth: 2,
            )
          : Center(
              child: Text(
                appProvider.localStr.loginButtonSigninbutton,
                style: themeData.textTheme.titleSmall?.copyWith(
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ),
    );
  }
}

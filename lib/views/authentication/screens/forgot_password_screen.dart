import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = "/ForgotPassword";

  final ForgotPasswordNavigationArguments arguments;

  const ForgotPassword({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with MySafeState {
  late ThemeData themeData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.arguments.email;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CommonLoader(color:themeData.primaryColor),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.forgotPass,
          ),
        ),
        body: getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Please enter your user name and click on the submit button. The password will be mailed to your email address",
                style: TextStyle(
                    fontSize:  15 ,
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              getEmailTextFormField(emailController, AppStrings.email),
              const SizedBox(
                height: 20,
              ),
              getButton(AppStrings.resetButton,Theme.of(context).primaryColor, onPressed: () async {
                if(_formKey.currentState?.validate() ?? false) {
                  FocusScope.of(context).unfocus();
                  MyPrint.printOnConsole("Valid");

                  isLoading = true;
                  mySetState();

                  bool isSent = await AuthenticationController(authenticationProvider: Provider.of<AuthenticationProvider>(context,listen: false)).forgotPassword(email: emailController.text);

                  isLoading = false;
                  mySetState();

                  if(isSent) {
                    if(pageMounted && context.mounted) {
                      MyToast.showSuccess(context: context, msg: "The password reset link is sent to your email address.");
                      Navigator.pop(context);
                    }
                  }
                  else {
                    if(pageMounted && context.mounted) {
                      MyToast.showError(context: context, msg: "The password reset link couldn't sent.");
                    }
                  }
                }
                else {
                  MyPrint.printOnConsole("Not Valid");
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget getEmailTextFormField(TextEditingController controller, String hintText,{bool isSuffix = false, Widget? widget, bool obscureText = false, Widget? prefixWidget}){
    return CommonTextFormField(
      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      controller: controller,
      obscureText: obscureText,
      suffixWidget: widget,
      borderRadius: 15,
      prefixWidget: prefixWidget,
      borderWidth: 1.5,
      hintText: hintText,
      isOutlineInputBorder: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(" "),
      ],
      validator: (String? text) {
        if(!AppConfigurationOperations.isValidEmailString(text?.trim() ?? "")) {
          return "Invalid Email Address";
        }
        else {
          return null;
        }
      },
    );
  }

  Widget labelText(String text){
    return RichText(
      text:  TextSpan(
          text: text,
          style:  const TextStyle(
              fontSize: 14,
              color: Colors.black
          ),
          children: const [
            TextSpan(
              text: " *",
              style:  TextStyle(
                fontSize: 14,
                color: Colors.red,
                // height: 5
              ),
            )
          ]
      ),
    );
  }

  Widget getButton(String text, Color color, {Function()? onPressed}){
    return CommonButton(
      onPressed: onPressed,
      text: text,
      fontColor: Colors.white,
      backGroundColor: color,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      borderRadius: 5,
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 0),
      minWidth: MediaQuery.of(context).size.width,
    );
  }

}

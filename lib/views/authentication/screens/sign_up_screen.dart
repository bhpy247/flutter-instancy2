import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_strings.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/SignUpScreen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late ThemeData themeData;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool isPassObscure = true, isConfirmPassObscure = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(AppStrings.signUp,
        style: const TextStyle(
        fontSize: 18,
        color: Colors.black
          )
        ),
      ),
      body: getMainBody(),
    );
  }

  Widget getMainBody(){
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        // color: Colors.orange,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              getHeadLine(),
              const SizedBox(height: 20,),
              getTextFormFields(),

              getSignInButton(AppStrings.signUp, themeData.primaryColor,
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    MyPrint.printOnConsole("succes");
                  }
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeadLine(){
    return const Text(AppStrings.pleaseFillTheFormToCreateAccount,style: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ));
  }

  Widget getTextFormFields(){
    return Form(
      key: formKey,
      child: Column(
        children: [
          getTextFormField(fNameController, AppStrings.fName, ),
          const SizedBox(height: 10,),
          getTextFormField(lNameController, AppStrings.lName, ),
          const SizedBox(height: 10,),
          getTextFormField(emailController, AppStrings.email, ),
          const SizedBox(height: 10,),
          getTextFormField(passController, AppStrings.pass, maxLength: 15, widget: eyeVisibleInvisibleForPass(),isSuffix: true,obscureText: isPassObscure),
          const SizedBox(height: 10,),
          getTextFormField(confirmPassController, AppStrings.confirmPass, maxLength: 15, widget: eyeVisibleInvisibleForConfirmPass(),isSuffix: true,obscureText: isConfirmPassObscure),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }

  Widget eyeVisibleInvisibleForPass() {
    return InkWell(
      onTap: () {
        setState(() {
          isPassObscure = !isPassObscure;
        });
      },
      child: Icon(
        !isPassObscure? FontAwesomeIcons.solidEye: FontAwesomeIcons.solidEyeSlash,
        size: 15,
      ),
    );
  }

  Widget eyeVisibleInvisibleForConfirmPass() {
    return InkWell(
      onTap: () {
        print("hiiiiiiii");
        setState(() {
          isConfirmPassObscure = !isConfirmPassObscure;
        });
      }
      ,
      child: Icon(
        !isConfirmPassObscure? FontAwesomeIcons.solidEye: FontAwesomeIcons.solidEyeSlash,
        size: 15,
      ),
    );
  }

  Widget getSignInButton(String text, Color color, {Function()? onPressed}){
    return CommonButton(
      onPressed: onPressed,
      text: text,
      fontColor: Colors.black,
      backGroundColor: color,
      borderRadius: 3,
      padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 0),
      minWidth: MediaQuery.of(context).size.width,
    );
  }

  Widget getTextFormField(TextEditingController controller, String hintText,{bool isSuffix = false, Widget? widget, bool obscureText = false,String? Function(String?)? validator, int maxLength = 50}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText(hintText),
        const SizedBox(height: 10,),
        CommonTextFormFieldWithLabel(
          contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          controller: controller,
          obscureText: obscureText,
          suffixWidget: widget,
          borderRadius: 3,
          validator: (String? val){
            if(val == null || val.isEmpty){
              return "Please fill the mandatory field";
            }
          },
          maxLength: maxLength,
          labelText: hintText,
          isOutlineInputBorder: true,
        ),
      ],
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
          children: [
            const TextSpan(
              text: " *",
              style:  const TextStyle(
                fontSize: 14,
                color: Colors.red,
                // height: 5
              ),
            )
          ]
      ),
    );
  }
}



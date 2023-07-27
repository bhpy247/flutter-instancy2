import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

class AboutTabView extends StatefulWidget {
  const AboutTabView({Key? key}) : super(key: key);

  @override
  State<AboutTabView> createState() => _AboutTabViewState();
}

class _AboutTabViewState extends State<AboutTabView> {

  late ThemeData themeData;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  FocusNode firstNamefn = FocusNode();
  
  void setDataForTheAbout(){
    ProfileProvider profileProvider = Provider.of(context, listen: false);
    // setProfileDataFieldNameModelList
    // profileProvider.
        
        
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MyPrint.printOnConsole("foccuss: ${firstNamefn.hasFocus}");
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              editButton(),
              getFirstNameTextField(),
              SizedBox(height: 19,),
              getLastNameTextField(),
              SizedBox(height: 19,),
              getDisplayNameTextField(),
              SizedBox(height: 19,),
              getEmailTextField(),
              SizedBox(height: 19,),
              getAboutMeTextField(),
              SizedBox(height: 19,),
              getJobTitleTextField(),
              SizedBox(height: 24,),
              getSaveChangesButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget editButton(){
    return InkWell(
      onTap: (){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.edit,size: 18,),
          SizedBox(width: 2,),
          Text("Edit",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14),)
        ],
      ),
    );
  }

  //region getFirstname
  Widget getFirstNameTextField(){
    return getCommonTextField(
        controller: firstNameController,
        labelText: "First Name",
    );
  }
  //endregion


  //region getLastName
  Widget getLastNameTextField(){
    return getCommonTextField(
        controller: lastNameController,
        labelText: "Last Name",
    );
  }
  //endregion

  //region getDisplayName
  Widget getDisplayNameTextField(){
    return getCommonTextField(
        controller: displayNameController,
        labelText: "Display Name",
    );
  }
  //endregion


  //region getEmail
  Widget getEmailTextField(){
    return getCommonTextField(
        controller: emailController,
        labelText: "Email",
    );
  }
  //endregion



  //region getAboutMeWidget
  Widget getAboutMeTextField(){
    return getCommonTextField(
        controller: aboutMeController,
        labelText: "About Me",
    );
  }
  //endregion


  //region getJobTitleWidget
  Widget getJobTitleTextField(){
    return getCommonTextField(
        controller: jobTitleController,
        labelText: "Job Title",
    );
  }
  //endregion

  //region commonTextField
  Widget getCommonTextField({
    required TextEditingController controller,
    String labelText = "",
    FocusNode? focusNode,
    bool isRequired = false,
    Color? floatingLabelColor
  }){
    return CommonTextFormFieldWithLabel(
      // maxLines: 5,
      // minLines: 5,
      controller: controller,
      isOutlineInputBorder: false,
      label: RichText(
        text: TextSpan(
          text: labelText,
          style: themeData.inputDecorationTheme.labelStyle,
          children: isRequired
              ? [
            TextSpan(
              text: " *",
              style: themeData.textTheme.titleMedium?.copyWith(
                color: Colors.red,
              ),
            ),
          ]
              : [],
        ),
      ),
      borderColor: Colors.black,
      borderWidth: 1,
      focusNode: focusNode,
      floatingLabelColor: floatingLabelColor,

      contentPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
    );
  }
  //endregion

  //region saveChangesButton
  Widget getSaveChangesButton(){
    return CommonButton(onPressed: (){},
      backGroundColor: themeData.primaryColor,
      minWidth: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Text("Save Changes", style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),),
    );
  }
  //endregion
}

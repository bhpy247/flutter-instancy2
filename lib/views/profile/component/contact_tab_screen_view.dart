import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';

import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class ContactTabScreenView extends StatefulWidget {
  const ContactTabScreenView({Key? key}) : super(key: key);

  @override
  State<ContactTabScreenView> createState() => _ContactTabScreenViewState();
}

class _ContactTabScreenViewState extends State<ContactTabScreenView> {

  late ThemeData themeData;
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  //region openDatePicker
  void getDatePicker() async {

    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );

    if(datePicker != null){
      dobController.text = DatePresentation.ddMMMMyyyyTimeStamp(Timestamp.fromDate(datePicker));
    }
    setState(() {});
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              editButton(),
              getCountryTextField(),
              const SizedBox(height: 19,),
              getMobileTextField(),
              const SizedBox(height: 19,),
              getGenderTextField(),
              const SizedBox(height: 19,),
              getDobTextField(),
              const SizedBox(height: 24,),
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
          const Icon(Icons.edit,size: 18,),
          const SizedBox(width: 2,),
          Text("Edit",style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14),)
        ],
      ),
    );
  }

  //region getCountryName
  Widget getCountryTextField(){
    return getCommonTextField(
      controller: countryController,
      labelText: "Country",
    );
  }
  //endregion

  //region getMobileNo
  Widget getMobileTextField(){
    return getCommonTextField(
      controller: mobileController,
      labelText: "Mobile No",
    );
  }
  //endregion

  //region getGenderField
  Widget getGenderTextField(){
    return getCommonTextField(
      controller: genderController,
      labelText: "Gender",
    );
  }
  //endregion

  //region getGenderField
  Widget getDobTextField(){
    return getCommonTextField(
      enable: true,
      controller: dobController,
      labelText: "Date Of Birth",
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        getDatePicker();
      },
      suffixWidget: Icon(Icons.calendar_month, color: Colors.black,)
    );
  }
  //endregion

  //region commonTextField
  Widget getCommonTextField({
    required TextEditingController controller,
    String labelText = "",
    bool enable = true,
    Function()? onTap,
    Widget? suffixWidget
  }){
    return CommonTextFormFieldWithLabel(
      controller: controller,
      isOutlineInputBorder: false,
      labelText: labelText,
      onTap: onTap,
      borderColor: Colors.black,
      borderWidth: 1,
      suffixWidget: suffixWidget,
      enabled: enable,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
    );
  }
  //endregion

  //region saveChangesButton
  Widget getSaveChangesButton(){
    return CommonButton(onPressed: (){},
      backGroundColor: themeData.primaryColor,
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Text("Save Changes", style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),),
    );
  }
  //endregion
}

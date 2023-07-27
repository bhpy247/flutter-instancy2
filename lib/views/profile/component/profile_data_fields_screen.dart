import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/models/authentication/response_model/country_response_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/data_field_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../configs/app_constants.dart';
import '../../../models/authentication/data_model/profile_config_data_ui_control_model.dart';

class ProfileDataFieldsScreen extends StatefulWidget {
  final List<DataFieldModel> list;
  final bool showEdit, isEditingEnabled;
  final void Function(bool isEditing) onEditing;
  final void Function(List<DataFieldModel> list) onSaveChanges;
  final List<Table5> choicesList;

  const ProfileDataFieldsScreen({
    Key? key,
    required this.list,
    required this.showEdit,
    required this.isEditingEnabled,
    required this.onEditing,
    required this.onSaveChanges,
    required this.choicesList,
  }) : super(key: key);

  @override
  State<ProfileDataFieldsScreen> createState() => _ProfileDataFieldsScreenState();
}

class _ProfileDataFieldsScreenState extends State<ProfileDataFieldsScreen> with MySafeState {
  late AppProvider appProvider;

  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validate(List<DataFieldModel> profileconfigdata) {
    bool isValidate = false;

    for (var element in profileconfigdata) {
      if ((element.valueName.isEmpty)) {
        MyPrint.printOnConsole('profileconfig ${element.attributedisplaytext} ${element.valueName} ${element.isrequired}');
        if (element.isrequired) {
          MyPrint.printOnConsole('ifrequired');
          isValidate = false;
          MyToast.showError(context: context, msg: appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory);
          break;
        }
        else {
          MyPrint.printOnConsole('elserequired');
          isValidate = true;
        }
      }
      else {
        isValidate = true;
      }
//
    }

    MyPrint.printOnConsole('dataisvalidated $isValidate');
    return isValidate;
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    // MyPrint.printOnConsole("isEditingEnabled:${widget.isEditingEnabled}");
    // MyPrint.printOnConsole("Params:${widget.list.map((e) => e.valueName)}");
    // MyPrint.printOnConsole("list.length:${widget.list.length}");

    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              editButton(),
              ...widget.list.map((e) {
                return getFieldWidgetFromProfileConfigData(profileConfigData: e, appProvider: appProvider) ?? const SizedBox();
              }),
              getSaveChangesButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget editButton() {
    if(!widget.showEdit) return const SizedBox();

    return InkWell(
      onTap: () {
        widget.onEditing(widget.isEditingEnabled);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.edit,
            size: 18,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            "Edit",
            style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget? getFieldWidgetFromProfileConfigData({required DataFieldModel profileConfigData, required AppProvider appProvider}) {
    MyPrint.printOnConsole("datafieldname:${profileConfigData.datafieldname}, valueName:${profileConfigData.valueName}, profileConfigDataUIControlModel:${profileConfigData.profileConfigDataUIControlModel}, uicontroltypeid:${profileConfigData.uicontroltypeid}, attributeconfigid:${profileConfigData.attributeconfigid}");

    if(!widget.isEditingEnabled) {
      ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

      if (uiControlModel == null) {
        return null;
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              uiControlModel.displayText,
              style: themeData.textTheme.titleSmall?.copyWith(
                color: themeData.textTheme.titleSmall!.color?.withAlpha(120),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profileConfigData.valueName.isEmpty ? "NA" : profileConfigData.valueName,
              style: themeData.textTheme.titleSmall?.copyWith(
                // color: themeData.textTheme.titleSmall!.color?.withAlpha(120),
              ),
            ),
          ],
        ),
      );
    }

    Widget? fieldWidget;

    int uiControlTypeId = profileConfigData.uicontroltypeid;
    if (UIControlTypes.textFieldTypeIds.contains(uiControlTypeId)) {
      fieldWidget = getTextFieldWidget(profileConfigData: profileConfigData, appProvider: appProvider);
    }
    else if (UIControlTypes.singleChoiceFromMultipleIds.contains(uiControlTypeId)) {
      fieldWidget = getDropDownWidget(profileConfigData: profileConfigData, appProvider: appProvider);
    }
    else if (UIControlTypes.dateFields.contains(uiControlTypeId)) {
      fieldWidget = getDatePickerWidget(profileConfigData: profileConfigData, appProvider: appProvider);
    }

    return fieldWidget;
  }

  Widget? getTextFieldWidget({required DataFieldModel profileConfigData, required AppProvider appProvider}) {
    ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

    if (uiControlModel == null) {
      return null;
    }
    MyPrint.printOnConsole("displayText: ${uiControlModel.displayText} displayId: ${profileConfigData.attributeconfigid} ${profileConfigData.attributedisplaytext}");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: getTextFromFieldWithLabel(
        attributeConfigId: profileConfigData.attributeconfigid,

        minLine: [1031].contains(profileConfigData.attributeconfigid) ? 1:1,
        maxLine: [1031].contains(profileConfigData.attributeconfigid) ? 8:1,
        isRequired: (widget.isEditingEnabled && uiControlModel.isRequired),

        controller: uiControlModel.textEditingController,
        labelName: uiControlModel.displayText,
        keyboardType: uiControlModel.keyboardType,
        validator: uiControlModel.validator,

        onChanged: (String text) {
          MyPrint.printOnConsole("On Changed called for ${profileConfigData.attributedisplaytext}:'$text'");

          uiControlModel.value = text;
          profileConfigData.valueName = text;
          // uiControlModel.textEditingController?.text = text;
        },
        enabled: [15].contains(profileConfigData.attributeconfigid) ? false : widget.isEditingEnabled,
        inputFormatters: uiControlModel.isPassword || uiControlModel.isEmail
            ? [
          FilteringTextInputFormatter.deny(" "),
        ]
            : null,
      ),
    );
  }

  Widget? getDropDownWidget({required DataFieldModel profileConfigData, required AppProvider appProvider}) {
    ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

    if (uiControlModel == null) {
      return null;
    }

    List<Table5> mainChoices = widget.choicesList.where((element) => element.attributeconfigid == profileConfigData.attributeconfigid).toList();

    Widget child;

    if(widget.isEditingEnabled) {
      if(mainChoices.isNotEmpty) {
        if(profileConfigData.valueName.isNotEmpty) {
          if(mainChoices.where((element) => element.choicetext == profileConfigData.valueName).isEmpty) {
            profileConfigData.valueName = "";
          }
        }

        child = Container(
          padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 3),
          decoration: BoxDecoration(
              border: Border.all(color: themeData.colorScheme.onBackground,width: 0.5),
              borderRadius: BorderRadius.circular(5)
          ),
          child: DropdownButton<String>(
            dropdownColor: themeData.colorScheme.background,
            value: profileConfigData.valueName.isEmpty ? null : profileConfigData.valueName,
            isExpanded: true,
            hint: Text(profileConfigData.attributedisplaytext),
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              // height: 2,
              // color: Color(int.parse(
              //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
            ),
            onChanged: (String? data) {
              profileConfigData.valueName = data ?? "";
              mySetState();
            },
            items: mainChoices.map<DropdownMenuItem<String>>((Table5 value) {
              return DropdownMenuItem<String>(
                value: value.choicetext,
                child: Text(
                  value.choicetext,
                ),
              );
            }).toList(),
          ),
        );
      }
      else {
        child = Container();
      }
    }
    else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileConfigData.valueName,
                  style: themeData.textTheme.titleSmall?.copyWith(

                  ),
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 2),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                  uiControlModel.isRequired ? "${uiControlModel.displayText} *" : uiControlModel.displayText,
                  style: themeData.textTheme.titleSmall?.copyWith(
                    color: themeData.textTheme.titleSmall!.color?.withAlpha(120),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }

  Widget? getDatePickerWidget({required DataFieldModel profileConfigData, required AppProvider appProvider}) {
    ProfileConfigDataUIControlModel? uiControlModel = profileConfigData.profileConfigDataUIControlModel;

    if (uiControlModel == null) {
      return null;
    }

    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      profileConfigData.valueName,
                      style: themeData.textTheme.titleSmall?.copyWith(

                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 2),
            ],
          ),
        ),

      ],
    );

    if(widget.isEditingEnabled) {
      child = InkWell(
        onTap: () async {
          // DateTime date = DateTime(1957);

          DateTime initialDate = ParsingHelper.parseDateTimeMethod(profileConfigData.valueName, dateFormat: "MM/dd/yyyy") ?? DateTime.now();

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1957),
            lastDate: DateTime.now(),
            builder: (BuildContext context,
                Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: themeData.colorScheme.onBackground,
                ),
                child: child ?? const SizedBox(),
              );
            },
          );

          if(pickedDate != null) {
            final df = DateFormat('MM/dd/yyyy');
            profileConfigData.valueName = df.format(pickedDate);
          }
          else {
            profileConfigData.valueName = "";
          }
          mySetState();
        },
        child: child,
      );
    }

    return Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                  uiControlModel.isRequired ? "${uiControlModel.displayText} *" : uiControlModel.displayText,
                  style: themeData.textTheme.titleSmall?.copyWith(
                    color: themeData.textTheme.titleSmall!.color?.withAlpha(120),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }

  Widget getSaveChangesButton() {
    if(!widget.isEditingEnabled) return const SizedBox();

    return CommonButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if((_formKey.currentState?.validate() ?? false) && validate(widget.list)) {
          widget.onSaveChanges(widget.list);
        }
      },
      backGroundColor: themeData.primaryColor,
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Text(
        "Save Changes",
        style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget getTextFromFieldWithLabel({
    TextEditingController? controller,
    String labelName = "",
    int attributeConfigId = 0,
    bool obscureText = false,
    bool enabled = false,
    Widget? suffixWidget,
    int minLine = 1,
    int maxLine = 1,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      onChanged: onChanged,
      enabled: enabled,

      controller: controller,
      style:  attributeConfigId != 15 ? themeData.textTheme.titleSmall : themeData.textTheme.titleSmall!.copyWith(color: Colors.grey),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        border: inputBorder(
          isOutlineInputBorder: false,
          borderWidth: 2,
        ),
        enabledBorder: inputBorder(
          isOutlineInputBorder: false,
          borderWidth: 2,
        ),
        focusedBorder: inputBorder(
          isOutlineInputBorder: false,
          borderColor: themeData.primaryColor,
          borderWidth: enabled ? 3 : 2,
        ),
        disabledBorder: inputBorder(
          isOutlineInputBorder: false,
          borderColor: Colors.grey,
          borderWidth: 2,
        ),
        label: RichText(
          text: TextSpan(
            text: labelName,
            style: attributeConfigId != 15 ? themeData.inputDecorationTheme.labelStyle: themeData.inputDecorationTheme.labelStyle!.copyWith(color: Colors.grey),
            children: isRequired && attributeConfigId != 15
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
        labelStyle: themeData.textTheme.titleSmall?.copyWith(
          color: themeData.textTheme.titleSmall!.color?.withAlpha(120),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        suffixIcon: suffixWidget,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5).copyWith(top: 10),
      ),
      maxLines: maxLine,
      minLines: minLine,
    );
  }

  InputBorder inputBorder({Color? borderColor, double borderRadius = 5, double borderWidth = 1, bool isOutlineInputBorder = false}) {
    if (isOutlineInputBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? themeData.inputDecorationTheme.border?.borderSide.color ?? themeData.colorScheme.onBackground, width: borderWidth),
      );
    } else {
      return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? themeData.inputDecorationTheme.border?.borderSide.color ?? themeData.colorScheme.onBackground, width: borderWidth),
      );
    }
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

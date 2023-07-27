
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_repository.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_experience_data_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/create_experience_request_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/remove_experience_request_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class AddEditExperienceScreen extends StatefulWidget {
  static const String routeName = "/AddEditExperienceScreen";

  final AddEditExperienceScreenNavigationArguments arguments;

  const AddEditExperienceScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<AddEditExperienceScreen> createState() => _AddEditExperienceScreenState();
}

class _AddEditExperienceScreenState extends State<AddEditExperienceScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  late AppProvider appProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime? fromDate, toDate;
  bool isCurrentlyWorking = false;

  Future<DateTime?> pickDateTime({required DateTime initialDate}) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1957),
      lastDate: DateTime.now(),
    );

    return dateTime;
  }

  Future<void> pickFromDate() async {
    DateTime initialDate = ParsingHelper.parseDateTimeMethod(fromDateController.text, dateFormat: "MMM yyyy") ?? DateTime.now();

    DateTime? pickedDate = await pickDateTime(initialDate: initialDate);

    if (pickedDate != null) {
      fromDate = pickedDate;
      fromDateController.text = DatePresentation.getFormattedDate(dateFormat: "MMM yyyy", dateTime: pickedDate) ?? "";
    }
  }

  Future<void> pickToDate() async {
    DateTime initialDate = ParsingHelper.parseDateTimeMethod(toDateController.text, dateFormat: "MMM yyyy") ?? DateTime.now();

    DateTime? pickedDate = await pickDateTime(initialDate: initialDate);

    if (pickedDate != null) {
      toDate = pickedDate;
      toDateController.text = DatePresentation.getFormattedDate(dateFormat: "MMM yyyy", dateTime: pickedDate) ?? "";
    }
  }

  Future<void> saveData() async {
    isLoading = true;
    mySetState();

    if (!isCurrentlyWorking) {
      if (toDate != null && fromDate != null) {
        if (toDate!.isBefore(fromDate!)) {
          MyToast.showError(context: context, msg: "Your end year can’t be earlier than your start year");
          isLoading = false;
          mySetState();
          return;
        }
      }
    }

    CreateExperienceRequestModel requestModel = CreateExperienceRequestModel(
      title: jobTitleController.text.trim(),
      company: companyNameController.text.trim(),
      location: locationController.text.trim(),
      showfromdate: fromDateController.text.trim(),
      tilldate: isCurrentlyWorking ? 1 : 0,
      showftoate: isCurrentlyWorking ? "" : toDateController.text.trim(),
      discription: descriptionController.text.trim(),
      userId: widget.arguments.userExperienceDataModel?.userid.toString() ?? "",
      displayNo: widget.arguments.userExperienceDataModel?.displayno.toString() ?? "",
    );

    bool isEdit = widget.arguments.userExperienceDataModel != null;

    DataResponseModel<bool> responseModel;
    if (isEdit) {
      responseModel = await ProfileRepository(apiController: ApiController()).updateExperience(createExperienceRequestModel: requestModel);
    } else {
      responseModel = await ProfileRepository(apiController: ApiController()).createExperience(createExperienceRequestModel: requestModel);
    }
    MyPrint.printOnConsole("Add/Edit responseModel:$responseModel");

    isLoading = false;
    mySetState();

    if (responseModel.appErrorModel != null) {
      if (pageMounted && context.mounted) {
        MyToast.showError(context: context, msg: responseModel.appErrorModel!.message);
      }
      return;
    }

    if (responseModel.data == true) {
      if (pageMounted && context.mounted) {
        MyToast.showSuccess(
            context: context,
            msg: isEdit
                ? appProvider.localStr.profileAlertsubtitleExperienceprofileupdatesuccessfully
                : appProvider.localStr.profileAlertsubtitleExperienceaddedsuccessfully);
        Navigator.pop(context, true);
      }
    } else {
      if (pageMounted && context.mounted) {
        MyToast.showError(context: context, msg: "Couldn't Save");
      }
    }
  }

  Future<void> deleteData({required UserExperienceDataModel model}) async {
    bool isDelete = await ProfileController(profileProvider: null).checkRemoveExperienceByUserFromDialog(context: context);

    if (!isDelete) {
      return;
    }

    isLoading = true;
    mySetState();

    RemoveExperienceRequestModel requestModel = RemoveExperienceRequestModel(
      userId: model.userid.toString(),
      displayNo: model.displayno.toString(),
    );

    DataResponseModel<bool> responseModel =
        await ProfileRepository(apiController: ApiController()).removeExperience(removeExperienceRequestModel: requestModel);
    MyPrint.printOnConsole("Delete responseModel:$responseModel");

    isLoading = false;
    mySetState();

    if (responseModel.appErrorModel != null) {
      if (pageMounted && context.mounted) {
        MyToast.showError(context: context, msg: responseModel.appErrorModel!.message);
      }
      return;
    }

    if (responseModel.data == true) {
      if (pageMounted && context.mounted) {
        MyToast.showSuccess(context: context, msg: appProvider.localStr.profileAlertsubtitleExperiencedeletesuccessfully);
        Navigator.pop(context, true);
      }
    } else {
      if (pageMounted && context.mounted) {
        MyToast.showError(context: context, msg: "Couldn't Save");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    if (widget.arguments.userExperienceDataModel != null) {
      UserExperienceDataModel model = widget.arguments.userExperienceDataModel!;

      jobTitleController.text = model.title;
      companyNameController.text = model.companyname;
      locationController.text = model.location;
      fromDateController.text = model.fromdate;
      descriptionController.text = model.description;
      isCurrentlyWorking = ["present", ""].contains(model.todate.toLowerCase());
      toDateController.text = isCurrentlyWorking ? DateFormat("MMM yyyy").format(DateTime.now()) : model.todate;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppConfigurations().commonAppBar(
          title: "${widget.arguments.userExperienceDataModel != null ? "Edit" : "Add"} Experience",
          actions: widget.arguments.userExperienceDataModel != null
              ? [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            deleteData(model: widget.arguments.userExperienceDataModel!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              // color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              : null,
        ),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    getJobTitleTextField(),
                    getCompanyNameTextField(),
                    getLocationTextField(),
                    getCurrentlyWorkingCheckBox(),
                    getFromDateTextField(),
                    getToDateTextField(),
                    getDescriptionTextField(),
                    const SizedBox(
                      height: 24,
                    ),
                    getSaveChangesButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getJobTitleTextField() {
    return getCommonTextField(
        controller: jobTitleController,
        labelText: appProvider.localStr.profileLabelExperiencetitlelabel,
        isRequired: true,
        validator: (String? text) {
          return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
        });
  }

  Widget getCompanyNameTextField() {
    return getCommonTextField(
        controller: companyNameController,
        labelText: appProvider.localStr.profileLabelExperiencecompanylabel,
        isRequired: true,
        validator: (String? text) {
          return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
        });
  }

  Widget getLocationTextField() {
    return getCommonTextField(
        controller: locationController,
        labelText: appProvider.localStr.profileLabelExperiencelocationlabel,
        isRequired: true,
        validator: (String? text) {
          return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
        });
  }

  Widget getCurrentlyWorkingCheckBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              isCurrentlyWorking = !isCurrentlyWorking;
              if (isCurrentlyWorking) {
                toDateController.text = DateFormat("MMM yyyy").format(DateTime.now());
              }
              mySetState();
            },
            child: Row(
              children: [
                Icon(
                  isCurrentlyWorking ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 21,
                  color: isCurrentlyWorking ? themeData.primaryColor : Colors.black54,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(appProvider.localStr.profileLabelExperienceiscurrentlyworkingtilldatelabel),
              ],
            ),
          )

          // Expanded(
          //   child: CheckboxListTile(
          //
          //     value: isCurrentlyWorking,
          //     onChanged: (bool? isTrue) {
          //       isCurrentlyWorking = isTrue ?? false;
          //       if(isCurrentlyWorking) {
          //         toDateController.text = DateFormat("MMM yyyy").format(DateTime.now());
          //       }
          //       mySetState();
          //     },
          //     activeColor: themeData.primaryColor,
          //     contentPadding: EdgeInsets.zero,
          //     controlAffinity: ListTileControlAffinity.leading,
          //     dense: false,
          //     title: Text(
          //       appProvider.localStr.profileLabelExperienceiscurrentlyworkingtilldatelabel
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget getFromDateTextField() {
    return getCommonTextField(
      controller: fromDateController,
      labelText: appProvider.localStr.profileLabelExperiencefromlabel,
      isRequired: true,
      validator: (String? text) {
        return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
      },
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        pickFromDate();
      },
      suffixWidget: const Icon(
        Icons.calendar_month,
        color: Colors.black,
      ),
      enabled: true,
      floatingLabelColor: Styles.lightTextColor2,
    );
  }

  Widget getToDateTextField() {
    return Visibility(
      visible: !isCurrentlyWorking,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 19),
        child: getCommonTextField(
          controller: toDateController,
          labelText: appProvider.localStr.profileLabelExperiencetolabel,
          isRequired: true,
          validator: (String? text) {
            if (text.checkEmpty) {
              return appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
            }
            DateTime fromDate = DateFormat("MMM yyyy").parse(fromDateController.text);
            DateTime toDate = DateFormat("MMM yyyy").parse(toDateController.text);

            // DateTime fromDate = DateTime.parse(DateFormat("MM yyyy").format(DateTime.parse(fromDateController.text)));
            if (fromDate.isAfter(toDate)) {
              return appProvider.localStr.profilefromYearIsGreaterThanToYearValidation;
            }
          },
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            pickToDate();
          },
          suffixWidget: const Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
          enabled: true,
          floatingLabelColor: Styles.lightTextColor2,
        ),
      ),
    );
  }

  Widget getDescriptionTextField() {
    return getCommonTextField(
      minLine: 1,
      maxLine: 3,
      controller: descriptionController,
      labelText: appProvider.localStr.profileLabelExperiencedescriptionlabel,
    );
  }

  //region commonTextField
  Widget getCommonTextField({
    required TextEditingController controller,
    String labelText = "",
    int minLine = 1,
    int maxLine = 1,
    bool isRequired = false,
    FocusNode? focusNode,
    Color? floatingLabelColor,
    Function()? onTap,
    Widget? suffixWidget,
    bool enabled = true,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CommonTextFormFieldWithLabel(
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
        suffixWidget: suffixWidget,
        maxLines: maxLine,
        minLines: minLine,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        enabled: enabled,
        validator: validator,
      ),
    );
  }

  //endregion

  Widget getSaveChangesButton() {
    return CommonButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState?.validate() ?? false) {
          saveData();
        }
      },
      backGroundColor: themeData.primaryColor,
      minWidth: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Text(
        appProvider.localStr.profileButtonExperiencesavebutton,
        // "Save Changes",
        style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}

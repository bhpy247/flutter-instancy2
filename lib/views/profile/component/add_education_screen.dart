import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/profile/data_model/education_title_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_education_data_model.dart';
import 'package:flutter_instancy_2/models/profile/request_model/create_education_request_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../api/api_controller.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/profile/profile_controller.dart';
import '../../../backend/profile/profile_repository.dart';
import '../../../models/common/data_response_model.dart';
import '../../../models/profile/request_model/remove_education_request_model.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/extensions.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class AddEducationScreen extends StatefulWidget {
  static const String routeName = "/addEducationScreen";

  final AddEducationScreenNavigationArguments arguments;

  const AddEducationScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  late AppProvider appProvider;
  late ProfileProvider profileProvider;
  late ProfileController profileController;

  Future<void>? futureGetData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController schoolUniversityController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController fromYearController = TextEditingController();
  TextEditingController toYearController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? fromDate, toDate;
  int titleId = 0;

  ScrollController titleSelectionScrollController = ScrollController();

  bool isCurrentlyWorking = false;

  Future<void> pickTitle() async {
    List<EducationTitleModel> list = profileProvider.educationTitlesList.getList(isNewInstance: false);

    if (list.isEmpty) {
      MyToast.showError(context: context, msg: "No Titles Found");
      return;
    }

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300.0, // Change as per your requirement
            width: 300.0,
            // Change as per your requirement
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.black, // Your color
                platform: TargetPlatform.android, // Specify platform as Android so Scrollbar uses the highlightColor
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 3.0,
                controller: titleSelectionScrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    EducationTitleModel educationTitleModel = list[index];

                    bool isSelected = titleId == educationTitleModel.id;

                    return Center(
                      child: ListTile(
                        title: Text(
                          educationTitleModel.name,
                          style: TextStyle(
                            color: isSelected ? themeData.primaryColor : themeData.colorScheme.onBackground,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        //tileColor: selectindex == index ? Colors.blue : null,
                        onTap: () {
                          Navigator.of(context).pop(educationTitleModel);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        );
      },
    );

    if(value is EducationTitleModel) {
      titleId = value.id;
      titleController.text = value.name;
    }
  }

  Future<DateTime?> pickYear({required String title, required DateTime initialDate}) async {
    DateTime? dateTime;
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: SizedBox(
            // Need to use container to add size constraint.
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            child: YearPicker(
              firstDate: DateTime(1957, 1),
              lastDate: DateTime.now(),
              initialDate: initialDate,
              selectedDate: initialDate,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (value is DateTime) {
      dateTime = value;
    }

    return dateTime;
  }

  Future<void> pickFromDate() async {
    DateTime initialDate = ParsingHelper.parseDateTimeMethod(fromYearController.text, dateFormat: "yyyy") ?? DateTime.now();

    DateTime? pickedDate = await pickYear(
      title: "From Year",
      initialDate: initialDate,
    );

    if (pickedDate != null) {
      fromDate = pickedDate;
      fromYearController.text = DatePresentation.getFormattedDate(dateFormat: "yyyy", dateTime: pickedDate) ?? "";
    }
  }

  Future<void> pickToDate() async {
    DateTime initialDate = ParsingHelper.parseDateTimeMethod(toYearController.text, dateFormat: "yyyy") ?? DateTime.now();

    DateTime? pickedDate = await pickYear(
      title: "To Year",
      initialDate: initialDate,
    );

    if (pickedDate != null) {
      toDate = pickedDate;
      toYearController.text = DatePresentation.getFormattedDate(dateFormat: "yyyy", dateTime: pickedDate) ?? "";
    }
  }

  Future<void> saveData() async {
    isLoading = true;
    mySetState();

    int startYear = ParsingHelper.parseIntMethod(fromYearController.text.trim());
    int endYear = ParsingHelper.parseIntMethod(toYearController.text.trim());
    int diff = endYear - startYear;

    if(fromDate != null && toDate != null){
      if(toDate!.isBefore(fromDate!)){
        MyToast.showError(context: context, msg: "Your end year can’t be earlier than your start year");
        isLoading = false;
        mySetState();
        return;
      }
    }

    CreateEducationRequestModel requestModel = CreateEducationRequestModel(
      school: schoolUniversityController.text,
      country: countryNameController.text,
      title: titleId.toString(),
      degree: degreeController.text,
      fromyear: fromYearController.text,
      toyear: toYearController.text,
      discription: descriptionController.text,
      showfromdate: '$startYear-$endYear .$diff yrs',
      titleEducation: titleController.text,
      oldtitle: titleId.toString(),
      userId: widget.arguments.userEducationDataModel?.userid.toString() ?? "",
      displayNo: widget.arguments.userEducationDataModel?.displayno.toString() ?? "",
    );

    bool isEdit = widget.arguments.userEducationDataModel != null;

    DataResponseModel<bool> responseModel;
    if (isEdit) {
      responseModel = await ProfileRepository(apiController: ApiController()).updateEducation(requestModel: requestModel);
    } else {
      responseModel = await ProfileRepository(apiController: ApiController()).createEducation(requestModel: requestModel);
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
          msg: isEdit ? appProvider.localStr.profileAlertsubtitleEducationprofileupdatesuccessfully : appProvider.localStr.profileAlertsubtitleEducationaddedsuccessfully,
        );
        Navigator.pop(context, true);
      }
    } else {
      if (pageMounted && context.mounted) {
        MyToast.showError(context: context, msg: "Couldn't Save");
      }
    }
  }

  Future<void> deleteData({required UserEducationDataModel model}) async {
    bool isDelete = await ProfileController(profileProvider: null).checkRemoveEducationByUserFromDialog(context: context);

    if (!isDelete) {
      return;
    }

    isLoading = true;
    mySetState();

    RemoveEducationRequestModel requestModel = RemoveEducationRequestModel(
      userId: model.userid.toString(),
      displayNo: model.displayno.toString(),
    );

    DataResponseModel<bool> responseModel = await ProfileRepository(apiController: ApiController()).removeEducation(requestModel: requestModel);
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
        MyToast.showSuccess(context: context, msg: appProvider.localStr.profileAlertsubtitleEducationdeleteSuccessfully);
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
    profileProvider = widget.arguments.profileProvider ?? ProfileProvider();
    profileController = ProfileController(profileProvider: profileProvider);

    if (profileProvider.educationTitlesList.getList(isNewInstance: false).isEmpty) {
      futureGetData = profileController.getEducationTitles(isFromCache: true);
    }

    if (widget.arguments.userEducationDataModel != null) {
      UserEducationDataModel model = widget.arguments.userEducationDataModel!;

      schoolUniversityController.text = model.school;
      degreeController.text = model.degree;
      countryNameController.text = model.country;
      titleController.text = model.titleeducation;
      titleId = model.titleid;
      descriptionController.text = model.description;
      fromYearController.text = model.fromyear;
      toYearController.text = model.toyear;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
      ],
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppConfigurations().commonAppBar(
                title: "${widget.arguments.userEducationDataModel != null ? "Edit" : "Add"} Education",
                actions: widget.arguments.userEducationDataModel != null
                    ? [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              CommonIconButton(
                                onTap: () {
                                  deleteData(model: widget.arguments.userEducationDataModel!);
                                },
                                iconData: Icons.delete,
                              ),
                            ],
                          ),
                        ),
                      ]
                    : null,
              ),
              body: futureGetData != null
                  ? FutureBuilder(
                      future: futureGetData,
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return getMainWidget();
                        } else {
                          return const CommonLoader();
                        }
                      },
                    )
                  : getMainWidget(),
            ),
          );
        },
      ),
    );
  }

  //region MainWidget
  Widget getMainWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                getSchoolTitleTextField(),
                const SizedBox(
                  height: 19,
                ),
                getCountryTextField(),
                const SizedBox(height: 19),
                getTitleWidget(),
                const SizedBox(height: 19),
                getDegreeTextField(),
                const SizedBox(
                  height: 10,
                ),
                // getCurrentlyWorkingCheckBox(),
                // const SizedBox(height: 19,),

                // const SizedBox(height: 19,),
                getFromDateTextField(),
                getToDateTextField(),
                const SizedBox(
                  height: 19,
                ),
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
    );
  }

  Widget getSchoolTitleTextField() {
    return getCommonTextField(
      controller: schoolUniversityController,
      labelText: appProvider.localStr.profileLabelEducationschooluniversitylabel,
      isRequired: true,
      validator: (String? text) {
        return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
      },
    );
  }

  Widget getCountryTextField() {
    return getCommonTextField(
      controller: countryNameController,
      labelText: appProvider.localStr.profileLabelEducationcountrylabel,
      isRequired: true,
      validator: (String? text) {
        return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
      },
    );
  }

  Widget getTitleWidget() {
    return InkWell(
      onTap: () {
        pickTitle();
      },
      child: IgnorePointer(
        child: getCommonTextField(
          controller: titleController,
          labelText: appProvider.localStr.profileLabelEducationtitlelabel,
          isRequired: true,
          validator: (String? text) {
            return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
          },
        ),
      ),
    );
  }

  Widget getDegreeTextField() {
    return getCommonTextField(
      controller: degreeController,
      labelText: appProvider.localStr.profileLabelEducationdegreelabel,
      isRequired: true,
      validator: (String? text) {
        return text.checkEmpty ? appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory : null;
      },
    );
  }

  /*Widget getCurrentlyWorkingCheckBox() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            value: isCurrentlyWorking,
            onChanged: (bool? isTrue) {
              isCurrentlyWorking = isTrue ?? false;
              setState(() {});
            },
            activeColor: themeData.primaryColor,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: const Text("Currently pursuing"),
          ),
        ),

        // Checkbox(value: isCurrentlyWorking, onChanged: (bool? isTrue){
        //   isCurrentlyWorking = isTrue ?? false;
        //   setState(() {});
        // }),
        // Text("I currently Work here"),
      ],
    );
  }*/

  Widget getFromDateTextField() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        pickFromDate();
      },
      child: IgnorePointer(
        child: getCommonTextField(
          controller: fromYearController,
          labelText: appProvider.localStr.profileLabelEducationfromlabel,
          isRequired: true,
          validator: (String? text) {
            if (text.checkEmpty) {
              return appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
            }

            int? startDate = ParsingHelper.parseIntNullableMethod(text!.trim());
            int? endDate = ParsingHelper.parseIntNullableMethod(toYearController.text.trim());

            // if (startDate != null && endDate != null && startDate > endDate) {
            //   return appProvider.localStr.profilefromYearIsGreaterThanToYearValidation;
            // }

            return null;
          },
          suffixWidget: const Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget getToDateTextField() {
    return Visibility(
      visible: !isCurrentlyWorking,
      child: Padding(
        padding: const EdgeInsets.only(top: 19),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            pickToDate();
          },
          child: IgnorePointer(
            child: getCommonTextField(
              controller: toYearController,
              labelText: appProvider.localStr.profileLabelEducationtolabel,
              isRequired: true,
              validator: (String? text) {
                if (text.checkEmpty) {
                  return appProvider.localStr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
                }

                int? startDate = ParsingHelper.parseIntNullableMethod(fromYearController.text.trim());
                int? endDate = ParsingHelper.parseIntNullableMethod(text!.trim());

                if (startDate != null && endDate != null && startDate > endDate) {
                  return appProvider.localStr.profileAlertsubtitleEducationdatefieldvaluevalidation;
                }

                return null;
              },
              suffixWidget: const Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDescriptionTextField() {
    return getCommonTextField(
      minLine: 1,
      maxLine: 3,
      controller: descriptionController,
      labelText: appProvider.localStr.profileLabelEducationdescriptionlabel,
      isRequired: false,
    );
  }

  Widget getCommonTextField({
    required TextEditingController controller,
    String labelText = "",
    bool isRequired = false,
    int minLine = 1,
    int maxLine = 1,
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
        minLines: minLine,

        maxLines: maxLine,
        isOutlineInputBorder: false,
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: themeData.textTheme.bodyLarge,
            children: isRequired
                ? [
                    TextSpan(
                      text: " *",
                      style: themeData.textTheme.titleLarge?.copyWith(
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
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        enabled: enabled,
        validator: validator,
      ),
    );
  }

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
        appProvider.localStr.profileButtonEducationsavebutton,
        style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

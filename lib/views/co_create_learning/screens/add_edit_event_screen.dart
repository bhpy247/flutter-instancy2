import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_text_form_field.dart';

class AddEditEventScreen extends StatefulWidget {
  static const String routeName = "/AddEditEventScreen";
  final AddEditEventScreenArgument arguments;

  const AddEditEventScreen({super.key, required this.arguments});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> with MySafeState {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController guestController = TextEditingController();
  TextEditingController eventUrlController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<String> _selectTime(BuildContext context) async {
    String? selectedDate;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedDate = "${pickedTime.hour}:${pickedTime.minute}";
      print('Selected time: ${pickedTime.format(context)}');
    }
    return selectedDate ?? "";
  }

  Future<String> _selectDate(BuildContext context) async {
    String? selectedDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      print('Selected date: $pickedDate');
      selectedDate = DatePresentation.mmmddYYyyFormatter(pickedDate);
    }
    return selectedDate ?? "";
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppConfigurations().commonAppBar(
        title: "Create Event",
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: CommonButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          text: "Create",
          fontColor: themeData.colorScheme.onPrimary,
        ),
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // getTitleFormField(),
            // const SizedBox(
            //   height: 15,
            // ),
            getDateFormField(),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: getStartTimeTextFormField(),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text("To"),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: getEndTimeTextFormField(),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            // getDescriptionFormField(),
            const SizedBox(
              height: 15,
            ),
            getEventURLFormField(),
            const SizedBox(
              height: 15,
            ),
            getLocationFormField(),
          ],
        ),
      ),
    );
  }

  Widget getTitleFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: titleController,
      labelText: "Title of your event",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getDescriptionFormField() {
    return getTexFormField(
        isMandatory: false,
        showPrefixIcon: false,
        controller: descriptionController,
        labelText: "Description",
        keyBoardType: TextInputType.text,
        iconUrl: "assets/catalog/imageDescription.png",
        minLines: 5,
        maxLines: 5);
  }

  Widget getEventURLFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: eventUrlController,
      labelText: "Event URL",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getLocationFormField() {
    return getTexFormField(
      isMandatory: false,
      showPrefixIcon: false,
      controller: guestController,
      labelText: "Location",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getEndTimeTextFormField() {
    return getTexFormField(
      onTap: () async {
        endTimeController.text = await _selectTime(context);
        mySetState();
      },
      isMandatory: false,
      showPrefixIcon: false,
      controller: endTimeController,
      labelText: "End Time",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  Widget getStartTimeTextFormField() {
    return getTexFormField(
      onTap: () async {
        startTimeController.text = await _selectTime(context);
        mySetState();
      },
      isMandatory: false,
      showPrefixIcon: false,
      controller: startTimeController,
      labelText: "Start Time",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  bool isDateEnabled = true, isStartDateEnabled = true, isEndDateEnabled = true;

  Widget getDateFormField() {
    return getTexFormField(
      onTap: () async {
        isDateEnabled = true;
        mySetState();

        dateController.text = await _selectDate(context);
        isDateEnabled = false;
        mySetState();
      },
      isEnabled: isDateEnabled,
      isMandatory: false,
      showPrefixIcon: false,
      controller: dateController,
      labelText: "Date",
      keyBoardType: TextInputType.text,
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  //region textFieldView
  Widget getTexFormField(
      {TextEditingController? controller,
      String iconUrl = "",
      String? Function(String?)? validator,
      String labelText = "Label",
      Widget? suffixWidget,
      required bool isMandatory,
      int? minLines,
      int? maxLines,
      bool showPrefixIcon = false,
      TextInputType? keyBoardType,
      double iconHeight = 15,
      double iconWidth = 15,
      TextStyle? labelStyle,
      Function()? onTap,
      bool isEnabled = true}) {
    return CommonTextFormFieldWithLabel(
      onTap: onTap,
      labelStyle: labelStyle,
      enabled: isEnabled,
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      floatingLabelColor: Colors.black.withOpacity(.6),
      minLines: minLines,
      maxLines: maxLines,
      borderColor: Styles.textFieldBorderColor,
      enabledBorderColor: Styles.textFieldBorderColor,
      borderWidth: 1,
      isOutlineInputBorder: true,
      keyboardType: keyBoardType,
      prefixWidget: showPrefixIcon
          ? iconUrl.isNotEmpty
              ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
              : const Icon(
                  FontAwesomeIcons.globe,
                  size: 15,
                  color: Colors.grey,
                )
          : null,
      suffixWidget: suffixWidget,
    );
  }

  Widget labelWithStar(String labelText, {TextStyle? style}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: style ?? const TextStyle(color: Colors.grey),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

//endregion
}

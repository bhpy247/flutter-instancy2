import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:provider/provider.dart';

class AddExternalLearningContentDialog extends StatefulWidget {
  final bool isPrefillData;
  final String? url;

  const AddExternalLearningContentDialog({
    super.key,
    this.isPrefillData = false,
    this.url,
  });

  @override
  State<AddExternalLearningContentDialog> createState() => _AddExternalLearningContentDialogState();
}

class _AddExternalLearningContentDialogState extends State<AddExternalLearningContentDialog> with MySafeState {
  late AppProvider appProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey expansionTile = GlobalKey();
  bool isSkillsExpanded = false;
  List<String> selectedSkillsList = [];

  List<String> skillsList = [];

  DateTime? startDateTime;
  DateTime? endDateTime;

  Future<DateTime?> pickDateTime({required DateTime? initialDate}) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    return dateTime;
  }

  Future<void> pickStartDateTime() async {
    DateTime? dateTime = await pickDateTime(initialDate: startDateTime);
    Future.delayed(const Duration(milliseconds: 10), () => FocusScope.of(context).unfocus());

    if (dateTime == null) {
      return;
    }

    startDateTime = dateTime;
    mySetState();
  }

  Future<void> pickEndDateTime() async {
    DateTime? dateTime = await pickDateTime(initialDate: endDateTime);
    Future.delayed(const Duration(milliseconds: 10), () => FocusScope.of(context).unfocus());

    if (dateTime == null) {
      return;
    }

    endDateTime = dateTime;
    mySetState();
  }

  Future<void> onAddContentButtonTap() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    // return;

    Map<String, dynamic> contentMap = <String, dynamic>{
      "Expired": "",
      "ContentStatus": " <span title='Not Started' class='statusComplete'>Not Started</span>",
      "ReportLink":
          "<a class='fa viewicon' href='#' title='Delete' onclick=\"javascript:fnDelete(this,'Please confirm before deleting this content item?',3,688,'131aeefc-ba5f-4063-a1af-3e2246107595',0,'rthsrt','Delete Content');\">Delete</a>",
      "DiscussionsLink": "",
      "CertificateLink": "",
      "NotesLink": "",
      "CancelEventLink": "",
      "DownLoadLink": "",
      "RepurchaseLink": "",
      "SetcompleteLink": "",
      "ViewRecordingLink": "",
      "InstructorCommentsLink": "",
      "Required": 0,
      "DownloadCalender": "",
      "EventScheduleLink": "",
      "EventScheduleStatus": "",
      "EventScheduleConfirmLink": "",
      "EventScheduleCancelLink": "",
      "EventScheduleReserveTime": "",
      "EventScheduleReserveStatus": "",
      "ReScheduleEvent": "",
      "Addorremoveattendees": "",
      "CancelScheduleEvent": "",
      "Sharelink": "https://qalearning.instancy.com/InviteURLID/contentId/131aeefc-ba5f-4063-a1af-3e2246107595/ComponentId/1",
      "SurveyLink": "",
      "RemoveLink":
          "<a id='remove_131aeefc-ba5f-4063-a1af-3e2246107595' title='Delete' href=\"Javascript:fnUnassignUserContent('131aeefc-ba5f-4063-a1af-3e2246107595','Are you sure you want to remove the content item?');\">Delete</a> ",
      "RatingLink": "https://qalearning.instancy.com/MyCatalog Details/Contentid/131aeefc-ba5f-4063-a1af-3e2246107595/componentid/3/componentInstanceID/3134/Muserid/1962",
      "DurationEndDate": null,
      "PracticeAssessmentsAction": "",
      "CreateAssessmentAction": "",
      "OverallProgressReportAction": "",
      "EditLink": "",
      "TitleName": "rthsrt",
      "PercentCompleted": 0.0,
      "PercentCompletedClass": "statusComplete",
      "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
      "CancelOrderData": "",
      "CombinedTransaction": false,
      "EventScheduleType": 0,
      "TypeofEvent": 1,
      "Duration": "",
      "IsViewReview": true,
      "JWVideoKey": "",
      "Credits": "",
      "IsArchived": false,
      "DetailspopupTags": "",
      "ThumbnailIconPath": null,
      "InstanceEventEnroll": "",
      "Modules": "",
      "InstanceEventReSchedule": "",
      "InstanceEventReclass": "",
      "isEnrollFutureInstance": "",
      "ReEnrollmentHistory": "",
      "isBadCancellationEnabled": "true",
      "MediaTypeID": 0,
      "ActionViewQRcode": "",
      "RecordingDetails": null,
      "EnrollmentLimit": null,
      "AvailableSeats": null,
      "NoofUsersEnrolled": null,
      "WaitListLimit": null,
      "WaitListEnrolls": null,
      "isBookingOpened": false,
      "SubSiteMemberShipExpiried": false,
      "ShowLearnerActions": true,
      "SkinID": "",
      "BackGroundColor": "#2f2d3a",
      "FontColor": "#fff",
      "FilterId": 0,
      "SiteId": 374,
      "UserSiteId": 0,
      "SiteName": "Instancy Social Learning Network",
      "ContentTypeId": 688,
      "ContentID": "131aeefc-ba5f-4063-a1af-3e2246107595",
      "Title": "rthsrt&nbsp;&nbsp;&nbsp;",
      "TotalRatings": "0",
      "RatingID": "0",
      "ShortDescription": "",
      "ThumbnailImagePath": "/Content/SiteFiles/Images/External Training.jpg",
      "InstanceParentContentID": "",
      "ImageWithLink": null,
      "AuthorWithLink": "Dishant Agrawal",
      "EventStartDateTime": "",
      "EventEndDateTime": null,
      "EventStartDateTimeWithoutConvert": null,
      "EventEndDateTimeTimeWithoutConvert": null,
      "expandiconpath": null,
      "AuthorDisplayName": "Dishant Agrawal",
      "ContentType": "External Training",
      "CreatedOn": null,
      "TimeZone": null,
      "Tags": null,
      "SalePrice": null,
      "Currency": null,
      "ViewLink": "",
      "DetailsLink": "https://qalearning.instancy.com/MyCatalog Details/Contentid/131aeefc-ba5f-4063-a1af-3e2246107595/componentid/3/componentInstanceID/3134/Muserid/1962",
      "RelatedContentLink": "",
      "ViewSessionsLink": "",
      "SuggesttoConnLink": "131aeefc-ba5f-4063-a1af-3e2246107595",
      "SuggestwithFriendLink": "131aeefc-ba5f-4063-a1af-3e2246107595",
      "SharetoRecommendedLink": null,
      "IsCoursePackage": null,
      "IsRelatedcontent": "",
      "isaddtomylearninglogo": null,
      "LocationName": null,
      "BuildingName": null,
      "JoinURL": null,
      "Categorycolor": "#67BD4E",
      "InvitationURL": null,
      "HeaderLocationName": "none",
      "SubSiteUserID": null,
      "PresenterDisplayName": "",
      "PresenterWithLink": null,
      "ShowMembershipExpiryAlert": false,
      "AuthorName": "Dishant Agrawal",
      "FreePrice": null,
      "SiteUserID": 1962,
      "ScoID": 26689,
      "BuyNowLink": "",
      "bit5": false,
      "bit4": false,
      "OpenNewBrowserWindow": false,
      "salepricestrikeoff": "",
      "CreditScoreWithCreditTypes": null,
      "CreditScoreFirstPrefix": null,
      "EventType": 0,
      "InstanceEventReclassStatus": "",
      "ExpiredContentExpiryDate": "",
      "ExpiredContentAvailableUntill": "",
      "Gradient1": null,
      "Gradient2": null,
      "GradientColor": null,
      "ShareContentwithUser": "",
      "bit1": false,
      "ViewType": 1,
      "startpage": "",
      "CategoryID": 0,
      "AddLinkTitle": null,
      "GoogleProductId": null,
      "ItunesProductId": null,
      "ContentName": "rthsrt",
      "FolderPath": "131AEEFC-BA5F-4063-A1AF-3E2246107595",
      "CloudMediaPlayerKey": "",
      "ActivityId": "http://instancy.com/131aeefc-ba5f-4063-a1af-3e2246107595",
      "ActualStatus": "completed",
      "CoreLessonStatus": " <span title='Not Started' class='statusComplete'>Not Started</span>",
      "jwstartpage": "en-us/131aeefc-ba5f-4063-a1af-3e2246107595.html",
      "IsReattemptCourse": false,
      "AttemptsLeft": 0,
      "TotalAttempts": 0,
      "ListPrice": null,
      "ContentModifiedDateTime": "04/16/2024 02:38:39 PM"
    };

    CourseDTOModel courseDTOModel = CourseDTOModel.fromMap(contentMap);

    courseDTOModel.ContentID = MyUtils.getNewId();
    courseDTOModel.TitleName = titleController.text;
    courseDTOModel.Title = titleController.text;
    courseDTOModel.JoinURL = urlController.text;
    courseDTOModel.ShortDescription = descriptionController.text;

    String dateFormat = appProvider.appSystemConfigurationModel.eventDateTimeFormat;
    courseDTOModel.EventStartDateTime = DatePresentation.getFormattedDate(dateFormat: dateFormat, dateTime: startDateTime) ?? "";
    courseDTOModel.EventEndDateTime = DatePresentation.getFormattedDate(dateFormat: dateFormat, dateTime: endDateTime) ?? "";

    Navigator.pop(context, courseDTOModel);
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    if (widget.isPrefillData) {
      titleController.text = "The Complete 2024 Web Development Bootcamp";
      urlController.text = widget.url ?? "";
      typeController.text = "Udemy";
      descriptionController.text = "Become a Full-Stack Web Developer with just ONE course. HTML, CSS, Javascript, Node, React, PostgreSQL, Web3 and DApps";
      startDateTime = DateTime.now();
      endDateTime = startDateTime!.add(const Duration(days: 15));
    }

    skillsList = <String>[
      "Ability to \"Read\" Customer",
      "Communication",
      "Critical & Analytical Thinking",
      "integrity",
      "Interpersonal Skills And Teamwork",
      "Lifelong Learning",
      "Mobile Learning",
      "Process And Product",
      "Professionalism",
      "Relationship Buliding",
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: themeData.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "External Learning",
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getTextFieldWidget(
                        label: "Title",
                        isRequired: true,
                        textEditingController: titleController,
                        validator: (String? text) {
                          if ((text?.trim()).checkEmpty) {
                            return "Title cannot be empty";
                          }

                          return null;
                        },
                      ),
                      getTextFieldWidget(
                        label: "URL",
                        textEditingController: urlController,
                      ),
                      getTextFieldWidget(
                        label: "Type",
                        textEditingController: typeController,
                      ),
                      getTextFieldWidget(
                        label: "Description",
                        minLines: 5,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        textEditingController: descriptionController,
                      ),
                      getTextFieldWidget(label: "Institution"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Training Dates",
                            style: themeData.textTheme.labelMedium?.copyWith(
                              color: themeData.colorScheme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: getTextFieldWidget(
                                  label: "Start Date",
                                  isRequired: true,
                                  onTap: pickStartDateTime,
                                  textEditingController: TextEditingController(text: DatePresentation.getFormattedDate(dateFormat: "dd/MM/yyyy hh:mm aa", dateTime: startDateTime) ?? ""),
                                  validator: (String? text) {
                                    if ((text?.trim()).checkEmpty) {
                                      return "Start Date cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: getTextFieldWidget(
                                  label: "End Date",
                                  isRequired: true,
                                  onTap: pickEndDateTime,
                                  textEditingController: TextEditingController(text: DatePresentation.getFormattedDate(dateFormat: "dd/MM/yyyy hh:mm aa", dateTime: endDateTime) ?? ""),
                                  validator: (String? text) {
                                    if ((text?.trim()).checkEmpty) {
                                      return "End Date cannot be empty";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      getTextFieldWidget(label: "Credits"),
                      getTextFieldWidget(label: "Training Time"),
                      Row(
                        children: [
                          Expanded(child: getTextFieldWidget(label: "Cost")),
                          const SizedBox(width: 10),
                          Text(
                            "USD",
                            style: themeData.textTheme.labelLarge?.copyWith(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Attechment(s)",
                            style: themeData.textTheme.labelMedium?.copyWith(
                              color: themeData.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: themeData.primaryColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: themeData.colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      "Upload",
                                      style: themeData.textTheme.labelLarge?.copyWith(
                                        color: themeData.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      getSkillsExpansionTile(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            getSubmitButtonsRow(),
          ],
        ),
      ),
    );
  }

  Widget getTextFieldWidget({
    required String label,
    bool isRequired = false,
    TextEditingController? textEditingController,
    int? minLines,
    int? maxLines,
    TextInputType? keyboardType,
    void Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: CommonTextFormFieldWithLabel(
        label: isRequired
            ? RichText(
                text: TextSpan(
                  text: "* ",
                  style: themeData.textTheme.labelLarge?.copyWith(
                    color: Colors.red,
                  ),
                  children: [
                    TextSpan(
                      text: label,
                      style: themeData.textTheme.labelLarge,
                    ),
                  ],
                ),
              )
            : null,
        labelText: !isRequired ? label : null,
        // labelText: "${isRequired ? "* " : ""}$label",
        onTap: onTap,
        controller: textEditingController,
        borderColor: themeData.primaryColor,
        isOutlineInputBorder: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget getSkillsExpansionTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black45),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Theme(
        data: themeData.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: expansionTile,
          backgroundColor: const Color(0xffF8F8F8),
          initiallyExpanded: isSkillsExpanded,
          visualDensity: VisualDensity.compact,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          title: Text(
            "Skills${selectedSkillsList.isNotEmpty ? "(${selectedSkillsList.join(",")})" : ""}",
            style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onExpansionChanged: (bool? newVal) {
            FocusScope.of(context).unfocus();
          },
          children: skillsList.map((String e) {
            return Container(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  bool isChecked = !selectedSkillsList.contains(e);
                  if (isChecked) {
                    selectedSkillsList.add(e);
                  } else {
                    selectedSkillsList.remove(e);
                  }
                  mySetState();
                },
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: themeData.primaryColor,
                      value: selectedSkillsList.contains(e),
                      onChanged: (bool? value) {
                        bool isChecked = value ?? false;
                        if (isChecked) {
                          selectedSkillsList.add(e);
                        } else {
                          selectedSkillsList.remove(e);
                        }
                        mySetState();
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getSubmitButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CommonButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backGroundColor: themeData.colorScheme.onPrimary,
            borderColor: Colors.grey,
            fontColor: Colors.grey,
            fontWeight: FontWeight.w500,
            // isPrimary: false,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            text: "Close",
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: CommonButton(
            onPressed: () {
              onAddContentButtonTap();
            },
            backGroundColor: themeData.primaryColor,
            borderColor: themeData.primaryColor,
            fontColor: themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            // isPrimary: true,
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 7),
            text: "Add",
          ),
        ),
      ],
    );
  }

  Widget getUrlTextFieldWidget() {
    return Column(
      children: [
        Row(
          children: [
            Radio.adaptive(
              value: 0,
              groupValue: 0,
              onChanged: (int? value) {},
              visualDensity: VisualDensity.compact,
            ),
            const Expanded(
              child: Text("URL"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommonTextFormField(
          hintText: "Enter URL",
          borderColor: themeData.primaryColor,
          isOutlineInputBorder: true,
        ),
      ],
    );
  }
}

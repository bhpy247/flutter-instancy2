import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/associated_content_response_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/Catalog/catalog_provider.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/catalog/data_model/associated_content_course_dto_model.dart';
import '../../../models/catalog/request_model/add_associated_content_to_my_learning_request_model.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../my_learning/component/bottom_sheet_view.dart';

class PrerequisiteScreen extends StatefulWidget {
  static const String routeName = "/prerequisites";
  final PreRequisiteScreenNavigationArguments arguments;

  const PrerequisiteScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PrerequisiteScreen> createState() => _PrerequisiteScreenState();
}

class _PrerequisiteScreenState extends State<PrerequisiteScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  Future? getContentData;

  late CatalogProvider catalogProvider;
  late CatalogController catalogController;

  late AppProvider appProvider;

  late int selectedSequencePathId;
  late List<int>? sequencePathIdsList;

  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListRecommended = [];
  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListRequired = [];
  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListCompletion = [];

  String prerequisiteTitle = "";
  AssociatedContentCourseDTOModel parentPreRequisiteModel = AssociatedContentCourseDTOModel();

  Future<void> getAssociatedContentList({
    bool isRefresh = true,
    bool isGetFromCache = true,
    bool isNotify = true,
    required int preRequisiteSequencePathId,
  }) async {
    MyPrint.printOnConsole("preRequisiteSequencePathId:$preRequisiteSequencePathId");

    AssociatedContentResponseModel associatedContentResponse = await catalogController.getAssociatedContent(
      contentId: widget.arguments.contentId,
      componentId: widget.arguments.componentId,
      componentInstanceId: widget.arguments.componentInstanceId,
      preRequisiteSequencePathId: preRequisiteSequencePathId,
    );
    prerequisiteTitle = associatedContentResponse.title;

    parentPreRequisiteModel = associatedContentResponse.Parentcontent;
    if (parentPreRequisiteModel.AssignedContent.isNotEmpty && parentPreRequisiteModel.ExcludeContent.isEmpty) {
      parentPreRequisiteModel.Ischecked = true;
    }

    if (associatedContentResponse.CourseList.isNotEmpty) {
      _prerequisiteModelArrayListRecommended.clear();
      _prerequisiteModelArrayListRequired.clear();
      _prerequisiteModelArrayListCompletion.clear();
      for (AssociatedContentCourseDTOModel preRequisiteData in associatedContentResponse.CourseList) {
        setPrerequisiteModelArrayListRecommended(prerequisiteModelList: preRequisiteData, prerequisites: preRequisiteData.Prerequisites);
      }
    }
    MyPrint.printOnConsole("length of the _prerequisiteModelArrayListRecommended ${_prerequisiteModelArrayListRecommended.length}");
    MyPrint.printOnConsole(
        "length of the _prerequisiteModelArrayListRe bg6yuuuygttggggggggggggggggggggggggggquired ${_prerequisiteModelArrayListRequired.length}");
    MyPrint.printOnConsole("length of the _prerequisiteModelArrayListCompletion ${_prerequisiteModelArrayListCompletion.length}");
  }

  void showBottomSheet(List<AssociatedContentCourseDTOModel> selectedPrerequisites) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String data = appProvider.localStr.prerequisiteParentEnrollAlert
            .replaceFirst('\$\$prerequistedateconflictname\$\$', "")
            .replaceFirst("Pre-Requisite course:", "")
            .replaceFirst("on", "")
            .replaceFirst('\$\$prerequistedateconflicteventdate\$\$', "")
            .replaceAll("<br>", "");
        List<String> bottomLine = appProvider.localStr.prerequisiteParentEnrollAlert.split("<br><br>");
        String nameSplit = bottomLine.last.split("<br>").last;
        String date = nameSplit
            .replaceFirst('\$\$prerequistedateconflictname\$\$', selectedPrerequisites.first.Title)
            .replaceFirst('\$\$prerequistedateconflicteventdate\$\$', selectedPrerequisites.first.EventEndDateTime);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(data)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Please choose a new date/time",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Text("${data}", style: TextStyle(fontSize: 16)),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
              child: Text(
                // "${appProvider.localStr.prerequisiteParentEnrollAlert.replaceFirst('\$\$prerequistedateconflictname\$\$', "").replaceFirst('\$\$prerequistedateconflicteventdate\$\$', selectedPrerequisites.first.EventEndDateTime).replaceAll("<br>", "")}",
                "${bottomLine.last.split("<br>").first}\n${date}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  void setPrerequisiteModelArrayListRecommended({required AssociatedContentCourseDTOModel prerequisiteModelList, int prerequisites = 0}) {
    if (prerequisites == 1) {
      //recommended
      _prerequisiteModelArrayListRecommended.add(prerequisiteModelList);
    } else if (prerequisites == 2) {
      //required
      _prerequisiteModelArrayListRequired.add(prerequisiteModelList);
    } else if (prerequisites == 3) {
      //completion
      _prerequisiteModelArrayListCompletion.add(prerequisiteModelList);
    }
    mySetState();
  }

  Future<void> addMainContentToMyLearning(AssociatedContentCourseDTOModel parentPreRequisiteModel) async {
    List<AssociatedContentCourseDTOModel> allPrerequisites = [
      ..._prerequisiteModelArrayListRecommended,
      ..._prerequisiteModelArrayListRequired,
      ..._prerequisiteModelArrayListCompletion,
    ];

    if (parentPreRequisiteModel.ContentTypeId == InstancyObjectTypes.events) {
      DateTime? PartentCourseStartDate = ParsingHelper.parseDateTimeMethod(parentPreRequisiteModel.EventStartDateTime,
          dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat);
      if (PartentCourseStartDate != null) {
        List<AssociatedContentCourseDTOModel> selectedPrerequisites = allPrerequisites.where((AssociatedContentCourseDTOModel courseDTOModel) {
          if (courseDTOModel.ContentTypeId == InstancyObjectTypes.events) {
            DateTime? recommendedCourseEndDate =
                ParsingHelper.parseDateTimeMethod(courseDTOModel.EventEndDateTime, dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat);

            if (recommendedCourseEndDate != null &&
                (recommendedCourseEndDate.isAfter(PartentCourseStartDate) || DatePresentation.isSameDay(recommendedCourseEndDate, PartentCourseStartDate))) {
              return true;
            }
          }

          return false;
        }).toList();

        if (selectedPrerequisites.isNotEmpty) {
          MyPrint.printOnConsole("appProvider.localStr.prerequisiteParentEnrollAlert : ${appProvider.localStr.prerequisiteParentEnrollAlert}");
          MyPrint.printOnConsole("selectedPrerequisites.first.Title : ${selectedPrerequisites.first.Title}");
          MyPrint.printOnConsole("selectedPrerequisites.first.EventEndDateTime : ${selectedPrerequisites.first.EventEndDateTime}");
          // add dialog here
          // .
          showBottomSheet(selectedPrerequisites);
          // MyToast.showError(
          //   context: context,
          //   msg: appProvider.localStr.prerequisiteParentEnrollAlert
          //       .replaceFirst('\$\$prerequistedateconflictname\$\$', selectedPrerequisites.first.Title)
          //       .replaceFirst('\$\$prerequistedateconflicteventdate\$\$', selectedPrerequisites.first.EventEndDateTime)
          //       .replaceAll("<br>", ""),
          // );
          return;
        }
      }
    }

    bool doNotAllowPrerequisiteDesiredContent = ParsingHelper.parseBoolMethod(AppSystemConfigurationModel().doNotAllowPrerequisiteDesiredContent);

    String strContentIDs = "";
    String multiinstanceswithprice = "";
    String multiinstancesWaitlistContentIDs = "";
    bool IsRequiredwithcart = false;

    for (AssociatedContentCourseDTOModel prerequisiteModel in allPrerequisites) {
      //Check 1
      if (parentPreRequisiteModel.Ischecked) {
        if ([InstancyContentPrerequisiteType.required, InstancyContentPrerequisiteType.completion].contains(prerequisiteModel.Prerequisites) &&
            !prerequisiteModel.Ischecked &&
            (doNotAllowPrerequisiteDesiredContent || !prerequisiteModel.NoInstanceAvailable)) {
          if (prerequisiteModel.Prerequisites == InstancyContentPrerequisiteType.required) {
            MyToast.showError(
              context: context,
              msg: appProvider.localStr.associateRequiredPrerequisitesAlert.replaceFirst('\$\$DesiredContentName\$\$', prerequisiteTitle),
            );
          } else {
            MyToast.showError(
              context: context,
              msg: appProvider.localStr.associateRequiredCompletionAlert.replaceFirst('\$\$DesiredContentName\$\$', prerequisiteTitle),
            );
          }
          return;
        }
      }

      //Check 2
      if (prerequisiteModel.ContentTypeId == InstancyObjectTypes.events && prerequisiteModel.Ischecked && !prerequisiteModel.IsLearnerContent) {
        bool isMultiInstanceEnrollmentAlertShow = false;

        if (prerequisiteModel.NoInstanceAvailable && doNotAllowPrerequisiteDesiredContent) {
          isMultiInstanceEnrollmentAlertShow = true;
        }

        if (!isMultiInstanceEnrollmentAlertShow &&
            prerequisiteModel.EventScheduleType == "1" &&
            !prerequisiteModel.NoInstanceAvailable &&
            prerequisiteModel.EventselectedinstanceID.isEmpty) {
          isMultiInstanceEnrollmentAlertShow = true;
        }

        if (isMultiInstanceEnrollmentAlertShow) {
          MyToast.showError(
            context: context,
            msg: appProvider.localStr.associateMultiInstanceNotEnrollAlert,
          );
          // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Associate_MultiinstancenotEnrollalert'));
          return;
        }
      }

      //Check 3
      if (prerequisiteModel.Ischecked && !prerequisiteModel.IsLearnerContent && prerequisiteModel.PrerequisitehavingPrerequisites.isNotEmpty) {
        List<String> prerequisites = prerequisiteModel.PrerequisitehavingPrerequisites.split(',');
        int contentHavePrerequisiteCount = 0;
        for (String prerequisiteId in prerequisites) {
          for (AssociatedContentCourseDTOModel childPrerequisiteModel in allPrerequisites) {
            if (childPrerequisiteModel.ContentID == prerequisiteId && childPrerequisiteModel.Ischecked == false) {
              MyToast.showError(
                context: context,
                msg: appProvider.localStr.prerequisitePrerequisiteAlert.replaceFirst('\$\$Tile\$\$', prerequisiteModel.Title),
              );
              // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Prerequisite_prerequisitealert').replace('$$Tile$$', this.RecommendedPrerequisites[i].Title));
              return;
            } else if (childPrerequisiteModel.ContentID == prerequisiteId) {
              contentHavePrerequisiteCount++;
            }
          }
        }

        if (contentHavePrerequisiteCount == 0) {
          MyToast.showError(
            context: context,
            msg: appProvider.localStr.prerequisitePrerequisiteAlert.replaceFirst('\$\$Tile\$\$', prerequisiteModel.Title),
          );
          // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Prerequisite_prerequisitealert').replace('$$Tile$$', this.RecommendedPrerequisites[i].Title));
          return;
        }
      }

      //Check 4
      if (prerequisiteModel.ContentTypeId == InstancyObjectTypes.events && prerequisiteModel.Ischecked && prerequisiteModel.EventScheduleType == "1") {
        if (prerequisiteModel.NoInstanceAvailable && AppSystemConfigurationModel().doNotAllowPrerequisiteDesiredContent) {
          MyToast.showError(
            context: context,
            msg: appProvider.localStr.associateEventDateIsNotAvailable,
          );
          // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Associate_Eventdateisnotavailable'));
          return;
        }

        if (!prerequisiteModel.NoInstanceAvailable && prerequisiteModel.EventselectedinstanceID.isEmpty) {
          MyToast.showError(
            context: context,
            msg: appProvider.localStr.associateMultiInstanceNotEnrollAlert,
          );
          // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Associate_MultiinstancenotEnrollalert'));
          return;
        }
      }

      /*if(!this.Checkparentdata())  {
        return false;
      }*/

      //Check 5
      List<AssociatedContentCourseDTOModel> models = allPrerequisites.where((element) {
        return !element.IsLearnerContent &&
            element.PrerequisitehavingPrerequisites1.isNotEmpty &&
            prerequisiteModel.ContentTypeId == InstancyObjectTypes.events &&
            element.EventScheduleType != '1' &&
            [InstancyContentPrerequisiteType.required, InstancyContentPrerequisiteType.completion].contains(element.Prerequisites);
      }).toList();
      for (AssociatedContentCourseDTOModel model in models) {
        if (!CheckEnrolledChildsDateConflict(model)) {
          return;
        }
      }

      //Check 6
      PrerequisiteEnrolledDTOModel? prerequisiteEnrolledContent = prerequisiteModel.PrerequisiteEnrolledContent;
      if (prerequisiteEnrolledContent != null &&
          (prerequisiteEnrolledContent.ShowPrerequisiteEventDate || prerequisiteEnrolledContent.ShowParentPrerequisiteEventDate)) {
        CheckEnrolledChildsConfictDate(course: prerequisiteEnrolledContent);
        return;
      }

      if (prerequisiteModel.Ischecked && !prerequisiteModel.IsLearnerContent && !prerequisiteModel.NoInstanceAvailable) {
        if (prerequisiteModel.SalePrice.isNotEmpty &&
            [InstancyContentPrerequisiteType.required, InstancyContentPrerequisiteType.completion].contains(prerequisiteModel.ContentTypeId)) {
          IsRequiredwithcart = true;
        }

        bool isPrerequisiteContentTypeEvent = prerequisiteModel.ContentTypeId == InstancyObjectTypes.events;
        bool isEventScheduleType1 = prerequisiteModel.EventScheduleType == '1';
        bool isEventselectedinstanceIDNotEmpty = prerequisiteModel.EventselectedinstanceID.isNotEmpty;
        bool isSalesPriceNotEmpty = prerequisiteModel.SalePrice.isNotEmpty;
        if (isPrerequisiteContentTypeEvent && isEventScheduleType1 && isEventselectedinstanceIDNotEmpty && isSalesPriceNotEmpty) {
          multiinstanceswithprice += '${prerequisiteModel.EventselectedinstanceID}\$';
        } else if (isPrerequisiteContentTypeEvent && isEventScheduleType1 && isEventselectedinstanceIDNotEmpty) {
          if (isEventselectedinstanceIDNotEmpty && prerequisiteModel.ActionName.toLowerCase() == 'enroll') {
            strContentIDs += '${prerequisiteModel.EventselectedinstanceID}\$';
          } else if (isEventselectedinstanceIDNotEmpty && prerequisiteModel.ActionName.toLowerCase() == 'waitlist') {
            multiinstancesWaitlistContentIDs += '${prerequisiteModel.EventselectedinstanceID}\$';
          }
        } else {
          if (isPrerequisiteContentTypeEvent && !isEventScheduleType1 && prerequisiteModel.ActionName.toLowerCase() == 'waitlist') {
            multiinstancesWaitlistContentIDs += '${prerequisiteModel.ContentID}\$';
          } else {
            strContentIDs += '${prerequisiteModel.ContentID}\$';
          }
        }
      }
    }

    AddAssociatedContentToMyLearningRequestModel requestModel = AddAssociatedContentToMyLearningRequestModel(
      SelectedContent: strContentIDs,
      AddMultiinstanceswithprice: multiinstanceswithprice,
      AddWaitlistContentIDs: multiinstancesWaitlistContentIDs,
      MultiInstanceEventEnroll: "",
    );

    /*Map<String, dynamic> obj = {
      "actionName": parentPreRequisiteModel.ActionName,
      "ContentIDs": strContentIDs,
      "Multiinstanceswithprice": multiinstanceswithprice,
      "RequiredContentWithPrice": IsRequiredwithcart,
      "WaitlistContentIDs": multiinstancesWaitlistContentIDs,
    };*/

    String addtoLearnerPreRequisiteContent = "";
    if (parentPreRequisiteModel.ActionName == 'addlink' && IsRequiredwithcart && parentPreRequisiteModel.Ischecked) {
      if (parentPreRequisiteModel.ContentTypeId == InstancyObjectTypes.events && parentPreRequisiteModel.EventScheduleType == '1') {
        addtoLearnerPreRequisiteContent = parentPreRequisiteModel.EventselectedinstanceID;
      } else {
        addtoLearnerPreRequisiteContent = parentPreRequisiteModel.ContentID;
      }
    } else if (parentPreRequisiteModel.Ischecked && !parentPreRequisiteModel.IsLearnerContent && parentPreRequisiteModel.ActionName != 'waitlist') {
      requestModel.SelectedContent += parentPreRequisiteModel.ContentID;
    } else if (parentPreRequisiteModel.Ischecked && !parentPreRequisiteModel.IsLearnerContent && parentPreRequisiteModel.ActionName == 'waitlist') {
      requestModel.AddWaitlistContentIDs += parentPreRequisiteModel.ContentID;
    }
    requestModel.AddLearnerPreRequisiteContent = addtoLearnerPreRequisiteContent;

    isLoading = true;
    mySetState();

    bool isAdded = await catalogController.addAssociatedContentToMyLearning(requestModel: requestModel, context: context);

    isLoading = false;
    mySetState();

    if (isAdded && pageMounted && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  bool CheckEnrolledChildsDateConflict(AssociatedContentCourseDTOModel model) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CheckEnrolledChildsDateConflict called for ContentId:${model.ContentID}", tag: tag);

    if (model.ContentTypeId == InstancyObjectTypes.events) {
      if (!model.IsLearnerContent && model.PrerequisitehavingPrerequisites1.isNotEmpty) {
        MyPrint.printOnConsole("Content have Prerequisites", tag: tag);

        List<String> prerequisitesIds = model.PrerequisitehavingPrerequisites1.split(',');
        MyPrint.printOnConsole("prerequisitesIds:$prerequisitesIds", tag: tag);

        List<AssociatedContentCourseDTOModel> allPrerequisites = [
          ..._prerequisiteModelArrayListRecommended,
          ..._prerequisiteModelArrayListRequired,
          ..._prerequisiteModelArrayListCompletion,
        ];

        for (String prerequisiteId in prerequisitesIds) {
          //region Check if the content is Event and Any (required or completion) prerequisite Event is having a Enddate after start date of content
          //if found, show error
          List<AssociatedContentCourseDTOModel> contents = allPrerequisites.where((AssociatedContentCourseDTOModel prerequisiteModel) {
            if (prerequisiteModel.ContentID == prerequisiteId &&
                prerequisiteModel.ContentTypeId == InstancyObjectTypes.events &&
                [InstancyContentPrerequisiteType.required, InstancyContentPrerequisiteType.completion].contains(prerequisiteModel.Prerequisites)) {
              DateTime? contentStartDate = ParsingHelper.parseDateTimeMethod(model.EventStartDateTime);
              DateTime? recommendedCourseEndDate = ParsingHelper.parseDateTimeMethod(prerequisiteModel.EventEndDateTime);

              if (contentStartDate != null && recommendedCourseEndDate != null && contentStartDate.isBefore(recommendedCourseEndDate)) {
                return true;
              }
            }

            return false;
          }).toList();
          if (contents.isNotEmpty) {
            // this.RelatedprerequisiteDesiredContent_alert = this.LocalizationKeys.Prerequisite_parent_enroll_alert.replace("$$prerequistedateconflictname$$", this.recommendedCourseDateConflictTile).replace("$$prerequistedateconflicteventdate$$", this.recommendedCourseDateConflictEndDate)
            MyToast.showError(
              context: context,
              msg: AppProvider()
                  .localStr
                  .prerequisiteParentEnrollAlert
                  .replaceFirst('\$\prerequistedateconflictname\$\$', contents.first.Title)
                  .replaceFirst('\$\prerequistedateconflicteventdate\$\$', contents.first.EventEndDateTime),
            );
            return false;
          }
          //endregion
        }
      }
    }
    return true;
  }

  Future<void> addChildItemToMyLearning(AssociatedContentCourseDTOModel model) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("addChildItemToMyLearning called for ContentId:${model.ContentID}", tag: tag);

    if (ApiController().apiDataProvider.getCurrentUserId() == -1) {
      MyPrint.printOnConsole("returning from addChildItemToMyLearning because Logged in UserId is -1", tag: tag);
      return;
    }

    try {
      if (!model.IsLearnerContent && model.PrerequisitehavingPrerequisites1.isNotEmpty) {
        MyPrint.printOnConsole("Content have Prerequisites", tag: tag);

        List<String> prerequisitesIds = model.PrerequisitehavingPrerequisites1.split(',');
        MyPrint.printOnConsole("prerequisitesIds:$prerequisitesIds", tag: tag);

        List<AssociatedContentCourseDTOModel> allPrerequisites = [
          ..._prerequisiteModelArrayListRecommended,
          ..._prerequisiteModelArrayListRequired,
          ..._prerequisiteModelArrayListCompletion,
        ];

        for (String prerequisiteId in prerequisitesIds) {
          //region Check for prerequisite in allPrerequisites which is parentcontent and is not added to my learning, if found, show error
          List<AssociatedContentCourseDTOModel> notEnrolledPrerequisiteContents = allPrerequisites.where((element) {
            return element.ContentID == prerequisiteId && !element.IsLearnerContent;
          }).toList();
          MyPrint.printOnConsole("notEnrolledPrerequisiteContents length prerequisiteId '$prerequisiteId':${notEnrolledPrerequisiteContents.length}", tag: tag);

          if (notEnrolledPrerequisiteContents.isNotEmpty) {
            // this.toastr.warning(this.CommonUtilites.GetLocalizationString('Prerequisite_prerequisitealert').replace('$$Tile$$', ContentData.Title));
            // MyToast.showSuccess(context: context, msg: "${model.Title} have prerequisite");
            MyToast.showError(context: context, msg: appProvider.localStr.prerequisitePrerequisiteAlert.replaceFirst('\$\$Tile\$\$', model.Title));
            return;
          }
          //endregion

          //region Check if the content is Event and Any (required or completion) prerequisite Event is having a Enddate after start date of content
          //if found, show error
          MyPrint.printOnConsole("ContentTypeId:${model.ContentTypeId}", tag: tag);
          if (model.ContentTypeId == InstancyObjectTypes.events) {
            List<AssociatedContentCourseDTOModel> contents = allPrerequisites.where((AssociatedContentCourseDTOModel prerequisiteModel) {
              if (prerequisiteModel.ContentID == prerequisiteId &&
                  prerequisiteModel.ContentTypeId == InstancyObjectTypes.events &&
                  [InstancyContentPrerequisiteType.required, InstancyContentPrerequisiteType.completion].contains(prerequisiteModel.Prerequisites)) {
                DateTime? contentStartDate = ParsingHelper.parseDateTimeMethod(model.EventStartDateTime);
                DateTime? recommendedCourseEndDate = ParsingHelper.parseDateTimeMethod(prerequisiteModel.EventEndDateTime);

                if (contentStartDate != null && recommendedCourseEndDate != null && contentStartDate.isBefore(recommendedCourseEndDate)) {
                  return true;
                }
              }

              return false;
            }).toList();
            if (contents.isNotEmpty) {
              // this.RelatedprerequisiteDesiredContent_alert = this.LocalizationKeys.Prerequisite_parent_enroll_alert.replace("$$prerequistedateconflictname$$", this.recommendedCourseDateConflictTile).replace("$$prerequistedateconflicteventdate$$", this.recommendedCourseDateConflictEndDate)
              MyToast.showError(
                context: context,
                msg: appProvider.localStr.prerequisiteParentEnrollAlert
                    .replaceFirst('\$\prerequistedateconflictname\$\$', contents.first.Title)
                    .replaceFirst('\$\prerequistedateconflicteventdate\$\$', contents.first.EventEndDateTime),
              );
              return;
            }
          }
          //endregion
        }
      } else {
        MyPrint.printOnConsole("Content don't have any Prerequisites", tag: tag);
      }

      PrerequisiteEnrolledDTOModel? prerequisiteEnrolledContent = model.PrerequisiteEnrolledContent;
      if (prerequisiteEnrolledContent != null &&
          (prerequisiteEnrolledContent.ShowPrerequisiteEventDate || prerequisiteEnrolledContent.ShowParentPrerequisiteEventDate)) {
        CheckEnrolledChildsConfictDate(course: prerequisiteEnrolledContent);
        return;
      }

      isLoading = true;
      mySetState();

      bool isAdded = await catalogController.addContentToMyLearning(
        context: context,
        requestModel: AddContentToMyLearningRequestModel(
          SelectedContent: model.ContentID,
          ERitems: "",
          HideAdd: "",
          AdditionalParams: "",
          TargetDate: "",
          MultiInstanceEventEnroll: "",
          ComponentID: widget.arguments.componentId,
          ComponentInsID: widget.arguments.componentInstanceId,
        ),
        hasPrerequisites: model.hasPrerequisiteContents(),
        isShowToast: true,
        isWaitForOtherProcesses: true,
      );
      MyPrint.printOnConsole("isAdded:$isAdded");

      isLoading = false;
      mySetState();

      if (isAdded) {
        getContentData = getAssociatedContentList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: false,
          preRequisiteSequencePathId: selectedSequencePathId,
        );
        mySetState();
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in PrerequisiteScreen.addChildItemToMyLearning:$e");
      MyPrint.printOnConsole(s);
    }
  }

  void CheckEnrolledChildsConfictDate({required PrerequisiteEnrolledDTOModel course}) {
    if (course.ShowParentPrerequisiteEventDate.toString().toLowerCase() == 'true') {
      MyToast.showError(
        context: context,
        msg: appProvider.localStr.prerequisiteParentEnrollAlert
            .replaceFirst('\$\prerequistedateconflictname\$\$', course.PrerequisiteDateConflictName)
            .replaceFirst('\$\prerequistedateconflicteventdate\$\$', course.PrerequisiteDateConflictName),
      );
    } else if (course.ShowPrerequisiteEventDate.toString().toLowerCase() == 'true') {
      MyToast.showError(
          context: context,
          msg: appProvider.localStr.prerequisiteParentEnrollAlert
              .replaceFirst('\$\prerequistedateconflictname\$\$', course.PrerequisiteDateConflictName)
              .replaceFirst('\$\prerequistedateconflicteventdate\$\$', course.PrerequisiteDateConflictName));
    }
  }

  Future<void> onDetailsTap({required AssociatedContentCourseDTOModel model}) async {
    NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: model.ContentID,
        componentId: widget.arguments.componentId,
        componentInstanceId: widget.arguments.componentInstanceId,
        userId: ApiController().apiDataProvider.getCurrentUserId(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    catalogProvider = Provider.of<CatalogProvider>(context, listen: false);
    catalogController = CatalogController(provider: catalogProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);

    selectedSequencePathId = widget.arguments.selectedSequencePathId;
    sequencePathIdsList = widget.arguments.sequencePathIdsList;

    getContentData = getAssociatedContentList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: false,
      preRequisiteSequencePathId: selectedSequencePathId,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    themeData = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppConfigurations().commonAppBar(
          title: "Pre-requisites Content",
        ),
        bottomNavigationBar: addBottomRow(),
        body: AppUIComponents.getBackGroundBordersRounded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              getMainWidget(),
              getBackwardButton(),
              getForwardButton(),
            ],
          ),
          context: context,
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return FutureBuilder(
      future: getContentData,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              getParentWidget(),
              const Divider(
                height: 1,
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      getRecommendedListView(),
                      getRequiredListView(),
                      getCompletionListView(),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const CommonLoader();
        }
      },
    );
  }

  Widget getBackwardButton() {
    if ((sequencePathIdsList?.length ?? 0) > 1 && sequencePathIdsList!.indexOf(selectedSequencePathId) > 0) {
      return Positioned(
        left: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                selectedSequencePathId = sequencePathIdsList![sequencePathIdsList!.indexOf(selectedSequencePathId) - 1];
                getContentData = getAssociatedContentList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: false,
                  preRequisiteSequencePathId: selectedSequencePathId,
                );
                mySetState();
              },
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 2)]),
                height: 30,
                width: 30,
                child: const Icon(Icons.arrow_back_ios_outlined, size: 15),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getForwardButton() {
    if ((sequencePathIdsList?.length ?? 0) > 1 && sequencePathIdsList!.indexOf(selectedSequencePathId) < sequencePathIdsList!.length - 1) {
      return Positioned(
        right: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                selectedSequencePathId = sequencePathIdsList![sequencePathIdsList!.indexOf(selectedSequencePathId) + 1];
                getContentData = getAssociatedContentList(
                  isRefresh: true,
                  isGetFromCache: false,
                  isNotify: false,
                  preRequisiteSequencePathId: selectedSequencePathId,
                );
                mySetState();
              },
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 2)]),
                height: 30,
                width: 30,
                child: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getParentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ).copyWith(top: 18),
      child: PreRequisiteComponent(
        model: parentPreRequisiteModel,
        isChecked: parentPreRequisiteModel.Ischecked,
        onChecked: (bool val) {
          parentPreRequisiteModel.Ischecked = val;
          mySetState();
        },
        onDetailsTap: () {
          onDetailsTap(model: parentPreRequisiteModel);
        },
        onAddToMyLearningTap: () {
          addMainContentToMyLearning(parentPreRequisiteModel);
        },
      ),
    );
  }

  Widget getRecommendedListView() {
    return Container(
      child: getCommonListWidgetWithHeader(
        header: "Recommended",
        prerequisiteModelList: _prerequisiteModelArrayListRecommended,
      ),
    );
  }

  Widget getRequiredListView() {
    return Container(
      child: getCommonListWidgetWithHeader(
        header: "Required",
        prerequisiteModelList: _prerequisiteModelArrayListRequired,
      ),
    );
  }

  Widget getCompletionListView() {
    return Container(
      child: getCommonListWidgetWithHeader(
        header: "Completion",
        prerequisiteModelList: _prerequisiteModelArrayListCompletion,
      ),
    );
  }

  //region commonListWidgetWithHeader
  Widget getCommonListWidgetWithHeader({required String header, required List<AssociatedContentCourseDTOModel> prerequisiteModelList}) {
    if (prerequisiteModelList.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        headerText(header),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
          child: ListView.builder(
            itemCount: prerequisiteModelList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              AssociatedContentCourseDTOModel model = prerequisiteModelList[index];

              return PreRequisiteComponent(
                model: model,
                isChecked: model.Ischecked,
                onChecked: (bool val) {
                  model.Ischecked = val;
                  mySetState();
                },
                onAddToMyLearningTap: () {
                  addChildItemToMyLearning(model);
                },
                onDetailsTap: () {
                  onDetailsTap(model: model);
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget headerText(String header) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
      width: double.infinity,
      color: const Color(0xff1a4f831a),
      child: Text(
        "Pre-requisite ($header)",
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: .3),
      ),
    );
  }

  Widget addBottomRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CommonButton(
              minWidth: 110,
              padding: null,
              onPressed: () {
                addMainContentToMyLearning(parentPreRequisiteModel);
              },
              text: "Add (Selected)",
              fontSize: 13,
              backGroundColor: Colors.white,
              fontColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
            ),
            CommonButton(
              minWidth: 110,
              padding: null,
              fontSize: 13,
              onPressed: () {
                for (AssociatedContentCourseDTOModel element in [
                  ..._prerequisiteModelArrayListRecommended,
                  ..._prerequisiteModelArrayListRequired,
                  ..._prerequisiteModelArrayListCompletion,
                ]) {
                  element.Ischecked = true;
                }
                mySetState();
                addMainContentToMyLearning(parentPreRequisiteModel);
              },
              text: "Add All",
              fontColor: Colors.white,
              fontWeight: FontWeight.w600,
              backGroundColor: themeData.primaryColor,
              borderColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }

//endregion
}

class PreRequisiteComponent extends StatefulWidget {
  final AssociatedContentCourseDTOModel model;
  final int componentInstanceId, componentId;
  final CatalogProvider? catalogProvider;
  final void Function(bool) onChecked;
  final bool isChecked;

  final Function()? onAddToMyLearningTap, onViewTap, onMoreButtonTap, onDetailsTap;

  const PreRequisiteComponent({
    Key? key,
    required this.model,
    this.componentId = 0,
    required this.isChecked,
    required this.onChecked,
    this.componentInstanceId = 0,
    this.catalogProvider,
    this.onAddToMyLearningTap,
    this.onViewTap,
    this.onMoreButtonTap,
    this.onDetailsTap,
  }) : super(key: key);

  @override
  State<PreRequisiteComponent> createState() => _PreRequisiteComponentState();
}

class _PreRequisiteComponentState extends State<PreRequisiteComponent> {
  late ThemeData themeData;
  late AppProvider appProvider;

  //region BottomSheetView
  void showModalBottomSheetView({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetView();
      },
    );
  }

  //endregion
  String getAddToMyLearningDetails(AssociatedContentCourseDTOModel? model) {
    String result = "";
    if (!(model?.IsLearnerContent ?? false)) {
      if (model?.ContentTypeId == null || model?.ContentTypeId != InstancyObjectTypes.events) {
        result = appProvider.localStr.catalogActionsheetAddtomylearningoption;
      } else {
        result = appProvider.localStr.eventsActionsheetEnrolloption;
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return InkWell(
      onTap: () {
        NavigationController.navigateToCourseDetailScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: CourseDetailScreenNavigationArguments(
            contentId: widget.model.ContentID,
            componentId: widget.componentId,
            componentInstanceId: widget.componentInstanceId,
            userId: 1,
          ),
        );
      },
      child: getParentContentCard(
        themeData: themeData,
        onAddToMyLearningTap: () {},
        onChecked: widget.onChecked,
        ContentID: widget.model.ContentID,
        authorname: widget.model.AuthorDisplayName,
        contentType: widget.model.ContentType,
        ContentTypeId: widget.model.ContentTypeId,
        createdOn: widget.model.CreatedOn,
        imageUrl: widget.model.ThumbnailImagePath,
        isChecked: widget.isChecked,
        IsLearnerContent: widget.model.IsLearnerContent,
        name: widget.model.Title,
      ),
    );
  }

  //region imageView
  Widget imageWidget(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //endregionView
  Widget getParentContentCard({
    String ContentID = "",
    String name = "",
    String imageUrl = "",
    bool isChecked = false,
    required ThemeData themeData,
    required void Function(bool) onChecked,
    String authorname = "",
    String createdOn = "",
    String contentType = "",
    bool IsLearnerContent = false,
    int? ContentTypeId,
    required void Function() onAddToMyLearningTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: <Widget>[
            imageWidget(widget.model.ThumbnailImagePath),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                // color: Colors.green,
                height: 30,
                width: 30,
                child: Checkbox(
                  activeColor: const Color(0xff3A3A3A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  value: widget.model.Ischecked,
                  onChanged: (widget.model.ExcludeContent.isNotEmpty || widget.model.AssignedContent.isEmpty)
                      ? null
                      : (val) {
                          onChecked(val ?? false);
                          // setState(() {
                          //     parentcontent.Ischecked = val ?? false;
                          //   });
                        },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(child: detailColumn(themeData: themeData)),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //           padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        //           child: Text(
        //             name,
        //             //parentcontent.title,
        //             style: const TextStyle(
        //                 color:Colors.black,
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 16.0),
        //           )),
        //       Padding(
        //           padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        //           child: Row(
        //             children: [
        //               const Text(
        //                 'Author: ',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.black),
        //               ),
        //               Text(
        //                 authorname,
        //                 style: const TextStyle(
        //                     color: Colors.black),
        //               ),
        //             ],
        //           )),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 10.0),
        //         child: Row(
        //           children: [
        //             const Text(
        //               'Created on: ',
        //               style: TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black),
        //             ),
        //             Text(
        //               createdOn,
        //               style: const TextStyle(
        //                   color: Colors.black),
        //             )
        //           ],
        //         ),
        //       ),
        //       Padding(
        //           padding: const EdgeInsets.only(left: 10.0),
        //           child: Row(
        //             children: [
        //               const Text(
        //                 'Content Type: ',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.black),
        //               ),
        //               Text(
        //                 contentType,
        //                 style: const TextStyle(
        //                     color: Colors.black),
        //               ),
        //             ],
        //           )),
        //       IsLearnerContent
        //           ? const Padding(
        //         padding: EdgeInsets.only(left: 10.0),
        //         child: Text(
        //           "Already in your 'My Learning' ",
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black),
        //         ),
        //       )
        //           : Container(),
        //       Padding(
        //         padding: const EdgeInsets.all(10.0),
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: getCardActionButton(
        //                 text: "Details",
        //                 onTap: () {
        //                   // navigateToPrerequisiteDetailScreen(ContentID);
        //                 },
        //               ),
        //             ),
        //             if(!IsLearnerContent) Expanded(
        //               child: getCardActionButton(
        //                 text: ContentTypeId == null || InstancyContentType.getContentType(objecttypeid: ContentTypeId).type != InstancyContentTypeEnum.Event
        //                     ? "Add to my learning"
        //                     : "Enroll",
        //                 onTap: () {
        //                   onAddToMyLearningTap();
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }

  //region detailsView
  Widget detailColumn({required ThemeData themeData}) {
    // MyPrint.printOnConsole("askfhbakjb: ${model.name}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  coursesIcon(
                      assetName: AppConfigurations.getContentIconFromObjectAndMediaType(
                          mediaTypeId: widget.model.MediaTypeID, objectTypeId: widget.model.ContentTypeId)),
                  const SizedBox(width: 10),
                  Text(
                    widget.model.ContentType,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff757575)),
                  )
                ],
              ),
            ),
            threeVerticalDots()
          ],
        ),
        const SizedBox(height: 0),
        Text(
          widget.model.Title,
          style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F)),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.AuthorDisplayName,
                    style: themeData.textTheme.bodySmall?.copyWith(fontSize: 12, color: const Color(0xff9AA0A6)),
                  ),
                  const SizedBox(height: 8),
                  ratingView(ParsingHelper.parseDoubleMethod(2.2)),
                  eventStartDateAndTime(model: widget.model, context: context),
                  getContentNotAvailableText(
                    contentTypeId: widget.model.ContentTypeId,
                    excludedContent: widget.model.ExcludeContent,
                    assignedContent: widget.model.AssignedContent,
                  ),
                  Row(
                    children: [
                      getDetailsButton(model: widget.model),
                      getAddToMyLearningButton(model: widget.model),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget getContentNotAvailableText({required String excludedContent, required String assignedContent, required int contentTypeId}) {
    if (excludedContent.isNotEmpty || assignedContent.isEmpty) {
      String text = "";
      if (contentTypeId == InstancyObjectTypes.events) {
        text = appProvider.localStr.prerequisiteEventNotAvailable;
        if (text.isEmpty) text = "This event is not available for enrollment";
      } else {
        text = appProvider.localStr.prerequisiteContentNotAvailable;
        if (text.isEmpty) text = "This content is not available for add to mylearning";
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text,
          style: themeData.textTheme.labelSmall?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget getDetailsButton({required AssociatedContentCourseDTOModel model}) {
    if (model.AssignedContent.isNotEmpty && model.ExcludeContent.isEmpty) {
      return getButton(
        onTap: () {
          if (widget.onDetailsTap != null) {
            widget.onDetailsTap!();
          }
        },
        model: model,
        text: appProvider.localStr.catalogActionsheetDetailsoption,
        themeData: themeData,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getAddToMyLearningButton({required AssociatedContentCourseDTOModel model}) {
    bool isValidContentType = true;
    String buttonLabel = appProvider.localStr.catalogActionsheetAddtomylearningoption;
    if (model.ContentTypeId == InstancyObjectTypes.events) {
      if (model.EventScheduleType.isEmpty || model.EventScheduleType == "1") isValidContentType = false;
      buttonLabel = appProvider.localStr.eventsActionsheetEnrolloption;
    }

    if (!model.IsLearnerContent && isValidContentType && model.AssignedContent.isNotEmpty && model.ExcludeContent.isEmpty) {
      return getButton(
        onTap: () {
          if (widget.onAddToMyLearningTap != null) {
            widget.onAddToMyLearningTap!();
          }
        },
        model: model,
        text: buttonLabel,
        themeData: themeData,
      );
    } else {
      return const SizedBox();
    }
  }

  //endregion

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.contain,
    );
  }

  Widget ratingView(double ratings) {
    return RatingBarIndicator(
      rating: ratings,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.black,
      ),
      itemCount: 5,
      unratedColor: const Color(0xffCBCBD4),
      itemSize: 15.0,
      direction: Axis.horizontal,
    );
  }

  Widget threeVerticalDots() {
    return InkWell(
      onTap: widget.onMoreButtonTap,
      child: const Icon(
        Icons.more_vert,
        size: 22,
      ),
    );
  }

  Widget eventStartDateAndTime({required AssociatedContentCourseDTOModel model, required BuildContext context}) {
    AppProvider appProvider = context.read<AppProvider>();
    MyPrint.printOnConsole("appProvider.appSystemConfigurationModel.dateTimeFormat: '${appProvider.appSystemConfigurationModel.dateTimeFormat}'");
    MyPrint.printOnConsole("model. startDate: '${model.EventEndDateTime}'");

    if (model.EventStartDateTime.isEmpty || appProvider.appSystemConfigurationModel.dateTimeFormat.isEmpty) return const SizedBox();

    DateTime? startDateTime = ParsingHelper.parseDateTimeMethod(model.EventStartDateTime, dateFormat: "MM/dd/yyyy hh:mm aa");
    DateTime? endDateTime = ParsingHelper.parseDateTimeMethod(model.EventEndDateTime, dateFormat: "MM/dd/yyyy hh:mm aa");
    if (startDateTime == null) return const SizedBox();

    ThemeData themeData = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "dd MMM yyyy")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Time: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "hh:mm aa")} to ${DatePresentation.getFormattedDate(dateTime: endDateTime, dateFormat: "hh:mm aa")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }

  //endregion
  Widget getButton({String text = "", required AssociatedContentCourseDTOModel model, void Function()? onTap, required ThemeData themeData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: CommonButton(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        onPressed: () {
          if (onTap != null) {
            onTap();
          }
        },
        backGroundColor: themeData.primaryColor,
        child: Text(
          text,
          style: themeData.textTheme.bodySmall?.copyWith(color: Styles.textColor, fontSize: 12),
        ),
      ),
    );
  }

//endregion
  Widget getCardActionButton({required String text, required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MaterialButton(
        onPressed: () {
          onTap();
        },
        minWidth: 40,
        disabledColor: Colors.grey,
        color: Colors.green,
        textColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

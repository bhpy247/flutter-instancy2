import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/co_create_knowledge/co_create_content_authoring_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/thumbnail_dialog.dart';

class AddEditDocumentsScreen extends StatefulWidget {
  static const String routeName = "/DocumentsScreen";
  final AddEditDocumentScreenArguments argument;

  const AddEditDocumentsScreen({super.key, required this.argument});

  @override
  State<AddEditDocumentsScreen> createState() => _AddEditDocumentsScreenState();
}

class _AddEditDocumentsScreenState extends State<AddEditDocumentsScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();

  final GlobalKey expansionTile = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  bool isUrl = true;

  bool isExpanded = false;
  String documentName = "";
  Uint8List? documentBytes;
  String selectedCategoriesString = "";
  List<ContentFilterCategoryTreeModel> selectedCategoriesList = [];

  String? thumbnailImageUrl;
  String thumbNailName = "";
  Uint8List? thumbNailBytes;

  CourseDTOModel model = CourseDTOModel();

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.argument.coCreateContentAuthoringModel ??
        CoCreateContentAuthoringModel(
          coCreateAuthoringType: CoCreateAuthoringType.Create,
          contentTypeId: InstancyObjectTypes.document,
        );

    if (coCreateContentAuthoringModel.courseDTOModel != null) {
      CourseDTOModel courseDTOModel = coCreateContentAuthoringModel.courseDTOModel!;

      coCreateKnowledgeController.initializeCoCreateContentAuthoringModelFromCourseDTOModel(courseDTOModel: courseDTOModel, coCreateContentAuthoringModel: coCreateContentAuthoringModel);

      titleController.text = coCreateContentAuthoringModel.title;
      descriptionController.text = coCreateContentAuthoringModel.description;
      thumbnailImageUrl = coCreateContentAuthoringModel.ThumbnailImagePath;
      thumbNailBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
      documentBytes = coCreateContentAuthoringModel.uploadedDocumentBytes;
      documentName = coCreateContentAuthoringModel.uploadedDocumentName ?? "";

      List<ContentFilterCategoryTreeModel> list = coCreateKnowledgeProvider.skills.getList();
      for (String skill in coCreateContentAuthoringModel.skills) {
        ContentFilterCategoryTreeModel? model = list.where((element) => element.categoryName == skill).firstOrNull;
        if (model != null) {
          selectedCategoriesList.add(model);
        }
      }
      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: selectedCategoriesList.map((e) => e.categoryName).toList(),
        separator: ", ",
      );
    } else {
      Map<String, dynamic> map = <String, dynamic>{
        "Titlewithlink": "",
        "rcaction": "",
        "Categories": "",
        "IsSubSite": "False",
        "MembershipName": "",
        "EventAvailableSeats": "",
        "EventCompletedProgress": "",
        "EventContentProgress": "",
        "Count": 0,
        "PreviewLink": "",
        "ApproveLink": "",
        "RejectLink": "",
        "ReadLink": "",
        "AddLink": "javascript:fnAddItemtoMyLearning('7d659fde-70a4-4b30-a1f4-62f709ed3786');",
        "EnrollNowLink": "",
        "CancelEventLink": "",
        "WaitListLink": "",
        "InapppurchageLink": "",
        "AlredyinmylearnigLink": "",
        "RecommendedLink": "",
        "Sharelink": "https://enterprisedemo.instancy.com/InviteURLID/contentId/7d659fde-70a4-4b30-a1f4-62f709ed3786/ComponentId/1",
        "EditMetadataLink": "",
        "ReplaceLink": "",
        "EditLink": "",
        "DeleteLink": "",
        "SampleContentLink": "",
        "TitleExpired": "",
        "PracticeAssessmentsAction": "",
        "CreateAssessmentAction": "",
        "OverallProgressReportAction": "",
        "ContentName": "Test 3",
        "ContentScoID": "15342",
        "isContentEnrolled": "False",
        "ContentViewType": "Subscription",
        "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
        "isWishListContent": 0,
        "AddtoWishList": "Y",
        "RemoveFromWishList": null,
        "Duration": "",
        "Credits": "",
        "DetailspopupTags": "",
        "ThumbnailIconPath": "",
        "JWVideoKey": "",
        "Modules": "",
        "salepricestrikeoff": "",
        "isBadCancellationEnabled": "true",
        "EnrollmentLimit": "",
        "AvailableSeats": "0",
        "NoofUsersEnrolled": "1",
        "WaitListLimit": "",
        "WaitListEnrolls": "0",
        "isBookingOpened": false,
        "EventStartDateforEnroll": null,
        "DownLoadLink": "",
        "EventType": 0,
        "EventScheduleType": 0,
        "EventRecording": false,
        "ShowParentPrerequisiteEventDate": false,
        "ShowPrerequisiteEventDate": false,
        "PrerequisiteDateConflictName": null,
        "PrerequisiteDateConflictDateTime": null,
        "SkinID": "6",
        "FilterId": 0,
        "SiteId": 374,
        "UserSiteId": 0,
        "SiteName": "",
        "ContentTypeId": 9,
        "ContentID": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "Title": "Test 3",
        "TotalRatings": "",
        "RatingID": "0",
        "ShortDescription": "",
        "ThumbnailImagePath": "/Content/SiteFiles/Images/Assessment.jpg",
        "InstanceParentContentID": "",
        "ImageWithLink": "",
        "AuthorWithLink": "Richard Parker",
        "EventStartDateTime": "",
        "EventEndDateTime": "",
        "EventStartDateTimeWithoutConvert": "",
        "EventEndDateTimeTimeWithoutConvert": "",
        "expandiconpath": "",
        "AuthorDisplayName": "Richard Parker",
        "ContentType": "Test",
        "CreatedOn": "",
        "TimeZone": "",
        "Tags": "",
        "SalePrice": "",
        "Currency": "",
        "ViewLink": "",
        "DetailsLink": "https://enterprisedemo.instancy.com/Catalog Details/Contentid/7d659fde-70a4-4b30-a1f4-62f709ed3786/componentid/1/componentInstanceID/3131",
        "RelatedContentLink": "",
        "ViewSessionsLink": null,
        "SuggesttoConnLink": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "SuggestwithFriendLink": "7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "SharetoRecommendedLink": "",
        "IsCoursePackage": "",
        "IsRelatedcontent": "",
        "isaddtomylearninglogo": "0",
        "LocationName": "",
        "BuildingName": null,
        "JoinURL": "",
        "Categorycolor": "#ED1F62",
        "InvitationURL": "",
        "HeaderLocationName": "",
        "SubSiteUserID": null,
        "PresenterDisplayName": "",
        "PresenterWithLink": "",
        "ShowMembershipExpiryAlert": false,
        "AuthorName": null,
        "FreePrice": "",
        "SiteUserID": 363,
        "ScoID": 15342,
        "BuyNowLink": "",
        "bit5": false,
        "bit4": false,
        "OpenNewBrowserWindow": false,
        "CreditScoreWithCreditTypes": "",
        "CreditScoreFirstPrefix": "",
        "MediaTypeID": 27,
        "isEnrollFutureInstance": "",
        "InstanceEventReclass": "",
        "InstanceEventReclassStatus": "",
        "InstanceEventReSchedule": "",
        "InstanceEventEnroll": "",
        "ReEnrollmentHistory": "",
        "BackGroundColor": "#2f2d3a",
        "FontColor": "#fff",
        "ExpiredContentExpiryDate": "",
        "ExpiredContentAvailableUntill": "",
        "Gradient1": "",
        "Gradient2": "",
        "GradientColor": "radial-gradient(circle,  0%,  100%)",
        "ShareContentwithUser": "",
        "bit1": false,
        "ViewType": 2,
        "startpage": "start.html",
        "CategoryID": 0,
        "AddLinkTitle": "Add to My learning",
        "ContentStatus": "",
        "PercentCompletedClass": "",
        "PercentCompleted": "",
        "GoogleProductId": "",
        "ItunesProductId": "",
        "FolderPath": "17e97c34-af58-4a68-b729-988561f53808",
        "CloudMediaPlayerKey": "",
        "ActivityId": "http://instancy.com/assessment/7d659fde-70a4-4b30-a1f4-62f709ed3786",
        "ActualStatus": null,
        "CoreLessonStatus": null,
        "jwstartpage": null,
        "IsReattemptCourse": false,
        "AttemptsLeft": 0,
        "TotalAttempts": 0,
        "ListPrice": "",
        "ContentModifiedDateTime": null
      };

      CourseDTOModel courseDTOModel = CourseDTOModel.fromMap(map);
      courseDTOModel.ContentID = MyUtils.getNewId();
      courseDTOModel.ContentTypeId = coCreateContentAuthoringModel.contentTypeId;
      courseDTOModel.ContentType = "Documents";

      AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

      String name = authenticationProvider.getEmailLoginResponseModel()?.username ?? "";
      String imageurl = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";

      courseDTOModel.AuthorName = name;
      courseDTOModel.AuthorDisplayName = name;

      MyPrint.printOnConsole("courseDTOModel.AuthorName : ${courseDTOModel.AuthorName}");

      courseDTOModel.ThumbnailImagePath = "Content/SiteFiles/Images/assignment-thumbnail.png";
      courseDTOModel.UserProfileImagePath = imageurl;


      coCreateContentAuthoringModel.newCurrentCourseDTOModel = courseDTOModel;
      coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;

      // initializeMetadataForNewContentAccordingToType();
    }
  }

  void initializeMetadataForNewContentAccordingToType() {
    titleController.text = "Identifying and Addressing Ergonomic Hazards Workbook";
    descriptionController.text =
        "It provides practical guidance on identifying potential risks associated with poor ergonomics, such as musculoskeletal disorders, repetitive strain injuries, and general discomfort. The workbook includes step-by-step instructions, checklists, and interactive exercises to assess ergonomic setups and implement effective solutions.";
    thumbnailImageUrl =
        "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2Fdemo_contents_thumbnail%2FIdentifying%20and%20Addressing.png?alt=media&token=6ded5bc1-e599-4b5a-ba20-ef15d402e9f1";

    coCreateContentAuthoringModel.newCurrentCourseDTOModel?.ThumbnailImagePath = thumbnailImageUrl!;

    List<String> skills = ["UX Writing", "Neumorphism"];
    selectedCategoriesList.clear();
    List<ContentFilterCategoryTreeModel> list = coCreateKnowledgeProvider.skills.getList();
    for (String skill in skills) {
      ContentFilterCategoryTreeModel? model = list.where((element) => element.categoryName == skill).firstOrNull;
      if (model != null) {
        selectedCategoriesList.add(model);
      }
    }
    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.categoryName).toList(),
      separator: ", ",
    );
  }

  Future<void> thumbnailDialog() async {
    dynamic val = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ThumbnailDialog();
      },
    );

    MyPrint.printOnConsole("val: $val");
    if (val == null) return;

    if (val == 1) {
      await openFileExplorer(false, true);
    } else if (val is Uint8List) {
      thumbNailBytes = val;
      thumbNailName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
      mySetState();
    }

    MyPrint.printOnConsole("Final thumbNailName:'$thumbNailName'");
  }


  Future<void> openFileExplorer(bool multiPick, bool isThumbNail) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: isThumbNail ? FileType.image : FileType.custom,
      multiPick: multiPick,
      getBytes: true,
      extensions: !isThumbNail ? "doc,docx,pdf,xlsx,xls,xlsm,xlsb,xltx,ppt,pptx,mpp,vsdx,csv" : "",
    );

    if (paths.isEmpty) {
      return;
    }

    PlatformFile file = paths.first;
    if (!kIsWeb) {
      MyPrint.printOnConsole("File Path:${file.path}");
    }
    MyPrint.printOnConsole("Got file Name:${file.name}");
    MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
    fileName = MyUtils.regenerateFileName(fileName: file.name) ?? "";

    if (fileName.isEmpty) {
      return;
    }

    // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
    // fileName = fileName.trim();
    // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

    if (isThumbNail) {
      thumbNailName = fileName;
      thumbNailBytes = file.bytes;
    } else {
      documentName = fileName;
      documentBytes = file.bytes;
    }

    mySetState();
  }

  Future<CourseDTOModel?> saveDocument() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AddEditDocumentsScreen().saveDocument() called", tag: tag);

    isLoading = true;
    mySetState();

    coCreateContentAuthoringModel.contentTypeId = InstancyObjectTypes.document;
    String extension = documentName.contains(".") && (documentName.lastIndexOf(".") + 1) < documentName.length ? documentName.substring(documentName.lastIndexOf(".") + 1) : "";
    coCreateContentAuthoringModel.mediaTypeId = switch (extension) {
      "doc" => InstancyMediaTypes.word,
      "docx" => InstancyMediaTypes.word,
      "pdf" => InstancyMediaTypes.pDF,
      "xlsx" => InstancyMediaTypes.excel,
      "xls" => InstancyMediaTypes.excel,
      "xlsm" => InstancyMediaTypes.excel,
      "xlsb" => InstancyMediaTypes.excel,
      "xltx" => InstancyMediaTypes.excel,
      "ppt" => InstancyMediaTypes.ppt,
      "pptx" => InstancyMediaTypes.ppt,
      "mpp" => InstancyMediaTypes.mpp,
      "vsdx" => InstancyMediaTypes.visioTypes,
      "csv" => InstancyMediaTypes.csv,
      _ => InstancyMediaTypes.none,
    };

    coCreateContentAuthoringModel.uploadedDocumentBytes = documentBytes;
    coCreateContentAuthoringModel.uploadedDocumentName = documentName;
    coCreateContentAuthoringModel.title = titleController.text.trim();
    coCreateContentAuthoringModel.description = descriptionController.text.trim();
    coCreateContentAuthoringModel.skills = selectedCategoriesList.map((e) => e.categoryName).toList();
    coCreateContentAuthoringModel.skillsMap = Map<String, String>.fromEntries(selectedCategoriesList.map((e) => MapEntry<String, String>(e.categoryId, e.categoryName)));
    coCreateContentAuthoringModel.ThumbnailImageName = thumbNailName;
    coCreateContentAuthoringModel.thumbNailImageBytes = thumbNailBytes;

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from AddEditEventScreen().saveEvent() because contentId is null or empty", tag: tag);
      MyToast.showError(context: context, msg: coCreateContentAuthoringModel.isEdit ? "Couldn't Update Content" : "Couldn't Create Content");
      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveDocument();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveDocument();

    if (courseDTOModel == null) {
      return;
    }

    if (courseDTOModel.MediaTypeID == InstancyMediaTypes.pDF) {
      await NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: PDFLaunchScreenNavigationArguments(
          contntName: courseDTOModel.ContentName,
          isNetworkPDF: false,
          pdfFileBytes: courseDTOModel.uploadedDocumentBytes,
          // pdfUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fdocuments%2Fai%20for%20biotechnology.pdf?alt=media&token=ab06fadc-ba08-4114-88e1-529213d117bf",
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();

    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    // MyPrint.printOnConsole("fileBytes:${fileBytes?.length}");
    // isLoading = false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 20),
              child: bottomButton(),
            ),
            appBar: AppConfigurations().commonAppBar(
              title: !(widget.argument.coCreateContentAuthoringModel?.isEdit ?? false) ? "Create Document" : "Edit Document",
            ),
            body: mainWidget(),
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 19),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // getImageView(),
              const SizedBox(
                height: 19,
              ),
              getTitleTextFormField(),
              const SizedBox(
                height: 19,
              ),
              // getWidgetFromFileType(fileType),
              // const SizedBox(
              //   height: 19,
              // ),
              getDescriptionTextFormField(),
              // getImagePickerView(),
              const SizedBox(
                height: 19,
              ),
              getCategoryExpansionTile(),
              const SizedBox(
                height: 19,
              ),
              getWidgetFromFileType(),
              const SizedBox(
                height: 19,
              ),
              getThumbNail(FileType.image),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //region imageView
  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  //endregion

  //region getTitleTextFormField
  Widget getTitleTextFormField() {
    return getTexFormField(
      inputFormatters:[LengthLimitingTextInputFormatter(200)],

      validator: (String? val) {
        if (val == null || val.trim().isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      isMandatory: true,
      minLines: 1,
      // maxLines: 1,
      controller: titleController,
      iconUrl: "assets/catalog/title.png",
      labelText: "Title",
    );
  }

  //endregion

  //region getDescription
  Widget getDescriptionTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.trim().isEmpty) {
          return "Please enter description";
        }
        return null;
      },
      isMandatory: true,
      minLines: 5,
      maxLines: 5,
      controller: descriptionController,
      labelText: "Description",
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  //endregion

  //region categoryExpansionTile
  Widget getCategoryExpansionTile() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
      child: Theme(
        data: themeData.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            key: expansionTile,
            backgroundColor: const Color(0xffF8F8F8),
            initiallyExpanded: isExpanded,
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            title: Row(
              children: [
                getImageView(url: "assets/catalog/categories.png", height: 15, width: 15),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    selectedCategoriesString.isEmpty ? "Skills" : selectedCategoriesString,
                    style: themeData.textTheme.titleSmall?.copyWith(color: Colors.black45),
                  ),
                ),
              ],
            ),
            onExpansionChanged: (bool? newVal) {
              FocusScope.of(context).unfocus();
            },
            children: coCreateKnowledgeProvider.skills.getList(isNewInstance: false).map((e) {
              return Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    bool isChecked = !selectedCategoriesList.contains(e);
                    if (isChecked) {
                      selectedCategoriesList.add(e);
                    } else {
                      selectedCategoriesList.remove(e);
                    }

                    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                      list: selectedCategoriesList.map((e) => e.categoryName).toList(),
                      separator: ",",
                    );
                    setState(() {});

                    // if (isChecked) {
                    //   // selectedCategory = e.name;
                    //   selectedCategoriesList.add(e);
                    //   setState(() {});
                    //
                    // } else {
                    //   // selectedCategory = "";
                    //   selectedCategoriesList.remove(e);
                    // }
                    // print(isChecked);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: themeData.primaryColor,
                        value: selectedCategoriesList.where((element) => element.categoryName == e.categoryName).checkNotEmpty,
                        onChanged: (bool? value) {
                          bool isChecked = value ?? false;
                          if (isChecked) {
                            selectedCategoriesList.add(e);
                          } else {
                            selectedCategoriesList.remove(e);
                          }

                          selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                            list: selectedCategoriesList.map((e) => e.categoryName).toList(),
                            separator: ",",
                          );
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.categoryName),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }

  //endregion

  //region AddContent Button
  Widget bottomButton() {
    return CommonSaveExitButtonRow(
      onSaveAndExitPressed: () {
        if (formKey.currentState!.validate()) {
          if(documentBytes == null){
            MyToast.showError(context: context, msg: "Please upload the document");
            return;
          }
          onSaveAndExitTap();

        }
      },
      onSaveAndViewPressed: () async {
        if (formKey.currentState!.validate()) {
          if(documentBytes == null){
            MyToast.showError(context: context, msg: "Please upload the document");
            return;
          }
          await onSaveAndViewTap();
        }
      },
    );
  }

  //endregion

  //region getWidgetAccordingToFileType
  Widget getWidgetFromFileType() {
    return InkWell(
      onTap: () async {
        await openFileExplorer(false, false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: .5), borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            getImageView(url: "assets/imageUpload.png", height: 15, width: 15),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: labelWithStar(
                documentName.isEmpty ? "Upload" : documentName,
                style: documentName.isNotEmpty ? themeData.textTheme.titleSmall : themeData.inputDecorationTheme.hintStyle,
              ),
            ),
            const Icon(Icons.add)
          ],
        ),
      ),
    );
  }

  Widget getThumbNail(FileType? fileType) {
    if (fileType == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (thumbNailBytes == null && thumbnailImageUrl.checkEmpty)
          InkWell(
            onTap: () async {
              await thumbnailDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: themeData.primaryColor, width: .6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Text(
                "Add Thumbnail Image",
                style: TextStyle(color: themeData.primaryColor),
              ),
            ),
          )
        else if (thumbNailBytes != null)
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.memory(
                    thumbNailBytes!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                InkWell(
                  onTap: () {
                    thumbNailBytes = null;
                    thumbNailName = "";
                    thumbnailImageUrl = null;
                    mySetState();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        else if (thumbnailImageUrl.checkNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonCachedNetworkImage(
                    imageUrl: AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: thumbnailImageUrl!),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                InkWell(
                  onTap: () {
                    thumbNailBytes = null;
                    thumbNailName = "";
                    thumbnailImageUrl = null;
                    mySetState();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  //endregion

  //Supporting Widgets
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
        List<TextInputFormatter>? inputFormatters,

      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      isOutlineInputBorder: true,
      prefixWidget: iconUrl.isNotEmpty
          ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
          : const Icon(
              FontAwesomeIcons.globe,
              size: 15,
              color: Colors.grey,
            ),
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
              ))
        ],
      ),
    );
  }
//endregion
}

class DocumentPreviewScreen extends StatefulWidget {
  static const String routeName = "/DocumentPreviewScreen";

  final PDFLaunchScreenNavigationArguments arguments;

  const DocumentPreviewScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> with MySafeState {
  late Future<Uint8List?> futureGetPdfBytes;

  Future<Uint8List?> getData() async {
    Uint8List? uint8list;

    if (widget.arguments.isNetworkPDF) {
      uint8list = await getNetworkPdfBytes();
    } else {
      uint8list = await getLocalPdfBytes();
    }

    return uint8list;
  }

  FutureOr<Uint8List> getNetworkPdfBytes() async {
    try {
      Response response = await get(Uri.parse(widget.arguments.pdfUrl));
      return response.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting PDF Bytes:$e");
      MyPrint.printOnConsole(s);
      return Uint8List(0);
    }
  }

  FutureOr<Uint8List> getLocalPdfBytes() async {
    if (widget.arguments.pdfFileBytes != null) {
      return widget.arguments.pdfFileBytes!;
    }

    if (widget.arguments.pdfFilePath.isNotEmpty) {
      return File(widget.arguments.pdfFilePath).readAsBytes();
    }

    return Uint8List(0);
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("PDFLaunchScreen init called with arguments:${widget.arguments}");

    futureGetPdfBytes = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.contntName.isNotEmpty ? widget.arguments.contntName : 'PDF View',
        ),
        actions: [
          IconButton(
            onPressed: () {
              futureGetPdfBytes = getData();
              mySetState();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Uint8List?>(
              future: futureGetPdfBytes,
              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CommonLoader();
                }

                return PdfPreview(
                  build: (PdfPageFormat format) {
                    return Future.value(snapshot.data);
                  },
                  onError: (BuildContext context, Object? error) {
                    return Center(
                      child: Text(
                        "Error in Loading PDF:\n\n$error",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  onPrintError: (BuildContext context, dynamic error) {
                    MyPrint.printOnConsole("Error in Printing PDF:$error");
                  },
                  useActions: false,
                  allowPrinting: true,
                  allowSharing: true,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CommonButton(
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
              fontSize: 15,
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Done",
            ),
          )
        ],
      ),
    );
  }
}

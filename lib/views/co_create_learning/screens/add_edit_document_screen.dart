import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/wiki_component/wiki_controller.dart';
import '../../../backend/wiki_component/wiki_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/wiki_component/response_model/wikiCategoriesModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class AddEditDocumentsScreen extends StatefulWidget {
  static const String routeName = "/DocumentsScreen";
  final AddEditDocumentScreenArguments arguments;

  const AddEditDocumentsScreen({super.key, required this.arguments});

  @override
  State<AddEditDocumentsScreen> createState() => _AddEditDocumentsScreenState();
}

class _AddEditDocumentsScreenState extends State<AddEditDocumentsScreen> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();

  final GlobalKey expansionTile = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isUrl = true;
  FileType? fileType;
  late WikiProvider wikiProvider;
  late WikiController wikiController;

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;
  String selectedCategoriesString = "";
  List<WikiCategoryTable> selectedCategoriesList = [];
  String thumbNailName = "";
  Uint8List? thumbNailBytes;

  Future<String> openFileExplorer(FileType pickingType, bool multiPick, bool isThumbNail) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileName = file.name;

      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      if (isThumbNail) {
        thumbNailBytes = file.bytes;
      } else {
        fileBytes = file.bytes;
      }
    } else {
      fileName = "";
      fileBytes = null;
      thumbNailBytes = null;
    }
    return fileName;
  }

  FileType? getFileTypeFromMediaTypeId({required int mediaTypeId}) {
    if (mediaTypeId == InstancyMediaTypes.image) {
      return FileType.image;
    } else if (mediaTypeId == InstancyMediaTypes.audio) {
      return FileType.audio;
    } else if (mediaTypeId == InstancyMediaTypes.video) {
      return FileType.video;
    } else if (mediaTypeId == InstancyMediaTypes.pDF) {
      return FileType.custom;
    } else {
      // return FileType.custom;
      return null;
    }
  }

  // Future<void> addCatalogContent() async {
  //   String url = "";
  //   Uint8List? fileBytes;
  //   String fileName = "";
  //   String titleName = titleController.text.trim();
  //   String description = descriptionController.text.trim();
  //
  //   if (isUrl) {
  //     url = websiteUrlController.text;
  //     if (titleName.isEmpty) titleName = url;
  //   } else {
  //     fileBytes = this.fileBytes;
  //     fileName = this.fileName;
  //
  //     if (fileName.isEmpty) {
  //       fileName = "a.jpg";
  //     }
  //   }
  //
  //   if (!isUrl && (fileBytes.checkEmpty)) {
  //     MyToast.showError(context: context, msg: "Choose file");
  //     return;
  //   } else if (titleName.isEmpty) {
  //     MyToast.showError(context: context, msg: "Enter file name");
  //     return;
  //   }
  //
  //   isLoading = true;
  //   if (context.mounted) {
  //     setState(() {});
  //   }
  //
  //   DataResponseModel<String> responseModel = await WikiController(wikiProvider: null).addContent(
  //     wikiUploadRequestModel: WikiUploadRequestModel(
  //       isUrl: isUrl,
  //       url: url,
  //       fileUploads: [
  //         InstancyMultipartFileUploadModel(
  //           fieldName: "file",
  //           fileName: fileName,
  //           bytes: fileBytes,
  //         ),
  //       ],
  //       mediaTypeID: widget.addWikiContentScreenNavigationArguments.mediaTypeId,
  //       objectTypeID: widget.addWikiContentScreenNavigationArguments.objectTypeId,
  //       title: titleName,
  //       shortDesc: description,
  //       componentID: 1,
  //       cMSGroupId: 1,
  //       categories: selectedCategoriesList.map((e) => e.categoryID.toString()).toList(),
  //     ),
  //   );
  //
  //   isLoading = false;
  //   if (context.mounted) {
  //     setState(() {});
  //   }
  //
  //   if (responseModel.appErrorModel != null || responseModel.data == null) {
  //     String message = responseModel.appErrorModel?.message ?? "";
  //     if (message.isEmpty) {
  //       message = "Couldn't add content";
  //     }
  //     MyPrint.printOnConsole("Error in Adding Content:$message");
  //     if (context.mounted) {
  //       MyToast.showError(context: context, msg: message);
  //     }
  //   } else {
  //     MyPrint.printOnConsole("Content Added Successfully:${responseModel.data}");
  //     if (context.mounted) {
  //       MyToast.showSuccess(context: context, msg: '$titleName Submitted Successfully');
  //       Navigator.pop(context, true);
  //     }
  //   }
  // }

  CourseDTOModel model = CourseDTOModel();

  void onSaveButtonClicked() {
    CoCreateKnowledgeProvider provider = context.read();

    model = widget.arguments.courseDtoModel ?? CourseDTOModel();
    model.Title = titleController.text.trim();
    model.TitleName = titleController.text.trim();
    model.ContentName = titleController.text.trim();
    model.ShortDescription = descriptionController.text.trim();
    model.AuthorName = "Richard Parker";
    model.ContentTypeId = InstancyObjectTypes.document;
    model.MediaTypeID = InstancyMediaTypes.none;
    model.AuthorDisplayName = "Richard Parker";
    model.ContentType = "Documents";
    model.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";
    model.ViewLink = "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true";
    model.Categories = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.name).toList(),
      separator: ",",
    );
    MyPrint.printOnConsole(model.Categories);
    model.ThumbnailImagePath =
        "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3";
    model.thumbNailFileBytes = thumbNailBytes;
    // if (widget.arguments.isEdit) {
    //   provider.updateMyKnowledgeListModel(model, widget.arguments.index);
    // } else {
    //   provider.addToMyKnowledgeList(model);
    // }
    //
  }

  void editData() {
    if (widget.arguments.courseDtoModel == null) return;
    CourseDTOModel model = widget.arguments.courseDtoModel!;
    titleController.text = model.Title;
    descriptionController.text = model.ShortDescription;
    fileName = model.ViewLink;
    List<WikiCategoryTable> categoriesList = wikiProvider.wikiCategoriesList;
    List<String> categoriesidsFromString = model.Categories.split(",").toList();

    selectedCategoriesList = categoriesList.where((element) => categoriesidsFromString.contains(element.name.toString())).toList();
    MyPrint.printOnConsole(selectedCategoriesList);
    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.name).toList(),
      separator: ",",
    );
  }

  @override
  void initState() {
    super.initState();
    wikiProvider = context.read<WikiProvider>();
    wikiController = WikiController(wikiProvider: wikiProvider);
    wikiController.getWikiCategoriesFromApi(
      componentId: InstancyComponents.Catalog,
      componentInstanceId: InstancyComponents.CatalogComponentInsId,
    );
    editData();
    // isUrl = widget.addWikiContentScreenNavigationArguments.mediaTypeId == InstancyMediaTypes.url;
    fileType = getFileTypeFromMediaTypeId(
      mediaTypeId: InstancyMediaTypes.pDF,
    );
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
            appBar: AppConfigurations().commonAppBar(
              title: "Document",
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
              getThumbNail(FileType.image),
              const SizedBox(
                height: 30,
              ),
              getAddContentButton(),
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
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      isMandatory: true,
      minLines: 1,
      maxLines: 1,
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
        if (val == null || val.isEmpty) {
          return "Please enter description";
        }
        return null;
      },
      isMandatory: true,
      minLines: 1,
      maxLines: 5,
      controller: descriptionController,
      labelText: "Description",
      iconUrl: "assets/catalog/imageDescription.png",
    );
  }

  //endregion

  //region getWebsiteUrlTextFormField
  Widget getWebsiteUrlTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter website url";
        }
        if (!Uri.parse(val).isAbsolute) {
          return "Please enter valid url";
        }
        return null;
      },
      isMandatory: true,
      controller: websiteUrlController,
      labelText: "Add URL",
    );
  }

  //endregion

  //region categoryExpansionTile
  Widget getCategoryExpansionTile() {
    return Consumer<WikiProvider>(
      builder: (BuildContext context, WikiProvider provider, _) {
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
                children: provider.wikiCategoriesList.map((e) {
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
                          list: selectedCategoriesList.map((e) => e.name).toList(),
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
                            value: selectedCategoriesList.where((element) => element.name == e.name).checkNotEmpty,
                            onChanged: (bool? value) {
                              bool isChecked = value ?? false;
                              if (isChecked) {
                                selectedCategoriesList.add(e);
                              } else {
                                selectedCategoriesList.remove(e);
                              }

                              selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                                list: selectedCategoriesList.map((e) => e.name).toList(),
                                separator: ",",
                              );
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.name),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          ),
        );
      },
    );
  }

  //endregion

  //region AddContent Button
  Widget getAddContentButton() {
    return CommonButton(
      minWidth: double.infinity,
      fontSize: 15,
      backGroundColor: themeData.primaryColor,
      // minWidth: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          onSaveButtonClicked();
          NavigationController.navigateToCreateDocumentScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            argument: AddEditDocumentScreenArguments(
              componentId: 0,
              componentInsId: 0,
              courseDtoModel: model,
              isEdit: widget.arguments.isEdit,
              index: widget.arguments.index,
            ),
          );
        }
        // Navigator.pop(context);

        // if (formKey.currentState!.validate()) {
        //   FocusScope.of(context).unfocus();
        //   // addCatalogContent();
        // }
      },
      text: widget.arguments.courseDtoModel != null ? "Next" : "Next",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }

  //endregion

  //region getWidgetAccordingToFileType
  Widget getWidgetFromFileType(FileType? fileType) {
    if (fileType != null) {
      return InkWell(
        onTap: () async {
          fileName = await openFileExplorer(fileType, false, false);
          setState(() {});
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
                  fileName.isEmpty ? "Upload" : fileName,
                  style: fileName.isNotEmpty ? themeData.textTheme.titleSmall : themeData.inputDecorationTheme.hintStyle,
                ),
              ),
              const Icon(Icons.add)
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getThumbNail(FileType? fileType) {
    if (fileType == null) return const SizedBox();
    return Column(
      children: [
        InkWell(
          onTap: () async {
            thumbNailName = await openFileExplorer(fileType, false, true);
            setState(() {});
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
        ),
        if (thumbNailBytes != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
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
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
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

class CreateDocumentContentScreen extends StatefulWidget {
  static const String routeName = "/CreateDocumentContentScreen";
  final AddEditDocumentScreenArguments arguments;

  const CreateDocumentContentScreen({super.key, required this.arguments});

  @override
  State<CreateDocumentContentScreen> createState() => _CreateDocumentContentScreenState();
}

class _CreateDocumentContentScreenState extends State<CreateDocumentContentScreen> with MySafeState {
  String fileName = "";
  Uint8List? fileBytes;
  TextEditingController websiteUrlController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> openFileExplorer(FileType pickingType, bool multiPick) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;
      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileBytes = file.bytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.arguments.isFromReference ? "Generate Reference Link" : "Generate Document",
      ),
      body: getUploadButton(),
    );
  }

  Widget getUploadButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            widget.arguments.isFromReference ? getWebsiteUrlTextFormField() : getWidgetFromFileType(FileType.custom),
            const Spacer(),
            CommonButton(
              minWidth: double.infinity,
              fontColor: themeData.colorScheme.onPrimary,
              fontSize: 15,
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  if (!widget.arguments.isFromReference && fileName.checkEmpty) {
                    MyToast.showError(context: context, msg: "Please upload the file");
                    return;
                  }

                  CoCreateKnowledgeProvider provider = context.read();

                  CourseDTOModel model = widget.arguments.courseDtoModel ?? CourseDTOModel();
                  model.uploadedDocumentBytes = fileBytes;
                  model.ViewLink = websiteUrlController.text.trim();
                  if (widget.arguments.isEdit) {
                    provider.updateMyKnowledgeListModel(model, widget.arguments.index);
                  } else {
                    provider.addToMyKnowledgeList(model);
                  }

                  if (widget.arguments.isFromReference) {
                    NavigationController.navigateToWebViewScreen(
                      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                      arguments: WebViewScreenNavigationArguments(
                          title: model.Title,
                          // url: "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/",
                          url: websiteUrlController.text.trim(),
                          isFromAuthoringTool: true),
                    );
                    return;
                  }

                  NavigationController.navigateToDocumentPreviewScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    argument: PDFLaunchScreenNavigationArguments(
                      contntName: widget.arguments.courseDtoModel?.Title ?? "",
                      isNetworkPDF: fileBytes == null,
                      // pdfUrl: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
                      pdfUrl: widget.arguments.courseDtoModel?.ViewLink ?? "",
                      pdfFileBytes: widget.arguments.courseDtoModel?.uploadedDocumentBytes,
                    ),
                  );
                }
              },
              text: "Generate",
            )
          ],
        ),
      ),
    );
  }

  //region getWebsiteUrlTextFormField
  Widget getWebsiteUrlTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter website url";
        }
        if (!Uri.parse(val).isAbsolute) {
          return "Please enter valid url";
        }
        return null;
      },
      isMandatory: true,
      controller: websiteUrlController,
      labelText: "Add URL",
    );
  }

  //endregion

  Widget getWidgetFromFileType(FileType? fileType) {
    if (fileType != null) {
      return InkWell(
        onTap: () async {
          fileName = await openFileExplorer(fileType, false);
          setState(() {});
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
                  fileName.isEmpty ? "Upload" : fileName,
                  style: fileName.isNotEmpty ? themeData.textTheme.titleSmall : themeData.inputDecorationTheme.hintStyle,
                ),
              ),
              const Icon(Icons.add)
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
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

  //region imageView
  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

//endregion

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
      double iconHeight = 15,
      double iconWidth = 15}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
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
                Navigator.pop(context);
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

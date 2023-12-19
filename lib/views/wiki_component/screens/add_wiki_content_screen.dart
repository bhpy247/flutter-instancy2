import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_controller.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../models/common/data_response_model.dart';
import '../../../models/wiki_component/request_model/wiki_upload_request_model.dart';
import '../../../models/wiki_component/response_model/wikiCategoriesModel.dart';

class AddWikiContentScreen extends StatefulWidget {
  static const String routeName = "/AddWikiContentScreen";

  final AddWikiContentScreenNavigationArguments addWikiContentScreenNavigationArguments;

  const AddWikiContentScreen({
    Key? key,
    required this.addWikiContentScreenNavigationArguments,
  }) : super(key: key);

  @override
  State<AddWikiContentScreen> createState() => _AddWikiContentScreenState();
}

class _AddWikiContentScreenState extends State<AddWikiContentScreen> {
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

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;
  String selectedCategoriesString = "";
  List<WikiCategoryTable> selectedCategoriesList = [];

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

  Future<void> addCatalogContent() async {
    String url = "";
    Uint8List? fileBytes;
    String fileName = "";
    String titleName = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (isUrl) {
      url = websiteUrlController.text;
      if (titleName.isEmpty) titleName = url;
    } else {
      fileBytes = this.fileBytes;
      fileName = this.fileName;

      if (fileName.isEmpty) {
        fileName = "a.jpg";
      }
    }

    if (!isUrl && (fileBytes.checkEmpty)) {
      MyToast.showError(context: context, msg: "Choose file");
      return;
    } else if (titleName.isEmpty) {
      MyToast.showError(context: context, msg: "Enter file name");
      return;
    }

    isLoading = true;
    if (context.mounted) {
      setState(() {});
    }

    DataResponseModel<String> responseModel = await WikiController(wikiProvider: null).addContent(
      wikiUploadRequestModel: WikiUploadRequestModel(
        isUrl: isUrl,
        url: url,
        fileUploads: [
          InstancyMultipartFileUploadModel(
            fieldName: "file",
            fileName: fileName,
            bytes: fileBytes,
          ),
        ],
        mediaTypeID: widget.addWikiContentScreenNavigationArguments.mediaTypeId,
        objectTypeID: widget.addWikiContentScreenNavigationArguments.objectTypeId,
        title: titleName,
        shortDesc: description,
        componentID: 1,
        cMSGroupId: 1,
        categories: selectedCategoriesList.map((e) => e.categoryID.toString()).toList(),
      ),
    );

    isLoading = false;
    if (context.mounted) {
      setState(() {});
    }

    if (responseModel.appErrorModel != null || responseModel.data == null) {
      String message = responseModel.appErrorModel?.message ?? "";
      if (message.isEmpty) {
        message = "Couldn't add content";
      }
      MyPrint.printOnConsole("Error in Adding Content:$message");
      if (context.mounted) {
        MyToast.showError(context: context, msg: message);
      }
    } else {
      MyPrint.printOnConsole("Content Added Successfully:${responseModel.data}");
      if (context.mounted) {
        MyToast.showSuccess(context: context, msg: '$titleName Submitted Successfully');
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isUrl = widget.addWikiContentScreenNavigationArguments.mediaTypeId == InstancyMediaTypes.url;
    fileType = getFileTypeFromMediaTypeId(
      mediaTypeId: widget.addWikiContentScreenNavigationArguments.mediaTypeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // MyPrint.printOnConsole("fileBytes:${fileBytes?.length}");
    // isLoading = false;

    themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppConfigurations().commonAppBar(
            title: "Add Content",
          ),
          body: mainWidget(),
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
            children: [
              getImageView(),
              const SizedBox(
                height: 19,
              ),
              getTitleTextFormField(),
              const SizedBox(
                height: 19,
              ),
              getImageDescriptionTextFormField(),
              const SizedBox(
                height: 19,
              ),
              isUrl ? getWebsiteUrlTextFormField() : getWidgetFromFileType(fileType),
              // getImagePickerView(),
              const SizedBox(
                height: 19,
              ),
              getCategoryExpansionTile(),
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
      controller: titleController,
      iconUrl: "assets/catalog/title.png",
      labelText: "${widget.addWikiContentScreenNavigationArguments.title} Title",
    );
  }

  //endregion

  //region getImageDescription
  Widget getImageDescriptionTextFormField() {
    return getTexFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter description";
        }
        return null;
      },
      isMandatory: true,
      controller: descriptionController,
      labelText: "${widget.addWikiContentScreenNavigationArguments.title} Description",
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
      labelText: "Website URL",
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
                        selectedCategoriesString.isEmpty ? "Categories" : selectedCategoriesString,
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
                          separator: ", ",
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
                            value: selectedCategoriesList.contains(e),
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
      backGroundColor: themeData.primaryColor,
      minWidth: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          FocusScope.of(context).unfocus();
          addCatalogContent();
        }
      },
      text: "Add Content",
      fontColor: themeData.colorScheme.onPrimary,
    );
  }

  //endregion

  //region getWidgetAccordingToFileType
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
                  fileName.isEmpty ? "Upload ${widget.addWikiContentScreenNavigationArguments.title}" : fileName,
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

  //endregion

  //Supporting Widgets
  //region textFieldView
  Widget getTexFormField({TextEditingController? controller, String iconUrl = "", String? Function(String?)? validator, String labelText = "Label", Widget? suffixWidget, required bool isMandatory}) {
    return CommonTextFormFieldWithLabel(
      controller: controller,
      label: isMandatory ? labelWithStar(labelText) : null,
      labelText: isMandatory ? null : labelText,
      validator: validator,
      isOutlineInputBorder: true,
      prefixWidget: iconUrl.isNotEmpty ? getImageView(url: iconUrl, height: 15, width: 15) : const Icon(FontAwesomeIcons.globe),
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

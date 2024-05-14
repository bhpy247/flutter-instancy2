import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/wiki_component/wiki_controller.dart';
import '../../../backend/wiki_component/wiki_provider.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/wiki_component/response_model/wikiCategoriesModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';

class CommonCreateAuthoringToolScreen extends StatefulWidget {
  static const String routeName = "/CommonCreateAuthoringScreen";
  final CommonCreateAuthoringToolScreenArgument argument;

  const CommonCreateAuthoringToolScreen({super.key, required this.argument});

  @override
  State<CommonCreateAuthoringToolScreen> createState() => _CommonCreateAuthoringToolScreenState();
}

class _CommonCreateAuthoringToolScreenState extends State<CommonCreateAuthoringToolScreen> with MySafeState {
  bool isLoading = false;
  String appBarTitle = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteUrlController = TextEditingController();
  TextEditingController imageFileText = TextEditingController();
  String selectedCategoriesString = "";
  List<WikiCategoryTable> selectedCategoriesList = [];
  String thumbNailName = "";
  Uint8List? thumbNailBytes;
  late WikiProvider wikiProvider;
  late WikiController wikiController;
  bool isExpanded = false;
  final GlobalKey expansionTile = GlobalKey();
  Uint8List? fileBytes;

  String setAppBarTitle(int objectTypeId) {
    bool isEdit = widget.argument.courseDtoModel != null ? true : false;
    if (objectTypeId == InstancyObjectTypes.flashCard) {
      return isEdit ? "Edit Flashcard" : "Create Flashcard";
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      return isEdit ? "Edit RolePlay" : "Create RolePlay";
    } else if (objectTypeId == InstancyObjectTypes.podcastEpisode) {
      return isEdit ? "Edit PodCast Episode" : "Create PodCast Episode";
    } else if (objectTypeId == InstancyObjectTypes.referenceUrl) {
      return isEdit ? "Edit Reference Url" : "Create Reference Url";
    } else if (objectTypeId == InstancyObjectTypes.document) {
      return isEdit ? "Edit Document" : "Create Document";
    } else if (objectTypeId == InstancyObjectTypes.videos) {
      return isEdit ? "Edit Video" : "Create Video";
    } else if (objectTypeId == InstancyObjectTypes.quiz) {
      return isEdit ? "Edit Quiz" : "Create Quiz";
    } else if (objectTypeId == InstancyObjectTypes.article) {
      return isEdit ? "Edit Article" : "Create Article";
    } else if (objectTypeId == InstancyObjectTypes.events) {
      return isEdit ? "Edit Event" : "Create Event";
    } else {
      return "";
    }
  }

  void onNextTap(int objectTypeId) {
    if (objectTypeId == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToAddEditFlashcardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditFlashcardScreenNavigationArguments(),
      );
    } else if (objectTypeId == InstancyObjectTypes.podcastEpisode) {
      NavigationController.navigateToCreatePodcastSourceSelectionScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const CreatePodcastSourceSelectionScreenNavigationArguments(
          courseDtoModel: null,
          componentId: 0,
          componentInsId: 0,
          isEdit: false,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.referenceUrl) {
      NavigationController.navigateToReferenceLinkScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        // argument: const AddEditReferenceScreenArguments(componentId: 0, componentInsId: 0),
      );
    } else if (objectTypeId == InstancyObjectTypes.document) {
      NavigationController.navigateToAddEditDocumentScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditDocumentScreenArguments(componentId: 0, componentInsId: 0),
      );
    } else if (objectTypeId == InstancyObjectTypes.videos) {
      NavigationController.navigateToAddEditVideoScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: const AddEditVideoScreenArgument(),
      );
    } else if (objectTypeId == InstancyObjectTypes.quiz) {
      NavigationController.navigateToAddEditQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: const AddEditQuizScreenArgument(),
      );
    } else if (objectTypeId == InstancyObjectTypes.article) {
      NavigationController.navigateToAddEditFlashcardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: const AddEditFlashcardScreenNavigationArguments(),
      );
    } else if (objectTypeId == InstancyObjectTypes.events) {
      NavigationController.navigateToAddEditEventScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: const AddEditEventScreenArgument(
          courseDtoModel: null,
        ),
      );
    } else if (objectTypeId == InstancyObjectTypes.rolePlay) {
      NavigationController.navigateToAddEditRoleplayScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: const AddEditRolePlayScreenNavigationArgument(),
      );
    } else {}
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
    // isUrl = widget.addWikiContentScreenNavigationArguments.mediaTypeId == InstancyMediaTypes.url;
    // fileType = getFileTypeFromMediaTypeId(
    //   mediaTypeId: widget.addWikiContentScreenNavigationArguments.mediaTypeId,
    // );
  }

  Future<String> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
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
      thumbNailBytes = fileBytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            appBar: AppConfigurations().commonAppBar(
              title: setAppBarTitle(widget.argument.objectTypeId),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 17,
                    ),
                    getTitleTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getDescriptionTextFormField(),
                    const SizedBox(
                      height: 17,
                    ),
                    getCategoryExpansionTile(),
                    const SizedBox(
                      height: 17,
                    ),
                    getThumbNail(FileType.image),
                    const SizedBox(
                      height: 30,
                    ),
                    CommonButton(
                      minWidth: double.infinity,
                      onPressed: () {
                        onNextTap(widget.argument.objectTypeId);
                      },
                      text: "Next",
                      fontColor: themeData.colorScheme.onPrimary,
                    )
                  ],
                ),
              ),
            ),
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

  Widget getThumbNail(FileType? fileType) {
    if (fileType == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            thumbNailName = await openFileExplorer(
              fileType,
              false,
            );
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

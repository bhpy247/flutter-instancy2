import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_chat_bot/view/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_create_discussion_forum_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/CategoriesModel.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/app_ui_components.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/discussion/discussion_controller.dart';
import '../../../backend/discussion/discussion_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';
import '../component/bottom_sheet_for_moderator_list.dart';

class CreateEditDiscussionForumScreen extends StatefulWidget {
  static const String routeName = "/CreateDiscussionForumScreen";
  final CreateEditDiscussionForumScreenNavigationArguments arguments;

  const CreateEditDiscussionForumScreen({super.key, required this.arguments});

  @override
  State<CreateEditDiscussionForumScreen> createState() => _CreateEditDiscussionForumScreenState();
}

class _CreateEditDiscussionForumScreenState extends State<CreateEditDiscussionForumScreen> with MySafeState {
  late DiscussionController discussionController;
  late DiscussionProvider discussionProvider;
  late ThemeData themeData;
  bool newTopicCheckBox = true, attachFilesCheckBox = true, likeCheckBox = true, shareCheckBox = true, pinCheckBox = true, privacyForumCheckBox = false;

  int _groupValue = 2;

  bool isUrl = true, isLoading = false;
  FileType? fileType;
  FocusNode fn = FocusNode();

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController uploadFileTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCategoriesString = "";
  List<CategoriesModel> categoriesList = [];
  List<CategoriesModel> selectedCategoriesList = [];
  final GlobalKey expansionTile = GlobalKey();

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;

  List<ForumUserInfoModel> selectedModerator = [];

  String getStringBasedOnGroupValueForNotificationSubscription(int groupValue) {
    String val = "";
    if (groupValue == 1) {
      val = "dontsend";
    } else if (groupValue == 2) {
      val = "all";
    } else {
      val = "onlytopic";
    }
    return val;
  }

  void setGroupValueBaseOnTheString(String groupValue) {
    if (groupValue == "dontsend") {
      _groupValue = 1;
    } else if (groupValue == "all") {
      _groupValue = 2;
    } else {
      _groupValue = 3;
    }
    mySetState();
  }

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

  Future<void> createDiscussion() async {
    List<int> ids = selectedModerator.map((model) => model.UserID).toList();
    List<int> categoryids = selectedCategoriesList.map((model) => model.id).toList();
    if (ids.isEmpty) {
      MyToast.showError(context: context, msg: "Please Select Moderators");
      return;
    }

    isLoading = true;
    mySetState();

    String commaSeparatedIds = ids.join(', ');
    String commaSeparatedCategoriesIds = categoryids.join(', ');

    List<InstancyMultipartFileUploadModel>? list;
    if (fileBytes != null) {
      list = [
        InstancyMultipartFileUploadModel(
          fieldName: "image",
          fileName: fileName,
          bytes: fileBytes,
        ),
      ];
    }

    CreateDiscussionForumRequestModel requestModel = CreateDiscussionForumRequestModel(
      fileUploads: list,
      AllowPinTopic: pinCheckBox,
      AllowShare: shareCheckBox,
      AttachFile: attachFilesCheckBox,
      CreatedDate: DatePresentation.dateTimeFormatWithSlash(DateTime.now()),
      UpdatedDate: DatePresentation.dateTimeFormatWithSlash(DateTime.now()),
      CreateNewTopic: newTopicCheckBox,
      Description: descriptionTextEditingController.text.trim(),
      ForumID: -1,
      ForumThumbnailName: fileName,
      CategoryIDs: commaSeparatedCategoriesIds,
      IsPrivate: privacyForumCheckBox,
      LikePosts: likeCheckBox,
      Moderation: false,
      ModeratorID: commaSeparatedIds,
      Name: titleTextEditingController.text.trim(),
      ParentForumID: 0,
      RequiresSubscription: true,
      SendEmail: getStringBasedOnGroupValueForNotificationSubscription(_groupValue),
    );

    if (widget.arguments.isEdit) {
      requestModel.ForumID = widget.arguments.forumModel?.ForumID ?? 0;
      requestModel.ParentForumID = widget.arguments.forumModel?.ParentForumID ?? 0;
      // requestModel.CategoryIDs = widget.arguments.forumModel?.CategoryIDs ?? "";
      requestModel.RequiresSubscription = widget.arguments.forumModel?.RequiresSubscription ?? false;
    }

    MyPrint.logOnConsole("Request Model Discussion Forum ${requestModel.toJson()}");

    bool isCreated = widget.arguments.isEdit
        ? await discussionController.editDiscussionForum(
            requestModel: requestModel,
          )
        : await discussionController.createDiscussionForum(
            requestModel: requestModel,
          );

    isLoading = false;
    mySetState();

    if (isCreated && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> showModeratorList() async {
    dynamic data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, minHeight: MediaQuery.of(context).size.height * 0.9),
      builder: (BuildContext context) {
        return ModeratorBottomSheet(
          selectedModeratorList: selectedModerator,
        );
      },
    );
    if (data == null) return;
    if (data is List<ForumUserInfoModel>) {
      selectedModerator = data;
      mySetState();
    }
    MyPrint.printOnConsole("selectedModerator: $selectedModerator");
  }

  void setTheValueWhenEdit() {
    if (widget.arguments.forumModel == null) return;
    MyPrint.printOnConsole("setTheValueWhenEdit : ${widget.arguments.forumModel}");

    ForumModel forumModel = widget.arguments.forumModel ?? ForumModel();
    CreateDiscussionForumRequestModel? createDiscussionForumRequestModel = CreateDiscussionForumRequestModel(
      Name: forumModel.Name,
      ModeratorID: forumModel.ModeratorID,
      RequiresSubscription: forumModel.RequiresSubscription,
      Moderation: forumModel.Moderation,
      LikePosts: forumModel.LikePosts,
      IsPrivate: forumModel.IsPrivate,
      CategoryIDs: forumModel.CategoryIDs,
      ForumID: forumModel.ForumID,
      Description: forumModel.Description,
      CreateNewTopic: forumModel.CreateNewTopic,
      CreatedDate: forumModel.CreatedDate,
      AttachFile: forumModel.AttachFile,
      AllowShare: forumModel.AllowShare,
      AllowPinTopic: forumModel.AllowPin,
      CreatedUserID: forumModel.CreatedUserID,
      ParentForumID: forumModel.ParentForumID,
      SendEmail: forumModel.SendEmail,
      thumbnailUrl: forumModel.ForumThumbnailPath,
      UpdatedDate: forumModel.UpdatedDate,
    );
    pinCheckBox = forumModel.AllowPinEditValue;
    shareCheckBox = forumModel.AllowShareEditValue;
    attachFilesCheckBox = forumModel.AttachFileEditValue;
    newTopicCheckBox = forumModel.CreateNewTopicEditValue;
    privacyForumCheckBox = createDiscussionForumRequestModel.IsPrivate;
    likeCheckBox = forumModel.LikePostsEditValue;

    descriptionTextEditingController.text = createDiscussionForumRequestModel.Description;
    titleTextEditingController.text = createDiscussionForumRequestModel.Name;
    uploadFileTextEditingController.text = createDiscussionForumRequestModel.thumbnailUrl;
    fileName = forumModel.ForumThumbnailPath;
    setGroupValueBaseOnTheString(forumModel.SendEmail);
    List<String> idsFromString = createDiscussionForumRequestModel.ModeratorID.split(",").toList();
    List<String> categoriesidsFromString = createDiscussionForumRequestModel.CategoryIDs.split(",").toList();

    List<ForumUserInfoModel> moderators = discussionProvider.moderatorsList.getList();
    selectedModerator = moderators.where((element) => idsFromString.contains(element.UserID.toString())).toList();
    selectedCategoriesList = categoriesList.where((element) => categoriesidsFromString.contains(element.id.toString())).toList();
    MyPrint.printOnConsole("selectedModerator : ${selectedModerator.length}");
    selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
      list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
      separator: ", ",
    );

    mySetState();
  }

  void setTheUserModerator() {
    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    int userId = authenticationProvider.getEmailLoginResponseModel()?.userid ?? 0;
    if (userId == 0) return;
    String name = authenticationProvider.getEmailLoginResponseModel()?.username ?? "";
    String imageUrl = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";
    MyPrint.printOnConsole("authenticationProvider.  : ${authenticationProvider.getEmailLoginResponseModel()?.toMap()}");

    ForumUserInfoModel forumUserInfoModel = ForumUserInfoModel(
      UserID: userId,
      UserName: name,
      UserThumb: imageUrl,
    );
    if (selectedModerator.checkEmpty) {
      selectedModerator.add(forumUserInfoModel);
    }
    if (selectedModerator.checkNotEmpty) {
      List<ForumUserInfoModel> list = selectedModerator.toList();
      for (var element in list) {
        if (element.UserID != userId) {
          selectedModerator.add(forumUserInfoModel);
        }
      }
    }
    MyPrint.printOnConsole("forumUserInfoModel : ${forumUserInfoModel.toJson()}");
  }

  @override
  void initState() {
    super.initState();
    discussionProvider = context.read<DiscussionProvider>();
    discussionController = DiscussionController(discussionProvider: discussionProvider);
    discussionController.getUserListBaseOnUserInfo();
    discussionController.getCategoriesList(componentId: widget.arguments.componentId, componentInstanceId: widget.arguments.componentInsId);
    categoriesList = discussionProvider.categoriesList.getList();

    if (widget.arguments.isEdit) {
      setTheValueWhenEdit();
    }
    setTheUserModerator();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(),
          body: AppUIComponents.getBackGroundBordersRounded(
            context: context,
            child: mainWidget(),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        widget.arguments.isEdit ? "Edit Discussion" : "Create Discussion",
      ),
    );
  }

  Widget mainWidget() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    getCommonTextFormField(
                        fn: fn,
                        controller: titleTextEditingController,
                        hintext: "Title",
                        maxLines: 3,
                        minLines: 1,
                        iconAssetString: "assets/title_icon.png",
                        prefixIconData: FontAwesomeIcons.fileLines,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                        validator: (String? val) {
                          if (val == null || val.trim().checkEmpty) {
                            return "Please enter the title";
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    getCommonTextFormField(
                      controller: descriptionTextEditingController,
                      hintext: "Description",
                      maxLines: 5,
                      minLines: 1,
                      prefixIconData: FontAwesomeIcons.solidFileLines,
                      isStarVisible: false,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        fileName = await openFileExplorer(FileType.any, false);
                        uploadFileTextEditingController.text = fileName;
                        mySetState();
                      },
                      child: getCommonTextFormField(
                          enable: false,
                          hintext: "Upload file",
                          prefixIconData: FontAwesomeIcons.arrowUpFromBracket,
                          suffix: Icons.add,
                          controller: uploadFileTextEditingController,
                          isStarVisible: false),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          showModeratorList();
                        },
                        child: moderatorExpansionTile()),
                    const SizedBox(height: 20),
                    getCategoryExpansionTile(),
                    const SizedBox(height: 20),
                    getSettingSectionWidget(),
                    const SizedBox(height: 20),
                    getPrivacyPolicyWidget(),
                    const SizedBox(height: 40),
                    getCreateDiscussionButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCategoryExpansionTile() {
    return Consumer<DiscussionProvider>(
      builder: (BuildContext context, DiscussionProvider provider, _) {
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
              children: List.generate(categoriesList.length, (index) {
                return Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      bool isChecked = !selectedCategoriesList.where((element) => element.id == categoriesList[index].id).checkNotEmpty;
                      MyPrint.printOnConsole("isChecked : $isChecked");
                      if (isChecked) {
                        selectedCategoriesList.add(categoriesList[index]);
                      } else {
                        selectedCategoriesList.removeAt(index);
                      }

                      selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                        list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
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
                          value: selectedCategoriesList.where((element) => element.id == categoriesList[index].id).checkNotEmpty,
                          onChanged: (bool? value) {
                            bool isChecked = value ?? false;
                            MyPrint.printOnConsole("selectedCategoriesList : ${value}}");

                            if (isChecked) {
                              selectedCategoriesList.add(categoriesList[index]);
                            } else {
                              selectedCategoriesList.removeWhere((element) => element.id == categoriesList[index].id);
                            }

                            selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
                              list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
                              separator: ",",
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(categoriesList[index].CategoryName),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // children: provider.categoriesList.getList().map((e) {
              //   return Container(
              //     color: Colors.white,
              //     child: InkWell(
              //       onTap: () {
              //         bool isChecked = !selectedCategoriesList.contains(e);
              //         if (isChecked) {
              //           selectedCategoriesList.add(e);
              //         } else {
              //           selectedCategoriesList.remove(e);
              //         }
              //
              //         selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              //           list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
              //           separator: ", ",
              //         );
              //         setState(() {});
              //
              //         // if (isChecked) {
              //         //   // selectedCategory = e.name;
              //         //   selectedCategoriesList.add(e);
              //         //   setState(() {});
              //         //
              //         // } else {
              //         //   // selectedCategory = "";
              //         //   selectedCategoriesList.remove(e);
              //         // }
              //         // print(isChecked);
              //       },
              //       child: Row(
              //         children: [
              //           Checkbox(
              //             activeColor: themeData.primaryColor,
              //             value: selectedCategoriesList.where((element) => element.id == e.id).checkNotEmpty,
              //             onChanged: (bool? value) {
              //               bool isChecked = value ?? false;
              //               if (isChecked) {
              //                 selectedCategoriesList.add(e);
              //               } else {
              //                 selectedCategoriesList.remove(e);
              //               }
              //
              //               selectedCategoriesString = AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              //                 list: selectedCategoriesList.map((e) => e.CategoryName).toList(),
              //                 separator: ",",
              //               );
              //               setState(() {});
              //             },
              //           ),
              //           const SizedBox(width: 10),
              //           Expanded(
              //             child: Text(e.CategoryName),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
    return Image.asset(
      url,
      height: height,
      width: width,
    );
  }

  Widget moderatorExpansionTile() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: .5), borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              showModeratorList();
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: const Icon(
              Icons.person,
              size: 22,
            ),
            minLeadingWidth: 18,
            title: const Text(
              "Moderators",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.add, size: 25),
          ),
          if (selectedModerator.checkNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                itemCount: selectedModerator.length,
                itemBuilder: (BuildContext context, int index) {
                  return getModeratorSingleItem(model: selectedModerator[index], index: index);
                })
        ],
      ),
    );
  }

  Widget getModeratorSingleItem({required ForumUserInfoModel model, int index = 0}) {
    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: model.UserThumb,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0, left: 14, right: 14),
      child: Row(
        children: [
          if (model.UserThumb.checkNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CommonCachedNetworkImage(
                placeholder: null,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey.withOpacity(.4),
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 20,
                    ),
                  );
                },
                imageUrl: profileImageUrl,
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Text(model.UserName),
          const Spacer(),
          // if (index != 0)
          InkWell(
            onTap: () {
              if (selectedModerator.contains(model)) {
                selectedModerator.remove(model);
              } else {
                selectedModerator.add(model);
              }
              mySetState();
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                selectedModerator.contains(model) ? FontAwesomeIcons.solidSquareMinus : FontAwesomeIcons.solidSquarePlus,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCreateDiscussionButton() {
    return CommonButton(
      onPressed: () async {
        if (formKey.currentState?.validate() ?? false) {
          await createDiscussion();
        }
      },
      text: widget.arguments.isEdit ? "Update Forum" : "Create Discussion",
      fontColor: Colors.white,
      fontSize: 16,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  Widget getCommonTextFormField({
    FocusNode? fn,
    required TextEditingController controller,
    String hintext = "",
    IconData? prefixIconData,
    String iconAssetString = "",
    List<TextInputFormatter>? inputFormatters,
    IconData? suffix,
    String? Function(String?)? validator,
    bool isStarVisible = true,
    bool enable = true,
    int? maxLines,
    int? minLines,
  }) {
    return CommonTextFormField(
      isOutlineInputBorder: true,
      borderRadius: 5,
      node: fn,
      validator: validator,
      controller: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      hintText: hintext,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enable,
      label: RichText(
        text: TextSpan(
          text: "$hintext ",
          style: const TextStyle(color: Colors.black),
          children: [
            if (isStarVisible)
              const TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      inputFormatters: inputFormatters,
      prefixWidget: iconAssetString.checkNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  child: Image.asset(
                    iconAssetString,
                    height: 5,
                    width: 5,
                    fit: BoxFit.cover,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : prefixIconData == null
              ? null
              : Icon(
                  prefixIconData,
                  size: 15,
                ),
      suffixWidget: suffix == null ? null : Icon(suffix),
    );
  }

  Widget getSettingSectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(
          height: 0,
        ),
        getCheckListView(
          title: "Allow users to add topics",
          value: newTopicCheckBox,
          onChanged: (bool? val) {
            newTopicCheckBox = val ?? false;
            mySetState();
          },
        ),
        getCheckListView(
          title: "Allow users to attach files with posts",
          value: attachFilesCheckBox,
          onChanged: (bool? val) {
            attachFilesCheckBox = val ?? false;
            mySetState();
          },
        ),
        getCheckListView(
          title: "Allow users to like a topic or Comment",
          value: likeCheckBox,
          onChanged: (bool? val) {
            likeCheckBox = val ?? false;
            mySetState();
          },
        ),
        getCheckListView(
          title: "Allow users to share with connections or people",
          value: shareCheckBox,
          onChanged: (bool? val) {
            shareCheckBox = val ?? false;
            mySetState();
          },
        ),
        getCheckListView(
          title: "Allow users to pin the topics",
          value: pinCheckBox,
          onChanged: (bool? val) {
            pinCheckBox = val ?? false;
            mySetState();
          },
        ),
      ],
    );
  }

  Widget getCheckListView({bool value = false, Function(bool? val)? onChanged, required String title, ListTileControlAffinity listTileControlAffinity = ListTileControlAffinity.leading}) {
    return SizedBox(
      height: 35,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(color: Styles.lightGreyTextColor),
        ),
        controlAffinity: listTileControlAffinity,
      ),
    );
  }

  Widget getPrivacyPolicyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Privacy",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        getCheckListView(
          listTileControlAffinity: ListTileControlAffinity.leading,
          title: "Private Forum",
          value: privacyForumCheckBox,
          onChanged: (bool? val) {
            privacyForumCheckBox = val ?? false;
            mySetState();
          },
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Notification Subscriptions for this Discussion Forum",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "The Discussion notification at the site level must be 'on' for the user to receive any notifications. The following settings apply to this discussion forum only.",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        const SizedBox(
          height: 15,
        ),
        getRadioSingleItem(
          title: "Don’t send any notifications",
          value: 1,
          groupValue: _groupValue,
          onChanged: (val) {
            _groupValue = 1;
            mySetState();
          },
        ),
        const SizedBox(
          height: 15,
        ),
        getRadioSingleItem(
          title: "Send Notifications to the Moderators and to the User who Post Topic, Comment or Reply on this Forum",
          value: 2,
          groupValue: _groupValue,
          onChanged: (val) {
            _groupValue = 2;
            mySetState();
          },
        ),
        const SizedBox(
          height: 15,
        ),
        getRadioSingleItem(
          title: "Send Notifications about Activity on a Specific Topic to the Moderators of this Forum and to the Users who Post a Comment or a Reply to that Topic",
          value: 3,
          groupValue: _groupValue,
          onChanged: (val) {
            _groupValue = 3;
            mySetState();
          },
        ),
      ],
    );
  }

  Widget getRadioSingleItem({String title = "", int value = 0, int groupValue = 0, Function(int?)? onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 20, child: Radio(value: value, groupValue: groupValue, onChanged: onChanged)),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Styles.lightGreyTextColor),
          ),
        )
      ],
    );
  }
}

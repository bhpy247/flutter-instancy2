import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/message/components/roleFilterWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../models/message/data_model/chat_user_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../components/messageFilterWidget.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with MySafeState {
  bool isLoading = false;

  late MessageController messageController;
  late MessageProvider messageProvider;

  TextEditingController textEditingController = TextEditingController();

  List<ChatUserModel> chatUserList = <ChatUserModel>[];

  Future<void> getMessageUserList({bool isRefresh = true, bool isClear = true, bool isNotify = true}) async {
    chatUserList = await messageController.getChatUsersList(
      isRefresh: isRefresh,
      isNotify: isNotify,
      isClear: isClear,
    );

    int? userIdToNavigate = messageProvider.userIdToNavigateTo.get();
    if (userIdToNavigate != null) {
      messageProvider.userIdToNavigateTo.set(value: null, isNotify: false);

      int currentSiteId = ApiController().apiDataProvider.getCurrentSiteId();
      int currentUserId = ApiController().apiDataProvider.getCurrentUserId();

      List<ChatUserModel> list = messageProvider.allChatUsersList.getList().where((chatUser) {
        bool isValidUser = chatUser.UserID == userIdToNavigate;
        bool isValidSiteUser = chatUser.SiteID == currentSiteId;
        bool isValidUserStatus = chatUser.UserStatus == 1;
        bool isValidConnectionStatus = chatUser.Myconid == currentUserId;
        bool isValidRole = [MessageRoleTypes.admin, MessageRoleTypes.manager, MessageRoleTypes.groupAdmin, MessageRoleTypes.learner].contains(chatUser.RoleID);

        return isValidUser && isValidSiteUser && isValidUserStatus && isValidConnectionStatus && isValidRole;
      }).toList();

      if (list.isNotEmpty) {
        navigateToChatScreen(chatUserModel: list.first);
      }
    }
  }

  void showFilterSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<MessageProvider>(builder: (context, messageProvider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.,
            children: [
              const BottomSheetDragger(),
              InkWell(
                splashColor: Colors.black12,
                focusColor: Colors.black12,
                onTap: () {
                  Navigator.pop(context);
                  roleFilterBottomSheet(provider: messageProvider);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/role.png",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 22),
                      const Expanded(
                        child: Text(
                          "Role Filters",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Icon(
                        Icons.circle,
                        color: messageProvider.selectedFilterRole.get() != RoleFilterType.all ? Colors.green : Colors.transparent,
                        size: 10,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.black12,
                focusColor: Colors.black12,
                onTap: () {
                  Navigator.pop(context);
                  messageFilterBottomSheet(provider: messageProvider);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/messageFilter.png",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 22),
                      const Expanded(
                        child: Text(
                          "Message Filters",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Icon(
                        Icons.circle,
                        color: messageProvider.selectedMessageFilter.get() != MessageFilterType.all ? Colors.green : Colors.transparent,
                        size: 10,
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }

  void roleFilterBottomSheet({required MessageProvider provider}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return RoleFilterWidget(messageProvider: messageProvider);
      },
    );
  }

  void messageFilterBottomSheet({required MessageProvider provider}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MessageFilterWidget(messageProvider: messageProvider);
      },
    );
  }

  Future<void> navigateToChatScreen({required ChatUserModel chatUserModel}) async {
    await NavigationController.navigateToUserMessageListScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: UserMessageListScreenNavigationArguments(toUser: chatUserModel),
    );

    getMessageUserList(
      isRefresh: true,
      isClear: false,
      isNotify: true,
    );
  }

  @override
  void initState() {
    super.initState();
    messageProvider = context.read<MessageProvider>();
    messageController = MessageController(provider: messageProvider);

    bool isNavigateToUserChatScreen = messageProvider.userIdToNavigateTo.get() != null;

    getMessageUserList(
      isRefresh: isNavigateToUserChatScreen,
      isClear: isNavigateToUserChatScreen,
      isNotify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return AppUIComponents.getBackGroundBordersRounded(
      context: context,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<MessageProvider>.value(value: messageProvider),
        ],
        child: Consumer<MessageProvider>(
          builder: (BuildContext context, MessageProvider messageProvider, Widget? child) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: getSearchTextFormField()),
                  ],
                ),
                Expanded(
                  child: getUsersListVIew(messageProvider: messageProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getSearchTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: CommonTextFormField(
          borderRadius: 50,
          boxConstraints: const BoxConstraints(minWidth: 55),
          prefixWidget: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: "Search",
          isSuffix: true,
          suffixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (textEditingController.text.trim().isNotEmpty)
                InkWell(
                  onTap: () {
                    textEditingController.clear();
                    mySetState();
                  },
                  child: const Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showFilterSelectionBottomSheet();
                  },
                  child: const Icon(
                    FontAwesomeIcons.ellipsis,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          isOutlineInputBorder: true,
          controller: textEditingController,
          onChanged: (String text) {
            mySetState();
          },
        ),
      ),
    );
  }

  Widget getUsersListVIew({required MessageProvider messageProvider}) {
    if (messageProvider.isChatUsersLoading.get() && messageProvider.allChatUsersList.getList().isEmpty) {
      return const CommonLoader(isCenter: true);
    }

    List<ChatUserModel> chatUserList = messageProvider.filteredChatUserList.getList(isNewInstance: false);

    List<ChatUserModel> finalUsersList2 = chatUserList.where((ChatUserModel element) {
      String searchText = textEditingController.text.trim();

      return searchText.isEmpty || element.FullName.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    List<ChatUserModel> finalUsersList = finalUsersList2.where((ChatUserModel element) {
      if (messageProvider.selectedMessageFilter.get() == MessageFilterType.archive) {
        if (element.ArchivedUserID == -1) {
          return true;
        }
      } else {
        if (element.ArchivedUserID != -1) {
          return false;
        }
      }
      return true;
    }).toList();

    if (finalUsersList.isEmpty) {
      return Center(
        child: Text(
          "No Users",
          style: themeData.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        getMessageUserList(
          isRefresh: true,
          isNotify: true,
          isClear: true,
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: finalUsersList.length,
        itemBuilder: (context, int index) {
          MyPrint.printOnConsole("Name: ${finalUsersList[index].FullName} role: ${finalUsersList[index].JobTitle} roleId: ${finalUsersList[index].RoleID}");
          return getSingleUserItem(finalUsersList[index], index, messageProvider, finalUsersList);
        },
      ),
    );
  }

  Widget getSingleUserItem(ChatUserModel chatUser, int index, MessageProvider messageProvider, List<ChatUserModel> finalUsersList) {
    MyPrint.printOnConsole("UserName:${chatUser.FullName}, last message:${chatUser.LatestMessage}, ProfPic:${chatUser.ProfPic}, index:${chatUser.hashCode}");

    String imageUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: chatUser.ProfPic);

    return Dismissible(
      onDismissed: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          // messageProvider.isChatUsersLoading.set(value: true);
          finalUsersList.removeAt(index);
          messageController.setArchiveAndUnarchive(
            isArchive: chatUser.ArchivedUserID == -1,
            otherUserId: chatUser.UserID,
          );
          messageProvider.filteredChatUserList.setList(list: finalUsersList);
          if (chatUser.ArchivedUserID == -1) {
            MyToast.showSuccess(context: context, msg: "Successfully unarchived! you can view the chat by clicking on message filters -> All Message");
          } else {
            MyToast.showSuccess(context: context, msg: "Successfully archived! you can view the chat by clicking on message filters -> Archive");
          }
          // messageProvider.isChatUsersLoading.set(value: false);
          getMessageUserList(
            isRefresh: false,
            isNotify: false,
            isClear: false,
          );
        }
        mySetState();
      },
      background: Container(
        color: chatUser.ArchivedUserID != -1 ? Colors.red : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              chatUser.ArchivedUserID != -1 ? "assets/unarchive.png" : "assets/archive.png",
              height: 35,
              width: 35,
              fit: BoxFit.cover,
              color: Colors.white,
            ),
            Text(
              chatUser.ArchivedUserID != -1 ? "Unarchive" : "Archive",
              style: themeData.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: .3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      resizeDuration: const Duration(milliseconds: 200),
      key: Key(chatUser.FullName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: InkWell(
          onTap: () {
            navigateToChatScreen(chatUserModel: chatUser);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CommonCachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorIconSize: 30,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatUser.FullName,
                            style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: .3),
                          ),
                          if (chatUser.LatestMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                chatUser.LatestMessage,
                                style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      chatUser.Role,
                      style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DatePresentation.getLastChatMessageFormattedDate(dateTime: ParsingHelper.parseDateTimeMethod(chatUser.SendDateTime)) ?? "",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Styles.lightTextColor2,
                          ),
                        ),
                        Row(
                          children: [
                            if (chatUser.UnReadCount != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: themeData.primaryColor),
                                child: Text(
                                  chatUser.UnReadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

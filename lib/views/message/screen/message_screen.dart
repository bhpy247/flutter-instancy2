import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/message/components/roleFilterWidget.dart';
import 'package:flutter_instancy_2/views/message/screen/user_message_list.dart';
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
  }

  void showFilterSelectionBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MessageProvider>(builder: (context, messageProvider, _) {
            return Container(
              child: Column(
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
                          const SizedBox(
                            width: 22,
                          ),
                          Expanded(
                            child: const Text(
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
                          const SizedBox(
                            width: 22,
                          ),
                          Expanded(
                            child: const Text(
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
              ),
            );
          });
        });
  }

  void roleFilterBottomSheet({required MessageProvider provider}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return RoleFilterWidget(messageProvider: messageProvider);
        });
  }

  void messageFilterBottomSheet({required MessageProvider provider}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return MessageFilterWidget(messageProvider: messageProvider);
        });
  }

  @override
  void initState() {
    super.initState();
    messageProvider = context.read<MessageProvider>();
    messageController = MessageController(provider: messageProvider);
    getMessageUserList(
      isRefresh: false,
      isNotify: false,
      isClear: false,
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
                    )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
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

    List<ChatUserModel> finalUsersList = chatUserList.where((ChatUserModel element) {
      String searchText = textEditingController.text.trim();

      return searchText.isEmpty || element.FullName.toLowerCase().contains(searchText.toLowerCase());
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
          return getSingleUserItem(finalUsersList[index]);
        },
      ),
    );
  }

  Widget getSingleUserItem(ChatUserModel chatUser) {
    MyPrint.printOnConsole("UserName:${chatUser.FullName}, last message:${chatUser.LatestMessage}, index:${chatUser.hashCode}");

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => UserMessageListScreen(toUser: chatUser)));
          // mySetState();
          getMessageUserList(
            isRefresh: true,
            isClear: false,
            isNotify: true,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (chatUser.ProfPic.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonCachedNetworkImage(
                  imageUrl: chatUser.ProfPic,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
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
                  const SizedBox(
                    width: 14,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DatePresentation.getLastChatMessageFormattedDate(dateTime: ParsingHelper.parseDateTimeMethod(chatUser.SendDateTime)) ?? "",
                        // chatUser.sendDateTime,
                        // DateFormat.jm().format(DateTime.parse(chatUser.sendDateTime)),
                        style: const TextStyle(fontSize: 10, color: Styles.lightTextColor2),
                      ),
                      if (chatUser.UnReadCount != 0)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: themeData.primaryColor),
                          child: Text(
                            chatUser.UnReadCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterPopupMenu() {
    return PopupMenuButton<String>(
      // itemBuilder: (context) => [
      //   // PopupMenuItem 1
      //   const PopupMenuItem(
      //     value: 1,
      //     child: Text("All"),
      //   ),
      //   const PopupMenuItem(
      //     value: 2,
      //     child: Text("Group Admin"),
      //   ),const PopupMenuItem(
      //     value: 3,
      //     child: Text("Admin"),
      //   ),const PopupMenuItem(
      //     value: 4,
      //     child: Text("Manager"),
      //   ),
      // ],
      itemBuilder: (_) => RoleFilterType.values
          .map(
            (String e) => PopupMenuItem(
              value: e,
              child: Text(
                e,
                style: themeData.textTheme.labelMedium?.copyWith(
                  color: messageProvider.selectedFilterRole.get() == e ? themeData.primaryColor : null,
                ),
              ),
            ),
          )
          .toList(),
      offset: const Offset(0, 50),
      color: Colors.white,
      elevation: 2,
      onSelected: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        messageController.setSelectedFilterRole(selectedFilterRole: value);
      },
      child: const Icon(
        FontAwesomeIcons.ellipsis,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}

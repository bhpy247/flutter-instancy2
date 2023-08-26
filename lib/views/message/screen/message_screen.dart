import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/message/screen/user_message_list.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../models/message/data_model/chat_user_model.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';

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

  Future<void> getMessageUserList({bool isRefresh = true, bool isNotify = true}) async {
    chatUserList = await messageController.getChatUsersList(
      isRefresh: isRefresh,
      isNotify: isNotify,
    );
  }

  @override
  void initState() {
    super.initState();
    messageProvider = context.read<MessageProvider>();
    messageController = MessageController(provider: messageProvider);
    getMessageUserList(
      isRefresh: false,
      isNotify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return AppUIComponents.getBackGroundBordersRounded(
      context: context,
      child: Consumer<MessageProvider>(
        builder: (BuildContext context, MessageProvider messageProvider, Widget? child) {
          return Column(
            children: [
              getSearchTextFormField(),
              Expanded(
                child: getUsersListVIew(messageProvider: messageProvider),
              ),
            ],
          );
        },
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
    if (messageProvider.isChatUsersLoading.get()) {
      return const CommonLoader(isCenter: true);
    }

    List<ChatUserModel> chatUserList = messageProvider.chatUsersList.getList(isNewInstance: false);

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
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: finalUsersList.length,
        itemBuilder: (context, int index) {
          return getSingleUserItem(finalUsersList[index]);
        },
      ),
    );
  }

  Widget getSingleUserItem(ChatUserModel chatUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => UserMessageListScreen(toUser: chatUser)));

          getMessageUserList(
            isRefresh: true,
            isNotify: true,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chatUser.ProfPic.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonCachedNetworkImage(
                  imageUrl: chatUser.ProfPic,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Row(
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
}

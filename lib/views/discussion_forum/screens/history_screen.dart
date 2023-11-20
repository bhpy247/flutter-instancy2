import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/transferToAgent/screens/agent_chat_screen.dart';

import '../../../backend/app_theme/style.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_print.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_cached_network_image.dart';

class AgentHistoryScreen extends StatefulWidget {
  const AgentHistoryScreen({super.key});

  @override
  State<AgentHistoryScreen> createState() => _AgentHistoryScreenState();
}

class _AgentHistoryScreenState extends State<AgentHistoryScreen> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: getMainWidget(),
    );
  }

  Widget getMainWidget() {
    return ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return getSingleUserItem();
        });
  }

  Widget getSingleUserItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AgentChatScreen()));
          // mySetState();
          // getMessageUserList(
          //   isRefresh: true,
          //   isClear: false,
          //   isNotify: true,
          // );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // if (chatUser.ProfPic.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CommonCachedNetworkImage(
                imageUrl: "https://picsum.photos/id/237/200/300",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // ],
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
                          "Manoj Kumar",
                          style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: .3),
                        ),
                        // if (chatUser.LatestMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "Hi",
                            style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "chatUser.Role",
                  //   style: themeData.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  // ),
                  const SizedBox(
                    width: 14,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DatePresentation.getLastChatMessageFormattedDate(dateTime: DateTime.now()) ?? "",
                        // chatUser.sendDateTime,
                        // DateFormat.jm().format(DateTime.parse(chatUser.sendDateTime)),
                        style: const TextStyle(fontSize: 10, color: Styles.lightTextColor2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: themeData.primaryColor),
                        child: Text(
                          "1",
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

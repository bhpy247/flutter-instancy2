import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/backend/app_theme/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/app_ui_components.dart';

class AiAgentScreen extends StatefulWidget {
  static const String routeName = "/AiAgentScreen";
  final AiAgentScreenNavigationArgument arguments;

  const AiAgentScreen({super.key, required this.arguments});

  @override
  State<AiAgentScreen> createState() => _AiAgentScreenState();
}

class _AiAgentScreenState extends State<AiAgentScreen> with MySafeState {
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  List<AiAgentDataModel> dummyAiAgentDataModels = <AiAgentDataModel>[];
  List<AiAgentDataModel> rolePlayDataModels = <AiAgentDataModel>[];

  int currentIndex = -1;

  bool isSendingMessage = false;

  void checkAndAddChat() {
    int newIndex = currentIndex + 1;

    if (newIndex >= dummyAiAgentDataModels.length) {
      return;
    }

    currentIndex++;
    AiAgentDataModel rolePlayDataModel = dummyAiAgentDataModels[currentIndex];
    rolePlayDataModel.createdDateTime = DateTime.now();
    rolePlayDataModels.add(rolePlayDataModel);
    mySetState();

    if (!rolePlayDataModel.isMyMessage) {
      // checkAndPlayVideo();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Richard Parker",
    );
  }

  Widget getMainBody() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    itemCount: rolePlayDataModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      AiAgentDataModel rolePlayDataModel = rolePlayDataModels[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: getChatMessage(rolePlayDataModel: rolePlayDataModel),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Color(0xffE4E3E3),
                  height: 0,
                  thickness: 1.5,
                ),
                getTextField(),
              ],
            )));
  }

  AppBar? getAppBarWidget() {
    return AppBar(
      title: const Text(
        'Customer Query Resolution',
      ),
    );
  }

  Widget getChatMessage({required AiAgentDataModel rolePlayDataModel}) {
    if (rolePlayDataModel.isMyMessage) {
      return Row(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          mainWidget(rolePlayDataModel: rolePlayDataModel, isMyMessage: true),
        ],
      );
    } else {
      return Row(
        children: [
          mainWidget(rolePlayDataModel: rolePlayDataModel, isMyMessage: false),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      );
    }
  }

  Widget mainWidget({required AiAgentDataModel rolePlayDataModel, required bool isMyMessage}) {
    return Expanded(
      flex: 4,
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          /*Flexible(
            child: AWidget(index: index),
          ),*/
          Flexible(
            child: getCardBodyWidget(rolePlayDataModel: rolePlayDataModel),
          ),
        ],
      ),
    );
  }

  Widget getCardBodyWidget({required AiAgentDataModel rolePlayDataModel}) {
    String formattedTimeStampString = DatePresentation.getLastChatMessageFormattedDate(dateTime: rolePlayDataModel.createdDateTime) ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: rolePlayDataModel.isMyMessage ? themeData.primaryColor : Colors.grey.shade300,
        // color: themeData.scaffoldBackgroundColor,
        borderRadius: rolePlayDataModel.isMyMessage
            ? BorderRadius.circular(8).copyWith(
                topRight: const Radius.circular(0),
                bottomRight: const Radius.circular(16),
              )
            : BorderRadius.circular(8).copyWith(
                bottomLeft: const Radius.circular(16),
                topLeft: const Radius.circular(0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            rolePlayDataModel.message,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: rolePlayDataModel.isMyMessage ? Colors.white : null,
            ),
          ),
          Text(
            formattedTimeStampString,
            style: themeData.textTheme.labelSmall?.copyWith(
              color: rolePlayDataModel.isMyMessage ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextField() {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );

    // String userImageUrl = "";
    // String userImageUrl = widget.arguments.userImageUrl;
    // if (userImageUrl.isNotEmpty) {
    //   userImageUrl = AppConfigurations.getInstancyImageUrlFromImagePath(imagePath: userImageUrl);
    // }
    // MyPrint.printOnConsole("userImageUrl:$userImageUrl");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  onSubmitted: (String value) {},
                  onTap: () {
                    if (textEditingController.text.isNotEmpty) {
                      return;
                    }

                    if (currentIndex + 1 >= dummyAiAgentDataModels.length) {
                      return;
                    }

                    focusNode.unfocus();

                    AiAgentDataModel rolePlayDataModel = dummyAiAgentDataModels[currentIndex + 1];

                    if (!rolePlayDataModel.isMyMessage) return;

                    textEditingController.text = rolePlayDataModel.message;
                    // Future.delayed(const Duration(milliseconds: 1), () => FocusScope.of(context).unfocus());
                  },
                  textInputAction: TextInputAction.send,
                  style: themeData.textTheme.labelMedium,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Write Your Message...",
                    hintStyle: themeData.inputDecorationTheme.hintStyle?.copyWith(
                      fontSize: themeData.textTheme.labelMedium?.fontSize,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    filled: true,
                    fillColor: Styles.greyColor,
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () async {
                    checkAndAddChat();
                    textEditingController.clear();

                    Future.delayed(const Duration(seconds: 1), () => checkAndAddChat());
                  },
                  child: Container(
                    padding: EdgeInsets.all(isSendingMessage ? 5 : 10),
                    decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: isSendingMessage
                        ? SpinKitCircle(
                            color: themeData.colorScheme.onPrimary,
                            size: 30,
                          )
                        : Icon(
                            Icons.send,
                            size: 20,
                            color: themeData.colorScheme.onPrimary,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (pickedFile != null) getimageView()
      ],
    );
  }
}

class AiAgentDataModel {
  int index = 0;
  String message = "";
  bool isMyMessage = false;
  DateTime? createdDateTime;

  AiAgentDataModel({
    this.index = 0,
    this.message = "",
    this.isMyMessage = false,
    this.createdDateTime,
  });
}

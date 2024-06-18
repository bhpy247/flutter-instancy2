import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../backend/navigation/navigation.dart';
import '../../../utils/my_print.dart';

class RolePlayPreviewScreen extends StatefulWidget {
  static const String routeName = "/RolePlayPreviewScreen";

  final RolePlayPreviewScreenNavigationArguments arguments;

  const RolePlayPreviewScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<RolePlayPreviewScreen> createState() => _RolePlayPreviewScreenState();
}

class _RolePlayPreviewScreenState extends State<RolePlayPreviewScreen> with MySafeState {
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  VideoPlayerController? videoPlayerController;

  List<RolePlayDataModel> dummyRolePlayDataModels = <RolePlayDataModel>[];
  List<RolePlayDataModel> rolePlayDataModels = <RolePlayDataModel>[];

  int currentIndex = -1;

  bool isSendingMessage = false;

  void initializeDummyRolePlayDataModels() {
    dummyRolePlayDataModels.addAll([
      RolePlayDataModel(
        index: 0,
        message: "Hello, welcome to Ace Home Devices. How may I help you today?",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 1,
        message: "I am extremely frustrated because my appliances weren't delivered on the promised date. This is unacceptable!",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 2,
        message: "I am sorry for the inconvenience sir. can you tell me your order id so that I can help you to track your order?",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 3,
        message: "I don't have the Order ID at the moment, but the appliances were not delivered on time. I need an immediate solution to this problem!",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 4,
        message: "I can understand sir. but I will not be able to track and see what happened with your order without order id can you please tell me that?",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 5,
        message:
            "I understand your process, but as a customer, I expect my order to be delivered on time as promised. Can you please investigate with your team and see why there was a delay in the delivery? I need a proper explanation for this inconvenience.",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 6,
        message: "sure sir. If you provide me the order id I will tell ypu where is your order and give you a specific reason why it is not there yet.",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 7,
        message:
            "I appreciate your willingness to help, but unfortunately, I don't have the Order ID with me at the moment. Is there any other way that you can look into this issue and provide me with an update on the delivery status? I must know when my appliances will be delivered.",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 8,
        message: "ok sir. can you confirm that the number you are calling with is the same you used to order from the website?",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 9,
        message: "Yes, the number I am calling from is the same number I used to place the order on your website. Can you please check the status of my order with this phone number?",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 10,
        message: "ok I will track your order based on that. please wait a moment while I am looking into your order details.",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 11,
        message: "Thank you for your help with the late delivery of my appliances. I look forward to receiving an update on my order status.",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 12,
        message:
            "your oder is out for delivery. As we prepare each and every item carefully after getting the order and we have so many orders in this festive season and or sale is going on that's why it got delayed by one day. I am really sorry for that. It will reach your home by an hour.",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 13,
        message:
            "Thank you for the update and clarification. I appreciate your explanation and quick resolution to this issue. I understand that delays can happen, especially during busy times, and I thank you for your help in ensuring that my appliances are delivered today.",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 14,
        message: "thank you sir. Is there any other thing that I can help you with?",
        isMyMessage: true,
      ),
      RolePlayDataModel(
        index: 15,
        message: "No, that will be all for now. Thank you for your assistance in resolving the issue with my order. Have a great day.",
        isMyMessage: false,
      ),
      RolePlayDataModel(
        index: 16,
        message: "thank you sir. have a nice day to you too.",
        isMyMessage: true,
      ),
    ]);
  }

  void checkAndAddChat() {
    int newIndex = currentIndex + 1;

    if (newIndex >= dummyRolePlayDataModels.length) {
      return;
    }

    currentIndex++;
    RolePlayDataModel rolePlayDataModel = dummyRolePlayDataModels[currentIndex];
    rolePlayDataModel.createdDateTime = DateTime.now();
    rolePlayDataModels.add(rolePlayDataModel);
    mySetState();

    if (!rolePlayDataModel.isMyMessage) {
      checkAndPlayVideo();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> initializeVideoPlayerController({required String assetVideoPath}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("initializeVideoPlayerController() called", tag: tag);

    videoPlayerController = VideoPlayerController.asset(
      assetVideoPath,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
      ),
    );

    try {
      MyPrint.printOnConsole("Initializing Video", tag: tag);
      await videoPlayerController!.initialize();
      MyPrint.printOnConsole("Initialized Video", tag: tag);

      mySetState();
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Initializing Video:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      clearVideoController();
      return;
    }
  }

  Future<void> checkAndPlayVideo() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("checkAndPlayVideo() called", tag: tag);

    int index = currentIndex;
    MyPrint.printOnConsole("currentIndex:$index", tag: tag);

    if (videoPlayerController?.value.isCompleted ?? true) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because player null or completed", tag: tag);
      return;
    }

    ({int seekMilliseconds, int pauseMilliseconds}) videoData = switch (index) {
      1 => (seekMilliseconds: 0, pauseMilliseconds: 8100),
      3 => (seekMilliseconds: 8100, pauseMilliseconds: 9850),
      5 => (seekMilliseconds: 17000, pauseMilliseconds: 17500),
      7 => (seekMilliseconds: 34500, pauseMilliseconds: 17000),
      9 => (seekMilliseconds: 51500, pauseMilliseconds: 11000),
      11 => (seekMilliseconds: 62000, pauseMilliseconds: 8200),
      13 => (seekMilliseconds: 70000, pauseMilliseconds: 16500),
      15 => (seekMilliseconds: 86500, pauseMilliseconds: -1),
      _ => (seekMilliseconds: -1, pauseMilliseconds: -1),
    };

    if (videoData.seekMilliseconds == -1) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because invalid message", tag: tag);
      return;
    }

    if (videoPlayerController!.value.isPlaying) {
      try {
        MyPrint.printOnConsole("Pausing Video", tag: tag);
        await videoPlayerController!.play();
        MyPrint.printOnConsole("Paused Video", tag: tag);
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Pausing Video:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);

        clearVideoController();
        return;
      }
    }

    if (index != currentIndex) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because index not matching", tag: tag);
      return;
    }

    try {
      MyPrint.printOnConsole("Seeking Video", tag: tag);
      await videoPlayerController!.seekTo(Duration(milliseconds: videoData.seekMilliseconds));
      MyPrint.printOnConsole("Sought Video", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Seeking Video:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      clearVideoController();
      return;
    }

    if (index != currentIndex) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because index not matching", tag: tag);
      return;
    }

    try {
      MyPrint.printOnConsole("Playing Video", tag: tag);
      await videoPlayerController!.play();
      MyPrint.printOnConsole("Played Video", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Playing Video:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      clearVideoController();
      return;
    }

    if (index != currentIndex) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because index not matching", tag: tag);
      return;
    }

    if (videoData.pauseMilliseconds == -1) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because no pause needed", tag: tag);
      return;
    }

    await Future.delayed(Duration(milliseconds: videoData.pauseMilliseconds));

    if (index != currentIndex) {
      MyPrint.printOnConsole("Returning from checkAndPlayVideo() because index not matching", tag: tag);
      return;
    }

    try {
      MyPrint.printOnConsole("Pausing Video", tag: tag);
      await videoPlayerController!.pause();
      MyPrint.printOnConsole("Paused Video", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Playing Video:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      clearVideoController();
      return;
    }
  }

  void clearVideoController() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    mySetState();
  }

  Future<CourseDTOModel?> saveRoleplay() async {
    RoleplayContentModel roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel ?? RoleplayContentModel();
    coCreateContentAuthoringModel.roleplayContentModel = roleplayContentModel;

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    if (courseDTOModel != null) {
      courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
      courseDTOModel.Title = coCreateContentAuthoringModel.title;
      courseDTOModel.TitleName = coCreateContentAuthoringModel.title;

      courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
      courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;


      courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;

      courseDTOModel.roleplayContentModel = roleplayContentModel;

      if (!coCreateContentAuthoringModel.isEdit) {
        context.read<CoCreateKnowledgeProvider>().myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
      }
    }

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveRoleplay();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("PDFLaunchScreen init called with arguments:${widget.arguments}");

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    initializeDummyRolePlayDataModels();

    initializeVideoPlayerController(assetVideoPath: "assets/demo/ai-avatar-demo2.mp4").then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      checkAndAddChat();
      await Future.delayed(const Duration(seconds: 1));
      checkAndAddChat();
    });
  }

  @override
  void dispose() {
    clearVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    double? cacheExtent = scrollController.hasClients ? scrollController.position.maxScrollExtent : null;
    MyPrint.printOnConsole("cacheExtent:$cacheExtent");

    return Scaffold(
      appBar: getAppBarWidget(),
      body: Column(
        children: [
          getAIAvatarWidget(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              cacheExtent: cacheExtent,
              itemCount: rolePlayDataModels.length,
              itemBuilder: (BuildContext context, int index) {
                RolePlayDataModel rolePlayDataModel = rolePlayDataModels[index];

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
          getBottomButton(),
        ],
      ),
    );
  }

  AppBar? getAppBarWidget() {
    return AppBar(
      title: const Text(
        'Customer Query Resolution',
      ),
    );
  }

  Widget getAIAvatarWidget() {
    if (videoPlayerController == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(
          videoPlayerController!,
        ),
      ),
    );
  }

  Widget getChatMessage({required RolePlayDataModel rolePlayDataModel}) {
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

  Widget mainWidget({required RolePlayDataModel rolePlayDataModel, required bool isMyMessage}) {
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

  Widget getCardBodyWidget({required RolePlayDataModel rolePlayDataModel}) {
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

                    if (currentIndex + 1 >= dummyRolePlayDataModels.length) {
                      return;
                    }

                    focusNode.unfocus();

                    RolePlayDataModel rolePlayDataModel = dummyRolePlayDataModels[currentIndex + 1];

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

  Widget getBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Regenerate",
              fontColor: themeData.primaryColor,
              backGroundColor: themeData.colorScheme.onPrimary,
              borderColor: themeData.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CommonButton(
              onPressed: () {
                onSaveAndExitTap();
              },
              text: "Save",
              fontColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RolePlayDataModel {
  int index = 0;
  String message = "";
  bool isMyMessage = false;
  DateTime? createdDateTime;

  RolePlayDataModel({
    this.index = 0,
    this.message = "",
    this.isMyMessage = false,
    this.createdDateTime,
  });
}

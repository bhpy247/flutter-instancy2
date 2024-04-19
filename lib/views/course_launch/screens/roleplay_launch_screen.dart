import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/backend/app_theme/style.dart';
import 'package:flutter_chat_bot/backend/common/app_controller.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../../../../backend/navigation/navigation.dart';
import '../../../utils/my_print.dart';

class RolePlayLaunchScreen extends StatefulWidget {
  static const String routeName = "/RolePlayLaunchScreen";

  final RolePlayLaunchScreenNavigationArguments arguments;

  const RolePlayLaunchScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<RolePlayLaunchScreen> createState() => _RolePlayLaunchScreenState();
}

class _RolePlayLaunchScreenState extends State<RolePlayLaunchScreen> with MySafeState {
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  VideoPlayerController? videoPlayerController;

  List<RolePlayDataModel> dummyRolePlayDataModels = <RolePlayDataModel>[];
  List<RolePlayDataModel> rolePlayDataModels = <RolePlayDataModel>[];

  int currentIndex = -1;

  bool isSendingMessage = false;

  void initializeDummyRolePlayDataModels() {
    DateTime now = DateTime.now();

    dummyRolePlayDataModels.addAll([
      RolePlayDataModel(
        index: 0,
        message: "Hello, welcome to Ace Home Devices. How may I help you today?",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 0)),
      ),
      RolePlayDataModel(
        index: 1,
        message: "I'm angry because my appliances were not delivered on the promised delivery date! This is unacceptable!",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 10)),
      ),
      RolePlayDataModel(
        index: 2,
        message: "I am sorry for the inconvenience sir. can you tell me your order id so that I can help you to track your order?",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 20)),
      ),
      RolePlayDataModel(
        index: 3,
        message: "I don't have the order ID with me right now. But that doesn't change the fact that the appliances were not delivered on time. I need a solution to this problem immediately!",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 30)),
      ),
      RolePlayDataModel(
        index: 4,
        message: "I can understand sir. but I will not be able to track and see what happened with your order without order id can you please tell me that?",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 40)),
      ),
      RolePlayDataModel(
        index: 5,
        message:
            "I understand your process, but as a customer, I expect my order to be delivered on time as promised. Can you please check with your team and see why there was a delay in the delivery? I need a proper explanation for this inconvenience.",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 50)),
      ),
      RolePlayDataModel(
        index: 6,
        message: "sure sir. If you provide me the order id I will tell ypu where is your order and give you a specific reason why it is not there yet.",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 60)),
      ),
      RolePlayDataModel(
        index: 7,
        message:
            "I appreciate your willingness to help, but I don't have the order ID handy. Is there any other way you can look into this issue and provide me with an update on the delivery status? I really need to know when my appliances will be delivered.",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 70)),
      ),
      RolePlayDataModel(
        index: 8,
        message: "ok sir. can you confirm that the number you are calling with is the same you used to order from the website?",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 80)),
      ),
      RolePlayDataModel(
        index: 9,
        message: "Yes, the number I am calling from is the same number I used to place the order on your website. Can you please check the status of my order with this phone number?",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 90)),
      ),
      RolePlayDataModel(
        index: 10,
        message: "ok I will track your order based on that. please wait a moment while I am looking into your order details.",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 100)),
      ),
      RolePlayDataModel(
        index: 11,
        message:
            "Thank you for your assistance. I appreciate your help in resolving this issue regarding the late delivery of my appliances. I look forward to hearing an update on the status of my order.",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 110)),
      ),
      RolePlayDataModel(
        index: 12,
        message:
            "your oder is out for delivery. As we prepare each and every item carefully after getting the order and we have so many orders in this festive season and or sale is going on that's why it got delayed by one day. I am really sorry for that. It will reach your home by an hour.",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 120)),
      ),
      RolePlayDataModel(
        index: 13,
        message:
            "Thank you for the update and clarification. I appreciate your explanation and quick resolution to this issue. I understand that delays can happen, especially during busy times, and I thank you for your help in ensuring that my appliances are delivered today.",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 130)),
      ),
      RolePlayDataModel(
        index: 14,
        message: "thank you sir. Is there any other thing that I can help you with?",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 140)),
      ),
      RolePlayDataModel(
        index: 15,
        message: "No, that will be all for now. Thank you for your assistance in resolving the issue with my order. Have a great day.",
        isMyMessage: true,
        createdDateTime: now.add(const Duration(seconds: 150)),
      ),
      RolePlayDataModel(
        index: 16,
        message: "thank you sir. have a nice day to you too.",
        isMyMessage: false,
        createdDateTime: now.add(const Duration(seconds: 160)),
      ),
    ]);
  }

  void checkAndAddChat() {
    int newIndex = currentIndex + 1;

    if (newIndex < dummyRolePlayDataModels.length) {
      currentIndex++;
      RolePlayDataModel rolePlayDataModel = dummyRolePlayDataModels[currentIndex];
      rolePlayDataModels.add(rolePlayDataModel);
      mySetState();

      if (!rolePlayDataModel.isMyMessage) {
        checkAndPlayVideo();
      }

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
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
    MyPrint.printOnConsole("initializeVideoPlayerController() called", tag: tag);

    int index = currentIndex;
    MyPrint.printOnConsole("currentIndex:$index", tag: tag);

    if (videoPlayerController?.value.isCompleted ?? true) {
      MyPrint.printOnConsole("Returning from initializeVideoPlayerController() because player null or completed", tag: tag);
      return;
    }

    int pauseMilliseconds = switch (index) {
      0 => 5500,
      2 => 7500,
      4 => 9500,
      6 => 9000,
      8 => 7500,
      10 => 6500,
      12 => 17700,
      14 => 3800,
      16 => 4000,
      _ => -1,
    };

    if (pauseMilliseconds == -1) {
      MyPrint.printOnConsole("Returning from initializeVideoPlayerController() because invalid message", tag: tag);
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

    await Future.delayed(Duration(milliseconds: pauseMilliseconds));

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

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("PDFLaunchScreen init called with arguments:${widget.arguments}");

    initializeDummyRolePlayDataModels();

    initializeVideoPlayerController(assetVideoPath: "assets/demo/ai-avatar-demo1.mp4").then((value) {
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
    String formattedTimeStampString = DatePresentation.getFormattedDate(dateFormat: "", dateTime: rolePlayDataModel.createdDateTime) ?? "";

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
            style: themeData.textTheme.labelSmall,
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

    String userImageUrl = "";
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
                  decoration: InputDecoration(
                    hintText: "Write Your Message...",
                    hintStyle: themeData.inputDecorationTheme.hintStyle?.copyWith(
                      fontSize: themeData.textTheme.labelMedium?.fontSize,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    filled: true,
                    fillColor: Styles.greyColor,
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: userImageUrl.isNotEmpty
                              ? CommonCachedNetworkImage(
                                  imageUrl: userImageUrl,
                                  width: 35,
                                  height: 35,
                                  errorIconSize: 20,
                                  shimmerIconSize: 20,
                                )
                              : Image.asset(
                                  "assets/images/chatbot-chat-Icon.png",
                                  width: 35,
                                  height: 35,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                    );
                                  },
                                  package: AppController.getImagePackageName(),
                                ),
                        ),
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(onTap: () {}, child: const Icon(Icons.camera_alt_outlined)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // _speechToText.isNotListening
                            true
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: SpinKitWave(color: themeData.primaryColor, size: 15, type: SpinKitWaveType.center),
                                  ),
                            Container(
                              margin: const EdgeInsets.only(left: 0, right: 10),
                              child: GestureDetector(
                                /*onTap: isSendingMessage
                                    ? null
                                    : _speechToText.isNotListening
                                        ? _startListening
                                        : _stopListening,*/
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mic,
                                    color: themeData.textTheme.labelMedium?.color,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

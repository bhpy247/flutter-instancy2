import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/backend/chatbot/chatbot_provider.dart';
import 'package:flutter_chat_bot/chatbot.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/client_urls.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/successful_user_login_model.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../utils/my_print.dart';

class InstaBotScreen2 extends StatefulWidget {
  static const String routeName = "/InstaBotScreen2";

  final InstaBotScreen2NavigationArguments arguments;

  const InstaBotScreen2({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<InstaBotScreen2> createState() => _InstaBotScreen2State();
}

class _InstaBotScreen2State extends State<InstaBotScreen2> {
  late ThemeData themeData;

  late ChatBotArguments defaultArguments;
  ChatBotProvider chatBotProvider = ChatBotProvider();

  @override
  void initState() {
    super.initState();

    /*defaultArguments = ChatBotArguments(
      instancySiteUrl: "https://enterprisedemo.instancy.com/",
      userId: 375,
      userName: "Dishant Agrawal",
      userToken: "MWZjMDA5OWQtNzhiZi00MDkxLWE4NjItN2U4M2ZjZjcwYTViOjU3NGNjMDUyLTRlODUtNDRmMC04MjViLWRkYTVmZTNiMmU0YTo1LzExLzIwMjMgMTI6NDQ6MjMgUE0=",
      botName: "Instabot",
      trustedOrigins: [
        "https://enterprisedemo.instancy.com",
        "https://enterprisedemo-admin.instancy.com/",
      ],
      chatBotProvider: chatBotProvider,
    );*/

    InstaBotScreen2NavigationArguments arguments = widget.arguments;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;
    InstaBotProvider instaBotProvider = arguments.instaBotProvider ?? InstaBotProvider();
    SuccessfulUserLoginModel? successfulUserLoginModel = context.read<AuthenticationProvider>().getSuccessfulUserLoginModel();
    String imageUrl = successfulUserLoginModel?.image ?? "";

    String tokenUrl = ClientUrls.getChatBotTokenApiUrl(apiUrlConfigurationProvider.getCurrentSiteUrl());
    MyPrint.printOnConsole("tokenUrl:$tokenUrl");
    MyPrint.printOnConsole("siteBotDetailsModel _InstaBotScreen2State :${instaBotProvider.botDetailsModel.get()?.BotSettings.botIconBytes?.length}");

    String userName = apiUrlConfigurationProvider.getCurrentSiteLearnerUrl().replaceFirst("http://", "https://");
    if (arguments.courseId.isNotEmpty) userName += "~${arguments.courseId}";

    defaultArguments = ChatBotArguments(
      instancySiteUrl: apiUrlConfigurationProvider.getCurrentSiteLearnerUrl().replaceFirst("http://", "https://"),
      instancyApiUrl: apiUrlConfigurationProvider.getCurrentBaseApiUrl().replaceFirst("http://", "https://"),
      instancyTokenApiUrl: tokenUrl,
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
      siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
      // userName: successfulUserLoginModel?.username ?? "Instacy User",
      courseId: arguments.courseId,
      isCourseBot: arguments.courseId.isNotEmpty,
      userName: userName,
      userImageUrl: imageUrl,
      userToken: arguments.courseId.isNotEmpty ? "" : apiUrlConfigurationProvider.getAuthToken(),
      userLoggedIn: arguments.courseId.isNotEmpty ? true : apiUrlConfigurationProvider.getAuthToken().isNotEmpty,
      botName: "Instabot",
      botDetailsModel: instaBotProvider.botDetailsModel.get(),
      // botImageUrl: imageUrl,
      trustedOrigins: [
        apiUrlConfigurationProvider.getCurrentSiteLearnerUrl().replaceFirst("http://", "https://"),
        apiUrlConfigurationProvider.getCurrentSiteLMSUrl().replaceFirst("http://", "https://"),
      ],
      chatBotProvider: chatBotProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatBotProvider>.value(value: chatBotProvider),
        ],
        child: ChatBotVIew(
          arguments: defaultArguments,
          isStandaloneApp: false,
        ),
      ),
    );
  }
}

import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_repository.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../app_theme/app_theme_provider.dart';
import '../navigation/navigation_controller.dart';
import 'instabot_provider.dart';

class InstabotController {
  late InstabotRepository instabotRepository;
  late InstaBotProvider _instaBotProvider;

  InstabotController({required InstaBotProvider? provider, InstabotRepository? repository, ApiController? apiController}) {
    instabotRepository = repository ?? InstabotRepository(apiController: apiController ?? ApiController());
    _instaBotProvider = provider ?? InstaBotProvider();
  }

  InstaBotProvider get instaBotProvider => _instaBotProvider;

  Future<String> getInstabotUrl({
    required AppProvider appProvider,
    required NativeLoginDTOModel successfulUserLoginModel,
  }) async {
    MyPrint.printOnConsole("InstabotController().getInstabotUrl() called");

    String guid = "", url = "";

    DataResponseModel<String> responseModel = await instabotRepository.insertBotData(
      appProvider: appProvider,
      successfulUserLoginModel: successfulUserLoginModel,
    );
    guid = responseModel.data ?? "";

    if (guid.isEmpty) {
      return url;
    }

    url = "${instabotRepository.apiController.apiDataProvider.getCurrentSiteUrl()}/chatbot.html?ChatBotToken=$guid";
    if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "https://");
    }
    // url = "https://upgradedenterprise.instancy.com//chatbot.html?ChatBotToken=5cbead55-4d69-4990-99fd-381b323b12e6";

    MyPrint.printOnConsole("Instabot Url:$url");
    return url;
    //return "https://www.google.com/";
  }

  Future<BotDetailsModel?> getSiteBotDetails({required AppThemeProvider appThemeProvider, bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InstabotController().getSiteBotDetails() called", tag: tag);

    InstaBotProvider provider = instaBotProvider;

    BotDetailsModel? siteBotDetailsModel;
    provider.isSiteBotDetailsLoading.set(value: true, isNotify: isNotify);

    try {
      InstabotRepository repository = instabotRepository;

      DataResponseModel<BotDetailsModel> dataResponseModel = await repository.getSiteBotDetails();
      siteBotDetailsModel = dataResponseModel.data;

      MyPrint.printOnConsole("getSiteBotDetails response Model:$dataResponseModel", tag: tag);
      MyPrint.printOnConsole("BotSettings response Model:${dataResponseModel.data?.BotSettings}", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ChatBotController().getSiteBotDetails() $e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    provider.botDetailsModel.set(value: siteBotDetailsModel, isNotify: false);
    provider.isSiteBotDetailsLoading.set(value: false, isNotify: true);

    return siteBotDetailsModel;
  }

  bool enableMarginForChatBotButtonEnabled() {
    AppProvider? appProvider = NavigationController.mainNavigatorKey.currentContext?.read<AppProvider>();
    if (!(appProvider?.appSystemConfigurationModel.enableChatBot ?? true)) {
      return false;
    }

    if (appProvider?.appSystemConfigurationModel.mobileAppMenuPosition == "bottom") {
      return false;
    }

    if (instaBotProvider.isSiteBotDetailsLoading.get()) return false;

    BotDetailsModel? botDetailsModel = instaBotProvider.botDetailsModel.get();
    if (botDetailsModel == null) return false;

    return true;
  }
}

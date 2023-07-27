import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';

import '../common/common_provider.dart';

class InstaBotProvider extends CommonProvider {
  InstaBotProvider() {
    botDetailsModel = CommonProviderPrimitiveParameter<BotDetailsModel?>(
      value: null,
      notify: notify,
    );
    isSiteBotDetailsLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late final CommonProviderPrimitiveParameter<BotDetailsModel?> botDetailsModel;
  late final CommonProviderPrimitiveParameter<bool> isSiteBotDetailsLoading;
}

import 'package:flutter_chat_bot/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/feedback/data_model/feedback_dto_model.dart';

class FeedbackProvider extends CommonProvider {
  FeedbackProvider() {
    feedbackList = CommonProviderListParameter<FeedbackDtoModel>(list: [], notify: notify);
    isLoadingFeedbacks = CommonProviderPrimitiveParameter(value: false, notify: notify);
  }

  late CommonProviderListParameter<FeedbackDtoModel> feedbackList;
  late CommonProviderPrimitiveParameter<bool> isLoadingFeedbacks;

  void resetData() {
    feedbackList.setList(list: []);
    isLoadingFeedbacks.set(value: false);
  }
}

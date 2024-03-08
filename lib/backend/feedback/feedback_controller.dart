import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:flutter_instancy_2/models/feedback/data_model/feedback_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/response_model/common_response_model.dart';
import '../../models/feedback/request_model/update_feedback_request_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/common/components/common_confirmation_dialog.dart';
import '../app/app_provider.dart';
import 'feedback_repository.dart';

class FeedbackController {
  late FeedbackProvider _feedbackProvider;
  late FeedbackRepository _feedbackRepository;

  FeedbackController({required FeedbackProvider? feedbackProvider, FeedbackRepository? repository, ApiController? apiController}) {
    _feedbackProvider = feedbackProvider ?? FeedbackProvider();
    _feedbackRepository = repository ?? FeedbackRepository(apiController: apiController ?? ApiController());
  }

  FeedbackProvider get feedbackProvider => _feedbackProvider;

  FeedbackRepository get feedbackRepository => _feedbackRepository;

  Future<bool> updateFeedback({
    required UpdateFeedbackRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FeedbackController().updateFeedback() called '", tag: tag);

    DataResponseModel<List<CommonResponseModel>> dataResponseModel = await _feedbackRepository.updateFeedback(requestModel: requestModel);

    MyPrint.printOnConsole("UpdateFeed response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from FeedbackController().updateFeedback() because updateFeedback had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data?.first.issuccess ?? false;
  }

  Future<void> getFeedbackList({bool viewAll = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FeedbackController().updateFeedback() called '", tag: tag);

    _feedbackProvider.isLoadingFeedbacks.set(value: true);

    DataResponseModel<List<FeedbackDtoModel>> dataResponseModel = await _feedbackRepository.getFeedbackList(viewAll: viewAll);

    MyPrint.printOnConsole("UpdateFeed response:$dataResponseModel", tag: tag);
    List<FeedbackDtoModel> list = dataResponseModel.data ?? [];

    if (list.checkNotEmpty) {
      _feedbackProvider.feedbackList.setList(list: list);
    } else {
      _feedbackProvider.feedbackList.setList(list: []);
    }
    _feedbackProvider.isLoadingFeedbacks.set(value: false);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from FeedbackController().updateFeedback() because updateFeedback had some error", tag: tag);
      return;
    }
  }

  Future<bool> deleteFeedback({required int id, required BuildContext context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FeedbackController().deleteFeedback() called '", tag: tag);
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: "Remove Feedback",
          description: "Are you sure you want to remove this feedback?",
          confirmationText: "Confirm",
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteForum() because couldn't get confirmation", tag: tag);
      return false;
    }

    _feedbackProvider.isLoadingFeedbacks.set(value: true);
    DataResponseModel<String> dataResponseModel = await _feedbackRepository.deleteFeedback(id: id);

    MyPrint.printOnConsole("deleteFeedback response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from FeedbackController().deleteFeedback() because deleteFeedback had some error", tag: tag);
      return false;
    }
    _feedbackProvider.isLoadingFeedbacks.set(value: false);

    return dataResponseModel.data == "1";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/content_review_ratings/content_review_ratings_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/content_review_ratings/request_model/add_delete_content_user_ratings_request_model.dart';
import 'package:flutter_instancy_2/models/content_review_ratings/request_model/content_user_ratings_data_request_model.dart';
import 'package:flutter_instancy_2/models/content_review_ratings/response_model/content_user_ratings_data_response_model.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/content_review_ratings/data_model/content_user_rating_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';
import '../../views/content_review_ratings/components/add_edit_delete_review_dialog.dart';
import 'content_review_ratings_repository.dart';

class ContentReviewRatingsController {
  late ContentReviewRatingsProvider _contentReviewRatingsProvider;
  late ContentReviewRatingsRepository _filterRepository;

  ContentReviewRatingsController({
    required ContentReviewRatingsProvider? contentReviewRatingsProvider,
    ContentReviewRatingsRepository? repository,
    ApiController? apiController,
  }) {
    _contentReviewRatingsProvider = contentReviewRatingsProvider ?? ContentReviewRatingsProvider();
    _filterRepository = repository ?? ContentReviewRatingsRepository(apiController: apiController ?? ApiController());
  }

  ContentReviewRatingsProvider get contentReviewRatingsProvider => _contentReviewRatingsProvider;

  ContentReviewRatingsRepository get contentReviewRatingsRepository => _filterRepository;

  Future<List<ContentUserRatingModel>> getReviewsList({
    required String contentId,
    required int componentId,
    int documentLimit = 3,
    bool isRefresh = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "ContentReviewRatingsController().getReviewsList() called with contentId:'$contentId', componentId:'$componentId', "
        "documentLimit:'$documentLimit', isRefresh:'$isRefresh'",
        tag: tag);

    ContentReviewRatingsProvider provider = contentReviewRatingsProvider;

    List<ContentUserRatingModel> list = <ContentUserRatingModel>[];

    PaginationModel paginationModel = provider.paginationModel.get();

    if (isRefresh) {
      provider.maxReviewsCount.set(value: 0, isNotify: false);
      provider.userReviewsList.setList(list: [], isClear: true, isNotify: false);

      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 0,
        pageSize: documentLimit,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: false,
      );
    }

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Reviews', tag: tag);
      return provider.userReviewsList.getList();
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.userReviewsList.getList();
    //endregion

    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: true,
    );

    DataResponseModel<ContentUserRatingsDataResponseModel> dataResponseModel = await contentReviewRatingsRepository.getContentUserRatings(
      requestModel: ContentUserRatingsDataRequestModel(
        contentId: contentId,
        metadata: "0",
        cartId: "",
        iCms: "0",
        componentId: componentId.toString(),
        detailsCompId: InstancyComponents.Details.toString(),
        detailsCompInsId: InstancyComponents.DetailsComponentInsId.toString(),
        erItems: "false",
        noOfRows: paginationModel.pageSize,
        skippedRows: paginationModel.pageIndex,
      ),
    );

    if (dataResponseModel.data != null) {
      list = dataResponseModel.data!.userRatingDetails;
    }

    MyPrint.printOnConsole("Final userReviewsList length:${list.length}", tag: tag);
    provider.userReviewsList.setList(list: list, isClear: false, isNotify: false);
    provider.maxReviewsCount.set(value: dataResponseModel.data?.recordCount ?? 0, isNotify: false);
    provider.userLastReviewModel.set(value: dataResponseModel.data?.editRating, isNotify: false);
    MyPrint.printOnConsole("provider.maxReviewsCount:${provider.maxReviewsCount.get()}");

    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: false,
      isFirstTimeLoading: false,
      hasMore: provider.userReviewsListLength < provider.maxReviewsCount.get(),
      pageIndex: provider.userReviewsListLength,
      pageSize: provider.maxReviewsCount.get(),
      notifier: provider.notify,
      notify: true,
    );
    MyPrint.printOnConsole("Final userReviewsList paginationModel:$paginationModel", tag: tag);

    return provider.userReviewsList.getList(isNewInstance: true);
  }

  Future<bool> addEditReview({
    required String contentId,
    required String description,
    required int rating,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ContentReviewRatingsController().addEditReview() called with contentId:$contentId, description:$description, rating:$rating", tag: tag);

    bool isReviewAdded = false;

    try {
      DataResponseModel<String> responseModel = await contentReviewRatingsRepository.addReview(requestModel: AddDeleteContentUserRatingsRequestModel(
        contentId: contentId,
        description: description,
        rating: rating,
      ));
      MyPrint.printOnConsole("addReview response:$responseModel", tag: tag);

      if(responseModel.statusCode == 204) {
        isReviewAdded = true;
      }
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Adding Review in ContentReviewRatingsController().addEditReview():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isReviewAdded;
  }

  Future<bool> deleteReview({
    required String contentId,
    required int userId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ContentReviewRatingsController().deleteReview() called with contentId:$contentId", tag: tag);

    bool isReviewDeleted = false;

    try {
      DataResponseModel<String> responseModel = await contentReviewRatingsRepository.deleteReview(requestModel: AddDeleteContentUserRatingsRequestModel(
        contentId: contentId,
        userId: userId.toString(),
      ));
      MyPrint.printOnConsole("deleteReview response:$responseModel", tag: tag);

      if(responseModel.statusCode == 200) {
        isReviewDeleted = true;
      }
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Deleting Review in ContentReviewRatingsController().deleteReview():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isReviewDeleted;
  }
  
  Future<void> showAddEditDeleteReviewDialog({
    required BuildContext context,
    required String contentId,
    ContentUserRatingModel? userLastReviewModel,
    void Function({required String contentId, required String description, required int rating})? onAddEditReview,
    void Function({required String contentId, required int userId})? onDeleteReview,
  }) async {
    dynamic value = await showModalBottomSheet(
      context: context,
     isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddEditDeleteReviewDialog(
            userLastReviewModel: userLastReviewModel,
          ),
        );
      },
    );
    MyPrint.printOnConsole("Review value:$value");

    if(value is ContentUserRatingModel) {
      if(onAddEditReview != null) {
        onAddEditReview(
          contentId: contentId,
          description: value.description,
          rating: value.ratingId,
        );
      }
    }
    else if(value is AddDeleteContentUserRatingsRequestModel) {
      if(onDeleteReview != null) {
        onDeleteReview(contentId: contentId, userId: ParsingHelper.parseIntMethod(value.userId));
      }
    }
  }
}

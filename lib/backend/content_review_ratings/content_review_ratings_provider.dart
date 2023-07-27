import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';

import '../../models/content_review_ratings/data_model/content_user_rating_model.dart';

class ContentReviewRatingsProvider extends CommonProvider {
  ContentReviewRatingsProvider() {
    userReviewsList = CommonProviderListParameter<ContentUserRatingModel>(
      list: <ContentUserRatingModel>[],
      notify: notify,
    );
    maxReviewsCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    paginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        hasMore: true,
        isFirstTimeLoading: false,
        isLoading: false,
        pageIndex: 0,
        pageSize: 3,
        refreshLimit: 3,
      ),
      notify: notify,
    );
    userLastReviewModel = CommonProviderPrimitiveParameter<ContentUserRatingModel?>(
      value: null,
      notify: notify,
    );
  }

  late CommonProviderListParameter<ContentUserRatingModel> userReviewsList;
  int get userReviewsListLength => userReviewsList.getList(isNewInstance: false).length;

  late CommonProviderPrimitiveParameter<int> maxReviewsCount;
  late CommonProviderPrimitiveParameter<PaginationModel> paginationModel;
  late CommonProviderPrimitiveParameter<ContentUserRatingModel?> userLastReviewModel;

  void resetData() {
    userReviewsList.setList(list: [], isClear: true, isNotify: false);
    maxReviewsCount.set(value: 0, isNotify: false);
    paginationModel.set(
      value: PaginationModel(
        hasMore: true,
        isFirstTimeLoading: false,
        isLoading: false,
        pageIndex: 0,
        pageSize: 3,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    userLastReviewModel.set(value: null, isNotify: true);
  }
}

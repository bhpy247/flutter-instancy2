import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/bottomsheet_drager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../models/content_review_ratings/data_model/content_user_rating_model.dart';
import '../../../models/content_review_ratings/request_model/add_delete_content_user_ratings_request_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_text_form_field.dart';

class AddEditDeleteReviewDialog extends StatefulWidget {
  final ContentUserRatingModel? userLastReviewModel;

  const AddEditDeleteReviewDialog({
    super.key,
    this.userLastReviewModel,
  });

  @override
  State<AddEditDeleteReviewDialog> createState() => _AddEditDeleteReviewDialogState();
}

class _AddEditDeleteReviewDialogState extends State<AddEditDeleteReviewDialog> {
  late ThemeData themeData;

  late AppProvider appProvider;

  final TextEditingController reviewController = TextEditingController();
  bool isEditing = false;
  int totalRating = 0;

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    reviewController.text = widget.userLastReviewModel?.description ?? "";
    isEditing = widget.userLastReviewModel != null;
    totalRating = widget.userLastReviewModel?.ratingId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetDragger(),
          getRatingWidget(),
          const SizedBox(height: 20),
          getReviewWidget(),
          const SizedBox(height: 10),
          getButtonsRow(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget getRatingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Rate the Course",
          style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        getRatingStarWidget(),
      ],
    );
  }

  Widget getRatingStarWidget({ContentUserRatingModel? userLastReviewModel}) {
    bool editingEnabled = userLastReviewModel == null;

    return RatingBar.builder(
      initialRating: totalRating.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 30,
      unratedColor: Styles.chipBackgroundColor,
      glow: false,
      tapOnlyMode: true,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Styles.starYellowColor,
        size: 15,
      ),
      ignoreGestures: !editingEnabled,
      onRatingUpdate: (rating) {
        MyPrint.printOnConsole("rating:$rating");
        totalRating = rating.toInt();
        setState(() {});
      },
    );
  }

  Widget getReviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
         Text(
          "Write Your Review",
          style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),

        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CommonTextFormField(
            controller: reviewController,
            fillColor: Styles.textFieldBackgroundColor,
            isFilled: true,
            hintText: "What did you think about this content item?",
            borderRadius: 10,
            borderColor: Colors.transparent,

            isOutlineInputBorder: true,
            // keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  Widget getButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                if (isEditing && widget.userLastReviewModel != null) {
                  Navigator.pop(
                      context,
                      AddDeleteContentUserRatingsRequestModel(
                        userId: widget.userLastReviewModel!.ratingUserId.toString(),
                      ));
                } else {
                  Navigator.pop(context);
                }
              },
              backGroundColor: Colors.white,
              borderColor: themeData.primaryColor,
              fontColor: themeData.primaryColor,
              fontWeight: FontWeight.w600,
              // isPrimary: false,
              text: isEditing ? appProvider.localStr.mylearningActionsheetDeleteoption : appProvider.localStr.mylearningAlertbuttonCancelbutton,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            flex: 3,
            // child: CommonPrimarySecondaryButton(
            child: CommonButton(
              onPressed: () {
                if (totalRating > 0) {
                  Navigator.pop(
                      context,
                      ContentUserRatingModel(
                        description: reviewController.text,
                        ratingId: totalRating.toInt(),
                      ));
                } else {
                  MyToast.showError(context: context, msg: "Rating shouldn't be 0");
                }
              },
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              fontColor: Colors.white,
              fontWeight: FontWeight.w600,
              // isPrimary: true,
              text: isEditing ? appProvider.localStr.detailsButtonUpdatebutton : appProvider.localStr.detailsButtonSubmitbutton,
            ),
          ),
        ],
      ),
    );
  }
}

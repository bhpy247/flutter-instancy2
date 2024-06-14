import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/size_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';

import 'app_decoration.dart';
import 'custom_icon_button.dart';
import 'custom_image_view.dart';
import 'image_constants.dart';

class MyKnowledgeItemWidget extends StatelessWidget {
  final Function()? onMoreTap;
  final Function()? onCardTap;
  final CourseDTOModel model;

  MyKnowledgeItemWidget({
    super.key,
    this.onMoreTap,
    required this.model,
    this.onCardTap,
  });

  final Map<String, String> imageList = {
    "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}": "assets/cocreate/Card.png",
    "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}": "assets/cocreate/Chat Question.png",
    "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.audio}": "assets/cocreate/Vector-4.png",
    "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}": "assets/cocreate/Vector-2.png",
    "${InstancyObjectTypes.mediaResource}_${InstancyMediaTypes.video}": "assets/cocreate/video.png",
    "${InstancyObjectTypes.reference}_${InstancyMediaTypes.url}": "assets/cocreate/Vector-1.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.word}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.pDF}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.excel}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.ppt}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.mpp}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.visioTypes}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.document}_${InstancyMediaTypes.csv}": "assets/cocreate/Vector.png",
    "${InstancyObjectTypes.events}_${InstancyMediaTypes.none}": "assets/cocreate/Vector-3.png",
    "${InstancyObjectTypes.rolePlay}_${InstancyMediaTypes.none}": "assets/cocreate/video.png",
    "${InstancyObjectTypes.learningMaps}_${InstancyMediaTypes.none}": "assets/cocreate/Business Hierarchy.png",
    "${InstancyObjectTypes.courseBot}_${InstancyMediaTypes.none}": "assets/cocreate/Ai.png",
  };

  @override
  Widget build(BuildContext context) {
    String imagePath = imageList["${model.ContentTypeId}_${model.MediaTypeID}"] ?? "";
    MyPrint.printOnConsole("model.ContentType ${model.ContentType} : $imagePath");
    return InkWell(
      onTap: onCardTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6.h,
          vertical: 8.v,
        ),
        margin: EdgeInsets.only(top: 15.h),
        decoration: AppDecoration.outlineBlack.copyWith(borderRadius: BorderRadius.circular(5)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.adaptSize,
              width: 80.adaptSize,
              margin: EdgeInsets.only(bottom: 5.v),
              decoration: AppDecoration.fillGreen200.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder3,
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgThumbsUp,
                height: 68.v,
                width: 80.h,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: 3.v,
                  right: 7.h,
                  bottom: 8.v,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // coursesIcon(assetName: AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: model.MediaTypeID, objectTypeId: model.ContentTypeId)),
                                coursesIcon(assetName: imagePath),
                                const SizedBox(width: 10),
                                Text(
                                  model.ContentType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xff757575),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5.v),
                            Text(
                              model.Title,
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 7.v),
                            Text(
                              model.AuthorDisplayName,
                              style: theme.textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 5.v),
                        CustomImageView(
                          onTap: onMoreTap,
                          imagePath: ImageConstant.imgNotification,
                          height: 15.v,
                          width: 11.h,
                        ),
                        SizedBox(height: 32.v),
                        CustomIconButton(
                          height: 25,
                          width: 25,
                          padding: EdgeInsets.all(6.h),
                          decoration: IconButtonStyleHelper.outlineBlackTL12,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgDownload,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.contain,
    );
  }
}

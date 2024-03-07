import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';

class QuestionAnswerCard extends StatefulWidget {
  final Function()? onCardTap;
  final Function()? onMoreTap;
  final Function()? onAnswerButtonTap;
  final UserQuestionListDto userQuestionListDto;
  final bool isDetailScreen;
  final int answerListCount;

  const QuestionAnswerCard({super.key, this.onCardTap, required this.userQuestionListDto, this.answerListCount = 0, this.onAnswerButtonTap, this.onMoreTap, this.isDetailScreen = false});

  @override
  State<QuestionAnswerCard> createState() => _QuestionAnswerCardState();
}

class _QuestionAnswerCardState extends State<QuestionAnswerCard> {
  late ThemeData themeData;
  List<String> list = [];

  @override
  void initState() {
    super.initState();
    if (widget.userQuestionListDto.questionCategories.checkNotEmpty) {
      list = widget.userQuestionListDto.questionCategories.split(",");
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        if (widget.onCardTap != null) {
          widget.onCardTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13).copyWith(bottom: 5),
        margin: const EdgeInsets.only(bottom: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileView(),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.userQuestionListDto.userQuestion.checkNotEmpty ? widget.userQuestionListDto.userQuestion : "What the difference between customer satisfaction and delight ?",
              style: themeData.textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            thumbNailWidget(widget.isDetailScreen ? widget.userQuestionListDto.userQuestionImagePath : widget.userQuestionListDto.userQuestionImagePath),

            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Html(
                data: widget.userQuestionListDto.userQuestionDescription.checkNotEmpty
                    ? widget.userQuestionListDto.userQuestionDescription
                    : "Customer satisfaction and customer delight go hand in hand. However, customer satisfaction broadly speaking, is meeting the customers requirements in the best possible way.",
                style: {
                  "body": Style(
                    color: themeData.colorScheme.onBackground.withOpacity(0.65),
                    fontWeight: FontWeight.w400,
                    // fontFamily: "Roboto",
                    fontSize: FontSize(themeData.textTheme.labelMedium?.fontSize ?? 12),
                  ),
                },
              ),
            ),
            // Text(
            //   widget.userQuestionListDto.userQuestion
            //   "Customer satisfaction and customer delight go hand in hand. However, customer satisfaction broadly speaking, is meeting the customers requirements in the best possible way.",
            //   style: themeData.textTheme.bodyMedium?.copyWith(color: const Color(0xff757575), fontWeight: FontWeight.w400),
            // ),
            const SizedBox(
              height: 12,
            ),
            getQuestionCategories(),
            const SizedBox(
              height: 12,
            ),
            bottomRow()
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    String profileImage = "";
    if (widget.userQuestionListDto.picture.checkNotEmpty) {
      profileImage = widget.userQuestionListDto.picture;
    }
    if (widget.userQuestionListDto.userImage.checkNotEmpty) {
      profileImage = widget.userQuestionListDto.userImage;
    }

    String profileImageUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: profileImage,
      ),
    );

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: profileImageUrl,
              // imageUrl: profileImageUrl,
              // imageUrl: imageUrl,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              errorIconSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userQuestionListDto.userName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.userQuestionListDto.postedDate,
                      // DatePresentation.getFormattedDate(dateFormat: "dd MMMM yyyy", dateTime: DateFormat("MM/dd/yyyy hh:mm:ss a").parse(forumModel.CreatedDate)) ?? "",
                      // DatePresentation.niceDateFormatter(forumModel.CreatedDate, endTimeStamp),
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
              if (widget.onMoreTap != null)
                InkWell(
                  onTap: widget.onMoreTap,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 18,
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget thumbNailWidget(String url) {
    if (url.checkEmpty) return const SizedBox();
    url = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url),
    );
    // MyPrint.printOnConsole('thumbnailImageUrl:$url');

    if (url.checkEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: CommonCachedNetworkImage(
        imageUrl: url,
        height: 75,
        width: 75,
        fit: BoxFit.contain,
        errorWidget: (_, __, ___) {
          return const Icon(
            Icons.image,
            color: Colors.grey,
          );
        },
      ),
    );
    //for video thumbnail
    /*return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonCachedNetworkImage(
            imageUrl: url,
            height: 75,
            width: 75,
            fit: BoxFit.cover,

          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.play_arrow,size: 15,)),
          )
        ],
      ),
    );*/
  }

  Widget getQuestionCategories() {
    return Container(
      child: Wrap(
        runSpacing: -1,
        spacing: 10,
        children: list
            .map(
              (e) => Chip(
                side: const BorderSide(color: Color(0xffD3D3D3)),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xffEFEFEF),
                label: Text(
                  e,
                  style: themeData.textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget bottomRow() {
    return Row(
      children: [
        // iconTextButton(
        //   iconData: Icons.thumb_up_alt_outlined,
        //   text: "2",
        //   onTap: () {},
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
        Expanded(
          child: Row(
            children: [
              iconTextButton(
                imageAsset: "assets/comment.png",
                // iconData: FontAwesomeIcons.sackDollar,
                text: widget.userQuestionListDto.Answers.checkEmpty ? widget.answerListCount.toString() : widget.userQuestionListDto.Answers,
              ),
              if (!widget.isDetailScreen) ...[
                SizedBox(
                  width: 10,
                ),
                iconTextButton(
                  iconData: FontAwesomeIcons.eye,
                  text: widget.userQuestionListDto.views.toString(),
                ),
              ]
            ],
          ),
        ),
        answerButton()
      ],
    );
  }

  Widget answerButton() {
    if (widget.userQuestionListDto.answerBtnWithLink.checkEmpty) return const SizedBox();
    return CommonButton(
      onPressed: () {
        if (widget.onAnswerButtonTap != null) {
          widget.onAnswerButtonTap!();
        }
      },
      text: "Add Answer",
      fontColor: Colors.white,
      borderRadius: 2,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget iconTextButton({IconData? iconData, String text = " ", Function()? onTap, String? imageAsset}) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  )
                : Icon(iconData, color: Styles.iconColor, size: 18),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          text,
          style: themeData.textTheme.bodySmall,
        )
      ],
    );
  }
}

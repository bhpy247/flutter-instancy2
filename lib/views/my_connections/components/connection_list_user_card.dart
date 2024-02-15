import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/my_connections/data_model/people_listing_item_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:provider/provider.dart';

class ConnectionListUserCard extends StatefulWidget {
  final PeopleListingItemDTOModel model;
  final bool isListViewMode;
  final void Function({required PeopleListingItemDTOModel model})? onCardTap;
  final void Function({required PeopleListingItemDTOModel model})? onAddToMyConnectionsTap;
  final void Function({required PeopleListingItemDTOModel model})? onRemoveFromMyConnectionsTap;
  final void Function({required PeopleListingItemDTOModel model})? onAcceptConnectionRequestTap;
  final void Function({required PeopleListingItemDTOModel model})? onRejectConnectionRequestTap;

  const ConnectionListUserCard({
    super.key,
    required this.model,
    this.isListViewMode = true,
    this.onCardTap,
    this.onAddToMyConnectionsTap,
    this.onRemoveFromMyConnectionsTap,
    this.onAcceptConnectionRequestTap,
    this.onRejectConnectionRequestTap,
  });

  @override
  State<ConnectionListUserCard> createState() => _ConnectionListUserCardState();
}

class _ConnectionListUserCardState extends State<ConnectionListUserCard> with MySafeState {
  late AppProvider appProvider;
  late PeopleListingItemDTOModel model;



  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    model = widget.model;
  }

  @override
  void didUpdateWidget(covariant ConnectionListUserCard oldWidget) {
    model = widget.model;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    if (widget.isListViewMode) {
      return getListViewCard();
    } else {
      return getGridViewCard();
    }
  }

  Widget getListViewCard() {
    return InkWell(
      onTap: () {
        if (widget.onCardTap != null) {
          widget.onCardTap!(model: model);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5)),
          color: themeData.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.5, 0.5),
              color: themeData.colorScheme.onBackground.withAlpha(15),
              spreadRadius: 2,
              blurRadius: 1,
            ),
            BoxShadow(
              offset: const Offset(-0.5, -0.5),
              color: themeData.colorScheme.onBackground.withAlpha(15),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                getUserImageWidget(size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.UserDisplayname,
                        style: themeData.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                getSecondaryActionButton(),
                getPrimaryActionButton(isListView: true),
              ],
            ),
            getSkillsWidget(),
          ],
        ),
      ),
    );
  }

  Widget getGridViewCard() {
    return InkWell(
      onTap: () {
        if (widget.onCardTap != null) {
          widget.onCardTap!(model: model);
        }
      },
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5)),
              color: themeData.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0.5, 0.5),
                  color: themeData.colorScheme.onBackground.withAlpha(15),
                  spreadRadius: 2,
                  blurRadius: 1,
                ),
                BoxShadow(
                  offset: const Offset(-0.5, -0.5),
                  color: themeData.colorScheme.onBackground.withAlpha(15),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getUserImageWidget(size: 70),
                const SizedBox(height: 10),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          widget.model.UserDisplayname,
                          style: themeData.textTheme.titleSmall?.copyWith(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: getPrimaryActionButton(isListView: false)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: getSecondaryActionButton(),
          ),
        ],
      ),
    );
  }

  Widget getUserImageWidget({required double size}) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: widget.model.MemberProfileImage));
    // MyPrint.printOnConsole("Connection List User Thumbnail Image Url:$imageUrl");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // border: Border.all(color: themeData.primaryColor, width: 1.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CommonCachedNetworkImage(
          imageUrl: imageUrl,
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getSkillsWidget() {
    if (model.InterestAreas.isEmpty) {
      return const SizedBox();
    }

    return Html(
      data: "Expertise: ${model.InterestAreas}",
      style: {
        "body": Style(
          fontSize: FontSize(13),
          fontWeight: FontWeight.w900,
          color: themeData.textTheme.bodySmall?.color?.withAlpha(150),
        ),
      },
    );
  }

  Widget getPrimaryActionButton({bool isListView = true}) {
    bool isAddToMyConnectionsEnabled = model.AddToMyConnectionAction.isNotEmpty;
    bool isRequestSent = model.connectionstateAccept.isNotEmpty;
    bool isAcceptConnectionEnabled = model.AcceptAction.isNotEmpty;
    bool isSendMessageEnabled = model.SendMessageAction.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAddToMyConnectionsEnabled)
          CommonButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            onPressed: () {
              if (widget.onAddToMyConnectionsTap != null) {
                widget.onAddToMyConnectionsTap!(model: model);
              }
            },
            backGroundColor: themeData.primaryColor,
            text: appProvider.localStr.myconnectionsActionsheetAddtomyconnectionsoption,
            // text: "+ Connection",
            fontSize: 13,
            fontColor: themeData.colorScheme.onPrimary,
            borderRadius: 3,
          ),
        if (isRequestSent)
          CommonButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            onPressed: () {},
            backGroundColor: themeData.textTheme.bodySmall?.color?.withAlpha(20),
            text: appProvider.localStr.myConnectionsActionSheetRequestSentOption,
            // text: "Request Sent",
            fontSize: 13,
            borderRadius: 3,
          ),
        if (isAcceptConnectionEnabled) ...[
          CommonButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            onPressed: () {
              if (widget.onAcceptConnectionRequestTap != null) {
                widget.onAcceptConnectionRequestTap!(model: model);
              }
            },
            backGroundColor: themeData.primaryColor,
            text: appProvider.localStr.myconnectionsActionsheetAcceptconnectionoption,
            // text: "Accept",
            fontSize: 13,
            fontColor: themeData.colorScheme.onPrimary,
            borderRadius: 3,
          ),
          const SizedBox(width: 4),
          CommonButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            onPressed: () {
              if (widget.onRejectConnectionRequestTap != null) {
                widget.onRejectConnectionRequestTap!(model: model);
              }
            },
            backGroundColor: themeData.textTheme.bodySmall?.color?.withAlpha(20),
            text: appProvider.localStr.myconnectionsActionsheetIgnoreconnectionoption,
            // text: "Reject",
            fontSize: 13,
            borderRadius: 3,
          ),
        ],
        if (isSendMessageEnabled)
          CommonButton(
            padding: isListView ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            onPressed: () {},
            iconData: Icons.send,
            text: isListView ? "" : appProvider.localStr.myconnectionsActionsheetSendmessageoption,
            // text: isListView ? "" : "Message",
            backGroundColor: isListView ? Colors.transparent : null,
            borderColor: Colors.transparent,
            iconColor: isListView ? null : themeData.colorScheme.onPrimary,
            fontColor: isListView ? null : themeData.colorScheme.onPrimary,
            fontSize: 13,
            iconSize: isListView ? 22 : 15,
          ),
      ],
    );
  }

  Widget getSecondaryActionButton() {
    List<InstancyUIActionModel> options = <InstancyUIActionModel>[];

    if (model.RemoveFromMyConnectionAction.isNotEmpty) {
      options.add(
        InstancyUIActionModel(
          text: appProvider.localStr.myconnectionsActionsheetRemoveconnectionoption,
          iconData: InstancyIcons.remove,
          onTap: () {
            Navigator.pop(context);

            if (widget.onRemoveFromMyConnectionsTap != null) {
              widget.onRemoveFromMyConnectionsTap!(model: model);
            }
          },
        ),
      );
    }

    if (options.isEmpty) {
      return const SizedBox();
    }

    return CommonButton(
      onPressed: () {
        InstancyUIActions().showAction(
          context: context,
          actions: options,
        );
      },
      iconData: Icons.more_vert,
      backGroundColor: Colors.transparent,
      borderRadius: 100,
      padding: const EdgeInsets.all(2),
      borderColor: Colors.transparent,
      iconSize: 20,
      // margin: EdgeInsets.s,
    );
  }
}

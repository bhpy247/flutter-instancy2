import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/bottomsheet_drager.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/bottomsheet_option_tile.dart';

class InstancyUIActions {
  Future<void> showAction({
    required BuildContext context,
    required List<InstancyUIActionModel> actions,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        ThemeData themeData = Theme.of(context);

        return Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          decoration: BoxDecoration(
            color: themeData.colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetDragger(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...actions.map((InstancyUIActionModel actionModel) {
                        return BottomSheetOptionTile(
                          text: actionModel.text,
                          onTap: actionModel.onTap,
                          iconData: actionModel.iconData,
                          iconColor: actionModel.iconColor,
                          iconSize: actionModel.iconSize,
                          svgImageUrl: actionModel.svgImageUrl,
                          textColor: actionModel.textColor,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InstancyUIActionModel {
  final IconData? iconData;
  final String text;
  final String? svgImageUrl;
  final Color? iconColor, textColor;
  final double? iconSize;
  final void Function()? onTap;
  final InstancyContentActionsEnum? actionsEnum;

  const InstancyUIActionModel({
    this.iconData,
    required this.text,
    this.iconColor,
    this.svgImageUrl,
    this.textColor,
    this.iconSize,
    this.onTap,
    this.actionsEnum,
  });
}

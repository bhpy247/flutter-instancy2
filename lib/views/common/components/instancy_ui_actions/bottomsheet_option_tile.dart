import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetOptionTile extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final String? svgImageUrl;
  final Color? iconColor, textColor;
  final double? iconSize;
  final void Function()? onTap;

  BottomSheetOptionTile({
    super.key,
    this.iconData,
    required this.text,
    this.iconColor,
    this.svgImageUrl,
    this.textColor,
    this.iconSize,
    this.onTap,
  }) : assert(
      iconData == null || (svgImageUrl?.isEmpty ?? true),
      "Cannot provider both iconData and svgImageUrl"
      ),
      assert(
      iconData != null || (svgImageUrl?.isNotEmpty ?? false),
      "you have to pass any one of the iconData and svgImageUrl"
      );


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ListTile(
      minLeadingWidth: 35,
      contentPadding: const EdgeInsets.symmetric(horizontal:20,vertical: 0),
      onTap: () async {
        if(onTap != null) {
          onTap!();
        }
      },
      leading: (svgImageUrl?.isEmpty ?? true) ? Icon(
        iconData,
        color: iconColor ?? themeData.textTheme.labelSmall?.color,
        size: iconSize ?? 20,
      ) : SvgPicture.asset(
        svgImageUrl!,
        width: iconSize ?? 25,
        height: iconSize ?? 25,
      ),
      title: Text(
        text,
        style: themeData.textTheme.labelLarge?.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

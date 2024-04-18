import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';

extension on TextStyle {}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Label text style
  static get labelMediumGray600 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray600,
      );

// Title text style
  static get titleSmallGreen800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.green800,
      );
}

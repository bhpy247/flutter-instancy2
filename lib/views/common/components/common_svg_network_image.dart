import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../backend/app_theme/style.dart';
import '../../../utils/my_utils.dart';

class CommonSVGNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  const CommonSVGNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      MyUtils.getSecureUrl(imageUrl),
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      placeholderBuilder: placeholder ?? (context) => Shimmer.fromColors(
        baseColor: Styles.shimmerBaseColor,
        highlightColor: Styles.shimmerHighlightColor,
        child: Container(
          alignment: Alignment.center,
          color: Styles.shimmerContainerColor,
          child: const Icon(
            Icons.image,
            size: 100,
          ),
        ),
      ),
    );
  }
}

typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
);

typedef LoadingErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
  dynamic error,
);
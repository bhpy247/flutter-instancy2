import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../backend/app_theme/style.dart';
import '../../../utils/my_utils.dart';

class CommonCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height, shimmerIconSize, errorIconSize, errorHeight, errorWidth;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  const CommonCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.shimmerIconSize = 100,
    this.errorIconSize = 100,
    this.errorHeight,
    this.errorWidth,
    this.fit,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: MyUtils.getSecureUrl(imageUrl),
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder ?? (context, url) => Shimmer.fromColors(
        baseColor: Styles.shimmerBaseColor,
        highlightColor: Styles.shimmerHighlightColor,
        child: Container(
          alignment: Alignment.center,
          color: Styles.shimmerContainerColor,
          child: Icon(
            Icons.image,
            size: shimmerIconSize,
          ),
        ),
      ),
      /*progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress) {
        MyPrint.printOnConsole("url:$url");
        MyPrint.printOnConsole("progress.downloaded:${progress.downloaded}");
        MyPrint.printOnConsole("progress.totalSize:${progress.totalSize}");

        return Shimmer.fromColors(
          baseColor: Styles.shimmerBaseColor,
          highlightColor: Styles.shimmerHighlightColor,
          child: Container(
            alignment: Alignment.center,
            color: Styles.shimmerContainerColor,
            child: Icon(
              Icons.image,
              size: shimmerIconSize,
            ),
          ),
        );
      },*/
      errorWidget: errorWidget ?? (context, url, error) {
        return Container(
          width: errorHeight ?? MediaQuery.of(context).size.width,
          height: errorHeight ?? MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: Icon(
            Icons.image_outlined,
            color: Colors.grey[400],
            size: errorIconSize,
          ),
        );
      },
    );
  }
}

typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
);

typedef LoadingErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
  dynamic error,
);
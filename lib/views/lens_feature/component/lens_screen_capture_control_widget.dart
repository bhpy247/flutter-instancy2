import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LensScreenCaptureControlWidget extends StatelessWidget {
  final bool isTakingPicture;
  final void Function()? onClickImage;
  final void Function()? onGalleryTap;

  const LensScreenCaptureControlWidget({
    super.key,
    required this.isTakingPicture,
    this.onClickImage,
    this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (onGalleryTap != null)
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black38,
              ),
              child: InkWell(
                onTap: onGalleryTap,
                child: const Icon(
                  Icons.photo_sharp,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: InkWell(
              onTap: onClickImage,
              child: isTakingPicture
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox.square(
                        dimension: 60,
                        child: SpinKitCircle(
                          // isCenter: false,
                          size: 60,
                          color: Colors.white,
                  ),
                ),
              )
                  : const Icon(
                Icons.circle,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          if (onGalleryTap != null)
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.photo_sharp,
                color: Colors.transparent,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}

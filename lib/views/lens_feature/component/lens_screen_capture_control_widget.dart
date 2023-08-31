import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LensScreenCaptureControlWidget extends StatelessWidget {
  final bool isTakingPicture;
  final void Function()? onClickImage;

  const LensScreenCaptureControlWidget({
    super.key,
    required this.isTakingPicture,
    this.onClickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
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
          )
        ],
      ),
    );
  }
}

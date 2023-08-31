import 'package:flutter/material.dart';

class LensScreenFlashCloseButton extends StatelessWidget {
  final bool isFlashOn;
  final void Function()? onFlashTap;

  const LensScreenFlashCloseButton({
    super.key,
    this.isFlashOn = true,
    this.onFlashTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (onFlashTap != null) onFlashTap!();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: Icon(
                isFlashOn ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

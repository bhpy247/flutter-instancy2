import 'package:flutter/material.dart';

class BottomSheetDragger extends StatelessWidget {
  final Color? color;
  const BottomSheetDragger({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 8;
    ThemeData themeData = Theme.of(context);

    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 20, top: 17),
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: height,
            decoration: BoxDecoration(
              color: color ?? themeData.textTheme.labelSmall?.color?.withOpacity(0.4),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}

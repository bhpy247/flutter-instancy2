import 'package:flutter/material.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class BottomSheetView extends StatelessWidget {
   BottomSheetView({Key? key}) : super(key: key);

  List<BottomSheetOptionTileModel> bottomSheetItemList = [
    const BottomSheetOptionTileModel(title: "Details",iconData: InstancyIconType.pause),
    const BottomSheetOptionTileModel(title: "Report",iconData: InstancyIconType.pause),
    const BottomSheetOptionTileModel(title: "Archive",iconData: InstancyIconType.archived),
    const BottomSheetOptionTileModel(title: "Recommended to",iconData: InstancyIconType.pause),
    const BottomSheetOptionTileModel(title: "Share with Connection",iconData: InstancyIconType.shareWithConnection),
    const BottomSheetOptionTileModel(title: "Share with People",iconData: InstancyIconType.shareWithPeople),
    const BottomSheetOptionTileModel(title: "Generate Certificate",iconData: InstancyIconType.pause),
  ];

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetDragger(),
          const SizedBox(height: 40),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            shrinkWrap: true,
            children: bottomSheetItemList.map((e) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 22),
                leading: Icon(AppConfigurations().getInstancyIconFromType(e.iconData ?? InstancyIconType.shareWithPeople),size: 20, color: Styles.bottomSheetIconColor,),
                title: Text(e.title, style: themeData.textTheme.bodyLarge,),
              );
            }).toList(),
          )

          // ListTile(
          //   leading: Icon(AppConfigurations().getInstancyIconFromType(InstancyIconType.shareViaEmail)),
          //   title: const Text("email"),
          // )
          // Container(
          //   color: Colors.white38,
          //   child: Text("data"),
          // ),
        ],
      ),
    );
  }
}

class BottomSheetOptionTileModel {
  final String title;
  final Enum? iconData;
  final Widget? leadingWidget;

  const BottomSheetOptionTileModel({this.title = "", this.iconData, this.leadingWidget});
}
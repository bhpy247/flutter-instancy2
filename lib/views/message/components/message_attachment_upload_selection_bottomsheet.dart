import 'package:flutter/material.dart';

import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_option_tile.dart';

class MessageAttachmentUploadSelectionBottomSheet extends StatelessWidget {
  const MessageAttachmentUploadSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConfigurations().bottomSheetContainer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const BottomSheetDragger(),
            BottomSheetOptionTile(
              iconData: Icons.image,
              text: 'Image',
              onTap: () {
                Navigator.of(context).pop(MessageType.Image);
              },
            ),
            BottomSheetOptionTile(
              iconData: Icons.videocam_rounded,
              text: 'Video',
              onTap: () {
                Navigator.of(context).pop(MessageType.Video);
              },
            ),
            BottomSheetOptionTile(
              iconData: Icons.audiotrack_outlined,
              text: 'Audio',
              onTap: () {
                Navigator.of(context).pop(MessageType.Audio);
              },
            ),
            BottomSheetOptionTile(
              iconData: Icons.file_copy_rounded,
              text: 'Documents',
              onTap: () {
                Navigator.of(context).pop(MessageType.Doc);
              },
            )
          ],
        ),
      ),
    );
  }
}

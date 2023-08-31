import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/views/message/components/message_attachment_upload_selection_bottomsheet.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_constants.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';

class AttachmentIcon extends StatelessWidget {
  final bool isSendingMessage;
  final void Function({required String messageType, required Uint8List fileBytes, String? fileName})? onAttachmentPicked;

  const AttachmentIcon({
    Key? key,
    this.isSendingMessage = false,
    this.onAttachmentPicked,
  }) : super(key: key);

  Future<void> attachFile({required BuildContext context}) async {
    if (isSendingMessage) return;

    dynamic messageTypeValue = await showModalBottomSheet(
      shape: AppConfigurations().bottomSheetShapeBorder(),
      context: context,
      builder: (BuildContext bc) {
        return const MessageAttachmentUploadSelectionBottomSheet();
      },
    );
    MyPrint.printOnConsole("messageTypeValue:'$messageTypeValue'");

    if (messageTypeValue is! String || !MessageType.values.contains(messageTypeValue)) {
      MyPrint.printOnConsole("Returning from AttachmentIcon().attachFile() Because message type not valid");
      return;
    }

    PlatformFile? platformFile = await pickFile(messageTypeValue);
    Uint8List? bytes = platformFile?.bytes;
    MyPrint.printOnConsole("bytes length:${bytes?.length}");

    if (platformFile == null || bytes == null) {
      MyPrint.printOnConsole("Returning from AttachmentIcon().attachFile() Because couldn't pick file or bytes are null");
      return;
    }

    if (onAttachmentPicked != null) {
      onAttachmentPicked!(messageType: messageTypeValue, fileBytes: bytes, fileName: platformFile.name);
    }
  }

  Future<PlatformFile?> pickFile(String msgType) async {
    FileType pickingType = FileType.image;

    var extension = '';
    switch (msgType) {
      case MessageType.Image:
        pickingType = FileType.image;
        break;
      case MessageType.Audio:
        pickingType = FileType.custom;
        extension = "mp3,wav,3gp,webm";
        break;
      case MessageType.Video:
        pickingType = FileType.video;
        break;
      case MessageType.Doc:
        pickingType = FileType.custom;
        extension = "pdf,doc,docx,xlsx,xls";
        break;
      default:
        break;
      //   _pickingType = FileType.image;
    }

    List<PlatformFile> files = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: false,
      extensions: extension,
      getBytes: true,
    );
    MyPrint.printOnConsole("files length:${files.length}");

    return files.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkResponse(
        onTap: () async {
          attachFile(context: context);
        },
        child: Icon(
          Icons.attach_file_outlined,
          color: Styles.lightTextColor2.withOpacity(0.5),
          size: 20,
        ),
      ),
    );
  }
}

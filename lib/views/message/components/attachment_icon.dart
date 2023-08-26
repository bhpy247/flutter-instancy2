import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/message/request_model/attachment_upload_request_model.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/bottomsheet_option_tile.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_constants.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class AttachmentIcon extends StatelessWidget {
  final TextEditingController controller;
  final MessageController messageController;
  final String toUserId;
  final String chatRoom;

  const AttachmentIcon({
    Key? key,
    required this.controller,
    required this.messageController,
    required this.toUserId,
    required this.chatRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkResponse(
        child: Icon(
          Icons.attach_file_outlined,
          color: Styles.lightTextColor2.withOpacity(0.5),
          size: 20,
        ),
        onTap: () async {
          showModalBottomSheet(
            shape: AppConfigurations().bottomSheetShapeBorder(),
            context: context,
            builder: (BuildContext bc) {
              return AppConfigurations().bottomSheetContainer(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const BottomSheetDragger(),
                      BottomSheetOptionTile(
                          iconData: Icons.image,
                          text: 'Image',
                          onTap: () {
                            Navigator.of(context).pop();
                            openFile(MessageType.Image);
                          }),
                      BottomSheetOptionTile(
                          iconData: Icons.videocam_rounded,
                          text: 'Video',
                          onTap: () {
                            Navigator.of(context).pop();
                            openFile(MessageType.Video);
                          }),
                      BottomSheetOptionTile(
                          iconData: Icons.audiotrack_outlined,
                          text: 'Audio',
                          onTap: () {
                            Navigator.of(context).pop();
                            openFile(MessageType.Audio);
                          }),
                      BottomSheetOptionTile(
                          iconData: Icons.file_copy_rounded,
                          text: 'Documents',
                          onTap: () {
                            Navigator.of(context).pop();
                            openFile(MessageType.Doc);
                          })
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  openFile(String msgType) async {
    // if (_pickingType == FileType.custom) {
    // }
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

    List<PlatformFile> files = await MyUtils.pickFiles(pickingType: pickingType, multiPick: false, extensions: extension);
    if (files.isNotEmpty) {
      PlatformFile platformFile = files.first;
      File file = File(platformFile.path!);
      Uint8List bytes = file.readAsBytesSync();
      MyPrint.printOnConsole("bytesbytes : ${platformFile.bytes}");
      uploadFile(msgType, platformFile.name, bytes);
    }
  }

  Future uploadFile(String msgType, String fileName, Uint8List? fileBytes) async {
    MyPrint.printOnConsole("Length: ${fileBytes?.length}  fileBytes: $fileName");
    if ((fileBytes?.isEmpty ?? true) || fileName.isEmpty) {
      return;
    }

    InstancyMultipartFileUploadModel instancyMultipartFileUploadModel = InstancyMultipartFileUploadModel(
      fieldName: "File",
      fileName: fileName,
      bytes: fileBytes,
    );

    AttachmentUploadRequestModel attachmentUploadRequestModel = AttachmentUploadRequestModel(
      toUserId: toUserId,
      chatRoom: chatRoom,
      fileUploads: [instancyMultipartFileUploadModel],
    );

    messageController.attachmentUpload(
      attachmentUploadRequestModel: attachmentUploadRequestModel,
    );
  }
}

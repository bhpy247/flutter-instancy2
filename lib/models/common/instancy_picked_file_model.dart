import 'dart:typed_data';

class InstancyPickedFileModel {
  String fileName, filePath;
  Uint8List? bytes;

  InstancyPickedFileModel({
    this.fileName = "",
    this.filePath = "",
    this.bytes,
  });
}
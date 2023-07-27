import 'dart:typed_data';

class InstancyMultipartFileUploadModel {
  final String fieldName, fileName, filePath;
  final Uint8List? bytes;

  const InstancyMultipartFileUploadModel({
      required this.fieldName,
      required this.fileName,
      this.filePath = "",
      this.bytes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "fieldName" : fieldName,
      "fileName" : fileName,
      "filePath" : filePath,
      "bytes" : bytes,
    };
  }

  @override
  String toString() {
    return "InstancyFileUploadParametersModel(${toMap()})";
  }
}
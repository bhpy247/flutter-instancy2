import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class BookmarkDTOModel {
  String BookMarkID = "";

  BookmarkDTOModel({
    this.BookMarkID = "",
  });

  BookmarkDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    BookMarkID = ParsingHelper.parseStringMethod(map["BookMarkID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "BookMarkID": BookMarkID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

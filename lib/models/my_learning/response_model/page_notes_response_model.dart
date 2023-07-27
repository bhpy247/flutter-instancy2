import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class PageNotesResponseModel {
   List<UserNotes> userNotes =  const [];

   String name = "";

   PageNotesResponseModel({this.userNotes = const [], this.name = ""});

  PageNotesResponseModel.fromJson(Map<String, dynamic> json) {
    if (ParsingHelper.parseListMethod(json['usernotes']).isNotEmpty) {
      userNotes = <UserNotes>[];
      ParsingHelper.parseListMethod(json['usernotes']).forEach((v) {
        userNotes.add(UserNotes.fromJson(v));
      });
    }
    name = ParsingHelper.parseStringMethod(json['Name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usernotes'] = userNotes.map((v) => v.toJson()).toList();
    data['Name'] = name;
    return data;
  }
}

class UserNotes {
  String contentID = "";
  String trackID = "";
  String userNotesText = "";
  String noteCount = "";
  String pageID = "";
  String sequenceID = "";
  String noteDate = "";
  bool isEditEnabled = false;

  UserNotes({this.contentID = "", this.trackID = "", this.userNotesText = "", this.noteCount = "", this.pageID = "", this.sequenceID = "", this.noteDate = "", this.isEditEnabled = false});

  UserNotes.fromJson(Map<String, dynamic> json) {
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    trackID = ParsingHelper.parseStringMethod(json['TrackID']);
    userNotesText = ParsingHelper.parseStringMethod(json['Usernotestext']);
    noteCount = ParsingHelper.parseStringMethod(json['Notecount']);
    pageID = ParsingHelper.parseStringMethod(json['PageID']);
    sequenceID = ParsingHelper.parseStringMethod(json['SequenceID']);
    noteDate = ParsingHelper.parseStringMethod(json['NoteDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ContentID'] = contentID;
    data['TrackID'] = trackID;
    data['Usernotestext'] = userNotesText;
    data['Notecount'] = noteCount;
    data['PageID'] = pageID;
    data['SequenceID'] = sequenceID;
    data['NoteDate'] = noteDate;
    return data;
  }
}

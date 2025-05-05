

import '../data/local/db_helper.dart';

class NoteModel{
  int? serialNo;
  String? title;
  String? desc;

  NoteModel({this.serialNo,required this.title, required this.desc});

  Map<String,dynamic> toJson(){
    return {
      DBHelper.COLUMN_NOTE_SNO : this.serialNo,
      DBHelper.COLUMN_NOTE_TITLE : this.title,
      DBHelper.COLUMN_NOTE_DESC : this.desc
    };
  }

  factory NoteModel.fromJson(Map<String,dynamic> json) {
    return NoteModel(
      serialNo: json[DBHelper.COLUMN_NOTE_SNO],
      title: json[DBHelper.COLUMN_NOTE_TITLE],
      desc: json[DBHelper.COLUMN_NOTE_DESC],
    );
  }
}
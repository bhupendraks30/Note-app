import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_database_practice/model/note_model.dart';

import '../data/local/db_helper.dart';

class NoteController extends GetxController {
  var listOfNotes = <NoteModel>[].obs;
  DBHelper dbHelper = DBHelper.getDBHelper;

  NoteController() {
    updateListNotes();
  }

  List<NoteModel> getNotesList() => listOfNotes;

  void updateListNotes() async {
    List<Map<String, dynamic>> mapNoteList = await dbHelper.getAllNotes();
    //   converting here the list of map data into list of note model object and assign all objects into the list of notes
    listOfNotes.assignAll(
        mapNoteList.map((singleItem) => NoteModel.fromJson(singleItem)));
  }

  /// insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    Database db = await dbHelper.getDB();
    int rowEffected = await db.insert(DBHelper.TABLE_NOTE,
        {DBHelper.COLUMN_NOTE_TITLE: mTitle, DBHelper.COLUMN_NOTE_DESC: mDesc});
    if (rowEffected > 0) {
      updateListNotes();
      await Get.snackbar("Alert", "Note added.",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(milliseconds: 800),
          margin: EdgeInsets.only(bottom: 100.r,left: 10.r,right: 10.r),
          backgroundColor: Colors.green.shade400);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteNote(int serialNo) async {
    Database db = await dbHelper.getDB();
    int rowEffected = await db.rawDelete(
        "DELETE FROM ${DBHelper.TABLE_NOTE} WHERE ${DBHelper.COLUMN_NOTE_SNO} = $serialNo;");
    if (rowEffected > 0) {
      updateListNotes();
      await Get.snackbar("Alert", "Note deleted",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: await Duration(milliseconds: 800),
          margin: EdgeInsets.only(bottom: 100.r,left: 10.r,right: 10.r),
          backgroundColor: Colors.pink);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editNotes(
      {required String mTitle,
      required String mDesc,
      required int serialNo}) async {
    var db = await dbHelper.getDB();
    int rowEffected = await db.rawUpdate(
        "UPDATE note SET title = ?, desc = ? WHERE s_no = ?",
        [mTitle, mDesc, serialNo]);
    if (rowEffected > 0) {
      updateListNotes();
     await Get.snackbar("Alert", "Note updated",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          duration:await Duration(milliseconds: 800),
          margin: EdgeInsets.only(bottom: 100.r,left: 10.r,right: 10.r),
          backgroundColor: Colors.yellow);
      return true;
    } else {
      return false;
    }
  }
}

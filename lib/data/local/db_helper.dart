import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  /// Singleton
  // making constructor as a private to that when ever we use this class object then its object is not created.
  DBHelper._();

  // make only single object of this class  for whole app
  static final DBHelper getDBHelper = DBHelper._();

  /// table names
  static final String TABLE_NOTE = 'note';
  static final String COLUMN_NOTE_SNO = 's_no';
  static final String COLUMN_NOTE_TITLE = 'title';
  static final String COLUMN_NOTE_DESC = 'desc';

  Database? myDB;

  /// open the database (path -> if exist then open else create DB
  /// for this we check the connection and if the connection exist then open the database else create new database connection
  Future<Database> getDB() async {
    if (myDB!=null){
      return myDB!;
    }else{
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String path = join(appPath.path, 'noteDB.db');
    Database db =await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)");
    });
    return db;
  }


  /// all queries
  Future<List<Map<String, Object?>>> getAllNotes() async {
    Database db = await getDB();
    List<Map<String, Object?>> allNotes = await db.query(
      TABLE_NOTE,
    );
    return allNotes;
  }

  /// insertion
  // Future<bool> addNote({required String mTitle, required String mDesc}) async {
  //   Database db = await getDB();
  //   int rowEffected = await db.insert(
  //       TABLE_NOTE, {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mDesc});
  //   return rowEffected > 0;
  // }



  // Future<bool> deleteNote(int serialNo)async{
  //   Database db = await getDB();
  //   int rowEffected=await db.rawDelete("DELETE FROM $TABLE_NOTE WHERE $COLUMN_NOTE_SNO = $serialNo;");
  //   return rowEffected>0;
  // }
  //
  // Future<bool> editNotes({required String mTitle, required String mDesc, required int serialNo})async{
  //   var db = await getDB();
  //   int rowAffected = await db.rawUpdate("UPDATE note SET title = ?, desc = ? WHERE s_no = ?",
  //       ['$mTitle','$mDesc', 28]);
  //   return rowAffected>0;
  // }
}



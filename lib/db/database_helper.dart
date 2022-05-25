import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async=> _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    //Directory documentsDirectory = await ;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path+ "brickfinder5.db";
    //String path='brickfinder.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }



  Future _onCreate(Database db, int version)async{
    await db.execute('''
      create table COLOR
        (
          ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          LEGO_ID LONG,
          NAME    VARCHAR,
          RGB     VARCHAR
      );
      ''');

    await db.execute('''
       create table LEGO_SET
        (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        THEME_ID    LONG,
        SET_NUM     VARCHAR,
        NAME        VARCHAR,
        YEAR        INT,
        NUM_PARTS   INT,
        URL         VARCHAR,
        PICTURE_URL VARCHAR
        );
      ''');
    await db.execute('''
       create table PART
      (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        CATEGORY_ID LONG,
        PART_NUM    VARCHAR,
        NAME        VARCHAR,
        URL         VARCHAR,
        PICTURE_URL VARCHAR
    );

      ''');
    await db.execute('''
      create table SET_PART
      (
        SET_ID        LONG,
        PART_ID       LONG,
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        QUANTITY      INT,
        MISSING_TOTAL INT,
        COLOR_ID      LONG,
      constraint SETPART_COLOR_ID_FK
      foreign key (COLOR_ID) references COLOR (ID),
      constraint SETPART_PART_ID_FK
      foreign key (PART_ID) references PART (ID),
      constraint SETPART_SET_ID_FK
      foreign key (SET_ID) references LEGO_SET (ID)
      );
      ''');
  }

}
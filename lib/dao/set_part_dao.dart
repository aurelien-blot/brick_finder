
import 'dart:convert';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/models/lego_set.dart';
import 'package:brick_finder/services/api_service.dart';

import '../models/set_part.dart';

class SetPartDao {

  static String TABLE_NAME ='SET_PART';
  static String ID ='id';

  static Future<List<SetPart>> selectAll() async{
    Database db = await DatabaseHelper.instance.database;
    var colors = await db.query(TABLE_NAME, orderBy: ID);
    List<SetPart> colorList = colors.isNotEmpty?colors.map((c)=> SetPart.fromDbMap(c)).toList() :[];
    return colorList;
  }

  static Future<SetPart?> selectById(int id) async{
    Database db = await DatabaseHelper.instance.database;
    var setPartQuery = await db.query(TABLE_NAME, where: ID+' =?', whereArgs: [id]);
    SetPart? setPart = setPartQuery.isNotEmpty?SetPart.fromDbMap(setPartQuery.first):null;
    return setPart;
  }

  static Future<int> deleteAll() async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(TABLE_NAME);
  }

  static Future<int> deleteAllBySetId(int setId) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(TABLE_NAME, where: ID+'=?', whereArgs: [setId]
    );
  }

  static Future<int?> count() async{
    Database db = await DatabaseHelper.instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM '+TABLE_NAME));
  }

  static Future<SetPart?> selectBySetNum(String setNum) async{
    Database db = await DatabaseHelper.instance.database;
    var setQuery = await db.query(TABLE_NAME, where: 'SET_NUM =?', whereArgs: [setNum]);
    SetPart? setPart = setQuery.isNotEmpty?SetPart.fromDbMap(setQuery.first):null;
    return setPart;
  }
  static Future<int> add(SetPart setPart) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(TABLE_NAME, setPart.toMap());
  }

  static Future<int> update(SetPart setPart) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.update(TABLE_NAME, setPart.toMap(), where: ID+'=?', whereArgs: [setPart.id]);
  }

}
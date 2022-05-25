
import 'dart:convert';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/services/api_service.dart';

class ColorDao {
  
  static String TABLE_NAME ='COLOR';
  static String ID ='id';
  // OK
  static Future<List<LegoColor>> selectAll() async{
    Database db = await DatabaseHelper.instance.database;
    var colors = await db.query(TABLE_NAME, orderBy: ID);
    List<LegoColor> colorList = colors.isNotEmpty?colors.map((c)=> LegoColor.fromDbMap(c)).toList() :[];
    return colorList;
  }

  static Future<LegoColor?> selectById(int id) async{
    Database db = await DatabaseHelper.instance.database;
    var legoColorQuery = await db.query(TABLE_NAME, where: ID+' =?', whereArgs: [id]);
    LegoColor? legoColor = legoColorQuery.isNotEmpty?LegoColor.fromDbMap(legoColorQuery.first):null;
    return legoColor;
  }

  static Future<int> deleteAll() async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(TABLE_NAME);
  }

  static Future<int?> count() async{
    Database db = await DatabaseHelper.instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM '+TABLE_NAME));
  }

  static Future<LegoColor?> selectBySetNum(String setNum) async{
    Database db = await DatabaseHelper.instance.database;
    var setQuery = await db.query(TABLE_NAME, where: 'SET_NUM =?', whereArgs: [setNum]);
    LegoColor? legoColor = setQuery.isNotEmpty?LegoColor.fromDbMap(setQuery.first):null;
    return legoColor;
  }
  static Future<int> add(LegoColor legoColor) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(TABLE_NAME, legoColor.toMap());
  }

}

import 'dart:convert';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/models/lego_set.dart';
import 'package:brick_finder/services/api_service.dart';

class LegoSetDao {

  static String TABLE_NAME ='LEGO_SET';
  static String ID ='id';
  // OK
  static Future<List<LegoSet>> selectAll() async{
    Database db = await DatabaseHelper.instance.database;
    var colors = await db.query(TABLE_NAME, orderBy: ID);
    List<LegoSet> colorList = colors.isNotEmpty?colors.map((c)=> LegoSet.fromDbMap(c)).toList() :[];
    return colorList;
  }

  static Future<LegoSet?> selectById(int id) async{
    Database db = await DatabaseHelper.instance.database;
    var legoSetQuery = await db.query(TABLE_NAME, where: ID+' =?', whereArgs: [id]);
    LegoSet? legoSet = legoSetQuery.isNotEmpty?LegoSet.fromDbMap(legoSetQuery.first):null;
    return legoSet;
  }

  static Future<int> deleteAll() async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(TABLE_NAME);
  }

  static Future<int?> count() async{
    Database db = await DatabaseHelper.instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM '+TABLE_NAME));
  }

  static Future<LegoSet?> selectBySetNum(String setNum) async{
    Database db = await DatabaseHelper.instance.database;
    var setQuery = await db.query(TABLE_NAME, where: 'SET_NUM =?', whereArgs: [setNum]);
    LegoSet? legoSet = setQuery.isNotEmpty?LegoSet.fromDbMap(setQuery.first):null;
    return legoSet;
  }
  static Future<int> add(LegoSet legoSet) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(TABLE_NAME, legoSet.toMap());
  }

}
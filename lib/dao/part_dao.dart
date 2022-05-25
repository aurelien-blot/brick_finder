import 'package:sqflite/sqflite.dart';
import 'package:brick_finder/db/database_helper.dart';

import '../models/part.dart';

class PartDao {

  static String TABLE_NAME ='PART';
  static String ID ='id';

  static Future<List<Part>> selectAll() async{
    Database db = await DatabaseHelper.instance.database;
    var colors = await db.query(TABLE_NAME, orderBy: ID);
    List<Part> colorList = colors.isNotEmpty?colors.map((c)=> Part.fromDbMap(c)).toList() :[];
    return colorList;
  }

  static Future<Part?> selectById(int id) async{
    Database db = await DatabaseHelper.instance.database;
    var partQuery = await db.query(TABLE_NAME, where: ID+' =?', whereArgs: [id]);
    Part? part = partQuery.isNotEmpty?Part.fromDbMap(partQuery.first):null;
    return part;
  }

  static Future<int> deleteAll() async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(TABLE_NAME);
  }

  static Future<int?> count() async{
    Database db = await DatabaseHelper.instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM '+TABLE_NAME));
  }

  static Future<Part?> selectByPartNum(String partNum) async{
    Database db = await DatabaseHelper.instance.database;
    var partQuery = await db.query(TABLE_NAME, where: 'PART_NUM =?', whereArgs: [partNum]);
    Part? part = partQuery.isNotEmpty?Part.fromDbMap(partQuery.first):null;
    return part;
  }
  static Future<int> add(Part part) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(TABLE_NAME, part.toMap());
  }



}
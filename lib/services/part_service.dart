
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:brick_finder/dao/color_dao.dart';
import 'package:brick_finder/dao/part_dao.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/services/api_service.dart';

import '../models/part.dart';

class PartService {

  //OK
  static Future<HashMap<String, Part>> getPartNumInDb() async{
    HashMap<String, Part> results = new HashMap<String, Part>();
    await PartDao.selectAll().then((values) {
      for(var p in values){
        results.putIfAbsent(p.partNum, () => p);
      }
    });
    return results;
  }

  //OK
  static Future<List<Part>> selectAll() async   {
    List<Part> results= [];
    await PartDao.selectAll().then((values){
      results =values;
    });
    return results;
  }

  static Future<HashMap<int, Part>> mapAllById() async   {
    List<Part> fullList= [];
    HashMap<int, Part> results= new HashMap();
    await PartDao.selectAll().then((values){
      fullList =values;
    });
    for(Part p in fullList){
      results.putIfAbsent(p.id!, () => p);
    }
    return results;
  }

  //OK
  static Future<void> deleteAll() async{
    PartDao.deleteAll();
  }


  //OK
  static Future<int> countAll() async   {
    int result= 0;
    await PartDao.count().then((value){
      result =value!;
    });
    return result;
  }


  static Future<Part?> selectByPartNum(String setNum) async {
    Part? result =null;
    await PartDao.selectByPartNum(setNum).then((value) {
      result=value;
    });
    return result;
  }

  //OK
  static Future<Part?> create(Part part) async{
    await PartDao.add(part).then((value){
      part.id=value;
    });
    return part;
  }


  static Future<Part?> selectById(int id) async{
    Part? part = null;
    await PartDao.selectById(id).then((value){
      part=value;
    });
    return part;
  }
}

import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:brick_finder/dao/color_dao.dart';
import 'package:brick_finder/dao/lego_set_dao.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/models/set_part.dart';
import 'package:brick_finder/services/api_service.dart';
import 'package:brick_finder/services/set_part_service.dart';

import '../models/lego_set.dart';

class LegoSetService {

  // OK
  static Future<LegoSet ?> searchBySetNumFromAPI(String setNum) async {
    var response = await http.get(ApiService.getUri('/sets/'+setNum));
    if (response.statusCode == 404) {
      response = await http.get(ApiService.getUri('/sets/'+setNum+'-1'));
    }
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var value = jsonDecode(response.body);
      LegoSet legoSet=LegoSet.fromJsonMap(value) as LegoSet;
      return legoSet;
    }
    else {
      return null;
        //throw Exception('Failed to Find LEGOSET');
      }
  }

  // OK
  static Future<List<LegoSet>> selectAll() async   {
    List<LegoSet> results= [];
    await LegoSetDao.selectAll().then((values){
      results =values;
    });
    return results;
  }

  static Future<HashMap<int, LegoSet>> mapAllById() async   {
    List<LegoSet> fullList= [];
    HashMap<int, LegoSet> results= new HashMap();
    await LegoSetDao.selectAll().then((values){
      fullList =values;
    });
    for(LegoSet p in fullList){
      results.putIfAbsent(p.id!, () => p);
    }
    return results;
  }

  static Future<LegoSet?> selectById(int id) async{
    LegoSet? legoSet = null;
    await LegoSetDao.selectById(id).then((value){
      legoSet=value;
    });
    return legoSet;
  }

  //OK
  static Future<void> deleteAll() async{
     LegoSetDao.deleteAll();
  }


  //OK
  static Future<int> countAll() async   {
    int result= 0;
    await LegoSetDao.count().then((value){
      result =value!;
    });
    return result;
  }

  //OK
  static Future<LegoSet?> searchBySetNum(String setNum) async {
    LegoSet? result =null;
    await LegoSetDao.selectBySetNum(setNum).then((value) {
      result=value;
    });
    if(null==result) {
      await LegoSetDao.selectBySetNum(setNum + '-1').then((value) {
        result=value;
      });
    }
    return result;
  }

  //OK
  static  Future<LegoSet?> findSetInDbOrAPI(String setNum) async{
    LegoSet? result =null;
    await searchBySetNum(setNum).then((value) {
      result=value;
    });
    if(null==result){
      await searchBySetNumFromAPI(setNum).then((value) {
        result=value;
      });
    }
    return result;
  }

  //OK
  static Future<LegoSet?> create(LegoSet legoSet) async{
    await LegoSetDao.add(legoSet).then((value){
          legoSet.id=value;
          //TODO CONTINUER LE CREATE

      });
    await SetPartService.saveSetPartForSet(legoSet);

    return legoSet;
  }

}
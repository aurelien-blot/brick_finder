
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:brick_finder/dao/color_dao.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/services/api_service.dart';

class ColorService {

  static Future<List<LegoColor>> _getAllColorsFromAPI() async {
    final response = await http.get(ApiService.getUri('/colors'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var value = jsonDecode(response.body);

      List<LegoColor> results=[];
      for(var u in value['results']){
        LegoColor color=LegoColor.fromJsonMap(u);
        results.add(color);
      }
      return results;
    }
    else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<HashMap<int, LegoColor>> mapAllById() async   {
    List<LegoColor> fullList= [];
    HashMap<int, LegoColor> results= new HashMap();
    await ColorDao.selectAll().then((values){
      fullList =values;
    });
    for(LegoColor p in fullList){
      if(p.id!=null){
        results.putIfAbsent(p.id!, () => p);
      }
    }
    return results;
  }
  static Future<HashMap<String, LegoColor>> getColorMap() async{
    HashMap<String, LegoColor> results = new HashMap<String, LegoColor>();
    await ColorDao.selectAll().then((values) {
      for(var c in values){
        if(c.rgb!=null){
          results.putIfAbsent(c.rgb!, () => c);
        }
      }
    });
    return results;
  }

  static void saveAll(){
    _getAllColorsFromAPI().then((values){
      List<LegoColor> resultsJson =values;
      ColorDao.deleteAll();
      for(LegoColor c in resultsJson){
        ColorDao.add(c);
      }
      ColorDao.count().then((value) => print(value));
    });
  }

  static Future<LegoColor?> selectById(int id) async{
    LegoColor? legoColor = null;
    await ColorDao.selectById(id).then((value){
      legoColor=value;
    });
    return legoColor;
  }
}
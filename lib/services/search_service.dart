
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:brick_finder/dao/color_dao.dart';
import 'package:brick_finder/dao/part_dao.dart';
import 'package:brick_finder/dao/set_part_dao.dart';
import 'package:brick_finder/db/database_helper.dart';
import 'package:brick_finder/models/lego_color.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/services/api_service.dart';
import 'package:brick_finder/services/part_service.dart';
import 'package:brick_finder/services/set_part_service.dart';

import '../models/lego_set.dart';
import '../models/part.dart';
import '../models/set_part.dart';
import 'color_service.dart';
import 'lego_set_service.dart';

class SearchService {

  //OK
  static Future<List<SetPart>> searchAll() async   {
    List<SetPart> results= [];
    await SetPartService.selectAll().then((values){
      results =values;
    });
    await formatFullListForResponse(results);
    return results;
  }

  static Future<List<SetPart>> formatFullListForResponse(List<SetPart> setPartList) async{
    HashMap<int, Part> partMap =new HashMap();
    HashMap<int, LegoSet> setMap =new HashMap();
    HashMap<int, LegoColor> colorMap =new HashMap();
    await PartService.mapAllById().then((value){
      partMap=value;
    });
    await ColorService.mapAllById().then((value){
      colorMap=value;
    });
    await LegoSetService.mapAllById().then((value){
      setMap=value;
    });
    for(SetPart sp in setPartList){
      if(sp.partId!=null && partMap.containsKey(sp.partId)){
        sp.part=partMap[sp.partId];
      }
      if(sp.setId!=null && setMap.containsKey(sp.setId)){
        sp.legoSet=setMap[sp.setId];
      }
      if(sp.colorId!=null && colorMap.containsKey(sp.colorId)){
        sp.legoColor=colorMap[sp.colorId];
      }
    }
    return setPartList;
  }


}
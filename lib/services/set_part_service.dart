
import 'dart:collection';
import 'dart:convert';
import 'package:brick_finder/dao/lego_set_dao.dart';

import 'package:http/http.dart' as http;
import 'package:brick_finder/dao/part_dao.dart';
import 'package:brick_finder/dao/set_part_dao.dart';
import 'package:brick_finder/models/lego_color.dart';
import 'package:brick_finder/services/api_service.dart';
import 'package:brick_finder/services/color_service.dart';
import 'package:brick_finder/services/part_service.dart';

import '../models/lego_set.dart';
import '../models/part.dart';
import '../models/set_part.dart';
import 'lego_set_service.dart';

class SetPartService {

  // OK
  static Future<List<SetPart>> getSetPartForSetFromAPI(String setNum) async {
    var response = await http.get(ApiService.getUri('/sets/'+setNum+'/parts'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var values = jsonDecode(response.body);

      List<SetPart> results=[];
      for(var u in values['results']){
        SetPart setPart=SetPart.fromJsonMap(u);
        results.add(setPart);
      }
      return results;

    }
    else {
      return [];
      }
  }

  // OK
  static Future<List<SetPart>> saveSetPartForSet(LegoSet legoSet) async{
    String setNum =legoSet.setNum!;
    int setId = legoSet.id!;
    List<SetPart> results = [];
    HashMap<String, Part> partMap =new HashMap();
    HashMap<String, LegoColor> colorMap =new HashMap();
      await getSetPartForSetFromAPI(setNum).then((values){
          results = values;
      });
      await PartService.getPartNumInDb().then((values){
        partMap=values;
      });
      await ColorService.getColorMap().then((values){
        colorMap=values;
      });

    await SetPartDao.deleteAllBySetId(setId);
    //MAPPER LES PART PUIS LES SAVE SI ILS EXISTENT PAS
    for(int i =0; i<results.length;i++){
      SetPart setPart = results[i];
      setPart.setId = setId;

      // ON GERE LA PART
      Part part = setPart.part!;
      if (null != part && null != part.partNum &&
          !partMap.containsKey(part.partNum)) {
        await PartService.create(part);
        partMap.putIfAbsent(part.partNum, () => part);
        setPart.partId = part.id;
      }

      // ON GERE LA COULEUR
      if (colorMap != null && setPart.legoColor!=null && setPart.legoColor?.rgb !=null &&  colorMap.containsKey (setPart.legoColor?.rgb)){
          setPart.legoColor=colorMap[setPart.legoColor?.rgb];
          setPart.colorId=colorMap[setPart.legoColor?.rgb]?.id;
      }
        await create(results[i]).then((value){
          results[i]=value!;
        });
    }

      return results;
  }

  //OK
  static Future<List<SetPart>> selectAll() async   {
    List<SetPart> results= [];
    await SetPartDao.selectAll().then((values){
      results =values;
    });
    return results;
  }

  static Future<SetPart?> selectById(int id) async{
    SetPart? setPart = null;
    await SetPartDao.selectById(id).then((value){
      setPart=value;
    });
    return setPart;
  }

  //OK
  static Future<void> deleteAll() async{
    SetPartDao.deleteAll();
  }


  //OK
  static Future<int> countAll() async   {
    int result= 0;
    await SetPartDao.count().then((value){
      result =value!;
    });
    return result;
  }

  //OK
  static Future<SetPart?> create(SetPart setPart) async{
    await SetPartDao.add(setPart).then((value){
      setPart.id=value;
    });
    return setPart;
  }

  static Future<SetPart> formatForResponse(SetPart setPart) async{
    if(null!=setPart.partId){
        await PartService.selectById(setPart.partId!).then((value) => setPart.part=value);
    }
    if(null!=setPart.colorId){
        await ColorService.selectById(setPart.colorId!).then((value) => setPart.legoColor=value);
    }
    if(null!=setPart.setId){
        await LegoSetService.selectById(setPart.setId!).then((value) => setPart.legoSet=value);
    }
    return setPart;
  }

  static Future<List<SetPart>> formatListForResponse(List<SetPart> setPartList) async{
    for(SetPart sp in setPartList){
       await formatForResponse(sp);
    }
    return setPartList;
  }

  static Future<int> increaseMissingTotal(SetPart setPart) async{
     if(setPart.missingTotal<setPart.quantity){
       setPart.missingTotal++;
     }
    await SetPartDao.update(setPart);
    return setPart.missingTotal;
  }

  static Future<int> reduceMissingTotal(SetPart setPart) async{
    if(setPart.missingTotal>0){
      setPart.missingTotal--;
    }
    await SetPartDao.update(setPart);
    return setPart.missingTotal;
  }
}
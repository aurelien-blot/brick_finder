import 'package:flutter/material.dart';

import 'lego_color.dart';
import 'lego_set.dart';
import 'part.dart';

class SetPart {
  int? id, colorId, setId, partId;
  int  quantity, missingTotal;
  Part ? part;
  LegoSet ? legoSet;
  LegoColor ? legoColor;

  //TODO ON GARDE LES ID OU PAS ??

  SetPart({this.id, this.setId, this.part,this.partId, required this.quantity, required this.missingTotal, this.colorId, this.legoColor});

  factory SetPart.fromDbMap(Map<String, dynamic> json)=> SetPart(
    id :json["ID"],
    setId :json["SET_ID"],
    partId :json["PART_ID"],
    quantity :json ["QUANTITY"],
    missingTotal :json["MISSING_TOTAL"],
    colorId :json["COLOR_ID"],
  );
  factory SetPart.fromJsonMap(Map<String, dynamic> json)=> SetPart(
      quantity :json["quantity"],
      missingTotal :json["quantity"],
      part: Part.fromJsonMap(json["part"]),
      legoColor: LegoColor.fromJsonMap(json["color"]),
  );

  Map<String, dynamic> toMap(){
    return{
      'ID' : id,
      'PART_ID' : partId,
      'SET_ID' : setId,
      'QUANTITY' : quantity,
      'MISSING_TOTAL' : missingTotal,
      'COLOR_ID' : colorId,
    };
  }

 Color get color{
    if(legoColor!=null && legoColor!.rgb !=null){
      final buffer = StringBuffer();
      buffer.write('ff');
      buffer.write(legoColor!.rgb);
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return Colors.white;
  }


}
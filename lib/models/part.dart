import 'package:flutter/material.dart';

class Part {
  String partNum, name, url;
  String? pictureUrl;
  int? id, categoryId;

  Part({this.id, this.categoryId, this.pictureUrl,required this.partNum,required this.name,required this.url});

  factory Part.fromDbMap(Map<String, dynamic> json)=> Part(
      id :json["ID"],
      categoryId :json["CATEGORY_ID"],
      partNum :json["PART_NUM"],
      name :json["NAME"],
      url :json["URL"],
      pictureUrl :json["PICTURE_URL"],
  );

  factory Part.fromJsonMap(Map<String, dynamic> json)=> Part(
    partNum :json["part_num"],
    name :json["name"],
    url :json["part_url"],
    pictureUrl: json["part_img_url"],
    categoryId: json["part_cat_id"],
  );

  Map<String, dynamic> toMap(){
    return{
      'ID' : id,
      'CATEGORY_ID' : categoryId,
      'PART_NUM' : partNum,
      'NAME' : name,
      'URL' : url,
      'PICTURE_URL' : pictureUrl,
    };
  }
}

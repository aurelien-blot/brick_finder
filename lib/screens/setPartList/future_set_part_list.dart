import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:brick_finder/screens/setPartList/set_part_list.dart';
import 'package:brick_finder/services/search_service.dart';

import '../../constants.dart';
import '../../models/part.dart';
import '../../models/lego_set.dart';
import '../../models/set_part.dart';
import 'package:http/http.dart' as http;

class FutureSetPartList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FutureSetPartListState();
  }
}

class _FutureSetPartListState extends State<FutureSetPartList> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<SetPart>> _initSetPart() async {
    List<SetPart> results=[];
    await SearchService.searchAll().then((values){
      results =values;
    });
      return results;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SetPart>>(
            future: _initSetPart(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                else if (snapshot.hasData) {
                  return SetPartList(itemList: snapshot.data);
                }
                else {
                  return const Text('Empty data');
                }
                // By default, show a loading spinner.
              }
              else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
    );
  }
}

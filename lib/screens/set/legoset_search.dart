import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:brick_finder/services/lego_set_service.dart';

import '../../constants.dart';
import '../../models/lego_set.dart';
import 'package:http/http.dart' as http;

class LegoSetSearch extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LegoSetSearchState();
  }
}

class _LegoSetSearchState extends State<LegoSetSearch> {

  final searchSetLabelController = TextEditingController();
  LegoSet? selectedSet;
  @override
  void initState() {
    super.initState();
  }

  void _onSearchSet() async{
    await LegoSetService.findSetInDbOrAPI(searchSetLabelController.text).then((value){
      setState(() {
        selectedSet = value;
      });
    });
  }

  void _onSaveSet(LegoSet legoSet) async{
     LegoSetService.create(legoSet).then((value){
      setState(() {
          selectedSet=value;
      });
    });
  }

  Widget setButtonListWidget() {
    if(selectedSet!=null && selectedSet?.id!=null){
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.do_not_disturb),
              Text("Ce set LEGO est déjà enregistré.")
            ],
        );
    }
    else{
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            IconButton (
                  icon: Icon(Icons.add, color: Colors.green,),
                  onPressed: () {
                    _onSaveSet(selectedSet!);
                  },
            )
        ],
      );
    }
  }

  Widget selectLegoSetWigdet(){
    if(selectedSet!=null && selectedSet?.pictureUrl !=null){
      return Center(
        child:  Column(
          children: [
            Container(
             width: 300,
             height: 300,
             child : Image.network(selectedSet!.pictureUrl!),
            ),

            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.indigo[200],
              ),
              child : Column(
                children: [
                  Text(selectedSet!.name!, textAlign: TextAlign.center,),
                  setButtonListWidget()
                ],
              )
            ),
          ],
        )
      );
    }
    else{
      return Center(
          child : Text("Aucun set LEGO sélectionné ou introuvable.")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 75,
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.indigo[200],
            ),
            child :Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                SizedBox(
                  width: 400,
                    child : TextField(
                      controller : searchSetLabelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez la référence du set',
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                      border: Border.all(
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                  child: IconButton (
                    icon: Icon(Icons.search, color: Colors.white,),
                    onPressed: () {
                      _onSearchSet();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
           /* child:FutureBuilder<LegoSet>(
              future: _searchSet(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                else if (snapshot.hasData) {
                  return Image.network(snapshot.data.pictureUrl);
                }
                else {
                  return const Text('Empty data');
                }
                // By default, show a loading spinner.
                }
                else {
                  return Text('State: ${snapshot.connectionState}');
                }
              }
            )*/
            child :selectLegoSetWigdet(),
          )
        ]
    );
  }
}

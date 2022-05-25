import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:brick_finder/services/set_part_service.dart';

import '../../../constants.dart';
import '../../../models/set_part.dart';
import 'package:http/http.dart' as http;

class SetPartItemCard extends StatefulWidget {

  final Function press;
  final SetPart setPart;
  final Function onFilter;

  const SetPartItemCard({
    Key? key,
    required this.setPart,
    required this.onFilter,
    required this.press,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetPartItemCardState();
  }
}

class _SetPartItemCardState extends State<SetPartItemCard> {

  Future<int> _onUpdateMissingTotal(String type) async {
    final response = await http.put(
      Uri.parse(baseUrl+'setpart/missingTotal/'+type+'/'+ widget.setPart.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var values = jsonDecode(response.body);
      return values['missingTotal'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }

  void _incrementCounter() {
    SetPartService.increaseMissingTotal(widget.setPart).then((value){
      setState(() {
        widget.setPart.missingTotal=value;
      });
      widget.onFilter();
    });
  }
  void _decrementCounter() {
    SetPartService.reduceMissingTotal(widget.setPart).then((value){
      setState(() {
        widget.setPart.missingTotal=value;
      });
      widget.onFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    var picWidget;
    if(widget.setPart.part==null || widget.setPart.part?.pictureUrl==null){
      picWidget =Image.asset(noPicturePicPath);
    }
    else{
      picWidget = Image.network(widget.setPart.part!.pictureUrl!);
    }


    return GestureDetector(
      // onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: widget.setPart.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${widget.setPart.id}",
                child: picWidget,
              ),
            ),
          ),
          _shoppingItem(3),
        ],
      ),
    );
  }
  Widget _incrementButton(int index) {
    return FloatingActionButton(
      child: const Icon(Icons.add, color: Colors.black87),
      backgroundColor: Colors.white,
      onPressed: widget.setPart.missingTotal==widget.setPart.quantity?null:_incrementCounter,
    );
  }
  Widget _decrementButton(int index) {
    return FloatingActionButton(
      child : const Icon(Icons.remove, color: Colors.black87),
      backgroundColor: Colors.white,
      onPressed:widget.setPart.missingTotal==0?null: _decrementCounter,
    );
  }

  Widget _shoppingItem(int itemIndex) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _decrementButton(itemIndex),
            Text(
              '${widget.setPart.missingTotal.toString()}',
              style: TextStyle(fontSize: 18.0),
            ),
            _incrementButton(itemIndex),
          ],
        ),
      ),
    );
  }

}
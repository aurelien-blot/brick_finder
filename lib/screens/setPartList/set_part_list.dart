import 'package:flutter/material.dart';
import 'package:brick_finder/models/lego_set.dart';
import 'package:brick_finder/screens/setPartList/components/set_part_item_card.dart';

import '../../models/set_part.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SetPartList extends StatefulWidget {

  final List<SetPart> itemList;
  const SetPartList({
    Key? key,
    required this.itemList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetPartListState();
  }
}

class _SetPartListState extends State<SetPartList> {

  static const String ALL_SET_LABEL ='Tous';

  final anySetItem = LegoSet();
  int ? missingFilterindex;
  //String ? setFilterName;
  LegoSet ? setFilter;
  Color ? colorFilter;
  late List<LegoSet> legoSetList;
  late List<Color?> colorList;
  List<SetPart> filteredItemList= [];


  @override
  void initState() {
    legoSetList = this._buildLegoSetList();
    colorList = this._buildColorList();
    _onFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           OrientationBuilder(
            builder: (context, orientation){
              return _getFilterWidget(orientation);
            },
          ),
          Expanded(
            child: itemListWidget(filteredItemList),
          )
        ]
    );
  }

  List<LegoSet> _buildLegoSetList(){
    List<LegoSet> legoSetList =[];
    legoSetList.add(anySetItem); // CHOIX 1
    for(int i=0; i<widget.itemList.length; i++) {
      SetPart item = widget.itemList[i];
      if (item.legoSet != null) {
        bool alreadyInList = false;
        for (int u = 0; u < legoSetList.length; u++) {
          LegoSet legoSet = legoSetList[u];
          if (legoSet.id == item.legoSet!.id) {
            alreadyInList = true;
            break;
          }
        }
        if (!alreadyInList) {
          legoSetList.add(item.legoSet!);
        }
      }
    }
    return legoSetList;
  }

  List<Color?> _buildColorList(){
    List<Color?> colorList =[];
    colorList.add(null); // CHOIX 1
    for(int i=0; i<widget.itemList.length; i++) {
      SetPart item = widget.itemList[i];
      if (item.color != null) {
        bool alreadyInList = false;
        for (int u = 0; u < colorList.length; u++) {
          Color? color = colorList[u];
          if (color == item.color) {
            alreadyInList = true;
            break;
          }
        }
        if (!alreadyInList) {
          colorList.add(item.color);
        }
      }
    }
    return colorList;
  }

  bool _onMissingFilter(SetPart item) {
    if(missingFilterindex ==null){
      missingFilterindex=0;
    }
      if(missingFilterindex==0){
        if(item.missingTotal>0){
          return true;
        }
      }
      else if(missingFilterindex==1){
        if(item.missingTotal==0){
          return true;
        }
      }
      else if(missingFilterindex==2){
          return true;
      }
      return false;
  }

  bool _onSetFilter(SetPart item) {
    if(setFilter ==null){
      setFilter=anySetItem;
    }
    if(setFilter!.id==null){
      return true;
    }
    if(setFilter!.id==item.legoSet!.id) {
      return true;
    }
    return false;
  }
  bool _onColorFilter(SetPart item) {
    if(colorFilter ==null){
      return true;
    }
    if(colorFilter==item.color) {
      return true;
    }
    return false;
  }

  void _onFilter(){
    List<SetPart> applyFilterList=[];
    for(int i =0; i<widget.itemList.length;i++){
        SetPart item = widget.itemList[i];
        bool missingFilterInclude = _onMissingFilter(item);
        bool setFilterInclude = _onSetFilter(item);
        bool colorFilterInclude = _onColorFilter(item);

        if(missingFilterInclude && setFilterInclude && colorFilterInclude){
          applyFilterList.add(item);
        }
    }
    //TODO POURQUOI SI JE NE METS PAS LE DOUBLON SUIVANT CA NE MARCHE PAS ??
    filteredItemList=applyFilterList;
    setState(() {
      filteredItemList=applyFilterList;
    });

  }

  Widget itemListWidget(datas){
    return OrientationBuilder(
        builder : (context, orientation){
           return GridView.builder(
              itemCount: filteredItemList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext itemBuilder, int index) => SetPartItemCard(
                setPart: datas[index],
                onFilter : _onFilter,
                press: () => {},
              ),
           );
        }
       );
  }

  Widget colorSelect(Color? color){
    if(null==color){
      return Text("Aucune");
    }
    else{
      return Container(
          width: 30,
          height: 30,
          decoration:
          new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          )
      );
    }
  }
  Widget customDropDownWidget (Widget dropDown){
    return DecoratedBox(
        decoration: BoxDecoration(
            color:Colors.blue, //background color of dropdown button//border of dropdown button
            borderRadius: BorderRadius.circular(5), //border raiuds of dropdown button
            boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                  blurRadius: 5) //blur radius of shadow
            ]
        ),
        child:Padding(
          padding: EdgeInsets.only(left:30, right:30),
          child : dropDown
        )
    );
  }

  Widget _getLegoSetFilter(){
    return customDropDownWidget(DropdownButton<LegoSet>(
      value: setFilter,
      icon: Icon(Icons.arrow_drop_down_circle, color : Colors.white),
      elevation: 25,
      style: const TextStyle(fontSize :18, color: Colors.black),
      /*underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
              ),*/
      onChanged: (LegoSet? newValue) {
        setFilter=newValue;
        _onFilter();
      },
      items: legoSetList.map((LegoSet value) {
        return DropdownMenuItem<LegoSet>(
          value: value,
          child: Text(value.name!=null?value.name!:''),
        );
      }).toList(),
    ));
  }
  Widget _getColorFilter(){
    return customDropDownWidget(
        DropdownButton<Color>(
          value: colorFilter,
          icon: Icon(Icons.arrow_drop_down_circle, color : Colors.white),

          elevation: 16,
          style: const TextStyle(fontSize :18, color: Colors.black),
          onChanged: (Color? newValue) {
            colorFilter=newValue;
            _onFilter();
          },
          items: colorList.map((Color? value) {
            return DropdownMenuItem<Color>(
              value: value,
              child: colorSelect(value),
            );
          }).toList(),
        )
    );
  }
  Widget _getMissingStatusFilter(){
    return ToggleSwitch(
      initialLabelIndex: missingFilterindex,
      minWidth: 140.0,
      fontSize: 18.0,
      totalSwitches: 3,
      labels: ['Manquantes', 'Trouvées', 'Toutes'],
      onToggle: (index) {
        missingFilterindex=index!;
        _onFilter();
      },
    );
  }
  Widget _getFilterWidget(Orientation or){
    if(or == Orientation.portrait){
        return Container(
            height: 150,
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
            color: Colors.indigo[200],
            ),
            child :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _getMissingStatusFilter(),
                      _getColorFilter(),
                    ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _getLegoSetFilter(),
                      ]
                  ),
                ]
            )
        );
    }
    else{
      return Container(
          height: 75,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
          color: Colors.indigo[200],
          ),
          child :Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  _getMissingStatusFilter(),
                  _getLegoSetFilter(),
                  _getColorFilter(),

                ]
          )
      );
    }
  }

}

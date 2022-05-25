import 'package:flutter/material.dart';
import 'package:brick_finder/models/lego_set.dart';
import 'package:brick_finder/models/setting.dart';
import 'package:brick_finder/screens/setPartList/components/set_part_item_card.dart';
import 'package:brick_finder/services/color_service.dart';
import 'package:brick_finder/services/lego_set_service.dart';
import 'package:brick_finder/services/set_part_service.dart';

import '../../models/set_part.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/part_service.dart';
import '../../services/search_service.dart';

class Settings extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }

}

class _SettingsState extends State<Settings> {

  @override
  void initState() {

    super.initState();
  }

  List<Setting> settingsList =[
    Setting(label :"Couleurs", icon :Icons.format_paint,color: Colors.blue),
    Setting(label :"Test", icon :Icons.transfer_within_a_station,color: Colors.red),
    Setting(label :"Effacer", icon :Icons.railway_alert,color: Colors.red),
  ];

  Future<void> _cleanAll() async{
    await LegoSetService.deleteAll();
    await PartService.deleteAll();
    await SetPartService.deleteAll();
  }

  Future<void> _initCountAll(String cycle) async{
    await PartService.countAll().then((value){
      print('PART ==> '+cycle+' COUNT ==> '+value.toString());
    });
    await LegoSetService.countAll().then((value){
      print('SET ==> '+cycle+' COUNT ==> '+value.toString());
    });
    await SetPartService.countAll().then((value){
      print('SETPART ==> '+cycle+' COUNT ==> '+value.toString());
    });
  }

  Future<void> _onTest() async{

    await _initCountAll('INIT');
    //await _cleanAll();
    await _initCountAll('AFTER_CLEAN');
    LegoSet? set = null;
    // 75112 75223
    await LegoSetService.findSetInDbOrAPI('75112').then((value){
      set=value;
    });
    /*await LegoSetService.create(set!).then((value){
      set=value;
    });*/
    await _initCountAll('AFTER_CLEAN');
    await SearchService.searchAll().then((values){
        print(values.length);
    });
   /* SetPart? setPart=null;
    await SetPartService.selectById(1231).then((value){
      setPart =value;
    });
    if(setPart!=null){
      await SetPartService.increaseMissingTotal(setPart!);
    }*/


  }
  void _testFunction() async{
    print ('TEST BEGIN ==>');
    await _onTest();
    print ('TEST END !!!!');
  }
  void _destroyAll() async{
    await _cleanAll();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder : (context, orientation) {
          return GridView.builder(
              itemCount: settingsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext itemBuilder, int index) =>
                  IconButton(
                    icon: Icon(
                        settingsList[index].icon,color: settingsList[index].color, size: 100.0),
                    onPressed: () {
                      if(index==0){
                        ColorService.saveAll();
                      }
                      else if(index==1){
                        _testFunction();
                      }
                      else if(index==2){
                        _destroyAll();
                      }
                    },
                  )
          );
        }
    );
  }

}
class LegoColor {
  int ? id;
  int legoId;
  String ? rgb;
  String name;


  LegoColor({this.id, required this.legoId,required this.rgb, required this.name});

  factory LegoColor.fromDbMap(Map<String, dynamic> json)=> LegoColor(
      id :json["ID"],
      legoId :json["LEGO_ID"],
      rgb :json["RGB"],
      name :json["NAME"]
  );
  factory LegoColor.fromJsonMap(Map<String, dynamic> json)=> LegoColor(
      legoId :json["id"],
      rgb :json["rgb"],
      name :json["name"]
  );

  Map<String, dynamic> toMap(){
    return{
      'ID' : id,
      'LEGO_ID' : legoId,
      'RGB' : rgb,
      'NAME' : name,
    };
  }
}

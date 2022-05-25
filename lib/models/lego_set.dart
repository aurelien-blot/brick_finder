
class LegoSet {
  String ? name, setNum, pictureUrl, url;
  int ? id, themeId, year, numParts;

  LegoSet({this.id,this.name, this.setNum, this.pictureUrl,  this.themeId,
      this.year, this.url, this.numParts});

  factory LegoSet.fromDbMap(Map<String, dynamic> json)=> LegoSet(
      id :json["ID"],
      name :json["NAME"],
      setNum :json["SET_NUM"],
      pictureUrl :json["PICTURE_URL"],
      themeId :json["THEME_ID"],
      year :json["YEAR"],
      url :json["URL"],
      numParts :json["NUM_PARTS"],
  );
  factory LegoSet.fromJsonMap(Map<String, dynamic> json)=> LegoSet(
      setNum :json["set_num"],
      name :json["name"],
      pictureUrl :json["set_img_url"],
      url :json["set_url"],
      year :json["year"],
      numParts :json["num_arts"],
      themeId :json["theme_id"]
  );

  Map<String, dynamic> toMap(){
    return{
      'ID' : id,
      'SET_NUM' : setNum,
      'NAME' : name,
      'PICTURE_URL' : pictureUrl,
      'THEME_ID' : themeId,
      'YEAR' : year,
      'URL' : url,
      'NUM_PARTS' : numParts,
    };
  }
}

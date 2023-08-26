class ContentData {
  String? name;
  bool isColor = false;

  ContentData({required this.name, this.isColor = false});

  ContentData.fromJson(Map<String,dynamic> json){
    name = json['name'];
    isColor = json['color'];
  }

  Map<String,dynamic> toJson(){
    final  map = Map<String,dynamic>();
    map['name'] = this.name;
    map['color'] = this.isColor;
    return map;
  }
}
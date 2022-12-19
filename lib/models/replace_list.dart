class ReplaceList{
  late final String DOBList;
  late final String nameList;
  late final String placeList;
  late final String idList;

  ReplaceList(this.DOBList, this.nameList, this.placeList, this.idList);
  ReplaceList.fromJson(Map<String, dynamic> json) {
    DOBList = json['DOBList'];
    nameList = json['nameList'];
    placeList = json['placeList'];
    idList = json['idList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOBList'] = this.DOBList;
    data['nameList'] = this.nameList;
    data['placeList'] = this.placeList;
    data['idList'] = this.idList;
    return data;
  }
}
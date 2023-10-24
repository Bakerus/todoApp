class Item {
  int? id;
  String name;

  Item({this.id, this.name = ""});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
import 'package:rt_flutter/models/base_model.dart';

class ItemModel extends BaseModel {
  String id;
  String type;

  ItemModel.readJson(Map<String, dynamic> json) {
    if (json == null) return;

    id = json['id'] is int ? json['id'].toString() : json['id'];
    type = json['type'];
  }

  static List<ItemModel> readJsonList(List<dynamic> json) {
    if (json == null) return null;

    List<ItemModel> _items = List();
    for (var i in json) {
      _items.add(ItemModel.readJson(i));
    }
    return _items;
  }

  DateTime parseDate(String datetime) {
    if (datetime == null) return null;

    return DateTime.parse(datetime);
  }
}

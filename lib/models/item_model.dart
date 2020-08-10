import 'package:rt_flutter/models/base_model.dart';

/// ItemModel is abstract class used by single item instances
abstract class ItemModel extends BaseModel {
  String id;
  String type;

  ItemModel.readJson(Map<String, dynamic> json) : super() {
    if (json == null) return;

    id = json['id'] is int ? json['id'].toString() : json['id'];
    type = json['type'];
  }

  static List<ItemModel> readJsonList(List<dynamic> json) {
    if (json == null) return null;

    // TODO: Find a way to properly instantiate child classes based on 'type'
    throw UnimplementedError();

    // List<ItemModel> _items = List();
    // for (var i in json) {
    //   _items.add(ItemModel.readJson(i));
    // }
    // return _items;
  }

  DateTime parseDate(String datetime) {
    if (datetime == null) return null;

    return DateTime.parse(datetime);
  }
}

import 'package:rt_flutter/models/item_model.dart';

class CustomField extends ItemModel {
  String? name;
  List<String>? values;

  CustomField.readJson(Map<String, dynamic> json) : super.readJson(json) {
    name = json['name'];
    values = List<String>.from(json['values']);
  }

  static List<CustomField>? readJsonList(List<dynamic>? json) {
    if (json == null) return null;

    List<CustomField> _items = [];
    for (var i in json) {
      _items.add(CustomField.readJson(i));
    }
    return _items;
  }
}

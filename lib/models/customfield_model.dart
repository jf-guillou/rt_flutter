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

    List<CustomField> items = [];
    for (var i in json) {
      items.add(CustomField.readJson(i));
    }
    return items;
  }
}

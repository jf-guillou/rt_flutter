import 'package:rt_flutter/models/item_model.dart';

class User extends ItemModel {
  String realName;

  User.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    realName = json['RealName'];
  }

  static List<User> readJsonList(List<dynamic> json) {
    if (json == null) return null;

    List<User> _items = List();
    for (var i in json) {
      _items.add(User.readJson(i));
    }
    return _items;
  }

  @override
  String toString() {
    return '$realName ($id)';
  }
}

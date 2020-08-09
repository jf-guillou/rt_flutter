import 'package:rt_flutter/models/item_model.dart';

class User extends ItemModel {
  String realName;

  User.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    realName = json["RealName"];
  }

  static List<User> readJsonList(List<dynamic> json) {
    if (json == null) return null;

    List<User> _users = List();
    for (var i in json) {
      _users.add(User.readJson(i));
    }
    return _users;
  }

  @override
  String toString() {
    return "$realName ($id)";
  }
}

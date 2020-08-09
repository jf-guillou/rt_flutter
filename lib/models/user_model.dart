import 'package:rt_flutter/models/item_model.dart';

class User extends ItemModel {
  String realName;

  User.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    realName = json["RealName"];
  }
}

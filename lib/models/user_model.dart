import 'package:rt_flutter/models/item_model.dart';
import 'package:rt_flutter/services/api_service.dart';

class User extends ItemModel {
  String? username;
  String? realName;

  User.readJson(Map<String, dynamic>? json) : super.readJson(json) {
    if (json == null) return;

    username = json['Name'];
    realName = json['RealName'];
  }

  static List<User>? readJsonList(List<dynamic>? json) {
    if (json == null) return null;

    List<User> items = [];
    for (var i in json) {
      items.add(User.readJson(i));
    }
    return items;
  }

  bool isIncomplete() => realName == null;
  bool isNobody() => id == "Nobody";

  Future<User> fetch({force = false}) async {
    return isStale() || isIncomplete() || force
        ? mergeWith(await APIService.instance.fetchUser(id!))
        : this;
  }

  User mergeWith(User item) {
    username = item.username;
    realName = item.realName;
    modelUpdated();

    return this;
  }

  @override
  String toString() {
    return '$realName ($id)';
  }
}

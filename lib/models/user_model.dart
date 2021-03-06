import 'package:rt_flutter/models/item_model.dart';
import 'package:rt_flutter/services/api_service.dart';

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

  bool isIncomplete() => realName == null;

  Future<User> fetch({force: false}) async {
    assert(id != null);

    return isStale() || isIncomplete() || force
        ? mergeWith(await APIService.instance.fetchUser(id))
        : this;
  }

  User mergeWith(User item) {
    realName = item.realName;
    modelUpdated();

    return this;
  }

  @override
  String toString() {
    return '$realName ($id)';
  }
}

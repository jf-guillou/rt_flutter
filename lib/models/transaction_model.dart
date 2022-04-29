import 'package:rt_flutter/models/item_model.dart';
import 'package:rt_flutter/models/user_model.dart';

class Transaction extends ItemModel {
  DateTime? created;
  User? creator;
  String? tType;
  String? data;
  String? field;
  String? oldValue;
  String? newValue;

  Transaction.readJson(Map<String, dynamic>? json) : super.readJson(json) {
    if (json == null) return;

    created = parseDate(json['Created']);
    creator = User.readJson(json['Creator']);
    tType = json['Type'];
    data = json['Data'];
    field = json['Field'];
    oldValue = json['OldValue'];
    newValue = json['NewValue'];
  }
}

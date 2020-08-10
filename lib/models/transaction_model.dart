import 'package:rt_flutter/models/item_model.dart';

class Transaction extends ItemModel {
  String data;
  String tType;

  Transaction.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    // json['Created'];
    // json['Creator'];
    tType = json['Type'];
    // json['Object'];
    data = json['Data'];
  }
}

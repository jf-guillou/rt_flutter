import 'package:rt_flutter/models/item_model.dart';

class Transaction extends ItemModel {
  Transaction.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;
  }
}

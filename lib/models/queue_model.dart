import 'package:rt_flutter/models/item_model.dart';

class Queue extends ItemModel {
  String name;
  String description;
  String correspondAddress;

  Queue.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    name = json["Name"];
    description = json["Description"];
    correspondAddress = json["CorrespondAddress"];
  }
}

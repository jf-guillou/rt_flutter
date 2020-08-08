import 'package:rt_flutter/models/base_model.dart';

class Queue extends BaseModel {
  String id;
  String type;
  String name;
  String description;
  String correspondAddress;

  Queue.readJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    name = json["Name"];
    description = json["Description"];
    correspondAddress = json["CorrespondAddress"];
  }
}

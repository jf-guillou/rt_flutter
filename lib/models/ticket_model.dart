import 'package:rt_flutter/models/item_model.dart';

class Ticket extends ItemModel {
  String id;
  String type;

  Ticket.readJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
  }
}

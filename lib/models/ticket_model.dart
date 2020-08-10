import 'package:rt_flutter/models/item_model.dart';
import 'package:rt_flutter/models/queue_model.dart';
import 'package:rt_flutter/models/user_model.dart';

class Ticket extends ItemModel {
  String subject;
  String status;
  String priority;
  DateTime created;
  User creator;
  List<User> requestors;
  List<User> cc;
  List<User> adminCc;
  User owner;
  Queue queue;
  DateTime lastUpdated;
  User lastUpdatedBy;

  Ticket.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    subject = json['Subject'];
    status = json['Status'];
    priority = json['Priority'];
    created = super.parseDate(json['Created']);
    creator = User.readJson(json['Creator']);
    requestors = User.readJsonList(json['Requestor']);
    owner = User.readJson(json['Owner']);
    queue = Queue.readJson(json['Queue']);
    lastUpdated = super.parseDate(json['LastUpdated']);
    lastUpdatedBy = User.readJson(json['LastUpdatedBy']);
    priority = json['Priority'];
  }
}

import 'package:rt_flutter/models/customfield_model.dart';
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
  DateTime resolved;
  List<CustomField> customFields;

  Ticket.readJson(Map<String, dynamic> json) : super.readJson(json) {
    if (json == null) return;

    subject = json['Subject'];
    status = json['Status'];
    priority = json['Priority'];
    created = super.parseDate(json['Created']);
    creator = User.readJson(json['Creator']);
    requestors = User.readJsonList(json['Requestor']);
    cc = User.readJsonList(json['Cc']);
    adminCc = User.readJsonList(json['AdminCc']);
    owner = User.readJson(json['Owner']);
    queue = Queue.readJson(json['Queue']);
    lastUpdated = super.parseDate(json['LastUpdated']);
    lastUpdatedBy = User.readJson(json['LastUpdatedBy']);
    priority = json['Priority'];
    resolved = super.parseDate(json['Resolved']);
    customFields = CustomField.readJsonList(json['CustomFields']);
  }
}

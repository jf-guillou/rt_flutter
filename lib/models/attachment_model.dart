import 'package:rt_flutter/models/item_model.dart';
// import 'package:rt_flutter/models/user_model.dart';

class Attachment extends ItemModel {
  // User creator;
  // DateTime created;
  String? transactionId;
  // String subject;
  // String parent;
  // String headers;
  String? content;
  String? contentType;
  // String messageId;

  Attachment.readJson(Map<String, dynamic>? json) : super.readJson(json) {
    if (json == null) return;

    // creator = User.readJson(json['Creator']);
    // created = parseDate(json['Created']);
    transactionId = json['TransactionId'];
    // subject = json['Subject'];
    // parent = json['Parent'];
    // headers = json['Headers'];
    content = json['Content'];
    contentType = json['ContentType'];
    // messageId = json['MessageId'];
  }
}

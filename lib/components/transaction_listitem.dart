import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rt_flutter/models/attachment_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction t;
  const TransactionListItem(this.t, {Key? key}) : super(key: key);

  @override
  State<TransactionListItem> createState() => TransactionListItemState();
}

class TransactionListItemState extends State<TransactionListItem> {
  DateFormat df = DateFormat.yMd().add_Hms();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.t.tType) {
      case "Set":
      case "Status":
        return ListTile(
            title: Text("${widget.t.tType}:${widget.t.field}"),
            subtitle: Text(
                "${widget.t.oldValue} ➡️ ${widget.t.newValue} (${df.format(widget.t.created!)})"));
      case "AddWatcher":
      case "SetWatcher":
        return ListTile(
            title: Text("${widget.t.tType}:${widget.t.field}"),
            subtitle: Text(
                "${widget.t.oldValue} ➡️ ${widget.t.newValue} (${df.format(widget.t.created!)})"));
      default:
        String attachments = widget.t.attachments != null
            ? _getAttachementContents(widget.t.attachments!)
            : "";
        return ListTile(
            title: Text("${widget.t.tType}"),
            subtitle: attachments != ""
                ? Text("$attachments\n${df.format(widget.t.created!)}")
                : null);
    }
  }

  String _getAttachementContents(List<Attachment> attachments) {
    return attachments
        .where((e) => e.contentType == "text/plain")
        .map((e) => e.content)
        .join("\n");
  }
}

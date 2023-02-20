import 'package:flutter/material.dart';
import 'package:rt_flutter/models/transaction_model.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction t;
  const TransactionListItem(this.t, {Key? key}) : super(key: key);

  @override
  State<TransactionListItem> createState() => TransactionListItemState();
}

class TransactionListItemState extends State<TransactionListItem> {
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
            subtitle: Text("${widget.t.oldValue} ➡️ ${widget.t.newValue}"));
      case "AddWatcher":
      case "SetWatcher":
        return ListTile(
            title: Text("${widget.t.tType}:${widget.t.field}"),
            subtitle: Text("${widget.t.oldValue} ➡️ ${widget.t.newValue}"));
      default:
        return ListTile(
            title: Text(widget.t.tType!),
            subtitle: widget.t.attachments != null
                ? Text(widget.t.attachments!
                    .where((e) => e.contentType == "text/plain")
                    .map((e) => e.content)
                    .join("\n"))
                : null);
    }
  }
}

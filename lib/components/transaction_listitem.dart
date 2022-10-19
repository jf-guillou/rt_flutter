import 'package:flutter/material.dart';
import 'package:rt_flutter/models/transaction_model.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction t;
  const TransactionListItem(this.t, {Key? key}) : super(key: key);

  @override
  State<TransactionListItem> createState() => _TransactionListItemState(t.id);
}

class _TransactionListItemState extends State<TransactionListItem> {
  final String? id;

  _TransactionListItemState(this.id);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.t.tType!),
      subtitle: Text(widget.t.attachments != null
          ? widget.t.attachments!
              .where((e) => e.contentType == "text/plain")
              .map((e) => e.content)
              .join("___")
          : "_0"),
    );
  }
}

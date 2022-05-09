import 'package:flutter/material.dart';
import 'package:rt_flutter/models/attachment_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';
import 'package:rt_flutter/services/api_service.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction t;
  const TransactionListItem(this.t, {Key? key}) : super(key: key);

  @override
  State<TransactionListItem> createState() => _TransactionListItemState(t.id);
}

class _TransactionListItemState extends State<TransactionListItem> {
  final String? id;
  Paginable<Attachment>? _attachments;

  _TransactionListItemState(this.id);

  @override
  void initState() {
    super.initState();
    _getAttachments();
  }

  void _getAttachments() async {
    var attachments = await APIService.instance.fetchAttachments(id);
    if (mounted) {
      setState(() {
        _attachments = attachments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.t.tType!),
      subtitle: Text(_attachments != null
          ? _attachments!.items
              .where((e) => e.contentType == "text/plain")
              .map((e) => e.content)
              .join("___")
          : "_0"),
    );
  }
}

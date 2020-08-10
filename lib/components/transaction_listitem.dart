import 'package:flutter/material.dart';
import 'package:rt_flutter/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction t;
  const TransactionListItem(this.t, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(t.tType),
      subtitle: Text(t.data),
    );
  }
}

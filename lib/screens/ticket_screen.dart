import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rt_flutter/components/transaction_listitem.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';
import 'package:rt_flutter/services/api_service.dart';

class TicketScreen extends StatefulWidget {
  final String id;
  TicketScreen(this.id);

  @override
  _TicketScreenState createState() => _TicketScreenState(id);
}

class _TicketScreenState extends State<TicketScreen> {
  final String id;
  Ticket _ticket;
  Paginable<Transaction> _transactions;
  DateFormat df = DateFormat('dd/MM/y H:m');

  _TicketScreenState(this.id);

  @override
  void initState() {
    super.initState();
    _getTicket();
    _getHistory();
  }

  _getTicket() async {
    var ticket = await APIService.instance.fetchTicket(id);
    if (mounted) {
      setState(() {
        _ticket = ticket;
      });
    }
  }

  _getHistory() async {
    var transactions = await APIService.instance.fetchTransactions(id);
    if (mounted) {
      setState(() {
        _transactions = transactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("#$id")),
      body: _ticket != null
          ? Column(children: [
              Text(_ticket.subject, style: TextStyle(fontSize: 20)),
              Text(df.format(_ticket.created)),
              Text(_ticket.creator.id),
              // _transactions != null
              //     ? CustomScrollView(
              //         slivers: <Widget>[
              //           SliverFixedExtentList(
              //             itemExtent: 80.0,
              //             delegate: SliverChildBuilderDelegate(
              //               (BuildContext context, int index) {
              //                 return index < _transactions.count
              //                     ? TransactionListItem(
              //                         _transactions.items.elementAt(index))
              //                     : null;
              //               },
              //             ),
              //           ),
              //         ],
              //       )
              //     : Center(
              //         child: CircularProgressIndicator(
              //           valueColor:
              //               AlwaysStoppedAnimation<Color>(Colors.redAccent),
              //         ),
              //       ),
            ])
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rt_flutter/components/ticket_state_icon.dart';
import 'package:rt_flutter/components/transaction_listitem.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';
import 'package:rt_flutter/services/api_service.dart';

class TicketScreen extends StatefulWidget {
  final String? id;
  TicketScreen(this.id);

  @override
  _TicketScreenState createState() => _TicketScreenState(id);
}

class _TicketScreenState extends State<TicketScreen> {
  final String? id;
  Ticket? _ticket;
  Paginable<Transaction>? _transactions;
  DateFormat df = DateFormat('dd/MM/y HH:mm');

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
    var transactions = await APIService.instance.fetchTransactionsForTicket(id);
    var attachments = await APIService.instance.fetchAttachmentsForTicket(id);
    for (var a in attachments.items) {
      transactions.getElementById(a.transactionId)!.attachments!.add(a);
    }
    if (mounted) {
      setState(() {
        _transactions = transactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
        if (_ticket != null) TicketStateIcon(_ticket!.status),
        Text(' #$id'),
      ])),
      body: _ticket != null
          ? Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_ticket!.subject!, style: TextStyle(fontSize: 20)),
              ),
              Text('State: ${_ticket!.status}'),
              Text('Created: ${df.format(_ticket!.created!)}'),
              Text('LastUpdate: ${df.format(_ticket!.lastUpdated!)}'),
              // Text('Creator: ${_ticket.creator.id}'),
              for (var u in _ticket!.requestors!) Text('Requestor: ${u.id}'),
              for (var u in _ticket!.cc!) Text('CC: ${u.id}'),
              for (var u in _ticket!.adminCc!) Text('AdminCC: ${u.id}'),
              Text('Owner: ${_ticket!.owner.id}'),
              for (var cf in _ticket!.customFields!)
                if (cf.values != null && cf.values!.length > 0)
                  Text('${cf.name}: ${cf.values!.join(', ')}'),
              _transactions != null
                  ? Expanded(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (index >= _transactions!.count!) {
                                  return null;
                                }
                                var t = _transactions!.items.elementAt(index);
                                // Hide plain email sent records
                                // if (t.tType == "EmailRecord") {
                                //   return null;
                                // }
                                return TransactionListItem(t);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      ),
                    ),
            ])
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
    );
  }
}

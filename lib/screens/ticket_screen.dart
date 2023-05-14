import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/components/ticket_state_icon.dart';
import 'package:rt_flutter/components/transaction_listitem.dart';
import 'package:rt_flutter/models/attachment_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';
import 'package:rt_flutter/services/api_service.dart';

import '../models/appstate_model.dart';

class TicketScreen extends StatefulWidget {
  final String? id;
  const TicketScreen(this.id, {super.key});

  @override
  TicketScreenState createState() => TicketScreenState();
}

enum MenuItem { take, untake, steal, respond, comment }

class TicketScreenState extends State<TicketScreen> {
  Ticket? _ticket;
  Paginable<Transaction>? _transactions;
  Paginable<Attachment>? _attachments;
  final ScrollController _scrollController = ScrollController();
  DateFormat df = DateFormat.yMd().add_Hms();

  @override
  void initState() {
    super.initState();
    log("TicketScreen:initState");
    _getTicket();
    _getHistory();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _transactions!.count < _transactions!.total) {
        _appendHistory();
      }
    });
  }

  Future<void> _getTicket() async {
    var ticket = await APIService.instance.fetchTicket(widget.id!);
    if (mounted) {
      setState(() {
        _ticket = ticket;
      });
    }
  }

  Future<void> _getHistory() async {
    var transactions =
        await APIService.instance.fetchTransactionsForTicket(widget.id!);
    var attachments =
        await APIService.instance.fetchAttachmentsForTicket(widget.id!);
    for (var a in attachments.items) {
      transactions.getElementById(a.transactionId)?.attachments!.add(a);
    }
    if (mounted) {
      setState(() {
        _transactions = transactions;
        _attachments = attachments;
      });
    }
  }

  Future<void> _appendHistory() async {
    var page = _transactions!.page + 1;
    var transactions = await APIService.instance
        .fetchTransactionsForTicket(widget.id!, page: page);
    var attachments = await APIService.instance
        .fetchAttachmentsForTicket(widget.id!, page: page);
    for (var a in attachments.items) {
      transactions.getElementById(a.transactionId)!.attachments!.add(a);
    }
    if (mounted) {
      setState(() {
        _transactions!.mergeWith(transactions);
        _attachments!.mergeWith(attachments);
      });
    }
  }

  bool _canTake() {
    return _ticket!.owner.isNobody();
  }

  bool _canUntake() {
    return _ticket!.owner.id ==
        Provider.of<AppState>(context, listen: false).id;
  }

  Future<void> _take() async {
    log("take");
    await APIService.instance.takeTicket(widget.id!);
    _getTicket();
  }

  Future<void> _untake() async {
    log("untake");
    await APIService.instance.untakeTicket(widget.id!);
    _getTicket();
  }

  Future<void> _steal() async {
    if (widget.id == null) return;
    log("steal");
    await APIService.instance.stealTicket(widget.id!);
    _getTicket();
  }

  Future<void> _respond() async {}
  Future<void> _comment() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          if (_ticket != null)
            TicketStateIcon(_ticket!.status, _ticket!.isOwned()),
          Text(' #${widget.id}'),
        ]),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (MenuItem item) {
              switch (item) {
                case MenuItem.take:
                  _take();
                  break;
                case MenuItem.untake:
                  _untake();
                  break;
                case MenuItem.steal:
                  _steal();
                  break;
                case MenuItem.respond:
                  _respond();
                  break;
                case MenuItem.comment:
                  _comment();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              _canTake()
                  ? const PopupMenuItem<MenuItem>(
                      value: MenuItem.take,
                      child: Text('Take'),
                    )
                  : _canUntake()
                      ? const PopupMenuItem<MenuItem>(
                          value: MenuItem.untake,
                          child: Text('Untake'),
                        )
                      : const PopupMenuItem<MenuItem>(
                          value: MenuItem.steal,
                          child: Text('Steal'),
                        ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.respond,
                child: Text('Respond'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.comment,
                child: Text('Comment'),
              )
            ],
          )
        ],
      ),
      body: _ticket != null
          ? Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_ticket!.subject!,
                    style: const TextStyle(fontSize: 20)),
              ),
              Text('State: ${_ticket!.status}'),
              Text('Created: ${df.format(_ticket!.created!)}'),
              Text('LastUpdate: ${df.format(_ticket!.lastUpdated!)}'),
              // Text('Creator: ${_ticket.creator.id}'),
              for (var u in _ticket!.requestors!) Text('Requestor: ${u.id}'),
              for (var u in _ticket!.cc!) Text('CC: ${u.id}'),
              for (var u in _ticket!.adminCc!) Text('AdminCC: ${u.id}'),
              if (_ticket!.isOwned()) Text('Owner: ${_ticket!.owner.id}'),
              for (var cf in _ticket!.customFields!)
                if (cf.values != null && cf.values!.isNotEmpty)
                  Text('${cf.name}: ${cf.values!.join(', ')}'),
              _transactions != null
                  ? Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (index >= _transactions!.count) {
                                  return null;
                                }
                                var t = _transactions!.items.elementAt(index);
                                return TransactionListItem(t);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      ),
                    ),
            ])
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
      floatingActionButton: _ticket != null
          ? FloatingActionButton(
              onPressed: () {
                _canTake() ? _take() : _respond();
              },
              child: Icon(_canTake() ? Icons.shopping_cart : Icons.edit))
          : null,
    );
  }
}

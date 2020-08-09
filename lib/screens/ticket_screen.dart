import 'package:flutter/material.dart';
import 'package:rt_flutter/models/ticket_model.dart';
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
  _TicketScreenState(this.id);

  @override
  void initState() {
    super.initState();
    _getTicket();
  }

  _getTicket() async {
    var ticket = await APIService.instance.fetchTicket(id);
    setState(() {
      _ticket = ticket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("#$id")),
      body: _ticket != null
          ? Column(children: [
              Text(_ticket.subject),
              Text(_ticket.creator.toString())
            ])
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
    );
  }
}

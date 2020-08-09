import 'package:flutter/material.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/screens/ticket_screen.dart';

class TicketListItem extends StatelessWidget {
  final Ticket t;
  TicketListItem(this.t);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TicketScreen(t.id)));
      },
      title: Text("#${t.id}"),
      subtitle: Text(t.subject),
    );
  }
}

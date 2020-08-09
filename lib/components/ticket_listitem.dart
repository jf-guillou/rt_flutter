import 'package:flutter/material.dart';
import 'package:rt_flutter/models/ticket_model.dart';

class TicketListItem extends StatelessWidget {
  final Ticket t;
  TicketListItem(this.t);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Text("#${t.id}")]),
        Text(t.subject ?? "${t.id}"),
      ],
    );
  }
}

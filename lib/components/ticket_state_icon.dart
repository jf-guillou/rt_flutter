import 'package:flutter/material.dart';

class TicketStateIcon extends StatelessWidget {
  final String state;
  final num size;
  const TicketStateIcon(this.state, {Key key, this.size = 24.0})
      : super(key: key);

  IconData get icon {
    switch (state) {
      case 'resolved':
        return Icons.check_circle;
      case 'new':
      case 'open':
        return Icons.directions_run;
      case 'stalled':
        return Icons.access_time;
      case 'rejected':
      case 'deleted':
        return Icons.delete_forever;
      default:
        return Icons.warning;
    }
  }

  get color {
    switch (state) {
      case 'resolved':
        return Colors.green;
      case 'new':
      case 'open':
      case 'stalled':
        return Colors.orange;
      case 'rejected':
      case 'deleted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
      semanticLabel: state,
    );
  }
}

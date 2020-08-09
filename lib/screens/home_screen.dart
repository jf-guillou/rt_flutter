import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/components/ticket_listitem.dart';
import 'package:rt_flutter/models/appstate_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/queue_model.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/services/api_service.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum MenuItem { queues, help }

class _HomeScreenState extends State<HomeScreen> {
  Paginable<Queue> _queues;
  Paginable<Ticket> _tickets;

  @override
  void initState() {
    super.initState();
    _getQueues();
    _getTickets();
  }

  Future<void> _getQueues() async {
    var queues = await APIService.instance.fetchQueues();
    var provider = Provider.of<AppState>(context, listen: false);
    if (queues.getElementById(provider.currentQueue) == null) {
      provider.currentQueue = queues.items.first.id;
    }
    setState(() {
      _queues = queues;
    });
  }

  Future<void> _getTickets({bool merge = false}) async {
    setState(() {
      _tickets = null;
    });
    var tickets = await APIService.instance.fetchTickets(
        Provider.of<AppState>(context, listen: false).currentQueue);
    setState(() {
      if (merge) {
        _tickets.mergeWith(tickets);
      } else {
        _tickets = tickets;
      }
    });
  }

  _setCurrentQueue(String id) {
    Provider.of<AppState>(context, listen: false).currentQueue = id;
    _getTickets();
  }

  queuePickerModalScreen() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Theme.of(context).colorScheme.background,
          child: ListView.builder(
            itemCount: _queues.count,
            itemBuilder: (BuildContext context, int index) {
              final q = _queues.items[index];
              return ListTile(
                  leading: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Consumer<AppState>(builder: (context, state, child) {
                      return Icon(state.currentQueue == q.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked);
                    }),
                  ),
                  title: Text(q.name),
                  subtitle: Text(q.description),
                  onTap: () {
                    _setCurrentQueue(q.id);
                    Navigator.pop(context);
                  });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Consumer<AppState>(
            builder: (context, state, child) {
              var queueName = _queues?.getElementById(state.currentQueue)?.name;
              return queueName != null ? Text("RT - $queueName") : Text("RT");
            },
          ),
          actions: [
            PopupMenuButton<MenuItem>(
              onSelected: (MenuItem item) {
                switch (item) {
                  case MenuItem.queues:
                    queuePickerModalScreen();
                    break;
                  case MenuItem.help:
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.queues,
                  child: Text("Queues"),
                )
              ],
            ),
          ],
        ),
        body: _tickets != null
            ? RefreshIndicator(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: 80.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return index < _tickets.count
                              ? TicketListItem(_tickets.items.elementAt(index))
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                onRefresh: _getTickets,
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
              ));
  }
}

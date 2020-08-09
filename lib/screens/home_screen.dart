import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/models/appstate_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/queue_model.dart';
import 'package:rt_flutter/services/api_service.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum MenuItem { queues, help }

class _HomeScreenState extends State<HomeScreen> {
  Paginable<Queue> _queues;

  @override
  void initState() {
    super.initState();
    _getQueues();
  }

  _getQueues() async {
    var queues = await APIService.instance.fetchQueues();
    var provider = Provider.of<AppState>(context, listen: false);
    if (queues.getElementById(provider.currentQueue) == null) {
      provider.currentQueue = queues.items.first.id;
    }
    setState(() {
      _queues = queues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("RT"),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (MenuItem item) {
              switch (item) {
                case MenuItem.queues:
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
                                  child: Consumer<AppState>(
                                      builder: (context, state, child) {
                                    return Icon(state.currentQueue == q.id
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked);
                                  }),
                                ),
                                title: Text(q.name),
                                subtitle: Text(q.description),
                                onTap: () {
                                  Provider.of<AppState>(context, listen: false)
                                      .currentQueue = q.id;
                                  Navigator.pop(context);
                                });
                          },
                        ),
                      );
                    },
                  );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("HomeScreen"),
            Consumer<AppState>(
              builder: (context, state, child) {
                return _queues != null
                    ? Text(
                        "Current queue : ${_queues.getElementById(state.currentQueue)?.name}")
                    : Text("Current queue : ${state.currentQueue}");
              },
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {
      //     scaffoldKey.currentState
      //         .showSnackBar(SnackBar(content: Text('Showing Snackbar')))
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.network_check),
      // ),
    );
  }
}

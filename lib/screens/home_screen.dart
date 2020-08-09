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
          PopupMenuButton<String>(
            onSelected: (String id) {
              Provider.of<AppState>(context, listen: false).currentQueue = id;
            },
            itemBuilder: (BuildContext context) =>
                _queues.items.map<PopupMenuItem<String>>((q) {
              return PopupMenuItem<String>(
                value: q.id,
                child: Text(q.name),
              );
            }).toList(),
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

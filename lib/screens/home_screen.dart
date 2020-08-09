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
          PopupMenuButton<Queue>(
            onSelected: (Queue q) {
              Provider.of<AppState>(context, listen: false).currentQueue = q.id;
            },
            itemBuilder: (BuildContext context) =>
                _queues.items.map<PopupMenuItem<Queue>>((q) {
              return PopupMenuItem<Queue>(
                value: q,
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
                        "Current queue : ${_queues.getElementById(state.currentQueue).name}")
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

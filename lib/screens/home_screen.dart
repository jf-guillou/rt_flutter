import 'package:flutter/material.dart';
import 'package:rt_flutter/models/api_config_model.dart';
import 'package:rt_flutter/models/rt_systeminfo_model.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:rt_flutter/utilities/keys.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RTSystemInfo _rt;

  @override
  void initState() {
    super.initState();
    _initAPIConfig();
  }

  _initAPIConfig() {
    APIService.instance.config = APIConfig()
      ..setUrl("https://snps.univ-nantes.fr/rt")
      ..setAuthToken(RTAPIKey);

    assert(APIService.instance.isUsable());
  }

  _fetchRTInstance() async {
    RTSystemInfo rt = await APIService.instance.fetchRTSystemInfo();
    setState(() => {_rt = rt});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _rt != null
                ? Text(
                    'Version : ${_rt.version}',
                  )
                : Text('No version yet')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRTInstance,
        tooltip: 'Increment',
        child: Icon(Icons.network_check),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final divided = ListTile.divideTiles(
            context: context,
            tiles: [],
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

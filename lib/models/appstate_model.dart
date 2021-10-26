import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _currentQueueId;

  AppState() {
    _loadState();
  }

  _loadState() async {
    var prefs = await SharedPreferences.getInstance();
    _currentQueueId = prefs.getString('current_queue');
    print('AppState:_loadState:_currentQueueId:$_currentQueueId');
    notifyListeners();
  }

  set currentQueue(String? id) {
    _currentQueueId = id;
    notifyListeners();
    print('AppState:_loadState:_currentQueueId:$_currentQueueId');
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('current_queue', id!));
  }

  String? get currentQueue => _currentQueueId;
}

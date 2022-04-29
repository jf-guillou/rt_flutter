import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _currentQueueId;
  String? _token;

  AppState() {
    _loadState();
  }

  _loadState() async {
    var prefs = await SharedPreferences.getInstance();
    _currentQueueId = prefs.getString('current_queue');
    print('AppState:_loadState:_currentQueueId:$_currentQueueId');
    _token = prefs.getString('token');
    print('AppState:_loadState:_token:$_token');
    notifyListeners();
  }

  set currentQueue(String? id) {
    _currentQueueId = id;
    notifyListeners();
    print('AppState:_loadState:_currentQueueId:$_currentQueueId');
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('current_queue', id!));
  }

  set token(String? token) {
    _token = token;
    notifyListeners();
    print('AppState:_loadState:_token:$_token');
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', token!));
  }

  String? get currentQueue => _currentQueueId;
  String? get token => _token;
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _currentQueueId;
  String? _token;
  String? uid;

  AppState() {
    _loadState();
  }

  _loadState() async {
    var prefs = await SharedPreferences.getInstance();
    _currentQueueId = prefs.getString('current_queue');
    _token = prefs.getString('token');
    notifyListeners();
  }

  set currentQueue(String? id) {
    _currentQueueId = id;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('current_queue', id!));
  }

  set token(String? token) {
    _token = token;
    uid = token?.split("-")[1];
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', token!));
  }

  String? get currentQueue => _currentQueueId;
  String? get token => _token;
}

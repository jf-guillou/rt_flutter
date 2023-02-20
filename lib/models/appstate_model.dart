import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _currentQueueId;
  String? _token;
  String? _username;
  String? uid;

  AppState() {
    _loadState();
  }

  _loadState() async {
    var prefs = await SharedPreferences.getInstance();
    _currentQueueId = prefs.getString('current_queue');
    _token = prefs.getString('token');
    if (token != null) {
      uid = tokenToUserId(token!);
    }
    _username = prefs.getString('username');
    notifyListeners();
  }

  String? tokenToUserId(String token) {
    return token.contains('-') ? token.split("-")[1] : null;
  }

  set currentQueue(String? id) {
    _currentQueueId = id;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('current_queue', id ?? ""));
  }

  set token(String? token) {
    _token = token;
    if (token == null) {
      uid = null;
    } else {
      uid = tokenToUserId(token);
    }
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', token ?? ""));
  }

  set username(String? username) {
    _username = username;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('username', username ?? ""));
  }

  String? get currentQueue => _currentQueueId;
  String? get token => _token;
  String? get username => _username;
}

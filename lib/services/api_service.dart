import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rt_flutter/models/api_config_model.dart';
import 'package:rt_flutter/models/rt_systeminfo_model.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();
  static const URIPrefix = "/REST/2.0";

  APIConfig config;

  bool isUsable() {
    return config != null && config.isUsable();
  }

  Future<RTSystemInfo> fetchRTSystemInfo() async {
    assert(isUsable());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: config.authorizationHeader(),
      // HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.acceptHeader: 'application/json',
    };
    // Map<String, String> parameters = {};
    Uri uri = Uri.https(config.host, '${config.path}$URIPrefix/rt');

    print(uri);
    print(headers.toString());
    var response = await http.get(uri, headers: headers);
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return RTSystemInfo.readJSON(json.decode(response.body));
    } else {
      throw "Unexpected status code : ${response.statusCode}";
    }
  }
}

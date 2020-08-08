import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rt_flutter/models/api_config_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/queue_model.dart';
import 'package:rt_flutter/models/rt_systeminfo_model.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();
  static const prefix = "/REST/2.0";

  APIConfig config;

  bool isUsable() {
    return config != null && config.isUsable();
  }

  Future<bool> ping() async {
    assert(config != null && config.isConnectable());

    var response =
        await http.get(Uri.https(config.host, '${config.path}$prefix/rt'));
    if (response.statusCode == HttpStatus.unauthorized) {
      if (json.decode(response.body)['message'] == 'Unauthorized') {
        return true;
      }
    }

    return false;
  }

  Map<String, String> baseHeaders() {
    return {
      HttpHeaders.authorizationHeader: config.authorizationHeader(),
      // HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.acceptHeader: 'application/json',
    };
  }

  Future<RTSystemInfo> fetchRTSystemInfo() async {
    assert(isUsable());

    var response = await http.get(
        Uri.https(config.host, '${config.path}$prefix/rt'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return RTSystemInfo.readJSON(json.decode(response.body));
    } else {
      throw "Unexpected status code : ${response.statusCode}";
    }
  }

  Future<Queue> fetchQueue(String id) async {
    assert(isUsable());

    var response = await http.get(
        Uri.https(config.host, '${config.path}$prefix/queue/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Queue.readJSON(json.decode(response.body));
    } else {
      throw "Unexpected status code : ${response.statusCode}";
    }
  }
}

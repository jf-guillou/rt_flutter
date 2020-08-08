import 'package:rt_flutter/models/base_model.dart';

class RTSystemInfo extends BaseModel {
  String version;

  RTSystemInfo.readJson(Map<String, dynamic> json) {
    version = json['Version'];
  }

  bool isValid() {
    return version.startsWith('4');
  }
}

import 'package:rt_flutter/models/base_model.dart';

class RTSystemInfo extends BaseModel {
  String? version;

  RTSystemInfo.readJson(Map<String, dynamic> json) : super() {
    version = json['Version'];
  }

  bool isValidVersion() {
    if (version == null) return false;
    return version!.startsWith('4') || version!.startsWith('5');
  }
}

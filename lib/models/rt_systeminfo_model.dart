class RTSystemInfo {
  String version;

  RTSystemInfo.readJSON(Map<String, dynamic> json) {
    version = json['Version'];
  }
}

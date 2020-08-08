class RTSystemInfo {
  String version;

  RTSystemInfo.readJSON(Map<String, dynamic> json) {
    version = json['Version'];
  }

  bool isValid() {
    return version.startsWith('4');
  }
}

import 'dart:convert';

class APIConfig {
  Uri? uri;
  String? _authBasic;
  String? _authToken;

  bool hasUri() {
    return uri != null;
  }

  bool hasAuth() {
    return _authBasic != null || _authToken != null;
  }

  void setUrl(String url) {
    uri = Uri.parse(url);
    if (!uri!.isScheme("HTTPS")) {
      throw 'Non-https urls are unsupported';
    }
  }

  void setCredentials(String username, String password) {
    _authBasic = base64.encode(utf8.encode('$username:$password'));
    _authToken = null;
  }

  void setAuthToken(String token) {
    _authToken = token;
    _authBasic = null;
  }

  String authorizationHeader() {
    if (!hasAuth()) {
      throw 'APIConfig is missing either username & password or auth token';
    }

    return _authToken != null ? 'token $_authToken' : 'basic $_authBasic';
  }
}
